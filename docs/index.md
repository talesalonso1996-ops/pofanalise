# pofanalise

Análises do orçamento das famílias brasileiras com as cinco edições
harmonizadas da **Pesquisa de Orçamentos Familiares (POF)** do IBGE:
1987-1988, 1995-1996, 2002-2003, 2008-2009 e 2017-2018.

O projeto tem três partes:

- **Harmonização de produtos**, de Arthur Welle: o de-para que coloca os
  cerca de 48 mil produtos das cinco edições numa mesma árvore de
  categorias, com nota de qualidade por categoria e confiança por
  produto. Repositório
  [Harmoniza_Produtos](https://github.com/arthurwelle/Harmoniza_Produtos)
  e [explorador
  interativo](https://arthurwelle.github.io/Harmoniza_Produtos/).
- **Pacote R `pofanalise`**: lê os microdados harmonizados, aplica o
  de-para e estima participações no orçamento, prevalências, quintis,
  curvas de Engel e desigualdade do consumo, com intervalos de confiança
  do desenho amostral.
- **Análises**: sete estudos temáticos, uma síntese que cruza os
  resultados e um painel interativo.

## Instalação

``` r
# install.packages("remotes")
remotes::install_github("talesalonso1996-ops/pofanalise")
```

## Uso

``` r
library(pofanalise)

h <- pof_harmonizacao()   # baixa o de-para v2 de Arthur Welle (fica em cache)
b <- pof_ler_edicao(2017, dir = "HarmonizaPOF2026_data", harmonizacao = h)
b <- pof_add_quintis(pof_somar_grupos(b))

pof_participacao(b, pof_grupos_consumo())          # Brasil, com IC 95%
pof_participacao(b, "Alimentação", por = "Quintil")
pof_desigualdade(b, B = 200)                       # Gini com IC por bootstrap
```

Os microdados harmonizados (pipeline HarmonizaPOF2026) não acompanham o
pacote. Os resultados agregados das análises, sim:
[`pof_resultado()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_resultado.md)
lista as tabelas.

## Comece por

- [Começando](https://talesalonso1996-ops.github.io/pofanalise/articles/pofanalise.md):
  fluxo de uso e as três regras para comparar edições.
- [Harmonização de
  produtos](https://talesalonso1996-ops.github.io/pofanalise/articles/harmonizacao.md):
  como o de-para funciona e o que muda em relação à versão inicial.
- [Síntese das
  análises](https://talesalonso1996-ops.github.io/pofanalise/articles/sintese.md):
  o que se repete entre os estudos.

## Autoria

Pacote e análises: Tales Alonso. Harmonização dos produtos da POF:
Arthur Welle.
