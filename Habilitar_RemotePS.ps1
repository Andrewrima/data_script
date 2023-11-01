########################################################################
#                                                                      #
#   Função para acessar remotamente um computador pelo powershell      #
#                                                                      #
#     Adicionar o comando abaixo dentro do arquivo:                    #
#     C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1           #
#                                                                      #
#     Se o arquivo não existir, criar ele (Como Administrador)         #
#                                                                      #
#     . "\\SERVIDOR\TI\Scripts\Habilitar_RemotePS.ps1"                 #
#     Set-Alias remoto Enter-PSSession                                 #
#                                                                      #
#                                                                      #
#     Feito isso, será possível usar o comando abaixo:                 #
#        Habilitar-RemotePS WS10KPTL16-PC                              #
#                                                                      #
########################################################################


function Habilitar-RemotePS {
    param ($ComputerName)
    Get-Service -ComputerName $ComputerName -Name *winrm* | Start-Service
    Get-Service -ComputerName $ComputerName -Name *winrm* | Select-Object Name, Status
    Enter-PSSession $ComputerName
}

function Desabilitar-RemotePS {
    param ($ComputerName)
    Get-Service -ComputerName $ComputerName -Name *winrm* | Stop-Service
    Get-Service -ComputerName $ComputerName -Name *winrm* | Select-Object Name, Status
}