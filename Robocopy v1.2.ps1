<# 
.NAME
    Arquivos
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(486,75)
$Form.text                       = "Robocopy"
$Form.TopMost                    = $false
$Form.icon                       = "C:\Users\arm\Desktop\temp\scripts\robo.ico"
$Form.FormBorderStyle = 'FixedDialog'


$Button3                         = New-Object system.Windows.Forms.Button
$Button3.text                    = "De:"
$Button3.width                   = 42
$Button3.height                  = 29
$Button3.location                = New-Object System.Drawing.Point(8,6)
$Button3.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Button4                         = New-Object system.Windows.Forms.Button
$Button4.text                    = "Para:"
$Button4.width                   = 49
$Button4.height                  = 29
$Button4.location                = New-Object System.Drawing.Point(245,6)
$Button4.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 181
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(55,12)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $false
$TextBox2.width                  = 181
$TextBox2.height                 = 20
$TextBox2.location               = New-Object System.Drawing.Point(300,12)
$TextBox2.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Iniciar"
$Button1.width                   = 84
$Button1.height                  = 25
$Button1.location                = New-Object System.Drawing.Point(395,42)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Button1.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "Cancelar"
$Button2.width                   = 84
$Button2.height                  = 25
$Button2.location                = New-Object System.Drawing.Point(302,42)
$Button2.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$CheckBox1                       = New-Object system.Windows.Forms.CheckBox
$CheckBox1.text                  = "Substituir existentes"
$CheckBox1.AutoSize              = $false
$CheckBox1.width                 = 160
$CheckBox1.height                = 20
$CheckBox1.location              = New-Object System.Drawing.Point(15,47)
$CheckBox1.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$CheckBox2                       = New-Object system.Windows.Forms.CheckBox
$CheckBox2.text                  = "Cópia rápida"
$CheckBox2.AutoSize              = $false
$CheckBox2.width                 = 112
$CheckBox2.height                = 20
$CheckBox2.location              = New-Object System.Drawing.Point(183,47)
$CheckBox2.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(405,77)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

function Get-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string]$Message = "Please select a directory.",

        [Parameter(Mandatory=$false, Position=1)]
        [string]$InitialDirectory,

        [Parameter(Mandatory=$false)]
        [System.Environment+SpecialFolder]$RootFolder = [System.Environment+SpecialFolder]::Desktop,

        [switch]$ShowNewFolderButton
    )
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description  = $Message
    $dialog.SelectedPath = $InitialDirectory
    $dialog.RootFolder   = $RootFolder
    $dialog.ShowNewFolderButton = if ($ShowNewFolderButton) { $true } else { $false }
    $selected = $null

    # force the dialog TopMost
    # Since the owning window will not be used after the dialog has been 
    # closed we can just create a new form on the fly within the method call
    $result = $dialog.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
    if ($result -eq [Windows.Forms.DialogResult]::OK){
        $selected = $dialog.SelectedPath
    }
    # clear the FolderBrowserDialog from memory
    $dialog.Dispose()
    # return the selected folder
    $selected
} 

$Button3.Add_Click({$TextBox1.Text = Get-Folder})
$Button4.Add_Click({$TextBox2.Text = Get-Folder})


$Button1.Add_Click({$Label1.Text = "Copiando..."
    if ($CheckBox1.Checked){Start-Job {robocopy $using:TextBox1.Text $using:TextBox2.Text /E /Z /ZB /R:5 /W:5 /TBD /NP | Receive-Job -AutoRemoveJob -Wait }}# lento e substituindo
    
    if ($CheckBox2.Checked){Start-Job -ScriptBlock { robocopy $TextBox1.Text $TextBox2.Text /NOOFFLOAD /J /E /Z /ZB /NP /R:1 /W:1 /MT:128 /XC /XN /XO | Receive-Job -AutoRemoveJob -Wait }} # rápido sem substituir
    
    if (($CheckBox1.Checked) -and ($CheckBox2.Checked)){Start-Job -ScriptBlock { robocopy $TextBox1.Text $TextBox2.Text /NOOFFLOAD /J /E /Z /ZB /R:1 /W:1 /NP /MT:128 /LOG | Receive-Job -AutoRemoveJob -Wait }} # rápido e substituindo
    
    else{Start-Job -ScriptBlock { robocopy $TextBox1.Text $TextBox2.Text /E /Z /ZB /R:5 /W:5 /TBD /NP /XC /XN /XO | Receive-Job -AutoRemoveJob -Wait }} # lento sem substituir

})

$Button2.Add_Click({taskkill /F /IM robocopy.exe})


$Form.controls.AddRange(@($Button3,$Button4,$TextBox1,$TextBox2,$Button1,$Button2,$CheckBox1,$CheckBox2))

#region Logic 

#endregion

[void]$Form.ShowDialog()

