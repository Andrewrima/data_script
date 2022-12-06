######################################################################################################################################
#                                                                                                                                    #
#   Requeriments: Rsat.ActiveDirectory.DS-LDS.Tools                                                                                  #
#                                                                                                                                    #
#   How to install:                                                                                                                  #
#   set-itemproperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -value "0" -Force          #
#   start-process Add-WindowsCapability -ArgumentList "–online –Name Rsat.ActiveDirectory*" -Wait                                    #
#   set-itemproperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name "UseWUServer" -value "1" -Force          #
#                                                                                                                                    #
#                                                                                                                                    #
######################################################################################################################################


$computadores = Get-ADComputer -Filter * -Properties Name, Description | select Name, Description

foreach ($computador in $computadores) {
    try{
        if(Test-Connection -ComputerName $computador.Name -Delay 10 -Count 1 -ErrorAction Stop)
            {
            if($computador.Description -eq $null){Write-Host "Conexão Ok com $($computador.Name)"}
            else{Write-Host "Conexão Ok com $($computador.Description)"}
            }
            }
    
    catch{
          if($computador.Description -eq $null){
            Write-Host "$($_.Exception.Message): $($computador.Name)" -ForegroundColor Red
            }
          else{Write-Host "$($_.Exception.Message): $($computador.Description)" -ForegroundColor Red}
    
}
}