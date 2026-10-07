# Modelo de regressão para um item

Ajusta, em cada edição com desenho amostral, um modelo para a chance de
ter gasto com o item (logístico, `tipo = "prevalencia"`) ou para o log
do gasto entre quem gasta (`tipo = "gasto"`), com
[`survey::svyglm`](https://rdrr.io/pkg/survey/man/svyglm.html). As
variáveis explicativas podem ser os cortes de
[`pof_add_perfil()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_add_perfil.md),
`quintil` ou qualquer coluna da base.

## Uso

``` r
pof_modelo(
  dados,
  item,
  formula,
  tipo = c("prevalencia", "gasto"),
  recorte = c("auto", "brasil", "rms")
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

- formula:

  Lado direito da fórmula, ex. `~ quintil + sexo + cor`.

- tipo:

  `"prevalencia"` ou `"gasto"`.

- recorte:

  `"auto"`, `"brasil"` ou `"rms"`.

## Valor

`data.table` com `Edicao`, `Termo`, `Estimativa` (razão de chances no
modelo logístico; coeficiente do log do gasto no outro), `IC_inf`,
`IC_sup`, `p_valor`, `N_UC`.

## Exemplos

``` r
pof_modelo(pof_exemplo(), "Educação", ~ quintil + sexo)
#>     Edicao       Termo Estimativa    IC_inf   IC_sup    p_valor  N_UC
#>     <char>      <char>      <num>     <num>    <num>      <num> <int>
#> 1: exemplo (Intercept)  0.8822052 0.6997162 1.112288 0.28843020  2000
#> 2: exemplo    quintil2  1.0413526 0.7754972 1.398348 0.78716288  2000
#> 3: exemplo    quintil3  1.1271291 0.8411402 1.510355 0.42204561  2000
#> 4: exemplo    quintil4  1.3160275 0.9798544 1.767536 0.06796163  2000
#> 5: exemplo    quintil5  1.4715324 1.0859065 1.994101 0.01283871  2000
#> 6: exemplo  sexoMulher  0.9665371 0.8076635 1.156662 0.70970127  2000
```
