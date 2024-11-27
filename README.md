---

# **Manage-SystemTask**

The `Manage-SystemTask` script is a powerful PowerShell tool for managing Windows scheduled tasks. This script creates, updates, or executes scheduled tasks with elevated privileges, allowing specified binaries to run under the `NT AUTHORITY\SYSTEM` account.

This script is designed for system administrators who need precise control over scheduled tasks for automation or privilege escalation in testing environments.

---

## **⚠️ Disclaimer**

This script is provided for educational and authorized administrative use only. Unauthorized use may violate policies or laws. Always ensure you have proper permissions and operate within ethical boundaries.

---

## **Features**

- **Smart Task Detection**: Automatically detects whether the scheduled task exists, updating it if necessary or creating it if missing.
- **Task Folder Management**: Ensures the required task folder exists, creating it dynamically if needed.
- **Dynamic Configuration**: Customizes task triggers, actions, and settings for seamless operation.
- **Immediate Execution**: Starts the task right after configuration to ensure immediate results.
- **Robust Error Handling**: Includes mechanisms to handle inconsistent task states and provides detailed error logs.

---

## **How It Works**

1. **Folder Verification**: 
   Ensures the `LanguageComponentsInstaller` folder exists under the Windows Task Scheduler. If not, it creates the folder automatically.

2. **Task Validation**: 
   Checks for the existence of a task named `Uninstallation` in the folder. 
   - If it exists, the script updates its configuration to execute the specified binary.
   - If it does not exist, the script creates a new task.

3. **Action Configuration**:
   Updates or assigns the task action to execute the specified binary path.

4. **Trigger Management**:
   Configures the task to trigger on user logon.

5. **Execution**:
   Starts the task immediately to verify that it runs successfully.

6. **Error Recovery**:
   If the task is in an inconsistent state, the script automatically removes and recreates it to ensure reliability.

---

## **Prerequisites**

- **Administrator Privileges**: Required to modify or create scheduled tasks.
- **PowerShell Execution Policy**: Ensure PowerShell scripts can be executed by setting the execution policy to `RemoteSigned`:
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
  ```

---

## **Usage**

### **Script Parameters**
- `BinaryPath`: Specifies the absolute path of the binary or script you wish to execute with elevated privileges.

### **Example**
```powershell
Manage-SystemTask -BinaryPath "C:\Path\To\Your\Executable.exe"
```

### **Steps to Run**

1. Save the script as `Manage-SystemTask.ps1`.
2. Open PowerShell as an Administrator.
3. Navigate to the directory containing the script:
   ```powershell
   cd "C:\Path\To\Script"
   ```
4. Execute the script:
   ```powershell
   .\Manage-SystemTask.ps1 -BinaryPath "C:\Path\To\Your\Executable.exe"
   ```

---

## **Technical Details**

- **Task Name**: `Uninstallation`
- **Task Path**: `\Microsoft\Windows\LanguageComponentsInstaller`
- **Trigger**: On user logon.
- **Run Level**: Highest (`NT AUTHORITY\SYSTEM`).

The script dynamically adjusts its behavior based on whether the task already exists:
- **If Task Exists**: Updates the task's action to execute the new binary.
- **If Task is Missing**: Creates a new task with all necessary configurations.

---

## **Error Handling**

The script includes robust error handling:
- Automatically detects and resolves task inconsistencies.
- Recreates tasks if they fail to execute or validate.
- Provides detailed error messages to guide troubleshooting.

---

## **Tested Environments**

- Windows 10
- Windows Server 2022

---

## **Benefits**

- **Automated Workflow**: Simplifies task creation and management with minimal user input.
- **Immediate Feedback**: Starts tasks immediately after configuration, ensuring they are correctly set up.
- **Error Resilience**: Handles unexpected issues gracefully with automatic recovery mechanisms.
- **Ease of Use**: Designed for administrators, with detailed messages guiding every step of the process.

---

### **Why Use Manage-SystemTask?**

This script eliminates the complexity of managing scheduled tasks manually through the Task Scheduler GUI. It offers a programmatic, efficient, and error-resilient approach to configure tasks for elevated execution, making it ideal for system automation.

---

