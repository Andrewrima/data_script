@echo off
del c:\backup.txt
net use R: \\ip de onde vai ser copiado\pasta
net use T: \\ip do destino para onde vai ser copiado\pasta
xcopy /y /e /d /c R:\*.* T:\pastas >> c:\backup.txt
net use R: /delete
net use T: /delete
set Subject=Assunto do e-mail
set Sender=Endere�o do e-mail que vai enviar
set Receiver=Endere�o do e-mail que vai receber
set Server=ip do servidor de email
set Source=c:\backup.txt
blat.exe "%Source%" -to "%Receiver%" -subject "%Subject%" -f "%Sender%" -server "%Server%"

##Baixar Programa Blat e jogar dentro de System32##