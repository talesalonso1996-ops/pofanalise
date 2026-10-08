# Diferença entre grupos

Compara a prevalência ou o gasto médio do item entre as categorias de um
corte, dentro de cada edição, por regressão com desenho amostral
([`survey::svyglm`](https://rdrr.io/pkg/survey/man/svyglm.html)). Cada
linha é a diferença em relação à categoria de referência, com IC de 95%
e p-valor. Exige desenho amostral (2002 em diante).

## Uso

``` r
pof_diferenca(
  dados,
  item,
  por,
  medida = c("prevalencia", "gasto_medio"),
  recorte = c("auto", "brasil", "rms"),
  referencia = NULL
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

  Corte: `NULL`, `"quintil"`, `"sexo"`, `"idade"`, `"cor"`, `"tamanho"`,
  `"rm"`, `"regiao"` (Grande Região) ou `"situacao"` (urbana/rural).

- medida:

  `"prevalencia"` (diferença em pontos percentuais) ou `"gasto_medio"`.

- recorte:

  `"auto"`, `"brasil"` ou `"rms"`.

- referencia:

  Categoria de referência (padrão: a primeira).

## Valor

`data.table` com `Edicao`, `Grupo`, `Referencia`, `Diferenca`, `IC_inf`,
`IC_sup`, `p_valor`.

## Exemplos

``` r
pof_diferenca(pof_exemplo(), "Educação", por = "sexo")
#>     Edicao  Grupo Referencia Diferenca    IC_inf    IC_sup    p_valor
#>     <char> <char>     <char>     <num>     <num>     <num>      <num>
#> 1: exemplo Mulher      Homem -6.409932 -11.06414 -1.755722 0.00705619
```
