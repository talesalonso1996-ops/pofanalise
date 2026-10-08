# Estrutura do orçamento

**Pergunta.** Como a despesa de consumo das famílias se distribui entre
os grandes grupos de gasto, e como essa distribuição mudou entre
1987-1988 e 2017-2018?

**Dados e método.** Despesa de consumo no conceito do IBGE: Níveis 1 a
26 da harmonização v2. Entre edições, o recorte é o conjunto das regiões
metropolitanas e o aluguel fica fora do consumo (ver
[Começando](pofanalise.md)). Participação estimada por razão de totais
ponderada ([`pof_participacao()`](../reference/pof_participacao.md)),
com IC de 95% do desenho amostral de 2002 em diante.

## Resultados nas regiões metropolitanas

A alimentação cai de 23,5% do consumo sem aluguel em 1987-1988 para
19,2% em 2017-2018. Assistência à saúde sobe de 6,7% para 10,6%, e
educação, de 4,0% em 1995-1996 para 7,4%. Vestuário cai de 12,1% para
4,9%.

1987-1988 pede cautela: além do aluguel, habitação sem aluguel (15,5%)
fica bem abaixo de 1995-1996 (25,7%), e a educação daquela edição parece
incompleta (a folha de cursos regulares não existe em 1987).

![Gráfico: Participação dos grupos no consumo sem aluguel,
RMs](estrutura-orcamento_files/figure-html/unnamed-chunk-2-1.png)

| Grupo                       | 1987-1988 | 1995-1996 | 2002-2003 | 2008-2009 | 2017-2018 |
|:----------------------------|----------:|----------:|----------:|----------:|----------:|
| Alimentação                 |      23,5 |      18,8 |      20,8 |      20,4 |      19,2 |
| Assistência à saúde         |       6,7 |       7,8 |       7,4 |       8,5 |      10,6 |
| Despesas diversas           |       8,6 |       7,6 |       7,1 |       6,9 |       4,0 |
| Educação                    |       0,9 |       4,0 |       5,9 |       4,2 |       7,4 |
| Habitação                   |      15,5 |      25,7 |      23,5 |      21,3 |      20,5 |
| Higiene e cuidados pessoais |       1,8 |       1,6 |       2,3 |       2,7 |       3,7 |
| Recreação e cultura         |       2,9 |       3,1 |       3,3 |       4,2 |       3,2 |
| Serviços pessoais           |       2,9 |       2,6 |       2,0 |       2,0 |       2,3 |
| Transporte                  |      25,0 |      23,0 |      22,0 |      24,1 |      24,2 |
| Vestuário                   |      12,1 |       5,6 |       5,8 |       5,8 |       4,9 |

Participação no consumo sem aluguel, conjunto das RMs (%)

## Brasil, 2002 a 2018

Com o conceito completo de consumo (aluguel incluído), comparável ao do
IBGE:

| Grupo | 2002-2003 | 2008-2009 | 2017-2018 |
|:---|---:|---:|---:|
| Alimentação | 20,1 \[19,7; 20,5\] | 19,0 \[18,6; 19,5\] | 17,1 \[16,8; 17,4\] |
| Assistência à saúde | 6,3 \[5,9; 6,6\] | 7,0 \[6,8; 7,3\] | 8,2 \[8,0; 8,4\] |
| Despesas diversas | 5,5 \[4,8; 6,1\] | 4,6 \[3,2; 5,9\] | 2,9 \[2,7; 3,1\] |
| Educação | 4,0 \[3,7; 4,2\] | 2,9 \[2,8; 3,1\] | 4,8 \[4,6; 5,1\] |
| Habitação | 34,8 \[34,3; 35,4\] | 33,4 \[32,7; 34,1\] | 35,6 \[35,2; 35,9\] |
| Higiene e cuidados pessoais | 2,1 \[2,0; 2,2\] | 2,5 \[2,4; 2,5\] | 3,5 \[3,4; 3,6\] |
| Recreação e cultura | 2,3 \[2,2; 2,4\] | 3,2 \[3,1; 3,3\] | 2,4 \[2,3; 2,5\] |
| Serviços pessoais | 1,7 \[1,6; 1,7\] | 1,6 \[1,6; 1,7\] | 1,8 \[1,8; 1,8\] |
| Transporte | 17,8 \[17,4; 18,3\] | 20,2 \[19,6; 20,8\] | 19,4 \[19,0; 19,8\] |
| Vestuário | 5,5 \[5,3; 5,6\] | 5,5 \[5,3; 5,6\] | 4,3 \[4,3; 4,4\] |

Participação na despesa de consumo, Brasil, com IC 95% (%)

A comparação com os números oficiais do IBGE está na vinheta
[Harmonização de produtos](harmonizacao.md).

## Reproduzir

``` r
b <- pof_somar_grupos(pof_ler_edicao(2017, dir, pof_harmonizacao()))
pof_participacao(b, pof_grupos_consumo())                                 # Brasil
bs <- pof_sem_aluguel(b)
pof_participacao(bs, pof_grupos_consumo(), filtro = quote(!is.na(RGMT)))  # RMs
```
