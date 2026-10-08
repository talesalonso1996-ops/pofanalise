# Desigualdade do consumo

**Pergunta.** A desigualdade da despesa de consumo diminuiu?

**Método.** Despesa de consumo per capita sem aluguel, ponderada por
pessoa
([`pof_desigualdade()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_desigualdade.md)):
Gini, razão P90/P10 e parcela do consumo dos 10% de maior consumo. São
medidas sem unidade monetária, comparáveis entre edições. No Brasil, o
IC de 95% do Gini vem de 200 réplicas de bootstrap de Rao-Wu (em cada
estrato com n UPAs, sorteiam-se n - 1 com reposição e os pesos são
reescalonados).

## Resultados

Nas RMs, o Gini vai de 0,538 em 1987-1988 a 0,566 em 1995-1996, o ponto
mais alto, e cai para 0,521 em 2017-2018. No Brasil, passa de 0,533 (IC:
0,525 a 0,540) para 0,507 (IC: 0,498 a 0,516); os intervalos não se
sobrepõem. A parcela dos 10% de maior consumo cai de 40,7% para 38,7%.

![Gráfico: Gini da despesa de consumo per capita (sem
aluguel)](desigualdade_files/figure-html/unnamed-chunk-2-1.png)

| Recorte | Edicao    | Gini  | IC 95%        | P90/P10 | Top 10 (%) |
|:--------|:----------|:------|:--------------|:--------|:-----------|
| RMs     | 1987-1988 | 0,538 |               | 12,1    | 41,5       |
| RMs     | 1995-1996 | 0,566 |               | 14,6    | 43,8       |
| RMs     | 2002-2003 | 0,526 |               | 12,8    | 40,1       |
| Brasil  | 2002-2003 | 0,541 | 0,533 a 0,549 | 13,3    | 41,5       |
| RMs     | 2008-2009 | 0,540 |               | 12,8    | 41,8       |
| Brasil  | 2008-2009 | 0,533 | 0,525 a 0,540 | 13,1    | 40,7       |
| RMs     | 2017-2018 | 0,521 |               | 11,8    | 39,9       |
| Brasil  | 2017-2018 | 0,507 | 0,498 a 0,516 | 10,9    | 38,7       |

Medidas de desigualdade da despesa de consumo per capita

## Por região metropolitana

Entre 2008-2009 e 2017-2018 o Gini cai em 7 das 11 RMs. As amostras por
RM são menores e esta tabela não tem IC: diferenças pequenas entre RMs
não devem ser interpretadas.

| RM             | 1987-1988 | 1995-1996 | 2002-2003 | 2008-2009 | 2017-2018 |
|:---------------|:----------|:----------|:----------|:----------|:----------|
| Belo Horizonte | 0,517     | 0,540     | 0,497     | 0,543     | 0,462     |
| Belém          | 0,530     | 0,506     | 0,459     | 0,455     | 0,490     |
| Brasília       | 0,556     | 0,522     | 0,439     | 0,510     | 0,527     |
| Curitiba       | 0,517     | 0,535     | 0,488     | 0,542     | 0,460     |
| Fortaleza      | 0,564     | 0,559     | 0,545     | 0,490     | 0,469     |
| Goiânia        | 0,558     | 0,597     | 0,463     | 0,559     | 0,483     |
| Porto Alegre   | 0,511     | 0,534     | 0,492     | 0,457     | 0,467     |
| Recife         | 0,541     | 0,576     | 0,508     | 0,582     | 0,507     |
| Rio de Janeiro | 0,528     | 0,576     | 0,554     | 0,567     | 0,533     |
| Salvador       | 0,541     | 0,570     | 0,513     | 0,587     | 0,518     |
| São Paulo      | 0,528     | 0,552     | 0,512     | 0,508     | 0,531     |

Gini da despesa de consumo per capita, por RM
