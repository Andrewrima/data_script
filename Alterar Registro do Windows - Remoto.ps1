#############################################################################
#                                                                           #
#    Descrição: Habilita remotamente o Salvamento Local do Office.          #
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
            if($val1.LOCALSAVEAS -cne "Y")
                {
                 set-itemproperty -Path HKLM:\SOFTWARE\Interwoven\WorkSite\8.0\Integration\MenuSettings -Name "LOCALSAVEAS" -value "Y" -Force
                 "Registro LOCALSAVEASx86 de $($env:COMPUTERNAME) alterado em: $(get-date)" 
                }
            # verificando se a chave existe e caso seja igual a condição, ela será alterada pela definida
            $val2 = Get-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Interwoven\WorkSite\8.0\Integration\MenuSettings -Name "LOCALSAVEAS"
            if($val2.LOCALSAVEAS -cne "Y")
                {
                 set-itemproperty -Path HKLM:\SOFTWARE\WOW6432Node\Interwoven\WorkSite\8.0\Integration\MenuSettings -Name "LOCALSAVEAS" -value "Y" -Force
                 "Registro LOCALSAVEASx64 de $($env:COMPUTERNAME) alterado em: $(get-date)"
                }
        # ignorar os erros nas conexões por powershell
        } -ErrorAction Stop | Out-File "\\dsasp0505\temp\logfile.txt" -append
    }
catch {write-host "Erro ao conectar no computador $($computer)" -ForegroundColor Red} 
}
$counter = $null