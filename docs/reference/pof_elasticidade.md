# Elasticidade-despesa de um item

Especificação de Working-Leser
([`pof_engel()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_engel.md))
aplicada a qualquer item, em cada edição e, opcionalmente, dentro de
cada categoria de um corte.

## Uso

``` r
pof_elasticidade(
  dados,
  item,
  por = NULL,
  recorte = c("auto", "brasil", "rms"),
  sem_aluguel = NULL
)
```

## Argumentos

- dados:

  Resultado de
  [`pof_carregar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_carregar.md)
  ou uma base única.

- item:

  Nome de coluna: um item de
  [`pof_carregar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_carregar.md),
  um grupo (`"Alimentação"`) ou um Nível 1 (`"n07"`).

- por:

  Corte: `NULL`, `"quintil"`, `"sexo"`, `"idade"`, `"cor"`, `"tamanho"`
  ou `"rm"`.

- recorte:

  `"auto"`, `"brasil"` ou `"rms"`.

- sem_aluguel:

  `NULL` (automático), `TRUE` ou `FALSE`.

## Valor

`data.table` com `Edicao`, `Grupo`, `elasticidade`, `beta`, `ep`,
`w_medio`, `N`.

## Exemplos

``` r
pof_elasticidade(pof_exemplo(), "Alimentação", por = "sexo")
#>     Edicao  Grupo elasticidade        beta          ep  w_medio     N
#>     <char> <char>        <num>       <num>       <num>    <num> <int>
#> 1: exemplo Mulher    0.9081473 -0.02535763 0.002984660 27.60685  1029
#> 2: exemplo  Homem    0.9080695 -0.02544236 0.003178216 27.67563   971
```
