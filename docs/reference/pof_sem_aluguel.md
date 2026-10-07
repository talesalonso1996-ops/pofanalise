# Retira o aluguel do consumo

O aluguel estimado de quem mora em imóvel próprio só aparece de
2002-2003 em diante: em 1995-1996 apenas cerca de 18% das UCs
metropolitanas têm aluguel, e em 1987-1988 o valor é muito baixo. Para
comparar as cinco edições, o aluguel sai do consumo e da Habitação, e
consumo per capita e quintis devem ser recalculados depois.

## Uso

``` r
pof_sem_aluguel(b, col_aluguel = NULL)
```

## Argumentos

- b:

  Base com grupos somados
  ([`pof_somar_grupos()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_somar_grupos.md)).

- col_aluguel:

  Coluna do aluguel (folha `17101` na v2, `31001` na versão inicial).

## Valor

A base sem o aluguel.
