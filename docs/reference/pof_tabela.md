# Tabela pronta para publicação

Formata um resultado de [`pof_analisar()`](pof_analisar.md) em tabela
larga (grupos nas linhas, edições nas colunas), com vírgula decimal e IC
entre colchetes.

## Uso

``` r
pof_tabela(resultado, casas = 1, ic = TRUE)
```

## Argumentos

- resultado:

  Resultado de [`pof_analisar()`](pof_analisar.md).

- casas:

  Casas decimais.

- ic:

  Incluir o intervalo de confiança.

## Valor

`data.table` de texto.

## Exemplos

``` r
pof_tabela(pof_analisar(pof_exemplo(), "Jogos", por = "quintil"))
#> Key: <Grupo>
#>     Grupo           exemplo
#>    <char>            <char>
#> 1:      1 15,8 [12,0; 19,6]
#> 2:      2 14,2 [10,3; 18,0]
#> 3:      3 13,9 [10,4; 17,3]
#> 4:      4 13,8 [10,5; 17,2]
#> 5:      5 15,2 [11,7; 18,6]
```
