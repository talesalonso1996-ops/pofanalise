# Tabela pronta para publicação

Formata um resultado de
[`pof_analisar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_analisar.md)
em tabela larga (grupos nas linhas, edições nas colunas), com vírgula
decimal e IC entre colchetes.

## Uso

``` r
pof_tabela(resultado, casas = 1, ic = TRUE)
```

## Argumentos

- resultado:

  Resultado de
  [`pof_analisar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_analisar.md).

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
#> 1:      1  11,6 [8,2; 15,0]
#> 2:      2 17,6 [13,6; 21,5]
#> 3:      3  11,9 [8,6; 15,2]
#> 4:      4  10,9 [7,7; 14,2]
#> 5:      5 13,8 [10,4; 17,2]
```
