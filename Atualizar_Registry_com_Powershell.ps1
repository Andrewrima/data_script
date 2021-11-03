##############################################################################################
#                                                                                            #
#    Descrição: Registro Class Root                                                          #
#    Criado: 20/10/2021                                                                      #
#    Alterado:                                                                               #
#                                                                                            #
##############################################################################################

# lista dos computadores
$computerlist = Get-Content -Path 'C:\temp\computerlist.txt' -Force

ForEach ($computer in $computerlist){
# Barra de progresso
$counter++
Write-Progress -Activity 'Processando computadores...' -CurrentOperation $computer -PercentComplete (($counter / $computerList.count) * 100)
Start-Sleep -Milliseconds 200
    try{
    # comando para acessar remoto os computadores (precisa estar habilitador o remote powershell)
        Invoke-Command -ComputerName $computer -ScriptBlock {New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

            # verificando se a chave existe e caso seja igual a condição, ela será alterada pela definida
            $val1 = Get-ItemProperty -Path HKCR:\Nrl\Shell\open\Command\ -Name "(Default)"
            if($val1.'(default)' -eq '"C:\Program Files\Interwoven\WorkSite\Nrl.exe" /IManExt3.ProtectedOpenCmd /l "%1"')
                {
                 set-itemproperty -Path HKCR:\Nrl\Shell\open\Command\ -Name "(Default)" -value '"C:\Program Files\Interwoven\WorkSite\Nrl.exe" /IManExt.OpenCmd /l "%1"' -Force | Out-Null
                 "Registro ProtectOpenx64 de $($env:COMPUTERNAME) alterado em: $(get-date)"
                }
            # verificando se a chave existe e caso seja igual a condição, ela será alterada pela definida
            $val2 = Get-ItemProperty -Path HKCR:\Nrl\Shell\open\Command\ -Name "(Default)"
            if($val2.'(default)' -eq '"C:\Program Files (x86)\Interwoven\WorkSite\Nrl.exe" /IManExt3.ProtectedOpenCmd /l "%1"')
                {
                 set-itemproperty -Path HKCR:\Nrl\Shell\open\Command\ -Name "(Default)" -value '"C:\Program Files (x86)\Interwoven\WorkSite\Nrl.exe" /IManExt.OpenCmd /l "%1"' -Force | Out-Null
                 "Registro ProtectOpenx86 de $($env:COMPUTERNAME) alterado em: $(get-date)"
                }
        # ignorar os erros nas conexões por powershell
        } -ErrorAction Stop | Out-File "\\dsasp0505\temp\protectopen.txt" -append
    }
# filtrar os erros de conexão e exibir qual máquina não teve a conexão
catch {write-host "Erro ao conectar no computador $($computer)" -ForegroundColor Red} 
}


#############################################################################
#                                                                           #
#    Descrição: Registro Local Machine.                                     #
#    Criado: 20/10/2021                                                     #
#    Alterado:                                                              #
#                                                                           #
#############################################################################

# lista dos computadores
$computerlist = Get-Content -Path 'C:\temp\computerlist.txt' -Force

ForEach ($computer in $computerlist){
#Barra de progresso
$counter++
Write-Progress -Activity 'Processando computadores...' -CurrentOperation $computer -PercentComplete (($counter / $computerList.count) * 100)
Start-Sleep -Milliseconds 200
    try{
        # comando para acessar remoto os computadores (precisa estar habilitador o remote powershell)
        Invoke-Command -ComputerName $computer -ScriptBlock {
            # verificando se a chave existe e caso seja igual a condição, ela será alterada pela definida
            $val1 = Get-ItemProperty -Path HKLM:\SOFTWARE\Interwoven\WorkSite\8.0\Integration\MenuSettings -Name "LOCALSAVEAS"
            if($val1.LOCALSAVEAS -eq "N")
                {
                 set-itemproperty -Path HKLM:\SOFTWARE\Interwoven\WorkSite\8.0\Integration\MenuSettings -Name "LOCALSAVEAS" -value "Y" -Force
                 "Registro LOCALSAVEASx86 de $($env:COMPUTERNAME) alterado em: $(get-date)" 
                }
            # verificando se a chave existe e caso seja igual a condição, ela será alterada pela definida
            $val2 = Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Interwoven\WorkSite\8.0\Integration\MenuSettings -Name "LOCALSAVEAS"
            if($val2.LOCALSAVEAS -eq "N")
                {
                 set-itemproperty -Path HKLM:\SOFTWARE\WOW6432Node\Interwoven\WorkSite\8.0\Integration\MenuSettings -Name "LOCALSAVEAS" -value "Y" -Force
                 "Registro LOCALSAVEASx64 de $($env:COMPUTERNAME) alterado em: $(get-date)"
                }
        # ignorar os erros nas conexões por powershell
        } -ErrorAction Stop | Out-File "\\dsasp0505\temp\logfile.txt" -append
    }
catch {write-host "Erro ao conectar no computador $($computer)" -ForegroundColor Red} 
}
