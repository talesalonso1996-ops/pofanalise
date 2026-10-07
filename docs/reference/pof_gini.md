# Coeficiente de Gini ponderado

Coeficiente de Gini ponderado

## Uso

``` r
pof_gini(x, w)
```

## Argumentos

- x:

  Valores (ex. consumo per capita).

- w:

  Pesos (ex. peso da UC vezes moradores).

## Valor

Gini entre 0 e 1.

## Exemplos

``` r
pof_gini(c(1, 1, 1, 1), rep(1, 4))   # 0
#> [1] 0
pof_gini(c(0, 0, 0, 1), rep(1, 4))   # 0,75
#> [1] 0.75
```
