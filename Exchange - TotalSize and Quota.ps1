##################################################################################################
#                                                                                                #
#    Descrição: Verifica a Quota e tamanho da mailbox dos usuários no Exchange                   #
#               (Rodar no Exchange Managment Shell)                                              #
#    Criado: 21/05/2021                                                                          #
#    Alterado:                                                                                   #
#                                                                                                #
##################################################################################################

Get-Mailbox | Select-Object Displayname,Database,@{Name='TotalItemSize'; Expression={[String]::join(";",((Get-MailboxStatistics -identity $_.identity).TotalItemSize))}},@{Name='ItemCount'; Expression={[String]::join(";",((Get-MailboxStatistics -identity $_.identity).ItemCount))}},IssueWarningQuota, ProhibitSendQuota | export-csv -path "c:\temp\mailboxsizes.csv"