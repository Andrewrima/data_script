for ($i=1; $i -le 3; $i=$i+1 ) {

    $source="C:\Users\arm\Desktop\temp\natal\Backup\$((Get-Date).ToString('dd_MM-HH'))"
    New-Item -ItemType directory -Path $source
    xcopy C:\Users\arm\Desktop\temp\natal $source
    
    }