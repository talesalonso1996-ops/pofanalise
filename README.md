# Atlas da POF Harmonizada

Análises do orçamento das famílias brasileiras com as cinco edições harmonizadas da **Pesquisa de Orçamentos Familiares (POF)** do IBGE: 1987-1988, 1995-1996, 2002-2003, 2008-2009 e 2017-2018.

## O pacote R `pofanalise`

Um pacote para quem pesquisa com a POF: você escolhe o item de despesa, a medida e o corte, e o pacote cuida do recorte comparável entre edições, do aluguel imputado, dos quintis, do desenho amostral e do gráfico.

| | |
|---|---|
| [**Baixar e instalar**](articles/baixar.html) | Pacote pronto para Windows (`.zip`), código-fonte (`.tar.gz`) e instalação pelo GitHub |
| [**Primeiros passos**](articles/pofanalise.html) | Como ler os microdados e as três regras para comparar edições |
| [**Guia de pesquisa**](articles/pesquisa.html) | Analisar qualquer item: buscar, carregar, descrever, comparar, modelar, deflacionar e validar |
| [**Todas as funções**](reference/index.html) | Referência das 43 funções, com exemplos |
| [**Novidades**](news/index.html) | O que mudou em cada versão |

```r
library(pofanalise)
pof_buscar("aposta")                                        # acha o código do item
dados <- pof_carregar(dir = "HarmonizaPOF2026_data", itens = list(apostas = "26101"))
r <- pof_analisar(dados, "apostas", medida = "prevalencia", por = "quintil")
plot(r)                                                     # gráfico com IC do desenho amostral
pof_validar(dados[["2017-2018"]])                           # confere com as tabelas oficiais do IBGE
```

## A harmonização de produtos

O de-para de Arthur Welle coloca os cerca de 48 mil produtos das cinco edições numa mesma árvore de categorias, com nota de qualidade por categoria e confiança por produto. Veja [Harmonização de produtos](articles/harmonizacao.html), o repositório [Harmoniza_Produtos](https://github.com/arthurwelle/Harmoniza_Produtos) e o [explorador interativo](https://arthurwelle.github.io/Harmoniza_Produtos/).

## As análises

Doze estudos feitos com o pacote, uma [síntese](articles/sintese.html) que cruza os resultados, a [validação com os números oficiais do IBGE](articles/validacao-ibge.html) e um [painel interativo](atlas/index.html). Estão no menu **Análises**.

O pacote reproduz o número de famílias publicado pelo IBGE em 2008-2009 e 2017-2018, a despesa de consumo a menos de 2% do oficial e os coeficientes de variação oficiais (razão mediana 1,01).

## Autoria

Pacote e análises: Tales Alonso. Harmonização dos produtos da POF: Arthur Welle.
