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


$computadores = @{
    "NT10BKP04"   = "Andrew Machado"
    "Computador2" = "Usuário 2"
}


foreach ($computador in $computadores.GetEnumerator()) {
    Get-ADComputer -Filter * -Properties Name, Description | Where-Object { ($_.Name -eq $computador.Name) } | 
    Set-ADComputer -Description $computador.Value |
    Get-ADComputer -Filter * -Properties Name, Description | Where-Object { ($_.Name -eq $computador.Name) } | select Name, Description
}