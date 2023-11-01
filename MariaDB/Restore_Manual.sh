# ATENÇÃO - Instalar o 7zip: sudo apt install p7zip-full
# ATENÇÃO - Instalar o Mariabackup: sudo apt install mariadb-backup

# Restore do MariaDB a partir do MDBKPTL10 (Equinix)

#!/bin/bash
cp /media/MariaDB_Backup/MariaDB_$(date +%F).7z /media/kapitalo/dados/
mkdir /media/kapitalo/dados/MariaDB_$(date +%F)
chmod 777 -R /media/kapitalo/dados/MariaDB_$(date +%F)
7z x /media/kapitalo/dados/MariaDB_$(date +%F).7z -o/media/kapitalo/dados/MariaDB_$(date +%F)
mariabackup --prepare --target-dir /media/kapitalo/dados/MariaDB_$(date +%F)
systemctl stop mariadb
rm -rf /media/kapitalo/dados/mysql/* || true
rm /media/kapitalo/dados/mysql/.ibdata1.swp || true
mariabackup --copy-back --target-dir /media/kapitalo/dados/MariaDB_$(date +%F)
chown -R mysql. /media/kapitalo/dados/mysql
systemctl start mariadb
rm -r /media/kapitalo/dados/MariaDB_$(date +%F)
rm /media/kapitalo/dados/MariaDB_$(date +%F).7z