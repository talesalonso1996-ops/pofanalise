# Lê uma edição da POF harmonizada no nível da unidade de consumo

Lê despesas e moradores de uma edição, aplica a harmonização de produtos
e devolve uma linha por unidade de consumo (UC) com peso, desenho
amostral, características da pessoa de referência e gasto mensal por
Nível 1 (`n01` a `n34`) e por folha de consumo selecionada.

## Uso

``` r
pof_ler_edicao(
  ano,
  dir,
  harmonizacao = pof_harmonizacao(),
  arquivos = pof_arquivos(ano),
  folhas = NULL,
  itens = list(),
  manter_sem_consumo = FALSE
)
```

## Argumentos

- ano:

  Ano inicial da edição.

- dir:

  Pasta com os arquivos do HarmonizaPOF2026.

- harmonizacao:

  Resultado de
  [`pof_harmonizacao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_harmonizacao.md).

- arquivos:

  Nomes dos arquivos, ver
  [`pof_arquivos()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_arquivos.md).

- folhas:

  Códigos de folha (`cod_final`) a manter como colunas individuais
  (`f` + código). Por padrão, todas as folhas de consumo não alimentar e
  a folha de refeições.

- itens:

  Lista nomeada de códigos da harmonização para somar numa coluna
  própria: Nível 1 (2 dígitos), Nível 2 (3 dígitos) ou folha (5
  dígitos). Ex.:
  `list(apostas = "26101", celular = c("17202", "24201"))`. Ver
  [`pof_buscar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_buscar.md).

- manter_sem_consumo:

  Manter as UCs sem despesa de consumo registrada (o IBGE as inclui nas
  médias por família). Por padrão saem, porque as participações no
  orçamento não são definidas para elas.

## Valor

`data.table` com uma linha por UC. Colunas: `Edicao`, `id_uc`, `Peso`,
`RGMT`, `UPA`, `ESTRATO` (quando há), `UF`, `regiao` e `situacao`
(urbano/rural; 2002 em diante, quando a edição tem a informação),
`N_moradores_UC`, `Sexo_ref`, `Idade_ref`, `Cor_ref`, `n01`...`n34`,
colunas de folha, `Consumo` (Níveis de consumo) e `Consumo_pc`. O
atributo `"mapeamento"` traz a proporção do valor que casou com o
de-para.

## Detalhes

Os valores estão na moeda nominal de cada edição: compare participações,
índices e medidas de desigualdade entre edições, nunca valores.

Detalhes por edição:

- 1987 e 1995 cobrem só as regiões metropolitanas e não têm UPA e
  estrato; o peso de 1995 vem do arquivo de domicílios.

- Desenho amostral: UPA e estrato em 2002 (UPA composta por UF,
  sequência e dígito), 2008 e 2017.

## Exemplos

``` r
if (FALSE) { # \dontrun{
h <- pof_harmonizacao()
b <- pof_ler_edicao(2017, dir = "HarmonizaPOF2026_data", harmonizacao = h)
} # }
```
