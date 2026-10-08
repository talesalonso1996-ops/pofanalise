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

## Detalhes

A prevalência depende do período de referência com que o item é
investigado na POF: 7 dias (caderneta de despesa coletiva, alimentos e
artigos de limpeza), 30 ou 90 dias (serviços e despesas individuais
frequentes) ou 12 meses (bens duráveis, viagens, cursos). Uma UC sem
gasto no período pode gastar fora dele. Compare prevalências do mesmo
item entre edições e grupos, não entre itens com períodos diferentes.

## Exemplos

``` r
b <- pof_exemplo()
pof_prevalencia(b, "Educação", por = "Quintil")
#>     Edicao  Nivel     Item  N_UC     Perc   IC_inf   IC_sup
#>     <char> <char>   <char> <int>    <num>    <num>    <num>
#> 1: exemplo      1 Educação   395 45.35844 40.18678 50.53010
#> 2: exemplo      2 Educação   384 51.54387 46.43527 56.65246
#> 3: exemplo      3 Educação   398 48.52431 43.25755 53.79106
#> 4: exemplo      4 Educação   416 54.25368 49.14961 59.35775
#> 5: exemplo      5 Educação   407 54.58928 49.68956 59.48900
```
