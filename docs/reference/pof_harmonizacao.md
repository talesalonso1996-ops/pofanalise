# Harmonização de produtos da POF (Arthur Welle)

Baixa e prepara o de-para de produtos da POF mantido por Arthur Welle no
repositório
[Harmoniza_Produtos](https://github.com/arthurwelle/Harmoniza_Produtos)
(explorador em <https://arthurwelle.github.io/Harmoniza_Produtos/>). Os
arquivos ficam em cache local depois do primeiro download.

## Uso

``` r
pof_harmonizacao(
  versao = c("v2", "inicial"),
  ref = .harmo_ref_padrao,
  dir_local = NULL,
  cache = tools::R_user_dir("pofanalise", "cache"),
  correcoes = TRUE
)
```

## Argumentos

- versao:

  `"v2"` ou `"inicial"`.

- ref:

  Commit, tag ou ramo do repositório de origem.

- dir_local:

  Pasta com `produtos.csv` e `folhas.csv` já baixados. Se informado,
  nada é baixado.

- cache:

  Pasta de cache.

- correcoes:

  Aplicar as correções de
  [`pof_correcoes()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_correcoes.md)
  (só na v2).

## Valor

Lista com `depara` (ano, codigo, cod_final, n1, ambiguo, confianca),
`folhas` (taxonomia e qualidade), `versao` e `ref`.

## Detalhes

A versão `"v2"` (padrão) é a harmonização revista, com 307 folhas, nota
de qualidade por folha e confiança por produto. A versão `"inicial"` é o
esquema anterior, o mesmo do `Cod_harmo` gravado nos microdados.

Alguns códigos originais de produto apontam para mais de uma folha (a v2
detalha, por exemplo, espécies de pescado que dividem o mesmo código).
Nesses casos o código é atribuído à folha com mais descrições
associadas, e a coluna `ambiguo` marca a decisão. Em todos os casos
verificados as folhas concorrentes pertencem ao mesmo Nível 1, o que não
altera análises por grupo.

## Exemplos

``` r
if (FALSE) { # \dontrun{
h <- pof_harmonizacao()
h$folhas[n1_num == 22]
} # }
```
