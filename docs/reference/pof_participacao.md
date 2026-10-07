# Participação no consumo

Razão entre a soma ponderada de cada variável e a soma ponderada do
denominador (por padrão, `Consumo`), em percentual. Com desenho
amostral, o intervalo de confiança de 95% vem de
[`survey::svyratio`](https://rdrr.io/pkg/survey/man/svyratio.html), com
o desenho definido na base inteira e o recorte aplicado por
[`subset()`](https://rdrr.io/r/base/subset.html).

## Uso

``` r
pof_participacao(
  b,
  vars,
  por = NULL,
  filtro = NULL,
  den = "Consumo",
  ic = TRUE
)
```

## Argumentos

- b:

  Base de
  [`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md).

- vars:

  Colunas do numerador.

- por:

  Coluna de agrupamento (opcional).

- filtro:

  Expressão de recorte, ex. `quote(!is.na(RGMT))`.

- den:

  Coluna do denominador.

- ic:

  Calcular IC quando houver desenho.

## Valor

`data.table` com `Edicao`, `Nivel`, `Item`, `N_UC`, `Perc`, `IC_inf`,
`IC_sup`.

## Exemplos

``` r
b <- pof_exemplo()
pof_participacao(b, c("Alimentação", "Habitação"), por = "Quintil")
#>      Edicao  Nivel        Item  N_UC     Perc   IC_inf   IC_sup
#>      <char> <char>      <char> <int>    <num>    <num>    <num>
#>  1: exemplo      1 Alimentação   381 30.25543 29.34039 31.17048
#>  2: exemplo      1   Habitação   381 46.52357 45.58958 47.45756
#>  3: exemplo      2 Alimentação   401 27.75169 26.79706 28.70633
#>  4: exemplo      2   Habitação   401 48.00398 47.06037 48.94760
#>  5: exemplo      3 Alimentação   420 25.91569 25.09194 26.73944
#>  6: exemplo      3   Habitação   420 49.42835 48.65438 50.20231
#>  7: exemplo      4 Alimentação   397 24.69885 23.88449 25.51321
#>  8: exemplo      4   Habitação   397 49.63921 48.75391 50.52451
#>  9: exemplo      5 Alimentação   401 24.51805 23.70126 25.33483
#> 10: exemplo      5   Habitação   401 49.13746 48.07455 50.20036
```
