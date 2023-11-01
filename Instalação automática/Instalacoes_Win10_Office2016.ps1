# Criar pasta no C: se ela não existir
if (-not(Test-Path C:\Temp\Instalaco)){
    mkdir C:\Temp\Instalacao -ErrorAction SilentlyContinue
}

# Copiar programas para o computador local
$pastas = Get-ChildItem \\kapitalo.local\netlogon\Instalacao | % { $_.BaseName }

ForEach ($pasta in $pastas){
    $counter++
    $progresso = (($counter / $pastas.count) * 100)
    Write-Progress -Activity 'Copiando arquivos...' -Status "$([math]::Round($progresso)) % copiado..." -CurrentOperation $pasta -PercentComplete (($counter / $pastas.count) * 100)
    Start-Sleep -Milliseconds 250
    robocopy \\kapitalo.local\netlogon\Instalacao\$($pasta) C:\Temp\Instalacao\$($pasta) /E /NFL /NDL /NJH /NJS /NC /NS /NP
}
$counter = $null
Write-Progress -Activity 'Copiando arquivos...' -Completed
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
'Start-Process "Dism" -argumentlist "/Online /Enable-Feature /FeatureName:NetFX3 /All /LimitAccess /Source:C:\Temp\Instalacao\NETFramework\Windows10" -wait' = '05. Microsoft .NET Framework 3.5'
'Start-Process "C:\Temp\Instalacao\Office2016\x32\English\setup.exe" -argumentlist "/adminfile C:\Temp\Instalacao\Office2016\x32\English\office-setup.MSP" -wait' = '06. Office 2016'
'Start-Process "C:\Temp\Instalacao\GSuite\GSuite.exe" -argumentlist "/silent /install" -wait' = '07. GSuite'
'Start-Process "msiexec" -argumentlist "/i C:\Temp\Instalacao\PostgreODBC\PostgreODBC_v09.00.0101_x64.msi /qn /quiet" -wait' = '08. PostgreODBC x64'
'Start-Process "msiexec" -argumentlist "/i C:\Temp\Instalacao\PostgreODBC\PostgreODBC_v08.04.0200_x32.msi /qn /quiet" -wait' = '09. PostgreODBC x32'
'Start-Process "C:\Temp\Instalacao\DBeaver\DBeaver_v6.0.5_x86_64.exe" -argumentlist "/allusers /S" -wait' = '10. DBeaver'
'Start-Process "C:\Temp\Instalacao\Python\Python_v3.7.3.exe" -argumentlist "/quiet InstallAllUsers=1 DefaultAllUsersTargetDir=C:\Python37 PrependPath=1 /accepteula" -wait' = '11. Python 3.7'
'Start-Process "C:\Python37\Scripts\pip.exe" -argumentlist "install -r \\SERVIDOR\TI\Disks\_Python\Requirements.txt" -wait' = '12. Pip bibliotecas Python'
'Start-Process "C:\Python37\Scripts\xlwings.exe" -argumentlist "addin install" -Wait' = '13. Addin Xlwings'
'Start-Process "C:\Temp\Instalacao\Silverlight\Silverlight.exe" -argumentlist "/q /accepteula" -wait' = '14. Silverlight'
'Start-Process "C:\Temp\Instalacao\Winrar\Winrar_v611_x64.exe" -argumentlist "/S /accepteula" -wait' = '15. Winrar'
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

# Cria variaveis de ambiente do Python e organiza a ordem com a variável do Windows Apps
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

# Instalação manual de outros programas.
$continue = $true
while($continue){
$tecla = Read-Host '
1. Foxit Reader
2. Pycharm Community
3. R e R Studio
4. Refinitiv
5. Teamviewer
6. Sair
'
    if($tecla -eq 1){
        try{Write-Host "Instalando o Foxit Reader..." -BackgroundColor Yellow -ForegroundColor Black
            robocopy "\\SERVIDOR\TI\Disks\Foxit Reader" "C:\Temp\Instalacao\Foxit Reader" /E /NFL /NDL /NJH /NJS /NC /NS /NP
            start-process "C:\Temp\Instalacao\Foxit Reader\Foxit Reader v722.0929.exe" -argument "/VERYSILENT /NORESTART" -wait            
            }

        catch{write-host "Erro ao instalar o Foxit Reader" -ForegroundColor Red}
    
        Write-Host "Foxit Reader Instalado!" -BackgroundColor Green -ForegroundColor black
        }

    if($tecla -eq 2){
        try{Write-Host "Instalando o Pycharm Community..." -BackgroundColor Yellow -ForegroundColor Black
            robocopy "\\SERVIDOR\TI\Disks\PyCharm" "C:\Temp\Instalacao\Pycharm" "Pycharm Community v2022.2.3.exe" /E /NFL /NDL /NJH /NJS /NC /NS /NP
            start-process "C:\temp\instalacao\Pycharm\Pycharm Community v2022.2.3.exe" -argument "/S" -wait
            }

        catch{write-host "Erro ao instalar o Pycharm Community" -ForegroundColor Red}
    
        Write-Host "Pycharm Community Instalado!" -BackgroundColor Green -ForegroundColor black
        }

    if($tecla -eq 3){
        try{Write-Host "Instalando o R e R Studio..." -BackgroundColor Yellow -ForegroundColor Black
            robocopy "\\SERVIDOR\TI\Disks\RStudio" "C:\Temp\Instalacao\RStudio" "R 4.2.2.exe" "RStudio 2022.07.2.exe" /E /NFL /NDL /NJH /NJS /NC /NS /NP
            start-process "C:\temp\instalacao\RStudio\R 4.2.2.exe" -argument "/SILENT /VERYSILENT" -wait
            start-process "C:\temp\instalacao\RStudio\RStudio 2022.07.2.exe" -argument "/S" -wait
            }

        catch{write-host "Erro ao instalar o R e R Studio" -ForegroundColor Red}
    
        Write-Host "R e R Studio Instalado!" -BackgroundColor Green -ForegroundColor black
        }
    if($tecla -eq 4){
        try{Write-Host "Instalando o Refinitiv Messenger..." -BackgroundColor Yellow -ForegroundColor Black
            robocopy "\\SERVIDOR\Dados\TI\Disks\_Software Traders\Refinitiv Messenger" "C:\Temp\Instalacao\Refinitiv Messenger" /E /NFL /NDL /NJH /NJS /NC /NS /NP
            start-process "C:\Temp\Instalacao\Refinitiv Messenger\Refinitiv Messenger v1.11.385.exe" -argument "--silent" -wait            
            }

        catch{write-host "Erro ao instalar o Refinitiv Messenger" -ForegroundColor Red}
    
        Write-Host "Refinitiv Messenger Instalado!" -BackgroundColor Green -ForegroundColor black
        }

    if($tecla -eq 5){
        try{Write-Host "Instalando o TeamViewer..." -BackgroundColor Yellow -ForegroundColor Black
            robocopy "\\SERVIDOR\TI\Disks\Teamviewer" "C:\Temp\Instalacao\Teamviewer" /E /NFL /NDL /NJH /NJS /NC /NS /NP
            Start-Process msiexec.exe -argumentlist '/i "C:\Temp\Instalacao\Teamviewer\Teamviewer.msi" /qb SETTINGSFILE="C:\Temp\Instalacao\Teamviewer\Config.tvopt"' -wait
            }

        catch{write-host "Erro ao instalar o TeamViewer" -ForegroundColor Red}
    
        Write-Host "TeamViewer Instalado!" -BackgroundColor Green -ForegroundColor black
        }

    if($tecla -eq 6){exit}
}