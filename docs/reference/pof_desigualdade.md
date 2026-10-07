# Medidas de desigualdade do consumo per capita

Gini, razões P90/P10 e P90/P50 e parcela do consumo apropriada pelos 10%
de maior consumo, ponderadas por pessoa. Com `B > 0` e desenho amostral,
acrescenta IC de 95% do Gini por bootstrap de UPAs dentro de estrato
(sem recalibrar pesos).

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
#>     Edicao      Gini P90_P10  P90_P50   Top10 Gini_IC_inf Gini_IC_sup
#>     <char>     <num>   <num>    <num>   <num>       <num>       <num>
#> 1: exemplo 0.4193562 7.41544 2.750725 30.9154          NA          NA
```
