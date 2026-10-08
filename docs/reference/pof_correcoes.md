# Correções aplicadas à harmonização v2

Ajustes pontuais no de-para v2, encontrados ao comparar os resultados
com os números oficiais do IBGE. Cada linha diz o código original do
produto, a folha de destino e o motivo. São aplicados por
[`pof_harmonizacao()`](pof_harmonizacao.md) com `correcoes = TRUE`
(padrão) e foram reportados ao autor da harmonização.

## Uso

``` r
pof_correcoes()
```

## Valor

`data.table` com `ano`, `codigo`, `cod_final` e `motivo`.

## Detalhes

- **2017, quadro 44 (telefonia celular).** Na v2 os itens vão para
  `26102 Comunicação (outros)`, em Despesas diversas. Contas e cartões
  de celular passam para `17202 Telefone celular (plano/serviço)`, em
  Habitação, como nas edições anteriores e no IBGE; aparelho e
  acessórios passam para
  `24201 Telefone celular e acessórios (aquisição)`.

## Exemplos

``` r
pof_correcoes()
#>      ano codigo cod_final                            motivo
#>    <int>  <int>    <char>                            <char>
#> 1:  2017  44001     17202       Cartão de telefonia celular
#> 2:  2017  44002     17202 Conta de celular (voz e internet)
#> 3:  2017  44003     17202       Conta de celular (internet)
#> 4:  2017  44007     17202                     Pacote de voz
#> 5:  2017  44004     24201      Aparelho de telefone celular
#> 6:  2017  44006     24201    Acessórios de telefone celular
```
