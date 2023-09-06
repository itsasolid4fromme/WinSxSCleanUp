# Function to calculate folder size recursively
function Get-FolderSize {
    param (
        [string]$Path
    )
    $folder = Get-Item $Path
    $size = $folder.Length

    Get-ChildItem $Path -Recurse | ForEach-Object {
        $size += $_.Length
    }

    return $size
}

# Function to cleanup WinSxS folder
function Remove-WinSxS {
    Write-Host "Starting WinSxS cleanup..."
    
    $WinSxSPath = "C:\Windows\WinSxS"  # Change this path as needed
    $WinSxSSizeBefore = (Get-FolderSize -Path $WinSxSPath) / 1GB

    Write-Host "WinSxS folder size before cleanup: $WinSxSSizeBefore GB"

    # Run DISM cleanup (you can add more cleanup commands here)
    Write-Host "Running DISM cleanup..."
    DISM.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase /SPSuperseded


    $WinSxSSizeAfter = (Get-FolderSize -Path $WinSxSPath) / 1GB

    Write-Host "WinSxS folder size after cleanup: $WinSxSSizeAfter GB"
    $CleanupSize = $WinSxSSizeBefore - $WinSxSSizeAfter

    Write-Host "Total space saved: $CleanupSize GB"
    Write-Host "WinSxS cleanup completed."

    # Cleanup progress bar
    $Progress = 100
    Write-Progress -PercentComplete $Progress -Status "Cleanup completed" -Completed

    # Additional cleanup tasks can be added here

    # Display verbose information
    Write-Host "Verbose information:"
    Write-Host "  - This script runs DISM to clean up the WinSxS folder."
    Write-Host "  - The WinSxS folder size before and after cleanup is displayed."
    Write-Host "  - Total space saved is calculated."
}

# Run the cleanup function
Remove-WinSxS
