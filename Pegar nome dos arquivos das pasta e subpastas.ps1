Get-ChildItem -Path "C:\Users\arm\Downloads\OneDrive_1_15-06-2022" -Recurse |`
foreach{
$Item = $_
$Type = $_.Extension
$Path = $_.FullName
$Folder = $_.PSIsContainer
$Age = $_.CreationTime

$Path | Select-Object `
    @{n="Name";e={$Item}},`
    @{n="Created";e={$Age}},`
    @{n="filePath";e={$Path}},`
    @{n="Extension";e={if($Folder){"Folder"}else{$Type}}}`
}| Export-Csv "C:\Users\arm\Downloads\OneDrive_1_15-06-2022\Results.csv" -Encoding utf8 -NoTypeInformation 