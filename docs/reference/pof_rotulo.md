# Rótulos de Nível 1 e de folha

Troca códigos de coluna (`n01`, `f17101`) pelos nomes da harmonização.

## Uso

``` r
pof_rotulo(x)
```

## Argumentos

- x:

  Vetor de códigos.

## Valor

Vetor de rótulos (o próprio código quando não há rótulo).

## Exemplos

``` r
pof_rotulo(c("n07", "f17101", "Alimentação"))
#> [1] "Carnes"      "Aluguel"     "Alimentação"
```
