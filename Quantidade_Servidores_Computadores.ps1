$nomeclatura = @('WS10K', 'WS11K', 'NT10K', 'NT11K','BKP')
$desktopsAD = @{}
$serversAD = [System.Collections.ArrayList]::new()

for ($i = 0; $i -lt $nomeclatura.Length; $i++ | sort) {
    $compsAD = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Name -match $nomeclatura[$i] })
    
    foreach ($compAD in $compsAD) {
        $desktopsAD.add($compAD.Name, $compAD.Description) 
    } 
}

Write-Host ""
Write-Host -NoNewline "Desktops:" -BackgroundColor Blue
$desktopsAD | sort

$nomeclatura = @('WS10', 'WS11', 'NT10', 'NT11', 'BKP','KPTL10')
$compsAD = Get-AdComputer -Filter * -Properties Name, Description | Select-Object Name, Description

foreach ($compAD in $compsAD) {
    if ($compAD.Name -notmatch ($nomeclatura -join '|')) {
        [void]$serversAD.Add($compAD)
    }
}

Write-Host ""
Write-Host -NoNewline "Servidores:" -BackgroundColor Blue
$serversAD | sort | ft

Write-Host "Total de Servidores em SP: $($serversAD.Count)" -ForegroundColor Cyan
Write-Host "Total de Computadores em SP: $($desktopsAD.Count)" -ForegroundColor Cyan