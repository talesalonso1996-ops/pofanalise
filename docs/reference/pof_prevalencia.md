# Prevalência de gasto

Percentual ponderado de UCs com gasto positivo na variável, com IC de
95%
([`survey::svymean`](https://rdrr.io/pkg/survey/man/surveysummary.html))
quando há desenho amostral.

## Uso

``` r
pof_prevalencia(b, var, por = NULL, filtro = NULL, ic = TRUE)
```

## Argumentos

- b:

  Base de
  [`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md).

- var:

  Coluna de gasto.

- por:

  Coluna de agrupamento (opcional).

- filtro:

  Expressão de recorte, ex. `quote(!is.na(RGMT))`.

- ic:

  Calcular IC quando houver desenho.

## Valor

`data.table` com `Edicao`, `Nivel`, `Item`, `N_UC`, `Perc`, `IC_inf`,
`IC_sup`.

## Exemplos

``` r
b <- pof_exemplo()
pof_prevalencia(b, "Educação", por = "Quintil")
#>     Edicao  Nivel     Item  N_UC     Perc   IC_inf   IC_sup
#>     <char> <char>   <char> <int>    <num>    <num>    <num>
#> 1: exemplo      1 Educação   381 46.40468 41.10911 51.70026
#> 2: exemplo      2 Educação   401 47.45312 42.36804 52.53819
#> 3: exemplo      3 Educação   420 49.41943 44.25431 54.58455
#> 4: exemplo      4 Educação   397 53.28789 48.19234 58.38344
#> 5: exemplo      5 Educação   401 56.06547 50.91443 61.21650
```
