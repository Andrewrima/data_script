ICACLS "C:\Users\%username%\*" /inheritance:D
ICACLS "C:\Users\%username%" /grant:R %username%:(OI)(CI)RX /C
ICACLS "C:\Users\%username%\Desktop" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Contacts" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Documents" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Downloads" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Favorites" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Links"/grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Music" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Pictures" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Saved Games" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Searches" /grant:R %username%:(CI)(OI)RX /T
ICACLS "C:\Users\%username%\Videos" /grant:R %username%:(CI)(OI)RX /T

