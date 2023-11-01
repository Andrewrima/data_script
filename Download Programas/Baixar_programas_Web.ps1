#VSCode
Invoke-WebRequest "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64" -O "\\SERVIDOR\TI\Disks\Visual Studio Code\VSCodeSetup.exe"

#Winrar
Invoke-WebRequest "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-611br.exe" -O "\\SERVIDOR\TI\Disks\_Winrar\Winrar.exe"

#AnaConda
Invoke-WebRequest "https://repo.anaconda.com/archive/Anaconda3-2022.10-Windows-x86_64.exe" -O "\\SERVIDOR\TI\Disks\Anaconda\Anaconda.exe"

#Foxit Reader
Invoke-WebRequest "https://cdn78.foxitsoftware.com/product/reader/desktop/win/12.1.2/FoxitPDFReader1212_L10N_Setup.exe" -O "\\SERVIDOR\TI\Disks\Foxit Reader\Foxit Reader.exe"

#Pycharm Community
Invoke-WebRequest "https://download.jetbrains.com/python/pycharm-community-2022.2.4.exe" -O "\\SERVIDOR\TI\Disks\PyCharm\Pycharm Community.exe"

#BroadCast
Invoke-WebRequest "https://www.aebroadcastweb.com.br/arquivos/instaladores/bcsys_tcp.exe" -O "\\SERVIDOR\TI\Disks\_Software Traders\AE Broadcast\Broadcast.exe"

#Adobe Reader
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36"
$result = Invoke-RestMethod -Uri "https://rdc.adobe.io/reader/products?lang=mui&site=enterprise&os=Windows%2011&country=US&nativeOs=Windows%2010&api_key=dc-get-adobereader-cdn" -WebSession $session `
    -Headers @{
        "Accept"="*/*"
        "Accept-Encoding"="gzip, deflate, br"
        "Accept-Language"="en-US,en;q=0.9"
        "Origin"="https://get.adobe.com"
        "Referer"="https://get.adobe.com/"
        "Sec-Fetch-Dest"="empty"
        "Sec-Fetch-Mode"="cors"
        "Sec-Fetch-Site"="cross-site"
        "sec-ch-ua"="`" Not A;Brand`";v=`"99`", `"Chromium`";v=`"101`", `"Google Chrome`";v=`"101`""
        "sec-ch-ua-mobile"="?0"
        "sec-ch-ua-platform"="`"Windows`""
        "x-api-key"="dc-get-adobereader-cdn"
}

$version = $result.products.reader[0].version
$version = $version.replace('.','')

# Downloading
$URI = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/$Version/AcroRdrDCx64$($Version)_MUI.exe"
Invoke-WebRequest -Uri $URI -OutFile "\\SERVIDOR\TI\Disks\_Adobe Reader\AcroRdrDCx64.exe"

# NodeJS
python "\\SERVIDOR\TI\Scripts\Download Programas\download_nodejs.py"
