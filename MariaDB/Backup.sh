# ATENÇÃO - Instalar o 7zip: sudo apt install p7zip-full
# ATENÇÃO - Instalar o Mariabackup: sudo apt install mariadb-backup

# Backup do MariaDB a partir do MDBKPTL01 (Kapitalo)

#!/bin/bash
cd /mnt/sdb1
mkdir MariaDB_$(date +%F)
mariabackup --backup --target-dir /mnt/sdb1/MariaDB_$(date +%F) -u root
chmod 777 -R MariaDB_$(date +%F)
cd MariaDB_$(date +%F)
7z a MariaDB_$(date +%F).7z *
chmod 777 MariaDB_$(date +%F).7z
mv MariaDB_$(date +%F).7z /mnt/sdb1
cd ..
rm -r MariaDB_$(date +%F)