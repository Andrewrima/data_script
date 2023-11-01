$nomeclatura = @('WS10', 'WS11', 'NT10', 'NT11')
$todosPC = 0

for ($i = 0; $i -lt $nomeclatura.Length; $i++ | sort) {
    $computadores = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Name -match $nomeclatura[$i] }).Name
    $todosPC = $todosPC+$computadores.Count}

$todosPC = $todosPC
[int]$counter = 0

for ($i = 0; $i -lt $nomeclatura.Length; $i++ | sort) {
    $computadores = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Name -match $nomeclatura[$i] })

    foreach ($computerName in $computadores.Name) {
    
    $counter++
    $progresso = (($counter / $todosPC) * 100)
    Write-Progress -Activity 'Alterando assinatura...' -Status "$([math]::Round($progresso)) % alterado..." -CurrentOperation $computerName -PercentComplete (($counter / $todosPC) * 100)
    Start-Sleep -Milliseconds 250


    try{Get-Service -ComputerName $computerName -Name *winrm* | Start-Service -ErrorAction SilentlyContinue}
    catch{        
        $erro = $($_.Exception.Message)
        Write-Host "Erro: " -NoNewline; Write-Host $erro -ForegroundColor Red -NoNewline; Write-Host " ao Habilitar o serviço WinRM no " -NoNewline; Write-Host $computerName -ForegroundColor Red
        continue
        }

    try{
    Invoke-Command -ComputerName $computerName -ScriptBlock { 
        $profilePath = (Split-Path -Parent $env:USERPROFILE)
        $users = (Get-ChildItem -Path $profilePath).Name
        $path = ("\AppData\Roaming\Microsoft\Signatures")

        foreach ($user in $users) {    
   
            If ((Test-Path "$($profilePath)\$($user)\$($path)\Kapitalo_v3.htm") -eq $true) {
                    (Get-Content -Path "$($profilePath)\$($user)\$($path)\Kapitalo_v3.htm") | ForEach-Object {$_ -replace "3144 - 2", "3144 - 11"} | Set-Content -Path "$($profilePath)\$($user)\$($path)\Kapitalo_v3.htm"
                }

            If ((Test-Path "$($profilePath)\$($user)\$($path)\Kapitalo_v3 (Google Workspace).htm") -eq $true) {
                    (Get-Content -Path "$($profilePath)\$($user)\$($path)\Kapitalo_v3 (Google Workspace).htm") | ForEach-Object {$_ -replace "3144 - 2", "3144 - 11"} | Set-Content -Path "$($profilePath)\$($user)\$($path)\Kapitalo_v3 (Google Workspace).htm"
                }

            If ((Test-Path "$($profilePath)\$($user)\$($path)\Kapitalo (Google Workspace).htm") -eq $true) {
                    (Get-Content -Path "$($profilePath)\$($user)\$($path)\Kapitalo (Google Workspace).htm") | ForEach-Object {$_ -replace "3144 - 2", "3144 - 11"} | Set-Content -Path "$($profilePath)\$($user)\$($path)\Kapitalo (Google Workspace).htm"
                }

            }
        }

        }
        catch{
            $erro = $($_.Exception.Message)
            Write-Host "Erro: " -NoNewline; Write-Host $erro -ForegroundColor Red -NoNewline; Write-Host " ao invocar o comando no " -NoNewline; Write-Host $computerName -ForegroundColor Red
            continue
        }

      try{Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service -ErrorAction SilentlyContinue}
      catch{continue}
}

$counter = $null
Write-Progress -Activity 'Alterando assinatura...' -Completed

}

Write-Host "Assinaturas alteradas!" -BackgroundColor Green -ForegroundColor black
