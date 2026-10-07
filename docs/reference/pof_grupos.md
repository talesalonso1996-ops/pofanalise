# Grandes grupos de consumo

Tabela que associa cada Nível 1 da harmonização aos grupos de despesa do
IBGE. Na v2, a despesa de consumo é a soma dos Níveis 1 a 26; os Níveis
27 a 34 (outras despesas correntes, variação patrimonial, rendimentos e
inventário) ficam fora. Na versão inicial, os mesmos papéis cabem aos
Níveis 1 a 16 e 31 a 40 (consumo) e 41 a 47 e 88 (fora do consumo).

## Uso

``` r
pof_grupos(versao = c("v2", "inicial"))

pof_grupos_consumo()
```

## Argumentos

- versao:

  `"v2"` ou `"inicial"`.

## Valor

`data.table` com `n1`, `grupo` e `consumo` (lógico).

## Exemplos

``` r
pof_grupos()
#>        n1                       grupo consumo
#>     <int>                      <char>  <lgcl>
#>  1:     1                 Alimentação    TRUE
#>  2:     2                 Alimentação    TRUE
#>  3:     3                 Alimentação    TRUE
#>  4:     4                 Alimentação    TRUE
#>  5:     5                 Alimentação    TRUE
#>  6:     6                 Alimentação    TRUE
#>  7:     7                 Alimentação    TRUE
#>  8:     8                 Alimentação    TRUE
#>  9:     9                 Alimentação    TRUE
#> 10:    10                 Alimentação    TRUE
#> 11:    11                 Alimentação    TRUE
#> 12:    12                 Alimentação    TRUE
#> 13:    13                 Alimentação    TRUE
#> 14:    14                 Alimentação    TRUE
#> 15:    15                 Alimentação    TRUE
#> 16:    16                 Alimentação    TRUE
#> 17:    17                   Habitação    TRUE
#> 18:    18                   Habitação    TRUE
#> 19:    19                   Vestuário    TRUE
#> 20:    20                  Transporte    TRUE
#> 21:    21 Higiene e cuidados pessoais    TRUE
#> 22:    22         Assistência à saúde    TRUE
#> 23:    23                    Educação    TRUE
#> 24:    24         Recreação e cultura    TRUE
#> 25:    25           Serviços pessoais    TRUE
#> 26:    26           Despesas diversas    TRUE
#> 27:    27   Outras despesas correntes   FALSE
#> 28:    28            Aumento do ativo   FALSE
#> 29:    29       Diminuição do passivo   FALSE
#> 30:    30                 Rendimentos   FALSE
#> 31:    31                 Rendimentos   FALSE
#> 32:    32                 Rendimentos   FALSE
#> 33:    33                 Rendimentos   FALSE
#> 34:    34                  Inventário   FALSE
#>        n1                       grupo consumo
```
