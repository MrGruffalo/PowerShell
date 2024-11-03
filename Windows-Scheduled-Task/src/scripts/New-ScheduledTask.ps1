# New-ScheduledTask.ps1 is designed to iterate over a list of tasks and create them. Creation is based on having the same set of task actions, triggers etc.
$Tasks = @("Task-1", "Task-2")
$User = Get-Credential

foreach ($Task in $Tasks) {
    <# If the task already exists - an error will generate for that specific task and will continue to iterate through the list
    Register-ScheduledTask : Cannot create a file when that file already exists. #>
    $TaskName = "$Task"
    $TaskDescription = "$Task does a thing"
    $TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy ByPass -File Test2.ps1 $Task" -WorkingDirectory "C:\"
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId $User -LogonType Password -RunLevel Highest
    $TaskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1)
    $NewScheduledTask = New-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Description $TaskDescription
    Register-ScheduledTask -TaskName $TaskName -InputObject $NewScheduledTask -User $User.UserName -Password $User.GetNetworkCredential().password
}