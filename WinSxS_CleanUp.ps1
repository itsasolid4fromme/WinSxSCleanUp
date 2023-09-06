# Define a function to perform the WinSxS cleanup
function Clean-WinSxS {
    # Check if the script is running with elevated privileges (as Administrator)
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Please run this script as an administrator."
        Exit
    }

    # Perform a cleanup of the WinSxS folder using DISM
    Write-Host "Starting WinSxS cleanup..."

    # Capture the output of the DISM command
    $output = Invoke-Expression -Command "Dism.exe /Online /Cleanup-Image /StartComponentCleanup"

    # Check if the cleanup was successful
    if ($output -match "Operation completed successfully.") {
        Write-Host "WinSxS cleanup completed successfully."
    } else {
        Write-Host "WinSxS cleanup encountered an error. Please check the output for details."
        Write-Host $output
    }
}

# Run the WinSxS cleanup function
Clean-WinSxS
