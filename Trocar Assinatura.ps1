$OutLookProfilePath = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Profiles\" + $Profiles.Trim() + "\9375CFF0413111d3B88A00104B2A6676\00000002"
# Update the registry settings where Outlook picks up its signature information
If (Test-Path $TargetForSignatures) {
   Get-Item -Path $OutlookProfilePath | New-Itemproperty -Name "New Signature" -value $SignatureName -Propertytype string -Force 
   Get-Item -Path $OutlookProfilePath | New-Itemproperty -Name "Reply-Forward Signature" -value $SignatureName -Propertytype string -Force }