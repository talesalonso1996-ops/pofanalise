# Analisa um item ao longo das edições

Calcula, para cada edição carregada, uma medida do item, com intervalo
de confiança de 95% quando a edição tem desenho amostral (2002 em
diante).

## Uso

``` r
pof_analisar(
  dados,
  item,
  medida = c("prevalencia", "participacao", "gasto_medio"),
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

- medida:

  `"prevalencia"`, `"participacao"` ou `"gasto_medio"`.

- por:

  Corte: `NULL`, `"quintil"`, `"sexo"`, `"idade"`, `"cor"`, `"tamanho"`,
  `"rm"`, `"regiao"` (Grande Região) ou `"situacao"` (urbana/rural).

- recorte:

  `"auto"`, `"brasil"` ou `"rms"`.

- sem_aluguel:

  `NULL` (automático), `TRUE` ou `FALSE`.

## Valor

`data.table` (classe `pof_analise`) com `Edicao`, `Grupo`, `Estimativa`,
`IC_inf`, `IC_sup`, `N_UC` e atributos com as escolhas feitas.

## Detalhes

Medidas:

- `"prevalencia"`: % de UCs com gasto no item.

- `"participacao"`: % do item na despesa de consumo.

- `"gasto_medio"`: gasto mensal médio por UC, em moeda da edição. Os
  valores são nominais: compare só dentro de cada edição.

Recorte: com `"auto"`, usa as regiões metropolitanas quando há edição
anterior a 2002 entre as carregadas e o Brasil caso contrário. Com
`sem_aluguel = NULL`, o aluguel sai do consumo sempre que o recorte é
das RMs (comparação com 1987 e 1995). Os quintis são de consumo per
capita, calculados dentro de cada edição e recorte.

## Exemplos

``` r
r <- pof_analisar(pof_exemplo(), "Educação", medida = "prevalencia", por = "quintil")
r
#> Item: Educação | % das UCs com gasto 
#> Recorte: Brasil  | por quintil 
#> 
#>     Edicao  Grupo Estimativa IC_inf IC_sup  N_UC
#>     <char> <char>      <num>  <num>  <num> <int>
#> 1: exemplo      1      45.36  40.19  50.53   395
#> 2: exemplo      2      51.54  46.44  56.65   384
#> 3: exemplo      3      48.52  43.26  53.79   398
#> 4: exemplo      4      54.25  49.15  59.36   416
#> 5: exemplo      5      54.59  49.69  59.49   407
```
