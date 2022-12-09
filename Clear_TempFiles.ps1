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

#CSS codes
$header = @"
<style>

    h2 {

        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;

    }

    
    
   table {
		font-size: 12px;
		border: 0px; 
		font-family: Arial, Helvetica, sans-serif;
	} 
	
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}
	
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}

    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }

    .OkStatus {
    color: #008000;
    }

    .ErrorStatus {
        color: #ff0000;
    }


    #CreationDate {

        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;
        padding: 4px;


    }

</style>
"@


$nomeclatura = @('WS10', 'WS11', 'NT10', 'NT11')
$desktopsAD = @{}
$compList = @()

for ($i = 0; $i -lt $nomeclatura.Length; $i++ | sort) {
    $compsAD = (Get-AdComputer -Filter * -Properties Name, Description | select Name, Description | ? { $_.Name -match $nomeclatura[$i] })

    foreach ($compAD in $compsAD) {
        $desktopsAD.add($compAD.Name, $compAD.Description)  
    } 
}

[int]$countt = 0
[int]$ComputersCount = $desktopsAD.Count

foreach ($computer in $desktopsAD.GetEnumerator()) {
    $computerName = $computer.Name
    $computerDesc = $computer.Value

    if ($computerDesc -eq $null) { $computerDesc = $computerName }

    Write-Progress -Activity 'Computador do...' -id 0 -Status ($computerDesc) -PercentComplete (($countt / $ComputersCount) * 100)
     
    try { Get-Service -ComputerName $computerName -Name *winrm* | Start-Service -ErrorAction SilentlyContinue }
    
    catch {
        # $erro = $($_.Exception.Message)
        $compList += @{"Computer" = "$computerName"; 'Description' = "$computerDesc"; 'Temp Files' = "Erro" }
        continue
    }

    
    try {
        Invoke-Command -ComputerName $computerName -ScriptBlock {
            $SystemTemp = [Environment]::GetEnvironmentVariable('Temp', [EnvironmentVariableTarget]::Machine)

            If ((Test-Path -Path $SystemTemp) -eq $true) {
                Get-ChildItem -Path $SystemTemp -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            }

            $profilePath = (Split-Path -Parent $env:USERPROFILE)
            $users = (Get-ChildItem -Path $profilePath).Name
            $paths = ("\AppData\Local\Microsoft\Windows\Temporary Internet Files",
                "\AppData\Local\Temp"
            )


            [int]$count = 0
            [int]$UserCount = $users.Count


            foreach ($user in $users) {    
                Write-Progress -Activity 'Scanning User Folders' -Status ($user).ToUpper() -id 1 -ParentId 0 -PercentComplete (($count / $UserCount) * 100) 
   
                foreach ($path in $paths) {
                    If ((Test-Path -Path "$($profilePath)\$($user)\$($path)") -eq $true) {
                        Get-ChildItem -Path "$($profilePath)\$($user)\$($path)" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
                $count++
            }


        } -ErrorAction SilentlyContinue
        $compList += @{"Computer" = "$computerName"; 'Description' = "$computerDesc"; 'Temp Files' = "OK!" }
    }
    catch {
        #$erro = $($_.Exception.Message)
        $compList += @{"Computer" = "$computerName"; 'Description' = "$computerDesc"; 'Temp Files' = "Erro" }
        continue
    }

    
    $countt ++

    Get-Service -ComputerName $computerName -Name *winrm* | Stop-Service -ErrorAction SilentlyContinue
}

$count = $null
$countt = $null
$UserCount = $null
$ComputersCount = $null
$computerName = $null
$computerDesc = $null


$compList = $compList | % { new-object PSObject -Property $_ } | ConvertTo-Html -Property Computer, 'Description', 'Temp Files' -Fragment -PreContent "<h2>Temp Files</h2>"
$compList = $compList -replace '<td>Erro</td>', '<td class="ErrorStatus">Erro</td>'
$compList = $compList -replace '<td>Ok!</td>', '<td class="OkStatus">Ok!</td>' 

$date = (Get-Date).ToString("dd/MM/yyyy")

$Report = ConvertTo-HTML -Body "$compList" -Head $header -Title "Computer Information Report" -PostContent "<p id='CreationDate'>Data: $($date)</p>"

$Report | Out-File c:\temp\temporarios.html 

$outlook = New-Object -ComObject Outlook.Application
$body = Get-Content c:\temp\temporarios.html -Raw


$email = $outlook.CreateItem(0)
$email.To = "ti.admin@kapitalo.com.br"
$email.Subject = "Report Temp Files"
$email.HTMLBody = $body

$email.Send()
