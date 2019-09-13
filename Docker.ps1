Install-Module -name dockermsftprovider -Force
Install-Package -name docker -ProviderName dockermsftprovider -force
Restart-Computer -Force

netsh advfirewall firewall add rule name="docker engine" dir=in action=allow protocol=tcp localport=2375

Stop-Service docker
dockerd --unregister-service
dockerd -H npipe:// -H 0.0.0.0:2375 --register-service
Start-Service docker

docker pull microsoft/windowsservercore
## Ou
docker pull mcr.microsoft.com/windows/servercore:ltsc2016
docker run microsoft/windowsservercore

docker search microsoft ## Busca as imagens de containers

Find-PackageProvider ## Busca provedores de imagens 
Find-containerimage ##Mostra o que tem de imagem dentro desse container que baixei anteriormente
install-containerImage -name Windowsservercore ##Baixa a imagem server core do containerImage
Get-ContainerImage ##Mostra as imagens baixadas
Invoke-WebRequest https://aka.ms/tp5/b/dockerd -outfile $env:SystemRoot\system32\dockerd.exe ##Instalar o Docker dentro da pasta raiz
Invoke-WebRequest https://aka.ms/tp5/b/docker -outfile $env:SystemRoot\system32\docker.exe ##Instala o Cliente
Docker tag windowsservercore:10.0.14300.1016 windowsservercore:latest ##Gerar imagem com  com ultima versã

docker-images ##Mostra as imagens criadas

docker run -it NOMEDAIMAGEM powershell ##executa a imagem (COntainer