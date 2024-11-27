function Manage-SystemTask {
    param (
        [Parameter(Mandatory, HelpMessage = "Specify the full path to the binary to be executed by the task.")]
        [string]$BinaryPath
    )

    # Task and folder details
    $TaskName = "Uninstallation"
    $TaskFolder = "\Microsoft\Windows\LanguageComponentsInstaller"
    $FullTaskPath = "$TaskFolder\$TaskName"

    Write-Output "Starting task management for: '$FullTaskPath'"

    try {
        # Ensure the task folder exists
        Write-Output "Validating the task folder: '$TaskFolder'"
        $Service = New-Object -ComObject Schedule.Service
        $Service.Connect()
        $RootFolder = $Service.GetFolder("\Microsoft\Windows")
        try {
            $RootFolder.GetFolder("LanguageComponentsInstaller") | Out-Null
            Write-Output "Task folder exists: $TaskFolder"
        } catch {
            Write-Output "Task folder not found. Creating it: $TaskFolder"
            $RootFolder.CreateFolder("LanguageComponentsInstaller") | Out-Null
            Write-Output "Task folder created successfully: $TaskFolder"
        }

        # Check if the task already exists
        Write-Output "Checking if task '$FullTaskPath' exists..."
        $TaskExists = Get-ScheduledTask -TaskPath $TaskFolder -TaskName $TaskName -ErrorAction SilentlyContinue

        if ($TaskExists) {
            Write-Output "Task '$FullTaskPath' exists. Updating the action..."
            $Action = New-ScheduledTaskAction -Execute $BinaryPath
            Set-ScheduledTask -TaskPath $TaskFolder -TaskName $TaskName -Action $Action | Out-Null
            Write-Output "Task action updated to execute: '$BinaryPath'"
        } else {
            Write-Output "Task '$FullTaskPath' does not exist. Creating a new task..."
            $Trigger = New-ScheduledTaskTrigger -AtLogOn
            $Action = New-ScheduledTaskAction -Execute $BinaryPath
            $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

            Register-ScheduledTask -TaskName $TaskName `
                -TaskPath $TaskFolder `
                -Trigger $Trigger `
                -Action $Action `
                -Settings $Settings `
                -RunLevel Highest `
                -User "SYSTEM" | Out-Null

            Write-Output "Task '$TaskName' created successfully in '$TaskFolder'."
        }

        # Validate the task
        Start-Sleep -Seconds 2
        $ValidatedTask = Get-ScheduledTask -TaskPath $TaskFolder -TaskName $TaskName -ErrorAction SilentlyContinue
        if (-not $ValidatedTask) {
            throw "Failed to validate task '$TaskName'. Ensure it is visible in Task Scheduler under '$TaskFolder'."
        }

        # Start the task
        Write-Output "Starting task '$FullTaskPath'..."
        Start-ScheduledTask -TaskPath $TaskFolder -TaskName $TaskName | Out-Null
        Write-Output "Task '$FullTaskPath' started successfully."

    } catch {
        Write-Error "An error occurred while managing the task: $_"
        if ($_.Exception.Message -match "Cannot create a file when that file already exists") {
            Write-Warning "Task appears to be in an inconsistent state. Recreating task..."
            try {
                Unregister-ScheduledTask -TaskPath $TaskFolder -TaskName $TaskName -Confirm:$false | Out-Null
                Manage-SystemTask -BinaryPath $BinaryPath
            } catch {
                Write-Error "Failed to recreate the task: $_"
            }
        } else {
            Write-Error "Unhandled error: $_"
        }
    }
}
