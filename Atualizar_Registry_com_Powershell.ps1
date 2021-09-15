$val1 = Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Office\Word\Addins\WorkSiteOffice2007Addins.Connect -Name "LoadBehavior"
if($val1.LoadBehavior -ne 3)
{
 set-itemproperty -Path HKCU:\SOFTWARE\Microsoft\Office\Word\Addins\WorkSiteOffice2007Addins.Connect -Name "LoadBehavior" -value 3 -Force | Out-Null 
}

$val2 = Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Office\Excel\Addins\WorkSiteOffice2007Addins.Connect -Name "LoadBehavior"
if($val2.LoadBehavior -ne 3)
{
 set-itemproperty -Path HKCU:\SOFTWARE\Microsoft\Office\Excel\Addins\WorkSiteOffice2007Addins.Connect -Name "LoadBehavior" -value 3 -Force | Out-Null
}
