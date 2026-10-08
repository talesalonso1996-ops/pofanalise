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
#>     Edicao       Termo Estimativa    IC_inf    IC_sup     p_valor  N_UC
#>     <char>      <char>      <num>     <num>     <num>       <num> <int>
#> 1: exemplo (Intercept)  0.9473639 0.7528741 1.1920963 0.643972250  2000
#> 2: exemplo    quintil2  1.2886775 0.9671279 1.7171354 0.083174827  2000
#> 3: exemplo    quintil3  1.1374780 0.8425189 1.5356999 0.399471499  2000
#> 4: exemplo    quintil4  1.4125569 1.0545395 1.8921217 0.020663657  2000
#> 5: exemplo    quintil5  1.4572817 1.0920856 1.9446002 0.010631668  2000
#> 6: exemplo  sexoMulher  0.7745181 0.6418588 0.9345953 0.007796203  2000
```
