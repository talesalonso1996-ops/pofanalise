# Nomes dos arquivos de uma edição

Nomes dos arquivos gerados pelo pipeline HarmonizaPOF2026 para cada
edição. Altere se os seus arquivos tiverem outro nome.

## Uso

``` r
pof_arquivos(ano)
```

## Argumentos

- ano:

  Ano inicial da edição: 1987, 1995, 2002, 2008 ou 2017.

## Valor

Lista com `despesas`, `moradores` e, em 1995, `domicilios`.

## Exemplos

``` r
pof_arquivos(2017)
#> $despesas
#> [1] "POF2017__GZ__Despesas_POF_2017.gz"
#> 
#> $moradores
#> [1] "POF2017__RDS__MORADORES_H.RDS"
#> 
```
