import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

sender_email = "ti.admin@kapitalo.com.br"
receiver_email = "ti@kapitalo.com.br"
password = "PASSWORD"

message = MIMEMultipart()
message["From"] = sender_email
message["To"] = receiver_email
message["Subject"] = "MDBKPTL01 - Rsync"

# Read the text file into a string
with open("/home/administrator/Rsync.log", "r") as file:
    text = file.read()

# Attach the text file to the message
text_part = MIMEText(text, "plain")
message.attach(text_part)

server = smtplib.SMTP("smtp.gmail.com", 587)
server.starttls()
server.login(sender_email, password)
server.sendmail(sender_email, receiver_email, message.as_string())
server.quit()