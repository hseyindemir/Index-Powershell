Param
(
  [string]$SourceFilePath,
  [string]$FileName,
  [string]$ExeFolder
)
function Test-PendingReboot
{
 if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
 if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
 if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
 try { 
   $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
   $status = $util.DetermineIfRebootPending()
   if(($status -ne $null) -and $status.RebootPending){
     return $true
   }
 }catch{}
 
 return $false
}
function Last-Reboot-Time
{

 Get-WmiObject win32_operatingsystem | select csname, @{LABEL=’LastBootUpTime’;EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

$Computers= Get-Content C:\TESTDB.txt
foreach($computer in $Computers)
{
Write-Host $computer
$rebootStatus = Invoke-Command -ScriptBlock ${function:Test-PendingReboot} -ComputerName $computer
Write-Host $rebootStatus
if ($rebootStatus -eq $false)
{
    #Sunucu reboot bekliyorsa bunu kullanıcıya bildir ve dosya transferini başlatma
    Write-Host "Reboot Etmeniz Gerekli"
}
else 
{
 
  
  #Sunucuya dosya transferini başlat
  Copy-Item -Path $SourceFilePath\$FileName -Destination \\$computer\C$\DBA\$FileName -Verbose
  Write-Host "Patch Dosyasi"  $computer " Sunucusuna Kopyalanmistir. "
  #Patch İşlemini Yap.
  Write-Host "Patch İslemlerine Baslandi."
  $Session=New-PSSession -ComputerName $computer
  Invoke-Command -Session $Session -ScriptBlock{& $args[0] /q /action=patch /allinstances /IAcceptSQLServerLicenseTerms} -ArgumentList $ExeFolder -Verbose
}
}
