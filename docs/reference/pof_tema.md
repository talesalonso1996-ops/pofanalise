# Tema, cores e formatação para gráficos e textos

`pof_tema()` é o tema `ggplot2` usado nas análises. `pof_cores_edicao()`
devolve uma escala sequencial de azuis, do mais claro (1987) ao mais
escuro (2017). `pof_fmt()` formata números com vírgula decimal.

## Uso

``` r
pof_tema(base_size = 12)

pof_cores_edicao()

pof_fmt(x, casas = 1)
```

## Argumentos

- base_size:

  Tamanho base da fonte.

- x:

  Números.

- casas:

  Casas decimais.

## Valor

Tema `ggplot2`, vetor nomeado de cores ou texto.

## Exemplos

``` r
pof_fmt(12.345)
#> [1] "12,3"
pof_cores_edicao()
#> 1987-1988 1995-1996 2002-2003 2008-2009 2017-2018 
#> "#86b6ef" "#5598e7" "#2a78d6" "#1c5cab" "#0d366b" 
```
