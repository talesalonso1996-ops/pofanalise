# Correções provisórias da harmonização v2 (erros conhecidos)

**A harmonização v2 tem erros de classificação conhecidos.** Esta tabela
lista os códigos de produto que o pacote muda de folha até que sejam
corrigidos no repositório de origem (`arthurwelle/Harmoniza_Produtos`).
Foram encontrados comparando o de-para com o tradutor oficial do IBGE
(`Tradutor_Despesa_Geral`), que aplicado aos mesmos microdados reproduz
a Tabela 1.1.1 da POF 2017-2018 ao centavo, e com o mapeamento das
outras edições. São aplicados por
[`pof_harmonizacao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_harmonizacao.md)
com `correcoes = TRUE` (padrão) e foram reportados ao autor da
harmonização.

## Uso

``` r
pof_correcoes()
```

## Valor

`data.table` com `ano`, `codigo`, `cod_final` (folha de destino), `erro`
(o problema da v2) e `item` (descrição do produto).

## Detalhes

Erros corrigidos:

- **Condomínio fora do consumo (2008 e 2017).** O condomínio do
  domicílio principal vai para `27203 Outras despesas correntes`; em
  1995 e 2002 está em `17301 Outros serviços e taxas de habitação`.
  Quebra de série de 2% a 3% do consumo nas regiões metropolitanas.

- **Compra de imóvel como consumo (1987 a 2008).** O valor de "outros
  imóveis" adquiridos vai para `26105 Imóveis de uso ocasional`; passa
  para `28101 Aquisição de imóvel`. Até 3,9% do consumo nas RMs em 2008.

- **Celular em grupo errado (2008 e 2017).** Em 2008, cartão e conta de
  celular estão em `24301 Outras recreações`; em 2017 (quadro 44), em
  `26102 Comunicação (outros)`. Contas passam para `17202`, aparelhos e
  acessórios para `24201`.

- **Itens de veículos e de outros imóveis (2017).** Seguro obrigatório
  volta para Transporte, como em 2002 e 2008; multas, taxas do Detran,
  IPVA, IPTU e ITR saem do consumo (`27101 Impostos e taxas`), como no
  IBGE.

- **Papel higiênico em alimentação (2017).** Volta para `21104`, como em
  1987 a 2008.

Além destes códigos,
[`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md)
classifica por tipo de registro, em todas as edições: o INSS de
empregado doméstico (`Tipo == "INSS"`) vai para
`27102 Contribuições trabalhistas` (na v2 entra como serviço doméstico,
em Habitação), e as deduções de rendimento (`Tipo` começando por
"Deducao") vão para `27102` (previdência) ou `27101` (imposto de renda e
outras), em vez de Rendimentos.

## Exemplos

``` r
pof_correcoes()
#>       ano codigo cod_final                           erro
#>     <int>  <int>    <char>                         <char>
#>  1:  1987   4797     28101  Compra de imóvel como consumo
#>  2:  1995   4794     28101  Compra de imóvel como consumo
#>  3:  1995   4795     28101  Compra de imóvel como consumo
#>  4:  2002  47094     28101  Compra de imóvel como consumo
#>  5:  2002  47095     28101  Compra de imóvel como consumo
#>  6:  2002  48094     28101  Compra de imóvel como consumo
#>  7:  2002  48095     28101  Compra de imóvel como consumo
#>  8:  2008  47094     28101  Compra de imóvel como consumo
#>  9:  2008  47095     28101  Compra de imóvel como consumo
#> 10:  2008  10004     17301     Condomínio fora do consumo
#> 11:  2008  28023     17202        Celular em grupo errado
#> 12:  2008  28024     17202        Celular em grupo errado
#> 13:  2017  10005     17301     Condomínio fora do consumo
#> 14:  2017  10004     17301     Condomínio fora do consumo
#> 15:  2017  10999     17301     Condomínio fora do consumo
#> 16:  2017  44001     17202        Celular em grupo errado
#> 17:  2017  44002     17202        Celular em grupo errado
#> 18:  2017  44003     17202        Celular em grupo errado
#> 19:  2017  44007     17202        Celular em grupo errado
#> 20:  2017  44004     24201        Celular em grupo errado
#> 21:  2017  44006     24201        Celular em grupo errado
#> 22:  2017  50002     20303      Veículos e outros imóveis
#> 23:  2017  50999     20303      Veículos e outros imóveis
#> 24:  2017  50005     27101      Veículos e outros imóveis
#> 25:  2017  50006     27101      Veículos e outros imóveis
#> 26:  2017  50007     27101      Veículos e outros imóveis
#> 27:  2017  50008     27101      Veículos e outros imóveis
#> 28:  2017  50017     27101      Veículos e outros imóveis
#> 29:  2017  47003     26105      Veículos e outros imóveis
#> 30:  2017  47006     27101      Veículos e outros imóveis
#> 31:  2017  47007     27101      Veículos e outros imóveis
#> 32:  2017  47027     28101  Compra de imóvel como consumo
#> 33:  2017  89001     21104 Papel higiênico em alimentação
#>       ano codigo cod_final                           erro
#>                                                                          item
#>                                                                        <char>
#>  1:                     Valor escritural do imóvel adquirido (outros imóveis)
#>  2:            Valor do imóvel adquirido em primeira locação (outros imóveis)
#>  3:                          Valor do imóvel adquirido usado (outros imóveis)
#>  4:            Valor do imóvel adquirido em primeira locação (outros imóveis)
#>  5:                          Valor do imóvel adquirido usado (outros imóveis)
#>  6: Valor do imóvel adquirido em primeira locação (outros imóveis), quadro 48
#>  7:               Valor do imóvel adquirido usado (outros imóveis), quadro 48
#>  8:                       Valor de outro imóvel adquirido em primeira locação
#>  9:                                     Valor de outro imóvel adquirido usado
#> 10:                                                                Condomínio
#> 11:                                                Cartão de telefone celular
#> 12:                                                 Conta de telefone celular
#> 13:                                                                Condomínio
#> 14:                                                        Aluguel de garagem
#> 15:                       Agregado do quadro 10 (aluguel, condomínio e taxas)
#> 16:                                               Cartão de telefonia celular
#> 17:                                         Conta de celular (voz e internet)
#> 18:                                               Conta de celular (internet)
#> 19:                                                             Pacote de voz
#> 20:                                              Aparelho de telefone celular
#> 21:                                            Acessórios de telefone celular
#> 22:                                             Seguro obrigatório de veículo
#> 23:                 Agregado do quadro 50 (documentação e seguro de veículos)
#> 24:                                                  Emplacamento de caminhão
#> 25:                                                      Emplacamento de moto
#> 26:                                                                    Multas
#> 27:                                                           Taxas do Detran
#> 28:                                          IPVA, seguro obrigatório e taxas
#> 29:                                                 Aluguel de outros imóveis
#> 30:                                                    IPTU de outros imóveis
#> 31:                                                     ITR de outros imóveis
#> 32:                                   Consórcio de outros imóveis (prestação)
#> 33:                                                           Papel higiênico
#>                                                                          item
pof_correcoes()[, .N, by = erro]
#>                              erro     N
#>                            <char> <int>
#> 1:  Compra de imóvel como consumo    10
#> 2:     Condomínio fora do consumo     4
#> 3:        Celular em grupo errado     8
#> 4:      Veículos e outros imóveis    10
#> 5: Papel higiênico em alimentação     1
```
