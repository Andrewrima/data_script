$Certs = Get-ChildItem Cert:\CurrentUser\My -Recurse
Foreach($Cert in $Certs) {
            If($Cert.NotAfter -lt (Get-Date)) {
                $Cert | Remove-Item
            }
        }