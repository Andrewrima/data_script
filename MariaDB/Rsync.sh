# ATENÇÃO - Instalar o sshpass: sudo apt install sshpass

# Sincronização entre as pastas /opt/Sistemas do MDBKPTL01 e MDBKPTL10

#!/bin/bash
sshpass -p 'Tech#!2022' rsync -av --delete /opt/Sistemas/ sistemas@mdbkptl10:/opt/Sistemas/