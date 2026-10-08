# Elasticidade-despesa de um item

Especificação de Working-Leser ([`pof_engel()`](pof_engel.md)) aplicada
a qualquer item, em cada edição e, opcionalmente, dentro de cada
categoria de um corte.

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

  Resultado de [`pof_carregar()`](pof_carregar.md) ou uma base única.

- item:

  Nome de coluna: um item de [`pof_carregar()`](pof_carregar.md), um
  grupo (`"Alimentação"`) ou um Nível 1 (`"n07"`).

- por:

  Corte: `NULL`, `"quintil"`, `"sexo"`, `"idade"`, `"cor"`, `"tamanho"`,
  `"rm"`, `"regiao"` (Grande Região) ou `"situacao"` (urbana/rural).

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
#> 1: exemplo Mulher    0.8915537 -0.02971278 0.003326825 27.39861  1029
#> 2: exemplo  Homem    0.9352926 -0.01763070 0.003334163 27.24680   971
```
