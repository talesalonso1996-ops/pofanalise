# Quantil ponderado

Quantil ponderado

## Uso

``` r
pof_quantil(x, w, p)
```

## Argumentos

- x:

  Valores.

- w:

  Pesos.

- p:

  Probabilidades.

## Valor

Quantis.

## Exemplos

``` r
pof_quantil(1:10, rep(1, 10), c(0.1, 0.5, 0.9))
#> [1] 1 5 9
```
