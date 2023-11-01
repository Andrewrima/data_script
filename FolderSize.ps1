while ($true){

$folderPath = "E:\Research"

$folderSize = Get-ChildItem -Path $folderPath -Recurse | Measure-Object -Property Length -Sum

$sizeInBytes = $folderSize.Sum
$sizeInMB = $sizeInBytes / 1MB

$roundedSizeInMB = [math]::Round($sizeInMB, 2)

zabbix_sender -z 192.168.254.40 -s Hostname -k folder.size -o $folderSize.Sum

Write-Host "$roundedSizeInMB MB"

Sleep 1
}