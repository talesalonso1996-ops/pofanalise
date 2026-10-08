# Erros conhecidos na harmonização

**Situação: em aberto na origem.** A harmonização v2 de produtos
(repositório `arthurwelle/Harmoniza_Produtos`, commit `e4f2cc0`) tem os
erros de classificação listados nesta página. Até que sejam corrigidos
no de-para original, **o pacote e todas as análises do site usam
correções provisórias**, aplicadas por
[`pof_correcoes()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_correcoes.md).
Quem usar o de-para da v2 diretamente, sem o pacote, terá os erros
abaixo. Esta página será atualizada quando a harmonização for corrigida.

## Como os erros foram encontrados

A despesa de consumo calculada com a v2 ficava a -1,59% do IBGE em
2017-2018 e a +1,02% em 2008-2009; com as correções, fica a -0,01% e
-0,05%. Para saber a origem da diferença:

1.  **Os dados estão certos.** O arquivo de despesas do pipeline
    HarmonizaPOF2026 foi recalculado a partir dos microdados brutos do
    IBGE, com a fórmula oficial (valor deflacionado × fator de
    anualização ÷ 12). Bate quadro a quadro, com diferença zero.
2.  **O cálculo do IBGE foi reproduzido.** Aplicado aos mesmos
    microdados, o tradutor oficial do IBGE (`Tradutor_Despesa_Geral`,
    que classifica cada código de produto nas tabelas de despesa)
    reproduz ao centavo a despesa de consumo da Tabela 1.1.1 de
    2017-2018 (R\$ 3.764,51) e todos os grupos.
3.  **A diferença está no de-para.** O tradutor do IBGE foi comparado
    código a código com o de-para da v2, e a classificação de cada
    produto foi conferida nas outras edições. Os erros abaixo são os
    casos em que a v2 diverge do IBGE **e** da sua própria classificação
    em outras edições, ou põe dentro do consumo o que é investimento (ou
    o contrário).

O script da comparação está em `data-raw/conferir_tradutor_ibge.R`.

## Os erros

| Erro na v2 | Edições | Onde a v2 põe | Onde o pacote põe |
|----|----|----|----|
| **Condomínio fora do consumo** | 2008, 2017 | 27203 Outras despesas correntes | 17301 Outros serviços e taxas de habitação, como em 1995 e 2002 |
| **Compra de imóvel como consumo** | 1987 a 2008 | 26105 Imóveis de uso ocasional | 28101 Aquisição de imóvel |
| **Celular em grupo errado** | 2008, 2017 | 24301 Outras recreações (2008); 26102 Comunicação (2017) | 17202 Telefone celular; aparelhos em 24201 |
| **Itens de veículos e de outros imóveis** | 2017 | Seguro obrigatório fora do consumo; multas, taxas, IPVA, IPTU e ITR dentro | Seguro em Transporte; impostos e taxas em 27101 |
| **Papel higiênico em alimentação** | 2017 | 16103 Outros produtos | 21104, como em 1987 a 2008 |
| **INSS de empregado doméstico como consumo** | todas | Serviço doméstico (Habitação) | 27102 Contribuições trabalhistas |
| **Deduções de rendimento como rendimento** | 1995 a 2017 | Rendimentos (Nível 30) | 27101 e 27102 (outras despesas correntes) |

Os dois últimos não são de um código de produto: o pipeline grava o INSS
e as deduções com o código do serviço ou do rendimento a que se referem,
e o pacote os reclassifica pelo tipo de registro (coluna `Tipo`).

## Efeito nos resultados

### Comparação com o IBGE

| Edicao | Grupo | IBGE (R\$) | v2 sem correções | Com as correções |
|:---|:---|---:|---:|---:|
| 2008-2009 | Despesas de consumo | 2.134,77 | +1,02% | -0,05% |
| 2008-2009 | Alimentação | 421,72 | -2,70% | -2,70% |
| 2008-2009 | Habitação | 765,89 | -5,99% | +0,04% |
| 2008-2009 | Vestuário | 118,22 | -0,03% | -0,03% |
| 2008-2009 | Transporte | 419,19 | +4,10% | +4,10% |
| 2008-2009 | Higiene e cuidados pessoais | 51,02 | +4,06% | +4,06% |
| 2008-2009 | Assistência à saúde | 153,81 | -1,35% | -1,35% |
| 2008-2009 | Educação | 64,81 | -2,73% | -2,73% |
| 2008-2009 | Recreação e cultura | 42,76 | +62,44% | +1,20% |
| 2008-2009 | Fumo | 11,62 | 0,00% | 0,00% |
| 2008-2009 | Serviços pessoais | 23,85 | 0,00% | 0,00% |
| 2008-2009 | Despesas diversas | 61,87 | +59,68% | -9,40% |
| 2008-2009 | Outras despesas correntes | 285,00 | -55,38% | +0,35% |
| 2008-2009 | Aumento do ativo | 152,09 | +31,91% | +60,01% |
| 2017-2018 | Despesas de consumo | 3.764,51 | -1,59% | -0,01% |
| 2017-2018 | Alimentação | 658,23 | -3,82% | -4,71% |
| 2017-2018 | Habitação | 1.377,14 | -7,95% | -0,66% |
| 2017-2018 | Vestuário | 160,25 | +0,36% | +0,36% |
| 2017-2018 | Transporte | 679,76 | +5,75% | +6,64% |
| 2017-2018 | Higiene e cuidados pessoais | 136,82 | -5,07% | -0,83% |
| 2017-2018 | Assistência à saúde | 302,06 | +0,02% | +0,02% |
| 2017-2018 | Educação | 175,60 | +1,62% | +1,62% |
| 2017-2018 | Recreação e cultura | 96,16 | -48,10% | -6,97% |
| 2017-2018 | Fumo | 17,40 | -0,02% | -0,02% |
| 2017-2018 | Serviços pessoais | 48,55 | +1,99% | +1,99% |
| 2017-2018 | Despesas diversas | 112,53 | +75,02% | -1,93% |
| 2017-2018 | Outras despesas correntes | 545,37 | -49,89% | +0,14% |
| 2017-2018 | Aumento do ativo | 188,76 | +4,26% | -0,05% |

Diferença entre a estimativa e o valor oficial do IBGE, despesa média
mensal familiar, Brasil

A coluna “v2 sem correções” usa o de-para da v2 sem nenhuma correção,
inclusive a do celular de 2017 (quadro 44), que o pacote já fazia nas
versões anteriores. Dois grupos ficam fora do consumo e se comportam de
outro jeito: **outras despesas correntes** passa a bater com o IBGE
porque recebe as deduções de rendimento; **aumento do ativo** de
2008-2009 se afasta do oficial porque recebe a compra de outros imóveis,
e o IBGE não soma o valor total dos imóveis adquiridos na tabela de
2008-2009. Nenhum dos dois afeta a despesa de consumo.

### Participação dos grupos no consumo

Diferença, em pontos percentuais, entre a participação calculada com as
correções e com a v2 original. Conjunto das regiões metropolitanas,
consumo sem aluguel (o recorte das séries de 1987 a 2018).

| Grupo                       | 1987-1988 | 1995-1996 | 2002-2003 | 2008-2009 | 2017-2018 |
|:----------------------------|----------:|----------:|----------:|----------:|----------:|
| Alimentação                 |     +0,23 |     +0,31 |     +0,82 |     +0,38 |     -0,79 |
| Assistência à saúde         |     +0,07 |     +0,13 |     +0,29 |     +0,16 |     -0,34 |
| Despesas diversas           |     -0,89 |     -1,42 |     -3,55 |     -3,85 |     -3,20 |
| Educação                    |     +0,01 |     +0,07 |     +0,23 |     +0,08 |     -0,24 |
| Habitação                   |     +0,15 |     +0,31 |     +0,80 |     +4,06 |     +4,14 |
| Higiene e cuidados pessoais |     +0,02 |     +0,03 |     +0,09 |     +0,05 |     +0,05 |
| Recreação e cultura         |     +0,03 |     +0,05 |     +0,13 |     -1,49 |     +1,19 |
| Serviços pessoais           |     +0,03 |     +0,04 |     +0,08 |     +0,04 |     -0,07 |
| Transporte                  |     +0,24 |     +0,38 |     +0,87 |     +0,45 |     -0,58 |
| Vestuário                   |     +0,12 |     +0,09 |     +0,23 |     +0,11 |     -0,16 |

Efeito das correções na participação dos grupos, RMs, consumo sem
aluguel (p.p.)

Os efeitos maiores aparecem em habitação (o condomínio entra em 2008 e
2017) e em despesas diversas (a compra de imóveis sai de 1987 a 2008).
Sem as correções, a habitação parecia cair e as despesas diversas
pareciam cair muito mais entre 2002 e 2017 do que de fato caem.

## Diferenças que não são erros

Depois das correções, alguns grupos ainda diferem do IBGE porque a
harmonização agrupa de outro jeito, de forma consistente entre as
edições:

- **Viagens.** A v2 reúne em “20302 Viagens esporádicas” (Transporte) a
  alimentação, a hospedagem e os ingressos comprados em viagem; o IBGE
  os distribui entre Alimentação e Recreação. Por isso Transporte fica
  acima e Alimentação abaixo do oficial.
- **Alimentação escolar** fica em Educação; o IBGE a põe em Alimentação.
- **Pacote de telefone, TV e internet:** o IBGE o separa; a v2 o
  distribui entre telefone fixo e celular.
- Itens como streaming, console de videogame, ferramentas e fogão a gás
  estão em Recreação na v2 e em Habitação no IBGE.

## Lista completa das correções por código

| Ano | Código | Item | Erro | Folha na v2 | Folha usada |
|---:|---:|:---|:---|:---|:---|
| 1987 | 4797 | Valor escritural do imóvel adquirido (outros imóveis) | Compra de imóvel como consumo | 26105 | 28101 |
| 1995 | 4794 | Valor do imóvel adquirido em primeira locação (outros imóveis) | Compra de imóvel como consumo | 26105 | 28101 |
| 1995 | 4795 | Valor do imóvel adquirido usado (outros imóveis) | Compra de imóvel como consumo | 26105 | 28101 |
| 2002 | 47094 | Valor do imóvel adquirido em primeira locação (outros imóveis) | Compra de imóvel como consumo | 26105 | 28101 |
| 2002 | 47095 | Valor do imóvel adquirido usado (outros imóveis) | Compra de imóvel como consumo | 26105 | 28101 |
| 2002 | 48094 | Valor do imóvel adquirido em primeira locação (outros imóveis), quadro 48 | Compra de imóvel como consumo | 27203 | 28101 |
| 2002 | 48095 | Valor do imóvel adquirido usado (outros imóveis), quadro 48 | Compra de imóvel como consumo | 27203 | 28101 |
| 2008 | 47094 | Valor de outro imóvel adquirido em primeira locação | Compra de imóvel como consumo | 26105 | 28101 |
| 2008 | 47095 | Valor de outro imóvel adquirido usado | Compra de imóvel como consumo | 26105 | 28101 |
| 2008 | 10004 | Condomínio | Condomínio fora do consumo | 27203 | 17301 |
| 2008 | 28023 | Cartão de telefone celular | Celular em grupo errado | 24301 | 17202 |
| 2008 | 28024 | Conta de telefone celular | Celular em grupo errado | 24301 | 17202 |
| 2017 | 10005 | Condomínio | Condomínio fora do consumo | 27203 | 17301 |
| 2017 | 10004 | Aluguel de garagem | Condomínio fora do consumo | 27203 | 17301 |
| 2017 | 10999 | Agregado do quadro 10 (aluguel, condomínio e taxas) | Condomínio fora do consumo | 27203 | 17301 |
| 2017 | 44001 | Cartão de telefonia celular | Celular em grupo errado | 26102 | 17202 |
| 2017 | 44002 | Conta de celular (voz e internet) | Celular em grupo errado | 26102 | 17202 |
| 2017 | 44003 | Conta de celular (internet) | Celular em grupo errado | 26102 | 17202 |
| 2017 | 44007 | Pacote de voz | Celular em grupo errado | 26102 | 17202 |
| 2017 | 44004 | Aparelho de telefone celular | Celular em grupo errado | 26102 | 24201 |
| 2017 | 44006 | Acessórios de telefone celular | Celular em grupo errado | 26102 | 24201 |
| 2017 | 50002 | Seguro obrigatório de veículo | Veículos e outros imóveis | 27101 | 20303 |
| 2017 | 50999 | Agregado do quadro 50 (documentação e seguro de veículos) | Veículos e outros imóveis | 27101 | 20303 |
| 2017 | 50005 | Emplacamento de caminhão | Veículos e outros imóveis | 20303 | 27101 |
| 2017 | 50006 | Emplacamento de moto | Veículos e outros imóveis | 20303 | 27101 |
| 2017 | 50007 | Multas | Veículos e outros imóveis | 20303 | 27101 |
| 2017 | 50008 | Taxas do Detran | Veículos e outros imóveis | 20303 | 27101 |
| 2017 | 50017 | IPVA, seguro obrigatório e taxas | Veículos e outros imóveis | 20303 | 27101 |
| 2017 | 47003 | Aluguel de outros imóveis | Veículos e outros imóveis | 28101 | 26105 |
| 2017 | 47006 | IPTU de outros imóveis | Veículos e outros imóveis | 26105 | 27101 |
| 2017 | 47007 | ITR de outros imóveis | Veículos e outros imóveis | 26105 | 27101 |
| 2017 | 47027 | Consórcio de outros imóveis (prestação) | Compra de imóvel como consumo | 26105 | 28101 |
| 2017 | 89001 | Papel higiênico | Papel higiênico em alimentação | 16103 | 21104 |

Códigos reclassificados por pof_correcoes()

## Para quem usa o pacote

- As correções estão ligadas por padrão. Para reproduzir a v2 sem elas:
  `pof_harmonizacao(correcoes = FALSE)`.
- Ao citar resultados, informe que foi usada a harmonização v2 com as
  correções provisórias do pacote `pofanalise`.
- Encontrou outro problema? Use o botão “Apontar problema” do
  [explorador da
  harmonização](https://arthurwelle.github.io/Harmoniza_Produtos/) ou
  abra uma issue no [repositório do
  pacote](https://github.com/talesalonso1996-ops/pofanalise/issues).
