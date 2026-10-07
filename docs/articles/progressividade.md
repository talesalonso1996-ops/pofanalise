# Progressividade dos gastos

**Pergunta.** Quais gastos pesam mais no orçamento de quem consome
menos, e quais se concentram no topo? A resposta interessa a qualquer
política que mexa em preços: tarifa de ônibus, gás de cozinha, energia,
impostos sobre consumo.

**Método.**
[`pof_concentracao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_concentracao.md).
As pessoas são ordenadas pelo consumo per capita e mede-se como o gasto
com cada item se distribui ao longo dessa fila. O índice **K** compara a
concentração do item com a do consumo total: negativo, o item pesa mais
no orçamento de quem consome menos (gasto **regressivo**); positivo,
pesa mais para quem consome mais (**progressivo**). Brasil, despesa de
consumo completa, 2017-2018.

## Resultados

Os gastos mais regressivos são os serviços básicos da casa. Gás
doméstico tem K = -0,37: os 40% com menor consumo fazem 32,6% de todo o
gasto com gás do país. Seguem água e esgoto (K = -0,24), energia
elétrica (-0,21), transporte coletivo (-0,20) e fumo (-0,19).

No outro extremo estão plano de saúde (K = 0,26, com 78,3% do gasto
feito pelos 20% com maior consumo), aquisição de veículos (0,26),
viagens (0,24) e educação privada. Remédios são regressivos (K = -0,10),
ao contrário do restante da saúde: a assistência à saúde como um todo
tem K = 0,06.

![Gráfico: Índice de progressividade dos gastos, Brasil,
2017-2018](progressividade_files/figure-html/unnamed-chunk-2-1.png)

| Gasto | Tipo | C | K | Classificacao | Base 40% (%) | Topo 20% (%) |
|:---|:---|---:|---:|:---|---:|---:|
| Gás doméstico | Item | 0,111 | -0,372 | Regressivo | 32,6 | 25,6 |
| Água e esgoto | Item | 0,245 | -0,237 | Regressivo | 22,8 | 32,2 |
| Energia elétrica | Item | 0,272 | -0,210 | Regressivo | 22,3 | 35,4 |
| Higiene e cuidados pessoais | Grupo | 0,287 | -0,196 | Regressivo | 21,2 | 36,1 |
| Transporte coletivo | Item | 0,287 | -0,195 | Regressivo | 19,9 | 33,3 |
| Fumo | Item | 0,287 | -0,195 | Regressivo | 19,8 | 34,9 |
| Eletrodomésticos | Item | 0,372 | -0,110 | Regressivo | 17,4 | 43,6 |
| Remédios | Item | 0,383 | -0,099 | Regressivo | 16,1 | 43,7 |
| Cabeleireiro | Item | 0,384 | -0,098 | Regressivo | 17,0 | 44,5 |
| Alimentação | Grupo | 0,403 | -0,079 | Regressivo | 15,2 | 45,4 |
| Vestuário | Grupo | 0,414 | -0,068 | Regressivo | 15,3 | 46,9 |
| Aluguel | Item | 0,423 | -0,059 | Regressivo | 15,7 | 48,5 |
| Habitação | Grupo | 0,425 | -0,057 | Regressivo | 15,7 | 48,9 |
| Serviços pessoais | Grupo | 0,433 | -0,049 | Regressivo | 14,3 | 48,4 |
| Telefone celular (serviço) | Item | 0,435 | -0,047 | Regressivo | 13,5 | 47,7 |
| Jogos e apostas | Item | 0,438 | -0,044 | Regressivo | 12,7 | 46,2 |
| Roupa de mulher | Item | 0,457 | -0,026 | Regressivo | 13,3 | 50,5 |
| Recreação e cultura | Grupo | 0,501 | 0,019 | Progressivo | 11,1 | 54,1 |
| Refeição | Item | 0,523 | 0,041 | Progressivo | 10,0 | 56,2 |
| Gasolina | Item | 0,527 | 0,045 | Progressivo | 8,7 | 55,9 |
| Assistência à saúde | Grupo | 0,540 | 0,057 | Progressivo | 10,0 | 58,3 |
| Consulta médica | Item | 0,558 | 0,076 | Progressivo | 8,4 | 59,3 |
| Telefone fixo | Item | 0,599 | 0,117 | Progressivo | 6,5 | 63,1 |
| Educação | Grupo | 0,599 | 0,117 | Progressivo | 7,8 | 64,1 |
| Transporte | Grupo | 0,627 | 0,145 | Progressivo | 6,5 | 66,6 |
| Dentista | Item | 0,632 | 0,150 | Progressivo | 6,0 | 67,1 |
| Diversões e esportes | Item | 0,662 | 0,180 | Progressivo | 5,5 | 69,6 |
| Curso superior | Item | 0,666 | 0,183 | Progressivo | 2,8 | 67,9 |
| Cursos regulares | Item | 0,671 | 0,189 | Progressivo | 5,2 | 70,7 |
| Despesas diversas | Grupo | 0,680 | 0,197 | Progressivo | 5,0 | 71,8 |
| Viagens | Item | 0,726 | 0,244 | Progressivo | 4,4 | 77,2 |
| Aquisição de veículos | Item | 0,738 | 0,256 | Progressivo | 3,0 | 78,0 |
| Plano de saúde | Item | 0,746 | 0,263 | Progressivo | 2,2 | 78,3 |

Concentração dos gastos, Brasil, 2017-2018. Base 40%: parcela do gasto
feita pelos 40% com menor consumo per capita.

## Ao longo do tempo

Nas regiões metropolitanas, com consumo sem aluguel, a posição dos itens
é estável entre as edições: os mesmos gastos são regressivos em 1987 e
em 2017.

![Gráfico: Índice de progressividade, RMs (consumo sem
aluguel)](progressividade_files/figure-html/unnamed-chunk-4-1.png)

## Reproduzir

``` r
dados <- pof_carregar(c(2017), dir)
pof_concentracao(dados, c("f17103", "f17102", "f20101", "f22301"), recorte = "brasil", sem_aluguel = FALSE)
```
