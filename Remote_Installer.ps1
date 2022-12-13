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

<# 
.NAME
    Form Install
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$programas = @('Foxit Reader', 'Bibliotecas Python', 'Visual Studio Code', 'PowerBI', 'Pycharm Community', 'R 4.2.2', 'RStudio', 'Refinitiv Messenger', 'Teamviewer', 'Desinstalar Office 365', 'Office 16 x32', 'Office 16 x64', 'Office 365 x32', 'DBeaver', 'Office 365 x64', 'PostgreODBC x64', 'PostgreODBC x32')
#$computadores = Get-ADComputer -Filter * -SearchBase "CN=Computers,DC=kapitalo,DC=local" | select Name

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = New-Object System.Drawing.Point(357, 65)
$Form.text = "Remote Installer"
$Form.TopMost = $false

$button = New-Object system.Windows.Forms.Button
$button.text = "Instalar"
$button.width = 63
$button.height = 22
$button.location = New-Object System.Drawing.Point(289, 37)
$button.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$ComboBox2 = New-Object system.Windows.Forms.ComboBox
$ComboBox2.text = "Computador"
$ComboBox2.width = 167
$ComboBox2.height = 20
$ComboBox2.location = New-Object System.Drawing.Point(9, 10)
$ComboBox2.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$ComboBox1 = New-Object system.Windows.Forms.ComboBox
$ComboBox1.text = "Programa"
$ComboBox1.width = 167
$ComboBox1.height = 20
$ComboBox1.location = New-Object System.Drawing.Point(184, 10)
$ComboBox1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

foreach ($programa in $programas | sort) {
    $ComboBox1.Items.add($programa)
}

$nomeclatura = @('WS10', 'WS11', 'NT10', 'NT11')


for ($i = 0; $i -lt $nomeclatura.Length; $i++ | sort) {
    $computadores = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Name -match $nomeclatura[$i] }).Description
    foreach ($computador in $computadores | sort) {
        $ComboBox2.Items.add($computador)
    }
}


<#
foreach($computador in $computadores | sort name)
{
  $ComboBox2.Items.add($computador.Name)
}
#>

$Label1 = New-Object system.Windows.Forms.Label
$Label1.text = "Status"
$Label1.AutoSize = $true
$Label1.width = 25
$Label1.height = 10
$Label1.location = New-Object System.Drawing.Point(9, 38)
$Label1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

# Ícone base64 pego no site https://icons8.com/icons/set/base-64
$iconBase64 = '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'
$iconBytes = [Convert]::FromBase64String($iconBase64)
$stream = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
$Form.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
$stream.Dispose()

#$Form.Controls.Add($ComboBox1)

$Form.controls.AddRange(@($button, $ComboBox2, $ComboBox1, $Label1))

$button.Add_Click({

        # Instalar o PostgreODBC x64
        if ($ComboBox1.Text -eq 'PostgreODBC x64') {
            try {
                $file = "\\kapitalo.local\netlogon\Instalacao\PostgreODBC\PostgreODBC_v09.00.0101_x64.msi"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando PostgreODBC x64..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\PostgreODBC_v09.00.0101_x64.msi" -Force

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process msiexec -ArgumentList '/i c:\windows\temp\PostgreODBC_v09.00.0101_x64.msi /qn /quiet' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o PostgreODBC x64" 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\psqlODBC") {
                $Label1.text = "PostgreODBC x64 Instalado!"
                $Label1.ForeColor = "Green"
            }
        }

        # Instalar Bibliotecas do Python
        if ($ComboBox1.Text -eq 'Bibliotecas Python') {
            try {
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Bibliotecas Python..."
                $Label1.ForeColor = "Blue"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process "C:\Python37\Scripts\pip.exe" -ArgumentList 'install -r \\fskptl01\TI\Disks\_Python\requirements.txt' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar Bibliotecas Python" 
                $Label1.ForeColor = "Red"
            }
        
            $Label1.text = "Bibliotecas Python Instalado!"
            $Label1.ForeColor = "Green"
        }


        # Instalar o PostgreODBC x32
        if ($ComboBox1.Text -eq 'PostgreODBC x32') {
            try {
                $file = "\\kapitalo.local\netlogon\Instalacao\PostgreODBC\PostgreODBC_v08.04.0200_x32.msi"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando PostgreODBC x32..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\PostgreODBC_v08.04.0200_x32.msi"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process msiexec -ArgumentList '/i c:\windows\temp\PostgreODBC_v08.04.0200_x32.msi /qn /quiet' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o PostgreODBC x32" 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files (x86)\psqlODBC") {
                $Label1.text = "PostgreODBC x32 Instalado!"
                $Label1.ForeColor = "Green"
            }

        }

        # Desinstalar office 365
        if ($ComboBox1.Text -eq 'Desinstalar Office 365') {
            try {
                $file = "\\kapitalo.local\NETLOGON\Instalacao\Office2021Apps\Office2021Apps.exe"
                $file2 = "\\kapitalo.local\NETLOGON\Instalacao\Office2021Apps\Remove.xml"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Desinstalando Office 365..."

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\Office2021Apps.exe"
                Copy-Item -Path $file2 -Destination "\\$($computername)\c$\windows\temp\Remove.xml"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock {
                    Stop-Process -Name EXCEL -Force
                    Stop-Process -Name WINWORD -Force
                    Stop-Process -Name OUTLOOK -Force 
                    Start-Process c:\windows\temp\Office2021Apps.exe -ArgumentList '/configure c:\windows\temp\Remove.xml' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao desinstalar o Office 365" 
                $Label1.ForeColor = "Red"
            }
        
            Remove-Item "c:\windows\temp\Office2021Apps.exe" -Force
            Remove-Item "c:\windows\temp\Remove.xml" -Force
            $Label1.text = "Office 365 desinstalado!"
            $Label1.ForeColor = "Green"
        }

        # Instalar Office 365 x32
        if ($ComboBox1.Text -eq 'Office 365 x32') {
            try {
                $file = "\\kapitalo.local\NETLOGON\Instalacao\Office2021Apps\Office2021Apps.exe"
                $file2 = "\\kapitalo.local\NETLOGON\Instalacao\Office2021Apps\Configuracao.xml"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Office 365..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\Office2021Apps.exe"
                Copy-Item -Path $file2 -Destination "\\$($computername)\c$\windows\temp\Configuracao.xml"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock {
                    Stop-Process -Name EXCEL -Force
                    Stop-Process -Name WINWORD -Force
                    Stop-Process -Name OUTLOOK -Force 
                    Start-Process c:\windows\temp\Office2021Apps.exe -ArgumentList '/configure c:\windows\temp\Configuracao.xml' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao Instalar o Office 365." 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files (x86)\Microsoft Office\root\Office16") {
                $Label1.text = "Office 365 Instalado!"
                $Label1.ForeColor = "Green"
            }

        }

        # Instalar Office 365 x64
        if ($ComboBox1.Text -eq 'Office 365 x64') {
            try {
                $file = "\\kapitalo.local\NETLOGON\Instalacao\Office2021Apps\Office2021Apps.exe"
                $file2 = "\\kapitalo.local\NETLOGON\Instalacao\Office2021Apps\Configuracao_x64.xml"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Office 365 x64..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\Office2021Apps.exe"
                Copy-Item -Path $file2 -Destination "\\$($computername)\c$\windows\temp\Configuracao_x64.xml"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock {
                    Stop-Process -Name EXCEL -Force
                    Stop-Process -Name WINWORD -Force
                    Stop-Process -Name OUTLOOK -Force 
                    Start-Process c:\windows\temp\Office2021Apps.exe -ArgumentList '/configure c:\windows\temp\Configuracao_x64.xml' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao Instalar o Office 365 x64." 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\Microsoft Office\root\Office16") {
                $Label1.text = "Office 365 x64 Instalado!"
                $Label1.ForeColor = "Green"
            }

        }

        # Instalar Office 16 x32
        if ($ComboBox1.Text -eq 'Office 16 x32') {
            try {
                $file = "\\kapitalo.local\NETLOGON\Instalacao\Office2016\x32"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Office 16 x32..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Recurse -Path $file -Destination "\\$($computername)\c$\windows\temp\"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock {
                    Stop-Process -Name EXCEL -Force
                    Stop-Process -Name WINWORD -Force
                    Stop-Process -Name OUTLOOK -Force 
                    Start-Process C:\windows\temp\x32\English\setup.exe -ArgumentList '/adminflie C:\windows\temp\x32\English\office-setup.MSP' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao Instalar o Office 16 x32." 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files (x86)\Microsoft Office\Office16") {
                $Label1.text = "Office 16 x32 Instalado!"
                $Label1.ForeColor = "Green"
            }

        }

        # Instalar Office 16 x64
        if ($ComboBox1.Text -eq 'Office 16 x64') {
            try {
                $file = "\\kapitalo.local\NETLOGON\Instalacao\Office2016\x64"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Office 16 x64..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Recurse -Path $file -Destination "\\$($computername)\c$\windows\temp\"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock {
                    Stop-Process -Name EXCEL -Force
                    Stop-Process -Name WINWORD -Force
                    Stop-Process -Name OUTLOOK -Force 
                    Start-Process C:\windows\temp\x64\English\setup.exe -ArgumentList '/adminflie C:\windows\temp\x64\English\office-setup.MSP' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao Instalar o Office 16 x64." 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\Microsoft Office\Office16") {
                $Label1.text = "Office 16 x64 Instalado!"
                $Label1.ForeColor = "Green"
            }
        }

        # Instalar DBeaver
        if ($ComboBox1.Text -eq 'DBeaver') {
            try {
                $file = "\\FSKPTL01\TI\Disks\_Dbeaver\Dbeaver CE v6.0.5.exe"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando DBeaver..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\installer.exe"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process c:\windows\temp\installer.exe -ArgumentList '/allusers /S' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao Instalar o DBeaver." 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\DBeaver") {
                $Label1.text = "DBeaver Instalado!"
                $Label1.ForeColor = "Green"
            }
        }

        # Instala o Foxit Reader da Rede
        if ($ComboBox1.Text -eq 'Foxit Reader') {
            try {
                $file = "\\FSKPTL01\TI\Disks\Foxit Reader\Foxit Reader v722.0929.exe"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Foxit..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\installer.exe"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process c:\windows\temp\installer.exe -ArgumentList '/VERYSILENT /NORESTART' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o Foxit Reader" 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files (x86)\Foxit Software") {
                $Label1.text = "Foxit instalado!"
                $Label1.ForeColor = "Green"
            }
        }

        # Instala o Pycharm Community da Rede
        if ($ComboBox1.Text -eq 'Pycharm Community') {
            try {
                $file = "\\FSKPTL01\TI\Disks\PyCharm\Pycharm Community v2022.2.3.exe"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Pycharm Community..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\installer.exe"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process c:\windows\temp\installer.exe -ArgumentList '/S' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o Pycharm Community" 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\JetBrains") {
                $Label1.text = "Pycharm Community instalado!"
                $Label1.ForeColor = "Green"
            }
        }

        # Instala o R 4.2.2 da Rede
        if ($ComboBox1.Text -eq 'R 4.2.2') {
            try {
                $file = "\\FSKPTL01\TI\Disks\RStudio\R 4.2.2.exe"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando R 4.2.2..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\installer.exe"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process c:\windows\temp\installer.exe -ArgumentList '/SILENT /VERYSILENT' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o R 4.2.2" 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\R") {
                $Label1.text = "R 4.2.2 instalado!"
                $Label1.ForeColor = "Green"
            }
        }

        # Instala o RStudio da Rede
        if ($ComboBox1.Text -eq 'RStudio') {
            try {
                $file = "\\FSKPTL01\TI\Disks\RStudio\RStudio 2022.07.2.exe"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando RStudio..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\installer.exe"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process c:\windows\temp\installer.exe -ArgumentList '/S' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o RStudio" 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\RStudio") {
                $Label1.text = "RStudio instalado!"
                $Label1.ForeColor = "Green"
            }
        }

        # Instala o Refinitiv da Rede
        if ($ComboBox1.Text -eq 'Refinitiv Messenger') {
            try {
                $file = "\\Fskptl01\ti\Disks\_Software Traders\Refinitiv Messenger\Refinitiv Messenger v1.11.385.exe"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Refinitiv Messenger..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\installer.exe"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process c:\windows\temp\installer.exe -ArgumentList '--silent' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o Refinitiv Messenger" 
                $Label1.ForeColor = "Red"
            }
        
            Remove-Item "c:\windows\temp\installer.exe" -Force
            $Label1.text = "Refinitiv Messenger instalado!"
            $Label1.ForeColor = "Green"
        }

        # Instala o Visual Studio Code
        if ($ComboBox1.Text -eq 'Visual Studio Code') {
            try {
                $file = "\\FSKPTL01\TI\Disks\Visual Studio Code\VSCodeSetup.exe"
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Visual Studio Code..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\installer.exe"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process c:\windows\temp\installer.exe -ArgumentList '/DIR="C:\Program Files\Visual Studio Code" /VERYSILENT /NORESTART /MERGETASKS=!runcode' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o Visual Studio Code" 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\Visual Studio Code") {
                $Label1.text = "Visual Studio Code instalado!"
                $Label1.ForeColor = "Green"
            }
        }


        # Instala o PowerBI da Microsoft Store
        if ($ComboBox1.Text -eq 'PowerBI') {
            try {
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando PowerBI..."
                $Label1.ForeColor = "Blue"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process winget -ArgumentList 'install Microsoft.PowerBI -h' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o PowerBI" 
                $Label1.ForeColor = "Red"
            }
        
            $Label1.text = "PowerBI instalado!"
            $Label1.ForeColor = "Green"
        }


        # Instala o Teamviewer da Rede
        if ($ComboBox1.Text -eq 'Teamviewer') {
            try {
                $file = "\\FSKPTL01\TI\Disks\Teamviewer\Teamviewer.msi"
                $file2 = "\\FSKPTL01\TI\Disks\Teamviewer\Config.tvopt"
            
                $descricao = $ComboBox2.Text
                $computerName = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Description -match $descricao }).Name
                $Label1.text = "Instalando Teamviewer..."
                $Label1.ForeColor = "Blue"

                Copy-Item -Path $file -Destination "\\$($computername)\c$\windows\temp\Teamviewer.msi"
                Copy-Item -Path $file2 -Destination "\\$($computername)\c$\windows\temp\Config.tvopt"

                Get-Service -ComputerName $computerName -Name *winrm* | Start-Service
                Invoke-Command -ComputerName $computerName -ScriptBlock { 
                    Start-Process msiexec.exe -ArgumentList '/i "c:\windows\temp\Teamviewer.msi" /qb SETTINGSFILE="c:\windows\temp\Config.tvopt"' -Wait
                }
                Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service
            }

            catch {
                $Label1.text = "Erro ao instalar o Teamviewer" 
                $Label1.ForeColor = "Red"
            }
        
            $computerName = $computerName.ToString()
            if (Test-Path "\\$computerName\C$\Program Files\TeamViewer") {
                $Label1.text = "Teamviewer instalado!"
                $Label1.ForeColor = "Green"
            }
        }
		
    })

#region Logic 

#endregion

[void]$Form.ShowDialog()