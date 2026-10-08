# Desenho amostral da POF

Monta o desenho amostral
([`survey::svydesign`](https://rdrr.io/pkg/survey/man/svydesign.html))
com UPA e estrato quando a base os tem (2002 em diante). Para 1987 e
1995 devolve `NULL`.

## Uso

``` r
pof_desenho(b)
```

## Argumentos

- b:

  Base de
  [`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md).

## Valor

Objeto `survey.design2` ou `NULL`.
