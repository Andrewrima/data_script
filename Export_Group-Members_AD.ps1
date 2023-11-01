# Obter todos os grupos do AD dentro da OU especificada
$grupos = Get-ADGroup -Filter * -SearchBase "OU=Groups Kapitalo ,DC=kapitalo,DC=local"

# Inicializar uma lista vazia para armazenar os dados
$dadosGrupos = @()

# Iterar sobre cada grupo e obter os membros
foreach ($grupo in $grupos) {
    $membros = Get-ADGroupMember -Identity $grupo | Select-Object -ExpandProperty Name
    $membrosConcatenados = ($membros -join ", ")

    # Adicionar os dados do grupo e membros à lista
    $dadosGrupos += [PSCustomObject]@{
        GroupName = $grupo.Name
        Members = $membrosConcatenados
    }
}

# Exportar os dados para um arquivo CSV
$dadosGrupos | Export-Csv -Path "C:\Users\andrew.machado\Desktop\temp\Arquivo.csv" -NoTypeInformation -Encoding UTF8
