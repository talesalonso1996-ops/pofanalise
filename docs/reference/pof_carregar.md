# Carrega várias edições com os itens de interesse

Lê as edições pedidas com [`pof_ler_edicao()`](pof_ler_edicao.md), soma
os grandes grupos e cria uma coluna para cada item. Um item é um ou mais
códigos da harmonização: Nível 1 (2 dígitos, ex. `"26"`), Nível 2 (3
dígitos, ex. `"172"`) ou folha (5 dígitos, ex. `"26101"`). Use
[`pof_buscar()`](pof_buscar.md) para achar os códigos.

## Uso

``` r
pof_carregar(
  anos = c(1987, 1995, 2002, 2008, 2017),
  dir,
  itens = list(),
  harmonizacao = pof_harmonizacao()
)
```

## Argumentos

- anos:

  Anos iniciais das edições.

- dir:

  Pasta com os arquivos do HarmonizaPOF2026.

- itens:

  Lista nomeada (ou vetor nomeado) de códigos. Ex.:
  `list(apostas = "26101", celular = c("17202", "24201"))`.

- harmonizacao:

  Resultado de [`pof_harmonizacao()`](pof_harmonizacao.md).

## Valor

Lista de bases (classe `pof_dados`), uma por edição.

## Exemplos

``` r
if (FALSE) { # \dontrun{
dados <- pof_carregar(c(2002, 2008, 2017), "HarmonizaPOF2026_data",
                      itens = list(apostas = "26101"))
} # }
```
