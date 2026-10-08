# Busca produtos e categorias na harmonização

Procura um termo (sem diferenciar maiúsculas ou acentos) nos nomes das
categorias e nas descrições dos produtos originais, e devolve os códigos
para usar em [`pof_carregar()`](pof_carregar.md).

## Uso

``` r
pof_buscar(termo, harmonizacao = pof_harmonizacao(), produtos = TRUE)
```

## Argumentos

- termo:

  Texto a procurar (expressão regular).

- harmonizacao:

  Resultado de [`pof_harmonizacao()`](pof_harmonizacao.md).

- produtos:

  Procurar também nas descrições dos produtos originais.

## Valor

`data.table` com `codigo` (folha, Nível 2 ou Nível 1), `nivel`, `nome`,
`n1` e, para produtos, `ano` e `descricao`.

## Exemplos

``` r
if (FALSE) { # \dontrun{
pof_buscar("celular")
pof_buscar("aposta|loteria")
} # }
```
