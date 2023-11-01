import os, psycopg2
from datetime import date, datetime
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

os.environ['PGPASSWORD'] = 'PASSWORD'

# Contador de número de tabelas
total_tables = 0

today = date.today()
today = today.strftime("%d.%b.%Y")
today = str(today)
today_email = today.replace(".","/")

# Log File
log_file_name = 'Exportar_Tabelas_log.txt'

# Configurações do e-mail
sender_email = "ti.admin@kapitalo.com.br"
receiver_email = "ti@kapitalo.com.br"
password = "PASSWORD"
smtp_server = "smtp.gmail.com"
smtp_port = 587

# Função para enviar e-mail
def send_email(subject, corpo):
    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = receiver_email
    message["Subject"] = subject

    # Attach the text file to the message
    text_part = MIMEText(corpo, "plain")
    message.attach(text_part)

    try:
        # Conectar ao servidor SMTP
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        server.login(sender_email, password)

        # Enviar e-mail
        server.sendmail(sender_email, receiver_email, message.as_string())
        server.quit()
        print("E-mail enviado com sucesso!")
    except Exception as e:
        print("Falha ao enviar o e-mail:", str(e))

# Primeira linha com a data do log
with open(log_file_name, 'w') as log_file:
        log_file.write(f'Dia: {today_email} \n' )

# Cria a pasta do dia atual
try:
    os.mkdir(f'F://Backup//{today}')

except FileExistsError:
    pass   

# Cronômetro
start_time = datetime.now()

databases = ('db_Teste','Alocacao_DB','Bolsa_DB','DbKapitalo1.4','Gerencial','K101_DB','K11_DB','K12_DB','K13_DB','K141_DB','K151_DB','K16_DB','K4_DB','Macro','RiskApp','Risk_DB','db_Kapitalo_v1','kapitalo')

try:
    for database in databases:

        try:
            os.mkdir(f'F://Backup//{today}//{database}')

        except FileExistsError:
            pass   


        conn_data = dict(host="localhost", user="postgres",
                        password="PASSWORD", dbname=database)

        try:
            conn = psycopg2.connect(**conn_data)
            cur = conn.cursor()

            # Listar os schemas
            cur.execute("SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT LIKE 'pg_%' AND schema_name != 'audit' AND schema_name != 'information_schema' AND schema_name != 'pbi_test' AND schema_name != 'avaliacao';")

            for schema in cur.fetchall():
                schema = schema[0]
                schema = str(schema)

                try:
                    os.mkdir(f'F://Backup//{today}//{database}//{schema}')

                except FileExistsError:
                    pass

                # Listar as tabelas
                cur.execute(f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{schema}' AND table_type = 'BASE TABLE';")
                tables = cur.fetchall()

                # Contagem de número de tabelas para enviar para o zabbix               
                total_tables += len(tables)

                for table in tables:
                    table = table[0]
                    table = str(table)                    

                    # Fazer o Backup:
                    
                    try:
                        command = (
                            f'pg_dump.exe --file "F://Backup//{today}//{database}//{schema}//{table}.sql" '
                            '--host "localhost" '
                            '--port "5432" '
                            '--username "postgres" '
                            '--no-password '
                            '--verbose '
                            '--format=c '
                            '--blobs '
                            f'--table "{schema}.{table}" '
                            f'"{database}" '
                        )

                        exit_code = os.system(command)

                        if exit_code == 0:
                            print("Backup Executado com sucesso")
                        else:
                            print("Falha ao executar o backup")
                    except Exception as e:
                        print(f"An error occurred: {e}")
                        with open(log_file_name, 'a') as log_file:
                            log_file.write(f'Exception: {e}\n')                    
        except:
            pass

        finally:
            try:
                cur.close()
                conn.close()

            except:
                pass

except:
    pass

finally:
    try:
        end_time = datetime.now()

        # Calculate the time difference
        time_difference = end_time - start_time

        # Extract the components of the time difference
        days = time_difference.days
        seconds = time_difference.seconds
        hours, remainder_seconds = divmod(seconds, 3600)
        minutes, seconds = divmod(remainder_seconds, 60)

        time_to_execute= f"Tempo de execução: {days} days, {hours} hours, {minutes} minutes, {seconds} seconds"

        # Inserir o número de tabelas
        with open(log_file_name, 'a') as log_file:
                    log_file.write(f'\nTotal de tabelas: {total_tables}\n') 

        # Inserir o tempo de execução do backup das tabelas
        with open(log_file_name, 'a') as log_file:
                    log_file.write(f'\n\n{time_to_execute}\n') 

        # Read the text file into a string
        with open(log_file_name, "r") as file:
            text = file.read()

        # Print the time difference
        assunto_email = "SERVIDOR - Backup semanal das tabelas"
        send_email(assunto_email, text)

        command_zabbix = (
            f'zabbix_sender -z 192.168.254.40 -s SERVIDOR -k total_tables -o {total_tables}'
        )

        try:
            exit_code = os.system(command_zabbix)
            
        except Exception as e:
            print(f"An error occurred: {e}")
    
    except:
         pass

