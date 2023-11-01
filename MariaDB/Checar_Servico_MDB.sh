#!/bin/bash
SERVICE="mariadbd"
if ! pgrep -x "$SERVICE" >/dev/null
then
   /home/kapitalo/./Restore.sh
fi
