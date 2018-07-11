#Get Event Logs by Criteria

$failedLoginCount = get-eventlog -LogName Application -After (Get-Date).AddDays(-7) -Source MSSQLSERVER | Where-Object { $_.eventid -eq 18456 } | Group-Object Source
$acceptedLogCount = 100

#Evaluate Log Count

if ($failedLoginCount.Count -gt $acceptedLogCount) {
    Write-Host $env:computername -> "Failed Login Sayisi : Beklenilen Degerlerin Uzerindedir."
    Write-Host "Kabul Edilen Failed Login Sayisi : " $acceptedLogCount
}
else {
    Write-Host $env:computername -> "Failed Login Sayisi : Beklenilen Degerlerdedir."
    Write-Host "Kabul Edilen Failed Login Sayisi : " $acceptedLogCount
}
