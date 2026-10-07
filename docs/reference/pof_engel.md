# Curva de Engel (Working-Leser)

Estima, por mínimos quadrados ponderados pelo peso amostral, \$\$w_i =
\alpha + \beta \ln(c) + \gamma \ln(n) + \varepsilon,\$\$ em que \\w_i\\
é a participação do grupo no consumo da UC, \\c\\ o consumo per capita e
\\n\\ o número de moradores. A elasticidade-despesa na média é \\1 +
\beta / \bar{w}\\. Com desenho amostral (2002 em diante), o erro-padrão
de \\\beta\\ vem de
[`survey::svyglm`](https://rdrr.io/pkg/survey/man/svyglm.html); sem ele,
do MQO ponderado.

## Uso

``` r
pof_engel(b, grupos)
```

## Argumentos

- b:

  Base com grupos somados.

- grupos:

  Colunas de grupo.

## Valor

`data.table` com `Edicao`, `Grupo`, `beta`, `ep`, `w_medio`,
`elasticidade`, `R2`, `N`.
