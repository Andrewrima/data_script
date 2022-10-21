Set-ExecutionPolicy RemoteSigned -Force -ErrorAction SilentlyContinue

# Criar pasta no C: se ela não existir
if (-not(Test-Path C:\Temp\Instalaco)){
    mkdir C:\Temp\Instalacao -ErrorAction SilentlyContinue
}

# Copiar programas para o computador local

robocopy \\domain.local\netlogon\Instalacao C:\Temp\Instalacao /E

# Desinstalar WebAdvisor se ele existir
if (Test-Path "C:\Program Files\McAfee\WebAdvisor"){
    Start-Process "C:\Program Files\McAfee\WebAdvisor\uninstaller.exe" -argumentlist "/s" -wait
    rm -r "C:\Program Files\McAfee\WebAdvisor" -ErrorAction SilentlyContinue
}


# Desinstalar McAfee se ele existir
if (Test-Path "C:\Program Files\McAfee"){
    Start-Process "C:\temp\instalacao\MCPR\Mccleanup.exe" -ArgumentList "-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s" -wait
}


# Desinstalar GameEye se ele existir
if (Test-Path "C:\Program Files\Alienware\Alienware FXDisplay001 Components for AWCC"){
    Start-Process "C:\Program Files\Alienware\Alienware FXDisplay001 Components for AWCC\uninstall.exe" -ArgumentList "/s" -wait
    rm -r "C:\Program Files\Alienware\Alienware FXDisplay001 Components for AWCC" -ErrorAction SilentlyContinue
}

# Criar variáveis de ambiente 
[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\Python37\"+";C:\Python37\Scripts\", [EnvironmentVariableTarget]::Machine)

# Instalar AdobeReader
Start-Process "C:\Temp\Instalacao\AdobeReader\AdobeReader_v19820071.exe" -argumentlist "/sAll /rs /msi EULA_ACCEPT=YES" -wait

# Instalar DBeaver
Start-Process "C:\Temp\Instalacao\DBeaver\DBeaver_v6.0.5_x86_64.exe" -argumentlist "/allusers /S" -wait

# Intalar GoogleChrome
Start-Process "C:\Temp\Instalacao\GoogleChrome\GoogleChrome.exe" -argumentlist "/silent /install" -wait

# Instalar JDK
Start-Process "C:\Temp\Instalacao\Java\JDK_v8u211.exe" -argumentlist "/s" -wait

# Instalar JRE
Start-Process "C:\Temp\Instalacao\Java\JRE_v8u211.exe" -argumentlist "/s" -wait

# Instalar NETFramework
Start-Process "Dism" -argumentlist "/Online /Enable-Feature /FeatureName:NetFX3 /All /LimitAccess /Source:C:\Temp\Instalacao\NETFramework" -wait

# Remove todas as instalações antigas do office
Start-Process "C:\Temp\Instalacao\Office2021Apps\Office2021Apps.exe" -argumentlist "/configure C:\Temp\Instalacao\Office2021Apps\Remove.xml" -wait

# Instalar Office2021Apps
Start-Process "C:\Temp\Instalacao\Office2021Apps\Office2021Apps.exe" -argumentlist "/configure C:\Temp\Instalacao\Office2021Apps\Configuracao.xml" -wait

# Instalar GSuite
Start-Process "C:\Temp\Instalacao\GSuite\GSuite.exe" -argumentlist "/silent /install" -wait

# Remover a opção "Ask to update automatic links" do Excel
reg add HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\Options\Binaryoptions /f /v "fupdateext_78_1" /t REG_DWORD /d "1"

# Instalar PostgreODBC
Start-Process "msiexec" -argumentlist "/i C:\Temp\Instalacao\PostgreODBC\PostgreODBC_v09.00.0101_x64.msi /qn /quiet" -wait

# Instalar PostgreODBC
Start-Process "msiexec" -argumentlist "/i C:\Temp\Instalacao\PostgreODBC\PostgreODBC_v08.04.0200_x32.msi /qn /quiet" -wait

# Instalar Python
Start-Process "C:\Temp\instalacao\Python\Python_v3.7.3.exe" -argumentlist "/quiet InstallAllUsers=1 DefaultAllUsersTargetDir=C:\Python37 PrependPath=1 /accepteula" -wait

# Instalar bibliotecas do Python
Start-Process "C:\Python37\Scripts\pip.exe" -argumentlist "install bs4 certifi chardet idna joblib mariadb mysql-connector mysql-connector-python numpy pandas psycopg2 pymysql python-dateutil pytz pywin32 rsa scikit-learn scipy selenium six soupsieve sqlalchemy threadpoolctl urllib3 xlrd xlwings==0.20.5 xlsxwriter webdriver_manager lxml mss requests" -wait

# Instalar o xlwings no Excel
Start-Process "C:\Python37\Scripts\xlwings.exe" -argumentlist "addin install" -Wait

# Instalar Silverlight
Start-Process "C:\Temp\Instalacao\Silverlight\Silverlight.exe" -argumentlist "/q /accepteula" -wait

# Instalar Winrar
Start-Process "C:\Temp\Instalacao\Winrar\Winrar_v611_x64.exe" -argumentlist "/S /accepteula" -wait

# Instalar Teamviewer a partir de uma pasta na rede com configurações padrões
Start-Process "msiexec" -argumentlist "/i \\local\TeamViewer_Full.msi" /qb SETTINGSFILE="\\local\Config.tvopt" -wait

# Adicionar atalho do Dbeaver no Desktop
$SourceExe = 'C:\Program Files\DBeaver\dbeaver.exe'
$DestinationPath = 'C:\Users\Public\Desktop'

$SourceFilePath = "C:\Program Files\DBeaver\dbeaver.exe"
$ShortcutPath = "C:\Users\Public\Desktop\DBeaver.lnk"
$WScriptObj = New-Object -ComObject ("WScript.Shell")
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.Save()

Set-ExecutionPolicy Default -Force -ErrorAction SilentlyContinue
