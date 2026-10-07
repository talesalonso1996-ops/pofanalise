# Resultados agregados distribuídos com o pacote

Tabelas geradas por `data-raw/gerar_resultados.R` a partir dos
microdados harmonizados (harmonização v2). Permitem reproduzir as
vinhetas e o site sem acesso aos microdados.

## Uso

``` r
pof_resultado(nome = NULL)
```

## Argumentos

- nome:

  Nome da tabela. Sem argumento, lista as disponíveis.

## Valor

`data.table` (ou vetor de nomes).

## Exemplos

``` r
pof_resultado()
#>  [1] "alimentacao_quintil_2017"   "alimentacao_rms"           
#>  [3] "comparacao_ibge"            "comparacao_versoes"        
#>  [5] "desigualdade"               "desigualdade_rm"           
#>  [7] "engel"                      "grupos"                    
#>  [9] "grupos_rm"                  "itens_quintil_rms"         
#> [11] "itens_rms"                  "jogos_apostas"             
#> [13] "mapeamento"                 "n1_rms"                    
#> [15] "perfil_indice"              "perfil_participacao"       
#> [17] "prevalencia_quintil_brasil" "prevalencia_rms"           
#> [19] "quintis_brasil"             "quintis_rms"               
#> [21] "rotulos"                    "saude_educacao_quintil_rms"
pof_resultado("desigualdade")
#>       Edicao      Gini  P90_P10  P90_P50    Top10 Gini_IC_inf Gini_IC_sup
#>       <char>     <num>    <num>    <num>    <num>       <num>       <num>
#> 1: 1987-1988 0.5422405 12.13576 4.005936 41.94988          NA          NA
#> 2: 1995-1996 0.5719159 14.71170 4.230002 44.64854          NA          NA
#> 3: 2002-2003 0.5396034 13.26502 4.106290 41.66075          NA          NA
#> 4: 2002-2003 0.5529263 13.57723 3.956181 42.93627   0.5428395   0.5649729
#> 5: 2008-2009 0.5509170 12.63416 3.969188 43.29627          NA          NA
#> 6: 2008-2009 0.5396733 12.98560 3.731454 41.51841   0.5283546   0.5514583
#> 7: 2017-2018 0.5150116 11.37203 3.680590 39.32057          NA          NA
#> 8: 2017-2018 0.5028814 10.65677 3.365933 38.25456   0.4948067   0.5105218
#>    Recorte
#>     <char>
#> 1:     RMs
#> 2:     RMs
#> 3:     RMs
#> 4:  Brasil
#> 5:     RMs
#> 6:  Brasil
#> 7:     RMs
#> 8:  Brasil
```
