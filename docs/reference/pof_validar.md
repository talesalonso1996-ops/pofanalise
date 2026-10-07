# Compara as estimativas do pacote com as tabelas oficiais do IBGE

Reproduz, com os microdados harmonizados, a despesa média mensal
familiar publicada pelo IBGE (ver
[`pof_ibge()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ibge.md))
para cada tipo de despesa com correspondência em
[`pof_mapa_ibge()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_mapa_ibge.md),
e para o número de famílias e o tamanho médio da família. A estimativa
usa todas as UCs do recorte, inclusive as sem despesa de consumo, como o
IBGE; o IC de 95% vem do desenho amostral.

## Uso

``` r
pof_validar(dados, recortes = NULL)
```

## Argumentos

- dados:

  Bases de
  [`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md)
  lidas com `manter_sem_consumo = TRUE` e com grupos somados
  ([`pof_somar_grupos()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_somar_grupos.md)),
  ou o resultado de
  [`pof_carregar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_carregar.md)
  (que remove as UCs sem consumo e por isso subestima levemente o número
  de famílias). Edições sem tabela oficial no pacote são ignoradas.

- recortes:

  Recortes a validar (padrão: todos os disponíveis).

## Valor

`data.table` com `Edicao`, `Recorte`, `Grupo_ibge`, `Item_ibge`,
`Oficial`, `Estimado`, `IC_inf`, `IC_sup`, `Dif_pct` (diferença
relativa, %) e `Oficial_no_IC`.

## Exemplos

``` r
if (FALSE) { # \dontrun{
h <- pof_harmonizacao()
b <- pof_somar_grupos(pof_ler_edicao(2017, dir, h, manter_sem_consumo = TRUE))
v <- pof_validar(b)
v[Recorte == "Brasil"]
} # }
```
