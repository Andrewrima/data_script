cmdkey /generic:taskkplt01 /user:kapitalo.local\risk.scheduler /pass:RSKapitalo@01
mstsc /v:taskkplt01 
sleep 40
taskkill /IM mstsc.exe /F
cmdkey /delete:taskkplt01

cmdkey /generic:taskkplt01 /user:kapitalo.local\operation.scheduler /pass:OSKapitalo@01
mstsc /v:taskkplt01
sleep 40
taskkill /IM mstsc.exe /F
cmdkey /delete:taskkplt01

cmdkey /generic:taskkplt01 /user:kapitalo.local\pricing.scheduler /pass:PSKapitalo@01
mstsc /v:taskkplt01
sleep 40
taskkill /IM mstsc.exe /F
cmdkey /delete:taskkplt01

cmdkey /generic:taskkplt01 /user:kapitalo.local\macro.scheduler /pass:MSKapitalo@01
mstsc /v:taskkplt01
sleep 40
taskkill /IM mstsc.exe /F
cmdkey /delete:taskkplt01