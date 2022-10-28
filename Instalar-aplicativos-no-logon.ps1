# Criar pasta no C: se ela não existir
if (-not(Test-Path C:\Temp\Instalaco)){
    mkdir C:\Temp\Instalacao -ErrorAction SilentlyContinue
}

# Copiar programas para o computador local
$pastas = Get-ChildItem \\domain.local\netlogon\Instalacao | % { $_.BaseName }

ForEach ($pasta in $pastas){
    $counter++
    $progresso = (($counter / $pastas.count) * 100)
    Write-Progress -Activity 'Copiando arquivos...' -Status "$([math]::Round($progresso)) % copiado..." -CurrentOperation $pasta -PercentComplete (($counter / $pastas.count) * 100)
    Start-Sleep -Milliseconds 250
    robocopy \\domain.local\netlogon\Instalacao\$($pasta) C:\Temp\Instalacao\$($pasta) /E /NFL /NDL /NJH /NJS /nc /ns /np
}
$counter = $null
Write-Progress -Completed
Clear-Host
Write-Host "Arquivos Copiados!" -BackgroundColor Green -ForegroundColor black

# Desinstalar WebAdvisor se ele existir
if (Test-Path "C:\Program Files\McAfee\WebAdvisor"){
    Write-Host "Desinstalando WebAdvisor..." -BackgroundColor Yellow -ForegroundColor Black
    Start-Process "C:\Program Files\McAfee\WebAdvisor\uninstaller.exe" -argumentlist "/s" -wait
    rm -r "C:\Program Files\McAfee\WebAdvisor" -ErrorAction SilentlyContinue
    Write-Host "WebAdvisor Desinstalado!" -BackgroundColor Green -ForegroundColor black
}

# Desinstalar McAfee se ele existir
if (Test-Path "C:\Program Files\McAfee..."){
    Write-Host "Desinstalando McAfee" -BackgroundColor Yellow -ForegroundColor Black
    Start-Process "C:\temp\instalacao\MCPR\Mccleanup.exe" -ArgumentList "-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s" -wait
    Write-Host "McAfee Desinstalado!" -BackgroundColor Green -ForegroundColor black
}

# Desinstalar GameEye se ele existir
if (Test-Path "C:\Program Files\Alienware\Alienware FXDisplay001 Components for AWCC"){
    Write-Host "Desinstalando GameEye..." -BackgroundColor Yellow -ForegroundColor Black
    Start-Process "C:\Program Files\Alienware\Alienware FXDisplay001 Components for AWCC\uninstall.exe" -ArgumentList "/s" -wait
    rm -r "C:\Program Files\Alienware\Alienware FXDisplay001 Components for AWCC" -ErrorAction SilentlyContinue
    Write-Host "GameEye Desinstalado!" -BackgroundColor Green -ForegroundColor black
}

# Instalando programas definidos no array
$programas= @{
'Start-Process "C:\Temp\Instalacao\AdobeReader\AdobeReader_v19820071.exe" -argumentlist "/sAll /rs /msi EULA_ACCEPT=YES" -wait' = '01. Adobe Reader'
'Start-Process "C:\Temp\Instalacao\GoogleChrome\GoogleChrome.exe" -argumentlist "/silent /install" -wait' = '02. Google Chrome'
'Start-Process "C:\Temp\Instalacao\Java\JDK_v8u211.exe" -argumentlist "/s" -wait' = '03. JDK'
'Start-Process "C:\Temp\Instalacao\Java\JRE_v8u211.exe" -argumentlist "/s" -wait' = '04. JRE'
'Start-Process "Dism" -argumentlist "/Online /Enable-Feature /FeatureName:NetFX3 /All /LimitAccess /Source:C:\Temp\Instalacao\NETFramework" -wait' = '05. Microsoft .NET Framework 3.5'
'Start-Process "C:\Temp\Instalacao\Office2021Apps\Office2021Apps.exe" -argumentlist "/configure C:\Temp\Instalacao\Office2021Apps\Remove.xml" -wait' = '06. Removendo Instalações do Office'
'Start-Process "C:\Temp\Instalacao\Office2021Apps\Office2021Apps.exe" -argumentlist "/configure C:\Temp\Instalacao\Office2021Apps\Configuracao.xml" -wait' = '07. Office 365'
'Start-Process "C:\Temp\Instalacao\GSuite\GSuite.exe" -argumentlist "/silent /install" -wait' = '08. GSuite'
'Start-Process "msiexec" -argumentlist "/i C:\Temp\Instalacao\PostgreODBC\PostgreODBC_v09.00.0101_x64.msi /qn /quiet" -wait' = '09. PostgreODBC x64'
'Start-Process "msiexec" -argumentlist "/i C:\Temp\Instalacao\PostgreODBC\PostgreODBC_v08.04.0200_x32.msi /qn /quiet" -wait' = '10. PostgreODBC x32'
'Start-Process "C:\Temp\Instalacao\DBeaver\DBeaver_v6.0.5_x86_64.exe" -argumentlist "/allusers /S" -wait' = '11. DBeaver'
'Start-Process "C:\Temp\instalacao\Python\Python_v3.7.3.exe" -argumentlist "/quiet InstallAllUsers=1 DefaultAllUsersTargetDir=C:\Python37 PrependPath=1 /accepteula" -wait' = '12. Python 3.7'
'Start-Process "C:\Python37\Scripts\pip.exe" -argumentlist "install bs4 certifi chardet idna joblib mariadb mysql-connector mysql-connector-python numpy pandas psycopg2 pymysql python-dateutil pytz pywin32 rsa scikit-learn scipy selenium six soupsieve sqlalchemy threadpoolctl urllib3 xlrd xlwings==0.20.5 xlsxwriter webdriver_manager lxml mss requests" -wait' = '13. Pip bibliotecas Python'
'Start-Process "C:\Python37\Scripts\xlwings.exe" -argumentlist "addin install" -Wait' = '14. Addin Xlwings'
'Start-Process "C:\Temp\Instalacao\Silverlight\Silverlight.exe" -argumentlist "/q /accepteula" -wait' = '15. Silverlight'
'Start-Process "C:\Temp\Instalacao\Winrar\Winrar_v611_x64.exe" -argumentlist "/S /accepteula" -wait' = '16. Winrar'
}

ForEach ($programa in $programas.GetEnumerator() | sort Value){    
    $counter++
    $progresso = (($counter / $programas.count) * 100)
    Write-Progress -Activity 'Instalando programas...' -Status "$($programa.Value)" -CurrentOperation "$([math]::Round($progresso)) % instalado..." -PercentComplete (($counter / $programas.count) * 100)
    Start-Sleep -Milliseconds 250
    try{Invoke-Expression $programa.Name -ErrorAction Stop
    Write-Host "$($programa.Value) instalado!" -BackgroundColor Green -ForegroundColor black}
    catch {write-host "Erro ao instalar o programa $($programa.Value)" -ForegroundColor Red | Out-File "C:\Temp\Instalacao\logfile.txt" -append}  
}
$counter = $null
$programa = $null
$programas.Clear()
Write-Progress -Completed
Clear-Host
Write-Host "Programas instalados!" -BackgroundColor Green -ForegroundColor black
Write-Host "Log de erros em: C:\Temp\Instalacao\logfile.txt"

sleep 5

# Cria váriaveis de ambiente do python e organizar a ordem com a variável do Wi
$WindowsAppsPath="$Env:USERPROFILE\AppData\Local\Microsoft\WindowsApps";
$PythonPath=(Resolve-Path "$Env:C:\Python37*\")
$PythonPath2=(Resolve-Path "$Env:C:\Python37\Scripts*\")
$Env:Path = (($Env:Path.Split(';') | Where-Object { $_ -ne "$WindowsAppsPath" }) -join ';');
$Env:Path = (($Env:Path.Split(';') | Where-Object { $_ -ne "$PythonPath" }) -join ';');
$Env:Path = (($Env:Path.Split(';') | Where-Object { $_ -ne "$PythonPath2" }) -join ';');
$Env:Path += ";$PythonPath";
$Env:Path += ";$PythonPath2";
$Env:Path +=";$WindowsAppsPath";
[Environment]::SetEnvironmentVariable("PATH", "$Env:Path", "Machine")

# Adicionar atalho do Dbeaver no Desktop
$SourceExe = 'C:\Program Files\DBeaver\dbeaver.exe'
$DestinationPath = 'C:\Users\Public\Desktop'

$SourceFilePath = "C:\Program Files\DBeaver\dbeaver.exe"
$ShortcutPath = "C:\Users\Public\Desktop\DBeaver.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()

#Fechar Powershell
$delay = 5
while ($delay -ge 1)
{
  Clear-Host
  write-host 'Fechando em' $($delay) -ForegroundColor Red -BackgroundColor White
  start-sleep 1
  $delay -= 1
}

exit
