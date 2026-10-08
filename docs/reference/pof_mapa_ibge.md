# Correspondência entre as linhas das tabelas do IBGE e as colunas do pacote

Cada linha diz como reproduzir um tipo de despesa das tabelas oficiais
com as colunas de [`pof_ler_edicao()`](pof_ler_edicao.md) (harmonização
v2): uma expressão em R sobre as colunas de grupo, de Nível 1 (`n27`...)
e de folha (`f17101`...). Linhas sem correspondência direta na
harmonização (aluguel monetário e não monetário, condomínio, pacote de
telefone, TV e internet, itens de outras despesas correntes) ficam de
fora.

## Uso

``` r
pof_mapa_ibge()
```

## Valor

`data.table` com `Grupo_ibge`, `Item_ibge` e `expr`.

## Exemplos

``` r
head(pof_mapa_ibge())
#>             Grupo_ibge Item_ibge                      expr
#>                 <char>    <char>                    <char>
#> 1:       Despesa total      <NA> Consumo + n27 + n28 + n29
#> 2:  Despesas correntes      <NA>             Consumo + n27
#> 3: Despesas de consumo      <NA>                   Consumo
#> 4:         Alimentação      <NA>             `Alimentação`
#> 5:           Habitação      <NA>               `Habitação`
#> 6:           Habitação   Aluguel                    f17101
```
