#Get Event Logs by Criteria


$sqlLogs = Get-EventLog Application -After (Get-Date).AddDays(-1) -Source MSSQLSERVER -EntryType Error | Group-Object Source
$acceptedLogCount = 1000


#Evaluate Log Count

if ($sqlLogs.Count -gt $acceptedLogCount) {
    Write-Host $env:computername -> "Log Sayisi : Beklenilen Degerlerin Uzerindedir."
    Write-Host "Kabul Edilen Log Sayisi : " $acceptedLogCount
}
else {
    Write-Host $env:computername -> "Log Sayisi : Beklenilen Degerlerdedir."
    Write-Host "Kabul Edilen Log Sayisi : " $acceptedLogCount
}



