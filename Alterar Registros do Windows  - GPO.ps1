#############################################################################
#                                                                           #
#    Descrição: Altera registro que desabilita suplemento do Worksite       #
#               (Aplicar por GPO)                                           #
#                                                                           #
#    Criado: 05/10/2021                                                     #
#    Alterado:                                                              #
#                                                                           #
#############################################################################

$val1 = Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Office\Word\Addins\WorkSiteOffice2007Addins.Connect -Name "LoadBehavior"
if($val1.LoadBehavior -ne 3)
    {
     set-itemproperty -Path HKCU:\SOFTWARE\Microsoft\Office\Word\Addins\WorkSiteOffice2007Addins.Connect -Name "LoadBehavior" -value 3 -Force
     "Registro Word Loadbehavior de $($env:COMPUTERNAME) alterado em: $(get-date) no usuário $($env:UserName)" >> "\\dsasp0505\temp\loadbehavior.txt"
    }

$val2 = Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Office\Excel\Addins\WorkSiteOffice2007Addins.Connect -Name "LoadBehavior"
if($val2.LoadBehavior -ne 3)
    {
     set-itemproperty -Path HKCU:\SOFTWARE\Microsoft\Office\Excel\Addins\WorkSiteOffice2007Addins.Connect -Name "LoadBehavior" -value 3 -Force
     "Registro Excel Loadbehavior de $($env:COMPUTERNAME) alterado em: $(get-date) no usuário $($env:UserName)" >> "\\dsasp0505\temp\loadbehavior.txt"
    }