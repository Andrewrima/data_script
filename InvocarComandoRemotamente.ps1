$Computador = "NT11KPTL16-PC"

# Inicia o serviço de acesso remoto pelo powershell
Get-Service -ComputerName $Computador -Name *winrm* | Start-Service

# Invoca o comando remoto
Invoke-Command -ComputerName $Computador -ScriptBlock { Get-Process -Name explorer }

# Para o serviço de acesso remoto pelo powershell
Get-Service -ComputerName $Computador -Name *winrm* | Stop-Service
Get-Service -ComputerName $Computador -Name *winrm* | Select-Object Name, Status
