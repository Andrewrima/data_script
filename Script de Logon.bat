'============================================='
' Impedindo exibi��o de error para o usu�rio  '
'============================================='

On error Resume Next
Err.clear 0


'================================================='
'   Mapear Pastas de Acordo com o Grupo do USR    '
'================================================='

set objNetwork= CreateObject("WScript.Network")
strDom = objNetwork.UserDomain
strUser = objNetwork.UserName
Set objUser = GetObject("WinNT://" & strDom & "/" & strUser &  ",user")

For Each objGroup In objUser.Groups

    Select Case objGroup.Name
        Case "Grupo_1" 
		If Not FSODrive.DriveExists("X:") Then
			objNetwork.MapNetworkDrive "X:", "\\SRVAULA\COMPARTILHAMENTO1","true"	
		End If

        Case "Grupo_2" 
		If Not FSODrive.DriveExists("X:") Then
			objNetwork.MapNetworkDrive "X:", "\\SRVAULA\COMPARTILHAMENTO2","true"	
		End If
	
	Case "Grupo_3" 
		If Not FSODrive.DriveExists("X:") Then
			objNetwork.MapNetworkDrive "X:", "\\SRVAULA\COMPARTILHAMENTO3","true"	
		End If
    End Select
Next

'================================================='
'        Mapeando Impressoras e Pastas            '
'================================================='

Set WshNetwork = Wscript.CreateObject("Wscript.Network")
WshNetwork.AddWindowsPrinterConnection "\\SRVAULA\HP", "HP"
WshNetwork.AddWindowsPrinterConnection "\\SRVAULA\EPSON", "EPSON"
WshNetwork.SetDefaultPrinter "\\SRVAULA\HP", "HP"

WshNetwork.MapNetworkDrive "P:","\\SRVAULA\PUBLICA","true"
WshNetwork.MapNetworkDrive "J:","\\SRVAULA\GERAL","true"

'================================================'
'    Criar atalho para um site no Desktop        '
'================================================'

set WshShell = WScript.CreateObject("WScript.Shell")
strDesktop = WshShell.SpecialFolders("Desktop")

set oUrlLink = WshShell.CreateShortcut(strDesktop & "\NOME_DO_LINK.lnk")

oUrlLink.TargetPath = "http://aulaead.thinkific.com"

oUrlLink.IconLocation = "CAMINHO PARA UM .ico"

oUrlLink.Save


'============================================='
' CRIA ATALHO DO COMPARTILHAMENTO NO DESKTOP  '
'============================================='

strAppPath = "X:\"
Set wshShell = CreateObject("WScript.Shell")
objDesktop = wshShell.SpecialFolders("Desktop")
set oShellLink = WshShell.CreateShortcut(objDesktop & "\NOME_DO_LINK.lnk")
oShellLink.TargetPath = strAppPath
oShellLink.WindowStyle = "1"
oShellLink.Description = "Pasta do Grupo"
oShellLink.Save 

'ENVIA O COMANDO PARA APERTAR A TECLA F5 PARA ATUALIZAR OS ICONES NO DESKTOP
WshShell.SendKeys "{F5}"



'============================================='
'              Mensagem no Logon              '
'============================================='


MsgBox ("ATEN��O: Pedimos que ao desligar seu computador, escolha a op��o 'Instalar as atualiza��es e desligar'." & vbcrlf & "Somente assim seu computador instalar� atualiza��es cr�ticas de seguran�a e ficar� atualizado e seguro." & vbcrlf & "Agradecemos pela compreens�o," & vbcrlf & "Atenciosamente," & vbcrlf & "Equipe de TI")


wscript.quit