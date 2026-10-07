# Quintis ponderados

Classifica cada UC no quintil da variável (por padrão, consumo per
capita), com peso por pessoa (peso da UC vezes moradores).

## Uso

``` r
pof_quintil(x, w, k = 5L)
```

## Argumentos

- x:

  Variável de ordenação.

- w:

  Pesos.

- k:

  Número de grupos (5 = quintis).

## Valor

Inteiro de 1 a `k`.

## Exemplos

``` r
pof_quintil(c(10, 20, 30, 40, 50), rep(1, 5))
#> [1] 1 2 3 4 5
```
