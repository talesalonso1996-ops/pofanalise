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

  Base de [`pof_ler_edicao()`](pof_ler_edicao.md).

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
#>  1: exemplo      1 Alimentação   395 30.04957 29.04972 31.04943
#>  2: exemplo      1   Habitação   395 47.36518 46.34437 48.38600
#>  3: exemplo      2 Alimentação   384 27.76139 26.83485 28.68794
#>  4: exemplo      2   Habitação   384 48.26029 47.21873 49.30184
#>  5: exemplo      3 Alimentação   398 25.77935 24.96225 26.59645
#>  6: exemplo      3   Habitação   398 49.00203 48.17994 49.82411
#>  7: exemplo      4 Alimentação   416 24.81553 24.00828 25.62278
#>  8: exemplo      4   Habitação   416 49.16087 48.34575 49.97599
#>  9: exemplo      5 Alimentação   407 23.99450 23.10167 24.88734
#> 10: exemplo      5   Habitação   407 49.59807 48.83675 50.35938
```
