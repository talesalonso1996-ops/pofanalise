# Harmonização de produtos

Cada edição da POF tem sua própria lista de produtos, com códigos e
descrições que mudam de uma pesquisa para outra. Para comparar 1987 com
2017 é preciso colocar os cerca de 48 mil produtos das cinco edições
numa mesma árvore de categorias. Esse trabalho é a **harmonização de
produtos de Arthur Welle**, mantida no repositório
[Harmoniza_Produtos](https://github.com/arthurwelle/Harmoniza_Produtos).

## A árvore de categorias

A harmonização tem três níveis:

- **Nível 1**: 34 grandes categorias. De 1 a 16 são alimentos (cereais,
  carnes, laticínios…); de 17 a 26, consumo não alimentar (habitação,
  transporte, saúde…); de 27 a 34, outras despesas, variação patrimonial
  e rendimentos.
- **Nível 2**: subgrupos, como “17.2 Telefonia e comunicações”.
- **Folhas**: 307 categorias finais, como “17202 Telefone celular
  (plano/serviço)”.

Cada folha tem uma **nota de qualidade** (alta, média, baixa), que
indica se ela está presente nas cinco edições e se o mapeamento é
direto. Cada produto tem uma **confiança** de 0,6 a 1.

## Explorador da harmonização

O explorador do Arthur mostra, para cada folha, os produtos de cada
edição lado a lado. Use-o para conferir um mapeamento ou apontar um
problema (botão “Apontar problema”). Se ele não aparecer no quadro
abaixo, [abra o explorador em outra
aba](https://arthurwelle.github.io/Harmoniza_Produtos/).

[Abrir o explorador em tela
cheia](https://arthurwelle.github.io/Harmoniza_Produtos/)

## Como o pacote usa a harmonização

[`pof_harmonizacao()`](../reference/pof_harmonizacao.md) baixa o de-para
(`produtos.csv` e `folhas.csv`) de um commit fixo do repositório, para
que os resultados sejam reproduzíveis, e o guarda em cache.
[`pof_ler_edicao()`](../reference/pof_ler_edicao.md) casa cada despesa
pelo código original do produto.

``` r
h <- pof_harmonizacao()          # v2, com as correções de pof_correcoes()
h$folhas[qualidade != "Alta"]    # folhas que pedem cuidado
b <- pof_ler_edicao(2017, dir = "HarmonizaPOF2026_data", harmonizacao = h)
attr(b, "mapeamento")            # proporção do valor que casou com o de-para
```

Com a v2, **100,0% do valor** das despesas casa com o de-para em todas
as edições. Alguns códigos originais apontam para mais de uma folha (a
v2 detalha espécies de pescado que dividem o mesmo código); nesses casos
o pacote usa a folha mais frequente, e todas as folhas concorrentes
pertencem ao mesmo Nível 1.

## Correções aplicadas

Ao comparar os resultados com os números oficiais do IBGE, apareceu um
ponto na v2: em 2017-2018, os itens do quadro 44 (telefonia celular)
estão em “26102 Comunicação (outros)”, dentro de Despesas diversas. Nas
outras edições e no IBGE, conta de celular é Habitação. O pacote corrige
isso por padrão e documenta cada código:

|  Ano | Código | Folha de destino | Item                              |
|-----:|-------:|:-----------------|:----------------------------------|
| 2017 |  44001 | 17202            | Cartão de telefonia celular       |
| 2017 |  44002 | 17202            | Conta de celular (voz e internet) |
| 2017 |  44003 | 17202            | Conta de celular (internet)       |
| 2017 |  44007 | 17202            | Pacote de voz                     |
| 2017 |  44004 | 24201            | Aparelho de telefone celular      |
| 2017 |  44006 | 24201            | Acessórios de telefone celular    |

Para usar a v2 sem as correções: `pof_harmonizacao(correcoes = FALSE)`.

## Efeito de cada versão nos resultados

A tabela compara a participação dos grupos na despesa de consumo do
Brasil em 2017-2018 com três de-paras: o `Cod_harmo` antigo gravado nos
microdados, a v2 original e a v2 com correções.

| Grupo | IBGE | Cod_harmo antigo | v2 original | v2 com correções |
|:---|---:|---:|---:|---:|
| Assistência à saúde | 8,0 | 8,2 | 8,2 | 8,2 |
| Educação | 4,7 | 4,9 | 4,8 | 4,8 |
| Vestuário | 4,3 | 4,4 | 4,3 | 4,3 |
| Habitação | 36,6 | 34,5 | 34,2 | 35,6 |
| Higiene e cuidados pessoais | 3,6 | 3,5 | 3,5 | 3,5 |
| Despesas diversas | 3,0 | 5,4 | 5,3 | 2,9 |
| Recreação e cultura | 2,6 | 1,4 | 1,3 | 2,4 |
| Transporte | 18,1 | 19,6 | 19,4 | 19,4 |
| Alimentação | 17,5 | 16,4 | 17,1 | 17,1 |
| Serviços pessoais | 1,8 | 1,8 | 1,8 | 1,8 |

Participação na despesa de consumo, Brasil, 2017-2018 (%)

Duas mudanças se destacam:

- **Alimentação.** O `Cod_harmo` antigo deixava sem categoria o quadro
  24 de 2017 (refeições fora de casa: marmita, lanche, almoço). A v2 o
  leva para “16104 Refeição”, e a alimentação passa de 16,4% para 17,1%,
  contra 17,5% do IBGE.
- **Habitação e despesas diversas.** Com a correção do celular,
  habitação vai de 34,2% para 35,6% (IBGE: 36,6%) e despesas diversas,
  de 5,3% para 2,9% (IBGE: 3,0%).

Com a v2 corrigida, 10 dos 10 grupos ficam a menos de 1,5 ponto
percentual do número oficial.

## Pontos que continuam em aberto

- **Aluguel imputado.** O aluguel estimado de quem mora em imóvel
  próprio só aparece de 2002-2003 em diante. Toda comparação entre as
  cinco edições exclui o aluguel
  ([pof_sem_aluguel()](../reference/pof_sem_aluguel.md)).
- **Educação em 1987.** A folha de cursos regulares não existe em 1987,
  como a própria nota de qualidade da v2 registra.
- **Cor.** A variável não existe em 1987 e não tem as categorias usadas
  em 1995.
