<#
.SYNOPSIS
Use to remove all or past deadlines from WSUS

.PARAMETER WsusServer
Name of the remote machine running WSUS server. Defaults to localhost. 

.PARAMETER UseSecureConnection
If set to true, uses SSL instead of HTTP.

.PARAMETER port
The port number.

.PARAMETER OnlyPast
If set it will only remove past deadlines and leave future ones. If not set all deadlines will be removed.

#>
param(
    [parameter(Mandatory=$false)][string]$WsusServer = 'localhost',
    [parameter(Mandatory=$false)][boolean]$UseSecureConnection = $false,
    [parameter(Mandatory=$false)][int]$port = 8530,
    [parameter(Mandatory=$false)][switch]$OnlyPast
)

# Load WSUS assemblies
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")

# Connect to the WSUS Server and create the wsus object
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($wsusServer,$UseSecureConnection, $port)

# create datetime object to check if Deadline is set
if($OnlyPast){
    $deadline = Get-Date 
} else {
    $deadline = Get-Date '31/12/9999 11:59:59 PM'
}

Write-Progress -Activity "Getting all updates" -Status "...this many take some time" -PercentComplete 1 -id 1

# Get all approved updates, this can take a while depending on how many updates are in your catalog
$LatestRevision = $wsus.GetUpdates([Microsoft.UpdateServices.Administration.ApprovedStates]::LatestRevisionApproved,[DateTime]::MinValue,[DateTime]::MaxValue,$null,$null)

Write-Progress -Activity "Getting all updates" -Status "...this many take some time" -PercentComplete 50 -id 1
$HasStaleUpdate = $wsus.GetUpdates([Microsoft.UpdateServices.Administration.ApprovedStates]::HasStaleUpdateApprovals,[DateTime]::MinValue,[DateTime]::MaxValue,$null,$null)

$AllUpdates = @($LatestRevision) + @($HasStaleUpdate)

# Check each update approval for deadlines
$wp=1
foreach($update in $AllUpdates){
    Write-Progress -Activity "Checking for deadlines" -Status "$wp of $($AllUpdates.count)" -PercentComplete $(($wp/$($AllUpdates.count))*100) -id 1;$wp++
    
    # If deadline found reapprove without a deadline to remove it
    $update.GetUpdateApprovals() | %{
        if($_.Deadline -lt $deadline -and $_.Action -eq 'Install'){
            $_ | FT @{l='Title';e={$update.Title}}, Deadline
            $group = $wsus.GetComputerTargetGroup($_.ComputerTargetGroupId)
            $update.Approve([Microsoft.UpdateServices.Administration.UpdateApprovalAction]::Install,$group) | Out-Null
        }
    }
}
