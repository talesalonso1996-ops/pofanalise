# Saúde e educação

**Pergunta.** Quem gasta do próprio bolso com saúde e educação, e
quanto?

**Método.** Participação no consumo sem aluguel por quintil (RMs, cinco
edições) e prevalência de gasto, com IC de 95%, no Brasil de 2002 em
diante. Folhas: remédios (22101), plano e seguro de saúde (22301),
cursos regulares (23101) e curso superior (23102). Em 1987-1988 não
existe a folha de cursos regulares, o que torna a educação daquela
edição incompleta.

## Saúde

A assistência à saúde pesa 8,2% no consumo do 1º quintil e 11,1% no do
5º em 2017-2018, mas com composições opostas. Remédios pesam 6,6% no 1º
quintil e 3,2% no 5º; plano de saúde, 0,7% e 5,7%. No Brasil, têm gasto
com plano de saúde 3,4% (IC 95%: 2,9 a 4,0) das UCs do 1º quintil e
56,0% (IC 95%: 54,4 a 57,5) das do 5º.

## Educação

A participação da educação cresce com o consumo: 3,4% no 1º quintil e
8,1% no 5º em 2017-2018. O curso superior pago é o item que mais se
espalhou: a proporção de UCs com esse gasto no 3º quintil vai de 1,2%
(IC 95%: 0,9 a 1,6) em 2002-2003 para 5,9% (IC 95%: 5,3 a 6,5) em
2017-2018. O período coincide com a expansão do ensino superior privado
e do financiamento estudantil; esta análise descreve, não identifica
causa.

![Gráfico: UCs com gasto em plano de saúde e ensino pago,
Brasil](saude-educacao_files/figure-html/unnamed-chunk-2-1.png)

| Nome | Quintil | 2002-2003 | 2008-2009 | 2017-2018 |
|:---|---:|:---|:---|:---|
| Curso superior | 1 | 0,0 \[-0,0; 0,0\] | 0,3 \[0,2; 0,4\] | 0,8 \[0,6; 1,0\] |
| Curso superior | 2 | 0,3 \[0,1; 0,4\] | 0,8 \[0,6; 1,0\] | 2,7 \[2,3; 3,1\] |
| Curso superior | 3 | 1,2 \[0,9; 1,6\] | 2,1 \[1,8; 2,5\] | 5,9 \[5,3; 6,5\] |
| Curso superior | 4 | 4,4 \[3,7; 5,0\] | 5,8 \[5,1; 6,4\] | 10,1 \[9,3; 11,0\] |
| Curso superior | 5 | 16,6 \[15,2; 18,1\] | 13,1 \[11,9; 14,2\] | 18,1 \[17,1; 19,2\] |
| Cursos regulares (ensino fundamental/médio) | 1 | 1,5 \[1,2; 1,8\] | 1,3 \[1,0; 1,6\] | 3,6 \[3,1; 4,1\] |
| Cursos regulares (ensino fundamental/médio) | 2 | 3,9 \[3,4; 4,5\] | 2,5 \[2,1; 2,9\] | 6,3 \[5,7; 7,0\] |
| Cursos regulares (ensino fundamental/médio) | 3 | 7,1 \[6,3; 7,9\] | 4,7 \[4,1; 5,2\] | 8,9 \[8,2; 9,6\] |
| Cursos regulares (ensino fundamental/médio) | 4 | 10,9 \[9,9; 11,9\] | 7,4 \[6,7; 8,0\] | 12,8 \[11,9; 13,7\] |
| Cursos regulares (ensino fundamental/médio) | 5 | 22,1 \[20,6; 23,6\] | 14,3 \[13,2; 15,5\] | 18,7 \[17,4; 19,9\] |
| Plano e seguro de saúde | 1 | 2,0 \[1,5; 2,5\] | 2,1 \[1,6; 2,5\] | 3,4 \[2,9; 4,0\] |
| Plano e seguro de saúde | 2 | 5,7 \[4,9; 6,6\] | 7,4 \[6,5; 8,2\] | 10,4 \[9,4; 11,3\] |
| Plano e seguro de saúde | 3 | 14,1 \[12,7; 15,5\] | 15,4 \[14,1; 16,6\] | 17,5 \[16,4; 18,6\] |
| Plano e seguro de saúde | 4 | 26,9 \[25,2; 28,5\] | 28,8 \[27,3; 30,3\] | 30,5 \[29,2; 31,9\] |
| Plano e seguro de saúde | 5 | 56,0 \[54,0; 58,0\] | 55,7 \[54,1; 57,4\] | 56,0 \[54,4; 57,5\] |

Proporção de UCs com gasto, Brasil, IC 95% (%)

## Reproduzir

``` r
dados <- pof_carregar(c(2002, 2008, 2017), dir, itens = list(plano = "22301", superior = "23102"))
plot(pof_analisar(dados, "plano", por = "quintil"))
pof_diferenca(dados, "superior", por = "cor")
```
