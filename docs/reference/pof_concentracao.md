# Concentração e progressividade de um gasto

Mede como o gasto com um item se distribui entre as pessoas ordenadas
pelo consumo per capita:

## Uso

``` r
pof_concentracao(
  dados,
  itens,
  recorte = c("auto", "brasil", "rms"),
  sem_aluguel = NULL
)
```

## Argumentos

- dados:

  Resultado de [`pof_carregar()`](pof_carregar.md) ou uma base única.

- itens:

  Uma ou mais colunas.

- recorte:

  `"auto"`, `"brasil"` ou `"rms"`.

- sem_aluguel:

  `NULL` (automático), `TRUE` ou `FALSE`.

## Valor

`data.table` com `Edicao`, `Item`, `C`, `Gini_consumo`, `K`,
`Classificacao`, `Base40`, `Topo20`.

## Detalhes

- `C`: coeficiente de concentração do item (gasto per capita no item,
  pessoas ordenadas pelo consumo per capita). Vai de -1 a 1; positivo
  quando o gasto se concentra entre quem consome mais.

- `Gini_consumo`: Gini do consumo per capita no mesmo recorte.

- `K = C - Gini_consumo` (índice no estilo de Kakwani). Negativo: o item
  pesa mais no orçamento de quem consome menos (gasto **regressivo**,
  como uma necessidade); positivo: pesa mais para quem consome mais
  (**progressivo**, como um bem de luxo).

- `Base40` e `Topo20`: parcela do gasto total com o item feita pelos 40%
  com menor consumo e pelos 20% com maior consumo.

## Exemplos

``` r
pof_concentracao(pof_exemplo(), c("Alimentação", "Educação", "Transporte"))
#>     Edicao        Item         C Gini_consumo           K   Base40   Topo20
#>     <char>      <char>     <num>        <num>       <num>    <num>    <num>
#> 1: exemplo Alimentação 0.3962962    0.4272836 -0.03098731 16.81342 46.23397
#> 2: exemplo    Educação 0.4758786    0.4272836  0.04859505 12.67206 52.30526
#> 3: exemplo  Transporte 0.4438190    0.4272836  0.01653549 13.64444 49.36941
#>    Classificacao
#>           <char>
#> 1:    Regressivo
#> 2:   Progressivo
#> 3:   Progressivo
```
