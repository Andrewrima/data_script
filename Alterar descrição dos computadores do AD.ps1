$hashtab = @{
    "Computer1" = "User1"
    "Computer2" = "User2"
    "Computer3" = "User3"
    }

ForEach ($line in $hashtab.GetEnumerator()){    
    Set-ADComputer -Identity $line.Name -Description $line.Value
}