# Tabelas oficiais de despesa da POF (IBGE)

Despesa monetária e não monetária média mensal familiar (R\$), por tipo
de despesa, publicada pelo IBGE para a POF 2008-2009 e 2017-2018.
Recortes: Brasil, situação do domicílio (Urbana, Rural), Grandes Regiões
e, em 2008-2009, sexo (Homem, Mulher) e cor ou raça (Branca, Preta,
Parda) da pessoa de referência. Inclui o número de famílias e o tamanho
médio da família. Lidas das planilhas do FTP do IBGE por
`data-raw/ibge_oficial.R`; a coluna `Fonte` indica a tabela.

## Uso

``` r
pof_ibge(edicao = NULL, recorte = NULL)
```

## Argumentos

- edicao:

  Filtro opcional, ex. `"2017-2018"`.

- recorte:

  Filtro opcional, ex. `"Brasil"` ou `"Nordeste"`.

## Valor

`data.table` com `Edicao`, `Recorte`, `Grupo_ibge`, `Item_ibge` (vazio
nas linhas de grupo), `Valor` e `Fonte`.

## Exemplos

``` r
pof_ibge("2017-2018", "Brasil")[1:6]
#>       Edicao Recorte          Grupo_ibge Item_ibge   Valor
#>       <char>  <char>              <char>    <char>   <num>
#> 1: 2017-2018  Brasil       Despesa total      <NA> 4649.03
#> 2: 2017-2018  Brasil  Despesas correntes      <NA> 4309.88
#> 3: 2017-2018  Brasil Despesas de consumo      <NA> 3764.51
#> 4: 2017-2018  Brasil         Alimentação      <NA>  658.23
#> 5: 2017-2018  Brasil           Habitação      <NA> 1377.14
#> 6: 2017-2018  Brasil           Habitação   Aluguel  700.49
#>                          Fonte
#>                         <char>
#> 1: POF 2017-2018, Tabela 1.1.1
#> 2: POF 2017-2018, Tabela 1.1.1
#> 3: POF 2017-2018, Tabela 1.1.1
#> 4: POF 2017-2018, Tabela 1.1.1
#> 5: POF 2017-2018, Tabela 1.1.1
#> 6: POF 2017-2018, Tabela 1.1.1
```
