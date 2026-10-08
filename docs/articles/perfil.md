# Perfil da unidade de consumo

**Pergunta.** Como o nível e a composição do consumo variam com o sexo,
a idade e a cor da pessoa de referência e com o tamanho da UC?

**Método.** Consumo per capita (sem aluguel) de cada grupo como índice
da média da edição (média = 100), o que dispensa deflacionamento.
Conjunto das RMs. A cor não existe em 1987 e não tem as categorias
usadas em 1995; a análise por cor começa em 2002.

## As UCs mudaram

A proporção de UCs com mulher como pessoa de referência passa de 21,0%
para 44,2%. As UCs com cinco ou mais moradores caem de 35,3% para 11,3%,
e as com pessoa de referência de 60 anos ou mais sobem de 15,9% para
28,2%. Parte da mudança na estrutura do orçamento vem dessa
recomposição.

## Nível de consumo relativo

Em 2017-2018 o consumo per capita das UCs com pessoa de referência
branca é 135,7% da média; o das UCs com pessoa de referência preta ou
parda, 69,7%. Em 2002-2003 eram 131,7 e 63,6. UCs de uma pessoa consomem
183,8% da média per capita, e as de cinco ou mais, 55,3%; parte disso
são economias de escala que a medida per capita não ajusta.

![Gráfico: Consumo per capita relativo à média da edição (= 100),
RMs](perfil_files/figure-html/unnamed-chunk-2-1.png)

## Composição

A alimentação pesa 20,8% do consumo das UCs com pessoa de referência
preta ou parda e 17,0% das com pessoa de referência branca. Nas UCs com
pessoa de referência de 60 anos ou mais, a saúde chega a 16,2%.

| Dimensao | Categoria | Alimentação | Assistência à saúde | Educação | Habitação | Transporte |
|:---|:---|:---|:---|:---|:---|:---|
| Cor da pessoa de referência | Branca | 17,0 | 10,8 | 7,9 | 23,5 | 24,5 |
| Cor da pessoa de referência | Preta ou parda | 20,8 | 9,3 | 6,0 | 21,6 | 22,5 |
| Idade da pessoa de referência | 30 a 44 | 18,4 | 6,8 | 8,7 | 20,9 | 26,1 |
| Idade da pessoa de referência | 45 a 59 | 18,5 | 9,5 | 9,0 | 22,1 | 24,0 |
| Idade da pessoa de referência | 60 ou mais | 17,7 | 16,2 | 3,5 | 26,3 | 20,6 |
| Idade da pessoa de referência | Até 29 | 22,1 | 5,0 | 5,7 | 21,6 | 22,7 |
| Moradores na UC | 1 morador | 19,7 | 11,2 | 3,2 | 27,6 | 21,9 |
| Moradores na UC | 2 moradores | 18,3 | 12,5 | 3,9 | 25,6 | 22,3 |
| Moradores na UC | 3 a 4 moradores | 17,9 | 9,3 | 9,0 | 21,6 | 24,9 |
| Moradores na UC | 5 ou mais moradores | 20,1 | 8,9 | 9,3 | 19,1 | 22,4 |
| Sexo da pessoa de referência | Homem | 18,2 | 9,9 | 7,7 | 21,7 | 25,3 |
| Sexo da pessoa de referência | Mulher | 18,9 | 10,7 | 6,3 | 24,8 | 21,0 |

Participação no consumo sem aluguel segundo o perfil, RMs, 2017-2018 (%)

## Reproduzir

``` r
dados <- pof_carregar(dir = dir)
pof_analisar(dados, "Alimentação", medida = "participacao", por = "cor")
pof_modelo(dados[3:5], "Educação", ~ quintil + cor + sexo + idade)
```
