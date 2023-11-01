# Realizar a cópia com timeout
timeout $limite_tempo cp "$origem" "$destino" > log.txt

# Obter o ID do processo da cópia
pid=$!

# Verificar o status de saída do comando cp
status=$?
if [ $status -eq 124 ]; then
        # Lançar exceção caso o tempo limite seja excedido
        python3 /home/kapitalo/enviar_email.py "Backup MDBKPTL10 - A cópia não foi concluída dentro do limite de tempo"
        kill $pid
        exit 1
        elif [ $status -ne 0 ]; then
        kill $pid
        # Lançar exceção caso ocorra um erro na cópia
        python3 /home/kapitalo/enviar_email.py "Backup MDBKPTL10 - Ocorreu um erro durante a cópia"
        echo "Status de saída da cópia: $status" >> log.txt
        exit 1
fi

# Descompacta o backup zipado
mkdir /media/kapitalo/dados/MariaDB_$(date +%F)
chmod 777 -R /media/kapitalo/dados/MariaDB_$(date +%F)
7z x /media/kapitalo/dados/MariaDB_$(date +%F).7z -o/media/kapitalo/dados/MariaDB_$(date +%F)
rm /media/kapitalo/dados/MariaDB_$(date +%F).7z

# Executa o comando "mariabackup --prepare --target-dir"
mariabackup --prepare --target-dir /media/kapitalo/dados/MariaDB_$(date +%F)

# Verifica se o comando anterior foi executado com sucesso
if [ $? -eq 0 ]; then

        # Restaura o backup
        systemctl stop mariadb
        rm -rf /media/kapitalo/dados/mysql/* || true
        rm -rf /media/kapitalo/dados/mysql/.ibdata1.swp || true
        mariabackup --move-back --target-dir /media/kapitalo/dados/MariaDB_$(date +%F)
        chown -R mysql. /media/kapitalo/dados/mysql
        systemctl start mariadb

    if [ $? -eq 0 ]; then

                # Enviar e-mail de sucesso
                python3 /home/kapitalo/enviar_email.py "Backup MDBKPTL10 - Restaurado com Sucesso"

        else
        # Enviar e-mail de falha
                python3 /home/kapitalo/enviar_email.py "Backup MDBKPTL10 - Falha ao restaurar o Backup"

        fi
        else

    # Enviar e-mail de falha
    python3 /home/kapitalo/enviar_email.py "Backup MDBKPTL10 - Falha com o Backup do MDBKPTL01"

fi

# Apaga os arquivos de backup
rm -r /media/kapitalo/dados/MariaDB_$(date +%F)