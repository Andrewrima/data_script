#Criar parâmetros de importação e conexão com o servidor office365 
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

#Habilitar execução de políticas
Set-ExecutionPolicy RemoteSigned

#Importar módulo para execução 
Import-PSSession $Session

#Mover a caixa
New-Moverequest -identity email@dominio.com

#Ver status da movimentação
Get-Moverequest -identity email@dominio.com -Verbose

#Voltar a politica de execução de políticas
Set-ExecutionPolicy Default
