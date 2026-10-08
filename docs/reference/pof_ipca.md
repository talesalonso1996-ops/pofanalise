# IPCA e deflacionamento

`pof_ipca()` devolve o número-índice mensal do IPCA (IBGE, SIDRA, tabela
1737). `pof_deflacionar()` leva valores em reais de uma data para outra.
As datas de referência das POFs em real são: 1995-1996, setembro de
1996; 2002-2003, janeiro de 2003; 2008-2009, janeiro de 2009; 2017-2018,
janeiro de 2018. A POF 1987-1988 está em cruzados e não é deflacionada.

## Uso

``` r
pof_ipca()

pof_deflacionar(x, de = NULL, para = "201801")
```

## Argumentos

- x:

  Valores, ou um resultado de [`pof_analisar()`](pof_analisar.md) com
  `medida = "gasto_medio"` (estimativa e IC são deflacionados edição a
  edição).

- de:

  Mês de origem (`"AAAAMM"`) ou edição (`"2008-2009"`). Ignorado quando
  `x` é resultado de [`pof_analisar()`](pof_analisar.md).

- para:

  Mês de destino (`"AAAAMM"`) ou edição. Padrão: janeiro de 2018, a
  referência da POF 2017-2018.

## Valor

`pof_ipca()`: `data.table` com `mes` e `ipca`. `pof_deflacionar()`: o
mesmo tipo de `x`, em reais da data de destino.

## Exemplos

``` r
pof_deflacionar(1000, de = "2008-2009")    # R$ 1.000 de jan/2009 em jan/2018
#> [1] 1696.306
```
