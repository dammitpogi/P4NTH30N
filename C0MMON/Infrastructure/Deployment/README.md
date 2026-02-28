# VM Management and FTP Deployment System

## Overview

This system provides comprehensive VM control and file transfer capabilities for P4NTHE0N deployment workflows. It supports Hyper-V (primary) and VirtualBox (fallback) VM providers, along with FTP/SFTP file transfer mechanisms.

## Architecture

### Design Patterns

- **Strategy Pattern**: `IVMProvider` interface allows interchangeable VM provider implementations
- **Factory Pattern**: `VMProviderFactory` creates appropriate provider instances
- **Dependency Injection**: Services accept interfaces for loose coupling
- **Result Pattern**: Operations return structured results with success/failure information

### Provider Support

| Provider | Status | File Transfer | Command Execution |
|----------|--------|---------------|-------------------|
| Hyper-V | ✅ Implemented | PowerShell Copy-VMFile | PowerShell Direct |
| VirtualBox | 📝 Stub | VBoxManage guestcontrol | VBoxManage guestcontrol |
| VMware | ❌ Not Planned | N/A | N/A |

## File Structure

```
C0MMON/
├── Interfaces/
│   ├── IVMProvider.cs           # VM operations interface
│   ├── IVMFileTransfer.cs       # File transfer interface
│   ├── IFtpClient.cs            # FTP/SFTP interface
│   ├── IVMProviderFactory.cs    # Factory interface
│   ├── IVMDeploymentService.cs  # Orchestration interface
│   └── VMDeploymentModels.cs    # Configuration models
├── Infrastructure/
│   └── Deployment/
│       ├── HyperVProvider.cs          # Hyper-V PowerShell implementation
│       ├── HyperVFileTransfer.cs      # Hyper-V file transfer
│       ├── VirtualBoxProvider.cs      # VirtualBox stub
│       ├── VirtualBoxFileTransfer.cs  # VirtualBox stub
│       ├── VMProviderFactory.cs       # Factory implementation
│       ├── FluentFtpClient.cs         # FluentFTP implementation (requires NuGet)
│       └── SshNetFtpClient.cs         # SSH.NET SFTP implementation (requires NuGet)
└── Services/
    └── VMDeploymentService.cs   # High-level orchestration
```

## Installation

### 1. Add NuGet Packages

```bash
# Add FluentFTP for FTP/FTPS support
dotnet add C0MMON package FluentFTP --version 50.0.0

# Add SSH.NET for SFTP support
dotnet add C0MMON package SSH.NET --version 2024.0.0
```

### 2. Enable Hyper-V (Windows Pro/Enterprise)

```powershell
# Check if Hyper-V is enabled
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V

# Enable Hyper-V if needed
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# Install Hyper-V PowerShell module
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell
```

### 3. Configure VM Credentials

Create VMs in Hyper-V Manager and note their names. Ensure the VMs have:
- Guest services enabled (for Copy-VMFile)
- PowerShell remoting configured (for PowerShell Direct)

## Usage

### Basic VM Deployment

```csharp
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Interfaces;
using P4NTHE0N.C0MMON.Infrastructure.Deployment;
using P4NTHE0N.C0MMON.Services;

// Create factory and service
IVMProviderFactory factory = new VMProviderFactory();
VMDeploymentService deploymentService = new(factory);

// Configure deployment
VMConfiguration config = new(
    Name: "P4NTHE0N-Deploy-01",
    ProviderType: VMProviderType.HyperV,
    MemoryMB: 4096,
    CpuCount: 2,
    SnapshotToRestore: "clean-base",
    FileTransfers: new List<VMFileTransferTask>
    {
        new(
            SourcePath: @"C:\Deploy\AppFiles",
            DestinationPath: @"C:\Deployment",
            TransferType: FileTransferType.ProviderNative,
            IsDirectory: true
        )
    },
    PostDeployCommands: new List<VMCommandTask>
    {
        new(
            Command: "C:\\Deployment\\install.ps1",
            WorkingDirectory: "C:\\Deployment",
            Timeout: TimeSpan.FromMinutes(10),
            FailOnError: true
        )
    }
);

// Execute deployment
VMDeploymentResult result = await deploymentService.DeployAsync(config);

if (result.Success)
{
    Console.WriteLine($"Deployment successful in {result.Duration.TotalSeconds}s");
}
else
{
    Console.WriteLine($"Deployment failed: {result.Message}");
}
```

### Batch Deployment

```csharp
List<VMConfiguration> configs = new()
{
    new VMConfiguration("VM-01", VMProviderType.HyperV, 4096, 2),
    new VMConfiguration("VM-02", VMProviderType.HyperV, 4096, 2),
    new VMConfiguration("VM-03", VMProviderType.HyperV, 4096, 2),
};

DeploymentOptions options = new(
    Timeout: TimeSpan.FromMinutes(15),
    ParallelExecution: 2  // Deploy 2 VMs simultaneously
);

IReadOnlyList<VMDeploymentResult> results = await deploymentService.DeployBatchAsync(
    configs,
    options
);

int successCount = results.Count(r => r.Success);
Console.WriteLine($"Deployed {successCount}/{results.Count} VMs successfully");
```

### SFTP File Transfer

```csharp
FtpConfiguration ftpConfig = new(
    Host: "vm01.local",
    Port: 22,
    Username: "deployuser",
    Password: "securepassword",
    Protocol: FtpProtocol.Sftp
);

using SshNetFtpClient sftpClient = new(ftpConfig);
bool connected = await sftpClient.ConnectAsync();

if (connected)
{
    await sftpClient.UploadFileAsync(
        @"C:\Local\app.zip",
        "/home/deployuser/app.zip"
    );
    await sftpClient.DisconnectAsync();
}
```

## Configuration Options

### DeploymentOptions

| Property | Default | Description |
|----------|---------|-------------|
| Timeout | 10 minutes | Maximum deployment time |
| RetryCount | 3 | Number of retry attempts |
| RetryDelay | 5 seconds | Delay between retries |
| ParallelExecution | 1 | Concurrent deployments |
| WaitForNetwork | true | Wait for VM network |
| NetworkWaitTimeout | 5 minutes | Network availability timeout |
| TakeSnapshotOnSuccess | false | Create post-deployment snapshot |
| SuccessSnapshotName | null | Name for success snapshot |
| RollbackOnFailure | true | Restore pre-deployment state |

### VMConfiguration

| Property | Required | Description |
|----------|----------|-------------|
| Name | ✅ | VM name |
| ProviderType | ✅ | HyperV or VirtualBox |
| MemoryMB | ✅ | Allocated memory |
| CpuCount | ✅ | CPU cores |
| SnapshotToRestore | ❌ | Base snapshot to restore |
| FileTransfers | ❌ | Files to transfer |
| PostDeployCommands | ❌ | Commands to execute |
| FtpConfiguration | ❌ | FTP connection settings |

## PowerShell Requirements

### Hyper-V PowerShell Module

The system requires the Hyper-V PowerShell module on Windows Pro/Enterprise:

```powershell
# Install module
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell

# Verify installation
Get-Module Hyper-V -ListAvailable
```

### PowerShell Direct

For command execution inside VMs without network connectivity:

```powershell
# PowerShell Direct requires:
# - Windows 10/11 or Windows Server 2016+
# - Guest OS with PowerShell enabled
# - Hyper-V Integration Services
```

## Error Handling

The system follows P4NTHE0N error handling patterns:

```csharp
try
{
    VMDeploymentResult result = await deploymentService.DeployAsync(config);
    if (!result.Success)
    {
        // Handle deployment failure
        Console.WriteLine($"[{result.VMName}] {result.Message}");
        if (result.ErrorDetails != null)
        {
            Console.WriteLine(result.ErrorDetails);
        }
    }
}
catch (Exception ex)
{
    var frame = new StackTrace(ex, true).GetFrame(0);
    int line = frame?.GetFileLineNumber() ?? 0;
    Console.WriteLine($"[{line}] Deployment exception: {ex.Message}");
}
```

## Integration with P4NTHE0N

### Using with H4ND Agent

```csharp
// In H4ND.cs or H4ND automation logic
public class H4NDDeploymentWorker
{
    private readonly IVMDeploymentService _deploymentService;
    private readonly IStoreErrors _errorStore;

    public H4NDDeploymentWorker(IUnitOfWork unitOfWork)
    {
        IVMProviderFactory factory = new VMProviderFactory();
        _deploymentService = new VMDeploymentService(factory, unitOfWork.Errors);
        _errorStore = unitOfWork.Errors;
    }

    public async Task ProcessDeploymentQueueAsync(CancellationToken ct)
    {
        // Read deployment configs from SIGN4L collection
        // Execute deployments
        // Log results to EV3NT collection
    }
}
```

### Logging to MongoDB

```csharp
// Errors automatically logged to ERR0R collection
VMDeploymentService service = new(factory, errorStore: unitOfWork.Errors);

// Deployment events can be logged to EV3NT
IStoreEvents eventStore = unitOfWork.ProcessEvents;
eventStore.Insert(new ProcessEvent
{
    EventType = "VMDeployment",
    Data = result,
    Timestamp = DateTime.UtcNow
});
```

## Future Enhancements

1. **VirtualBox Full Implementation**: Complete VBoxManage integration
2. **Container Support**: Docker/Podman container deployment
3. **Cloud Providers**: Azure VM, AWS EC2, GCP Compute Engine
4. **Configuration Validation**: Pre-flight validation of VM configs
5. **Health Monitoring**: Continuous VM health checks
6. **Web Dashboard**: Real-time deployment status UI

## Troubleshooting

### Hyper-V Access Denied

```powershell
# Add user to Hyper-V Administrators group
Add-LocalGroupMember -Group "Hyper-V Administrators" -Member "USERNAME"
# Log out and back in for changes to take effect
```

### PowerShell Direct Fails

- Verify VM is running
- Check Hyper-V Integration Services version
- Ensure guest OS has PowerShell enabled
- Verify credentials have VM access

### File Transfer Fails

- Enable Guest Services in VM settings
- Check file paths exist on host
- Verify destination directory exists in VM
- Review VM permissions for file operations

## References

- [Hyper-V PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/module/hyper-v/)
- [VBoxManage Documentation](https://www.virtualbox.org/manual/ch08.html)
- [FluentFTP GitHub](https://github.com/robinrodricks/FluentFTP)
- [SSH.NET GitHub](https://github.com/sshnet/SSH.NET)
