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
        netsh interface ipv4 add dnsservers "Ethernet" 10.1.4.36 index=1
        netsh interface ipv4 add dnsservers "Ethernet" 10.1.4.27 index=2
        netsh interface ipv4 add dnsservers "Ethernet" 10.3.0.60 index=3
        # ignorar os erros nas conexões por powershell
        } -ErrorAction Stop | Out-File "\\dsasp0505\temp\dns.txt" -append
    }
catch {write-host "Erro ao conectar no computador $($computer)" -ForegroundColor Red} 
}
$counter = $null