# Validação com os números oficiais do IBGE

**Pergunta.** Os números que o pacote produz batem com os publicados
pelo IBGE?

**Método.**
[`pof_validar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_validar.md)
reproduz, com os microdados harmonizados, a **despesa média mensal
familiar** de cada tipo de despesa das tabelas oficiais da POF 2008-2009
e 2017-2018, lidas das planilhas do FTP do IBGE
([`pof_ibge()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ibge.md)).
São 1295 valores oficiais em 21 recortes: Brasil, urbano e rural, as
cinco Grandes Regiões e, em 2008-2009, sexo e cor ou raça da pessoa de
referência. 1090 têm correspondência direta com a harmonização
([`pof_mapa_ibge()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_mapa_ibge.md)).
Para cada um, o pacote calcula a estimativa e o IC de 95% do desenho
amostral.

## O que bate exatamente

- **Número de famílias**: 69.017.704 em 2017-2018 (IBGE: 69.017.704) e
  57.816.604 em 2008-2009 (IBGE: 57.816.604). Isso confirma que unidades
  de consumo e pesos amostrais estão sendo lidos como o IBGE os usa.
- **Tamanho médio da família**, nas duas edições.
- **Despesa de consumo**: 3.764,07 reais em 2017-2018, contra 3.764,51
  do IBGE (-0,0%).
- Itens com mapeamento direto, como energia elétrica, gás, água,
  aluguel, plano de saúde, fumo e jogos e apostas, reproduzem o valor
  oficial ao centavo ou quase.

## Grandes grupos de consumo

![Gráfico de pontos com a diferença percentual entre a estimativa do
pacote e o valor oficial do IBGE para os onze grupos de consumo, em
2008-2009 e
2017-2018.](validacao-ibge_files/figure-html/unnamed-chunk-2-1.png)

| Edicao | Grupo | IBGE (reais) | Pacote (reais) | IC 95% | Diferença (%) |
|:---|:---|---:|---:|---:|---:|
| 2008-2009 | Habitação | 765,89 | 766,20 | 744,08 a 788,32 | 0,0 |
| 2008-2009 | Alimentação | 421,72 | 410,34 | 401,92 a 418,76 | -2,7 |
| 2008-2009 | Transporte | 419,19 | 436,36 | 418,97 a 453,75 | 4,1 |
| 2008-2009 | Assistência à saúde | 153,81 | 151,74 | 144,84 a 158,63 | -1,3 |
| 2008-2009 | Vestuário | 118,22 | 118,18 | 114,72 a 121,65 | -0,0 |
| 2008-2009 | Educação | 64,81 | 63,04 | 58,32 a 67,76 | -2,7 |
| 2008-2009 | Despesas diversas | 61,87 | 56,05 | 52,86 a 59,25 | -9,4 |
| 2008-2009 | Higiene e cuidados pessoais | 51,02 | 53,09 | 51,58 a 54,61 | 4,1 |
| 2008-2009 | Recreação e cultura | 42,76 | 43,27 | 41,16 a 45,39 | 1,2 |
| 2008-2009 | Serviços pessoais | 23,85 | 23,85 | 22,93 a 24,78 | 0,0 |
| 2008-2009 | Fumo | 11,62 | 11,62 | 11,00 a 12,24 | 0,0 |
| 2017-2018 | Habitação | 1.377,14 | 1.368,11 | 1.325,64 a 1.410,58 | -0,7 |
| 2017-2018 | Transporte | 679,76 | 724,88 | 695,45 a 754,31 | 6,6 |
| 2017-2018 | Alimentação | 658,23 | 627,26 | 614,72 a 639,79 | -4,7 |
| 2017-2018 | Assistência à saúde | 302,06 | 302,13 | 290,03 a 314,24 | 0,0 |
| 2017-2018 | Educação | 175,60 | 178,45 | 166,67 a 190,22 | 1,6 |
| 2017-2018 | Vestuário | 160,25 | 160,83 | 156,58 a 165,07 | 0,4 |
| 2017-2018 | Higiene e cuidados pessoais | 136,82 | 135,69 | 133,28 a 138,10 | -0,8 |
| 2017-2018 | Despesas diversas | 112,53 | 110,36 | 103,36 a 117,36 | -1,9 |
| 2017-2018 | Recreação e cultura | 96,16 | 89,46 | 86,12 a 92,80 | -7,0 |
| 2017-2018 | Serviços pessoais | 48,55 | 49,52 | 47,76 a 51,27 | 2,0 |
| 2017-2018 | Fumo | 17,40 | 17,40 | 16,41 a 18,38 | -0,0 |

Despesa média mensal familiar por grupo de consumo, Brasil

Em 2017-2018 o maior desvio entre os grupos é o de recreação e cultura
(-7,0%); habitação, vestuário, higiene e cuidados pessoais, assistência
à saúde, educação, fumo, serviços pessoais e despesas diversas ficam a
menos de 2%. Em 2008-2009 o maior desvio é o de despesas diversas
(-9,4%). Sem as correções provisórias da harmonização, recreação e
cultura e despesas diversas ficavam 62% e 60% acima do oficial em
2008-2009, por causa das contas de celular classificadas em recreação e
da compra de imóveis classificada como consumo, e a despesa de consumo
de 2017-2018 ficava 1,59% abaixo, por causa do condomínio fora do
consumo. Ver [Erros conhecidos na
harmonização](https://talesalonso1996-ops.github.io/pofanalise/articles/erros-harmonizacao.md).

## Por recorte

| Edicao | Recorte | Grupos | Mediana \|dif\| (%) | Até 5% (%) | Oficial dentro do IC (%) |
|:---|:---|---:|---:|---:|---:|
| 2008-2009 | Brasil | 11 | 1,3 | 91 | 73 |
| 2008-2009 | Urbana | 11 | 1,4 | 91 | 73 |
| 2008-2009 | Rural | 11 | 0,8 | 100 | 100 |
| 2008-2009 | Homem | 11 | 1,2 | 91 | 73 |
| 2008-2009 | Mulher | 11 | 1,9 | 91 | 100 |
| 2008-2009 | Branca | 11 | 1,3 | 91 | 73 |
| 2008-2009 | Preta | 11 | 1,5 | 100 | 100 |
| 2008-2009 | Parda | 11 | 1,4 | 91 | 100 |
| 2008-2009 | Norte | 11 | 2,0 | 100 | 100 |
| 2008-2009 | Nordeste | 11 | 1,0 | 91 | 100 |
| 2008-2009 | Sudeste | 11 | 1,5 | 82 | 82 |
| 2008-2009 | Sul | 11 | 1,0 | 91 | 100 |
| 2008-2009 | Centro-Oeste | 11 | 3,0 | 82 | 100 |
| 2017-2018 | Brasil | 11 | 1,6 | 82 | 73 |
| 2017-2018 | Urbana | 11 | 1,3 | 82 | 73 |
| 2017-2018 | Rural | 11 | 2,4 | 82 | 100 |
| 2017-2018 | Norte | 11 | 2,4 | 100 | 100 |
| 2017-2018 | Nordeste | 11 | 0,8 | 91 | 82 |
| 2017-2018 | Sudeste | 11 | 1,4 | 73 | 82 |
| 2017-2018 | Sul | 11 | 1,4 | 82 | 73 |
| 2017-2018 | Centro-Oeste | 11 | 1,2 | 73 | 91 |

Grupos de consumo: concordância com o IBGE por recorte

## Itens: onde a harmonização diverge da classificação do IBGE

A comparação item a item é o teste mais exigente: um produto pode estar
no grupo certo e na folha errada. Os itens com maior diferença absoluta
(valor oficial de pelo menos R\$ 5):

| Edicao | Grupo | Item | IBGE (reais) | Pacote (reais) | Diferença (reais) |
|:---|:---|:---|:---|---:|---:|
| 2017-2018 | Habitação | Outros | 36,03 | 94,20 | 58,17 |
| 2017-2018 | Habitação | Serviços e taxas | 344,43 | 396,17 | 51,74 |
| 2017-2018 | Transporte | Viagens esporádicas | 69,24 | 109,51 | 40,27 |
| 2017-2018 | Despesas diversas | Serviços profissionais | 34,79 | 0,00 | -34,79 |
| 2017-2018 | Despesas diversas | Outras | 24,11 | 58,52 | 34,41 |
| 2017-2018 | Habitação | Telefone fixo | 7,72 | 33,79 | 26,07 |
| 2008-2009 | Habitação | Outros | 11,52 | 34,39 | 22,87 |
| 2008-2009 | Habitação | Serviços e taxas | 183,90 | 206,06 | 22,16 |
| 2017-2018 | Educação | Outras | 13,03 | 34,01 | 20,98 |
| 2017-2018 | Educação | Outros cursos e atividades | 39,07 | 19,39 | -19,68 |
| 2017-2018 | Habitação | Telefone Celular | 49,42 | 67,34 | 17,92 |
| 2008-2009 | Transporte | Viagens esporádicas | 32,43 | 50,16 | 17,73 |
| 2017-2018 | Assistência à saúde | Consulta médica | 15,76 | 32,13 | 16,37 |
| 2017-2018 | Recreação e cultura | Recreações e esportes | 21,55 | 7,26 | -14,29 |
| 2008-2009 | Habitação | Telefone celular | 26,19 | 40,22 | 14,03 |
| 2017-2018 | Assistência à saúde | Consulta e tratamento dentário | 14,59 | 1,77 | -12,82 |

Itens com maior divergência, Brasil

O padrão é de **itens trocados dentro do mesmo grupo**. Em 2017-2018,
dentista aparece como consulta médica, material de tratamento como
“outras” da saúde, serviços profissionais como “outras” despesas
diversas, e cirurgia e livros didáticos ficam vazios (a própria nota de
qualidade da v2 marca essas duas folhas como ausentes em 2017). Os
totais de saúde e educação, porém, batem. Para análises por grupo, a
harmonização é confiável; para análises de itens desses grupos em
2017-2018, confira a folha em
[`pof_ibge()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ibge.md)
antes de interpretar.

Algumas linhas têm explicação conhecida e não são erro de harmonização:

- **Condomínio.** O IBGE mostra o condomínio numa linha própria; a v2
  não tem uma folha só para ele, e o pacote o soma em “17301 Outros
  serviços e taxas de habitação”. Por isso “Outros” da habitação fica
  acima do oficial. Somadas as duas linhas do IBGE, a comparação fecha:
  R\$ 94,20 no pacote contra R\$ 89,64 do IBGE em 2017-2018.

- **Aumento do ativo em 2008-2009** fica 60% acima do oficial: o pacote
  soma nesse grupo o valor total dos imóveis adquiridos registrado no
  questionário, que o IBGE não soma por inteiro na tabela de 2008-2009.
  Não afeta a despesa de consumo.

- **Telefonia em 2017-2018.** O IBGE separa “pacote de telefone, TV e
  internet”; a harmonização o distribui entre telefone fixo e celular.
  Somados os três, o pacote estima R\$ 101,13, contra R\$ 107,55 do
  IBGE.

- **Outras despesas correntes** (impostos, contribuições trabalhistas)
  ficam a 0,1% do oficial em 2017-2018 e a 0,4% em 2008-2009. Na v2, as
  deduções de rendimento (imposto de renda, previdência) ficavam em
  Rendimentos; o pacote as leva para este grupo. Não entram na despesa
  de consumo.

## Reproduzir

``` r
h <- pof_harmonizacao()
b <- pof_somar_grupos(pof_ler_edicao(2017, dir, h, manter_sem_consumo = TRUE))
v <- pof_validar(b)
v[Recorte == "Nordeste" & is.na(Item_ibge)]
pof_ibge("2017-2018", "Brasil")      # a tabela oficial
```
