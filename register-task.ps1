# register-task.ps1 — Register PortfolioServer Scheduled Task
# Run this script as Administrator once to set up auto-start on login.
# Usage: Right-click this file → "Run with PowerShell" (as Admin)

$taskName = "PortfolioServer"
$workDir  = "C:\Users\HP\Desktop\HostedProjects\PortFolio"

# Remove old task if it exists
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Removed old task: $taskName"
}

$action  = New-ScheduledTaskAction `
    -Execute "C:\Users\HP\AppData\Local\Programs\Python\Python312\pythonw.exe" `
    -Argument "start_server.py" `
    -WorkingDirectory $workDir

$trigger = New-ScheduledTaskTrigger -AtLogOn

$settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Hours 72) `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName    $taskName `
    -Action      $action `
    -Trigger     $trigger `
    -Settings    $settings `
    -Description "Portfolio static site server - Port 8080" `
    -RunLevel    Highest `
    -Force

Write-Host "✅ Task '$taskName' registered successfully!" -ForegroundColor Green
Write-Host "   It will auto-start at next login." -ForegroundColor Cyan
Write-Host "   To start it now, run: Start-ScheduledTask -TaskName '$taskName'" -ForegroundColor Cyan
