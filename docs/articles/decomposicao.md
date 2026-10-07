# Comportamento ou composição?

**Pergunta.** Entre 1995 e 2017 as famílias metropolitanas ficaram
menores e mais velhas. Quanto das mudanças no orçamento vem dessa
recomposição, e quanto vem de mudança de comportamento dentro de cada
tipo de família?

**Método.**
[`pof_decompor()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_decompor.md),
decomposição *shift-share* simétrica da variação da participação de um
grupo no consumo:

- **efeito comportamento**: quanto a participação mudou dentro de cada
  tipo de UC;
- **efeito composição**: quanto mudou o peso de cada tipo de UC no
  consumo total.

A soma dos dois é a variação total. RMs, consumo sem aluguel, 1995-1996
a 2017-2018. Os tipos de UC são definidos pela idade da pessoa de
referência, pelo número de moradores ou pelo sexo da pessoa de
referência.

## Resultados

Em quase todos os casos o **comportamento domina**. A saúde ganha 2,75
p.p. no orçamento; o envelhecimento das UCs explica 0,73 p.p. disso,
cerca de 27%, e o restante vem de mudança de comportamento, concentrada
nas UCs mais velhas: com pessoa de referência de 60 anos ou mais, a
saúde passa de 11,2% para 16,8% do consumo; com até 29 anos, fica em
5,2%. O peso das UCs com pessoa de referência de 60 anos ou mais no
consumo passa de 18,9% para 27,0%.

A educação ganha 3,44 p.p.; a redução do tamanho das famílias joga
contra (-0,58 p.p.), porque UCs menores têm menos crianças, e o efeito
comportamento (4,03 p.p.) é maior que a variação observada.

![Gráfico: Decomposição da variação da participação, RMs, 1995-1996 a
2017-2018](decomposicao_files/figure-html/unnamed-chunk-2-1.png)

| Grupo | Corte | Periodo | Variação (p.p.) | Comportamento | Composição |
|:---|:---|:---|---:|---:|---:|
| Alimentação | idade | 1995 a 2017 | 0,42 | 0,56 | -0,14 |
| Alimentação | idade | 2002 a 2017 | -1,52 | -1,33 | -0,20 |
| Alimentação | tamanho | 1995 a 2017 | 0,42 | 0,90 | -0,48 |
| Alimentação | tamanho | 2002 a 2017 | -1,52 | -1,36 | -0,17 |
| Alimentação | sexo | 1995 a 2017 | 0,42 | 0,37 | 0,05 |
| Alimentação | sexo | 2002 a 2017 | -1,52 | -1,50 | -0,03 |
| Assistência à saúde | idade | 1995 a 2017 | 2,75 | 2,02 | 0,73 |
| Assistência à saúde | idade | 2002 a 2017 | 3,21 | 2,25 | 0,96 |
| Assistência à saúde | tamanho | 1995 a 2017 | 2,75 | 2,39 | 0,36 |
| Assistência à saúde | tamanho | 2002 a 2017 | 3,21 | 2,86 | 0,34 |
| Assistência à saúde | sexo | 1995 a 2017 | 2,75 | 2,52 | 0,23 |
| Assistência à saúde | sexo | 2002 a 2017 | 3,21 | 3,14 | 0,07 |
| Educação | idade | 1995 a 2017 | 3,44 | 3,64 | -0,19 |
| Educação | idade | 2002 a 2017 | 1,54 | 1,95 | -0,41 |
| Educação | tamanho | 1995 a 2017 | 3,44 | 4,03 | -0,58 |
| Educação | tamanho | 2002 a 2017 | 1,54 | 1,99 | -0,44 |
| Educação | sexo | 1995 a 2017 | 3,44 | 3,64 | -0,20 |
| Educação | sexo | 2002 a 2017 | 1,54 | 1,60 | -0,06 |
| Habitação | idade | 1995 a 2017 | -5,24 | -5,57 | 0,33 |
| Habitação | idade | 2002 a 2017 | -3,00 | -3,39 | 0,39 |
| Habitação | tamanho | 1995 a 2017 | -5,24 | -5,75 | 0,51 |
| Habitação | tamanho | 2002 a 2017 | -3,00 | -3,41 | 0,41 |
| Habitação | sexo | 1995 a 2017 | -5,24 | -5,72 | 0,48 |
| Habitação | sexo | 2002 a 2017 | -3,00 | -3,31 | 0,31 |
| Transporte | idade | 1995 a 2017 | 1,20 | 1,69 | -0,49 |
| Transporte | idade | 2002 a 2017 | 2,20 | 2,78 | -0,57 |
| Transporte | tamanho | 1995 a 2017 | 1,20 | 0,95 | 0,24 |
| Transporte | tamanho | 2002 a 2017 | 2,20 | 2,30 | -0,09 |
| Transporte | sexo | 1995 a 2017 | 1,20 | 2,24 | -1,04 |
| Transporte | sexo | 2002 a 2017 | 2,20 | 2,69 | -0,49 |

Decomposição da variação da participação no consumo sem aluguel, RMs

## Reproduzir

``` r
dados <- pof_carregar(c(1995, 2017), dir)
d <- pof_decompor(dados, "Assistência à saúde", por = "idade", de = "1995-1996", para = "2017-2018")
d$resumo; d$grupos
```
