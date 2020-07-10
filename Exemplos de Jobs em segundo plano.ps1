#Cria um job e coloca em segundo plano
Get-ChildItem d:\ -Recurse 
Start-Job -Name GetAllFiles -ScriptBlock {Get-ChildItem d:\ -Recurse}

#Verifica os Jobs existentes e abre-os 
Get-Job -Name GetAllFiles
Receive-Job -Name GetAllFiles

#Verifica todos os Jobs e Elimina-os
Get-Job | Stop-Job