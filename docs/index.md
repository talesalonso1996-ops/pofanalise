# Atlas da POF Harmonizada

Análises do orçamento das famílias brasileiras com as cinco edições
harmonizadas da **Pesquisa de Orçamentos Familiares (POF)** do IBGE:
1987-1988, 1995-1996, 2002-2003, 2008-2009 e 2017-2018.

> **Aviso: erros conhecidos na harmonização.** A harmonização v2 de
> produtos tem erros de classificação identificados em outubro de 2026:
> o condomínio fica fora do consumo em 2008 e 2017, a compra de imóveis
> entra como consumo de 1987 a 2008, e há contas de celular, itens de
> veículos e outros códigos em grupos errados. Até que sejam corrigidos
> no de-para original, o pacote aplica correções provisórias
> ([`pof_correcoes()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_correcoes.md))
> e todos os resultados deste site já as incorporam. Lista completa e
> efeito de cada correção em [Erros conhecidos na
> harmonização](https://talesalonso1996-ops.github.io/pofanalise/articles/erros-harmonizacao.md).

## O pacote R `pofanalise`

Um pacote para quem pesquisa com a POF: você escolhe o item de despesa,
a medida e o corte, e o pacote cuida do recorte comparável entre
edições, do aluguel imputado, dos quintis, do desenho amostral e do
gráfico.

|  |  |
|----|----|
| [**Baixar e instalar**](https://talesalonso1996-ops.github.io/pofanalise/articles/baixar.md) | Pacote pronto para Windows (`.zip`), código-fonte (`.tar.gz`) e instalação pelo GitHub |
| [**Primeiros passos**](https://talesalonso1996-ops.github.io/pofanalise/articles/pofanalise.md) | Como ler os microdados e as três regras para comparar edições |
| [**Guia de pesquisa**](https://talesalonso1996-ops.github.io/pofanalise/articles/pesquisa.md) | Analisar qualquer item: buscar, carregar, descrever, comparar, modelar, deflacionar e validar |
| [**Todas as funções**](https://talesalonso1996-ops.github.io/pofanalise/reference/index.md) | Referência das 43 funções, com exemplos |
| [**Novidades**](https://talesalonso1996-ops.github.io/pofanalise/news/index.md) | O que mudou em cada versão |

``` r
library(pofanalise)
pof_buscar("aposta")                                        # acha o código do item
dados <- pof_carregar(dir = "HarmonizaPOF2026_data", itens = list(apostas = "26101"))
r <- pof_analisar(dados, "apostas", medida = "prevalencia", por = "quintil")
plot(r)                                                     # gráfico com IC do desenho amostral
pof_validar(dados[["2017-2018"]])                           # confere com as tabelas oficiais do IBGE
```

## A harmonização de produtos

O de-para de Arthur Welle coloca os cerca de 48 mil produtos das cinco
edições numa mesma árvore de categorias, com nota de qualidade por
categoria e confiança por produto. Veja [Harmonização de
produtos](https://talesalonso1996-ops.github.io/pofanalise/articles/harmonizacao.md),
o repositório
[Harmoniza_Produtos](https://github.com/arthurwelle/Harmoniza_Produtos)
e o [explorador
interativo](https://arthurwelle.github.io/Harmoniza_Produtos/).

## Produtos da POF

A ferramenta [Produtos da
POF](https://talesalonso1996-ops.github.io/pof-produtos/) mostra, para
cada um dos 280 produtos harmonizados, a prevalência de compra, a
participação no gasto da categoria e no gasto total, nas cinco edições
([repositório](https://github.com/talesalonso1996-ops/pof-produtos)).

## As análises

Doze estudos feitos com o pacote, uma
[síntese](https://talesalonso1996-ops.github.io/pofanalise/articles/sintese.md)
que cruza os resultados, a [validação com os números oficiais do
IBGE](https://talesalonso1996-ops.github.io/pofanalise/articles/validacao-ibge.md)
e um [painel
interativo](https://talesalonso1996-ops.github.io/pofanalise/atlas/index.md).
Estão no menu **Análises**.

O pacote reproduz o número de famílias publicado pelo IBGE em 2008-2009
e 2017-2018, a despesa de consumo a menos de 2% do oficial e os
coeficientes de variação oficiais (razão mediana 1,01).

## Autoria

Pacote e análises: Tales Alonso. Harmonização dos produtos da POF:
Arthur Welle.
