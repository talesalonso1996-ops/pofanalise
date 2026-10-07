# Variação entre duas edições

Compara duas edições de um resultado de
[`pof_analisar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_analisar.md),
grupo a grupo: diferença, IC de 95% e p-valor. As amostras de edições
diferentes são independentes, então o erro-padrão da diferença é a raiz
da soma dos quadrados dos erros-padrão (recuperados dos intervalos de
confiança). Sem IC numa das edições (1987, 1995), devolve só a
diferença.

## Uso

``` r
pof_variacao(resultado, de, para)
```

## Argumentos

- resultado:

  Resultado de
  [`pof_analisar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_analisar.md).

- de, para:

  Edições, como `"2008-2009"` e `"2017-2018"`.

## Valor

`data.table` com `Grupo`, `De`, `Para`, `Diferenca`, `IC_inf`, `IC_sup`,
`p_valor` e `Significativa` (p \< 0,05).

## Exemplos

``` r
r <- pof_analisar(list(pof_exemplo(semente = 1), pof_exemplo(semente = 2)), "Jogos")
r$Edicao <- c("2008-2009", "2017-2018")
pof_variacao(r, "2008-2009", "2017-2018")
#> Key: <Grupo>
#>     Grupo       De    Para  Diferenca    IC_inf   IC_sup   p_valor
#>    <char>    <num>   <num>      <num>     <num>    <num>     <num>
#> 1:  Total 14.57348 14.4433 -0.1301792 -2.390293 2.129934 0.9101153
#>    Significativa
#>           <lgcl>
#> 1:         FALSE
```
