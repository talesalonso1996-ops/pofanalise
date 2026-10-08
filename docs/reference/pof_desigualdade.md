# Medidas de desigualdade do consumo per capita

Gini, razões P90/P10 e P90/P50 e parcela do consumo apropriada pelos 10%
de maior consumo, ponderadas por pessoa. Com `B > 0` e desenho amostral,
acrescenta IC de 95% do Gini (percentis) por bootstrap de Rao-Wu: em
cada estrato com n UPAs sorteiam-se n - 1 UPAs com reposição e os pesos
são reescalonados. Os pesos não são recalibrados às projeções de
população.

## Uso

``` r
pof_desigualdade(b, var = "Consumo_pc", B = 0, semente = 20261007)
```

## Argumentos

- b:

  Base de
  [`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md).

- var:

  Variável (padrão: `Consumo_pc`).

- B:

  Réplicas de bootstrap (0 = sem IC).

- semente:

  Semente aleatória.

## Valor

`data.table` de uma linha.

## Exemplos

``` r
pof_desigualdade(pof_exemplo())
#>     Edicao      Gini  P90_P10  P90_P50    Top10 Gini_IC_inf Gini_IC_sup
#>     <char>     <num>    <num>    <num>    <num>       <num>       <num>
#> 1: exemplo 0.4272836 7.740449 2.871468 31.66169          NA          NA
```
