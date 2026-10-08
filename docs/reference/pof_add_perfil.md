# Variáveis de perfil da UC

Acrescenta rótulos de sexo, faixa etária e cor da pessoa de referência,
tamanho da UC e região metropolitana, usados no argumento `por` de
[`pof_analisar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_analisar.md).
As colunas `regiao` (Grande Região) e `situacao` (urbana/rural) vêm de
[`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md)
e também podem ser usadas em `por` (2002 em diante; situação a partir de
2008).

## Uso

``` r
pof_add_perfil(b)
```

## Argumentos

- b:

  Base de
  [`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md).

## Valor

A base com `sexo`, `idade`, `cor`, `tamanho` e `rm`.
