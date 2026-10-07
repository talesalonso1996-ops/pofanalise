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
#>  [1] "alimentacao_quintil_2017"    "alimentacao_rms"            
#>  [3] "apostas_concentracao"        "apostas_modelo"             
#>  [5] "apostas_modelo_gasto"        "apostas_participacao_perfil"
#>  [7] "apostas_prevalencia_perfil"  "apostas_serie"              
#>  [9] "apostas_variacao"            "comparacao_ibge"            
#> [11] "comparacao_versoes"          "composicao_saude_habitacao" 
#> [13] "concentracao"                "concentracao_rms"           
#> [15] "cv_2017"                     "decomposicao"               
#> [17] "decomposicao_grupos"         "desigualdade"               
#> [19] "desigualdade_rm"             "engel"                      
#> [21] "grupos"                      "grupos_rm"                  
#> [23] "itens_quintil_rms"           "itens_rms"                  
#> [25] "jogos_apostas"               "mapeamento"                 
#> [27] "n1_rms"                      "perfil_indice"              
#> [29] "perfil_participacao"         "prevalencia_quintil_brasil" 
#> [31] "prevalencia_rms"             "quintis_brasil"             
#> [33] "quintis_rms"                 "rotulos"                    
#> [35] "saude_educacao_quintil_rms"  "validacao_ibge"             
#> [37] "variacao_2008_2017"          "verificacao"                
pof_resultado("desigualdade")
#>       Edicao      Gini  P90_P10  P90_P50    Top10 Gini_IC_inf Gini_IC_sup
#>       <char>     <num>    <num>    <num>    <num>       <num>       <num>
#> 1: 1987-1988 0.5422405 12.13576 4.005936 41.94988          NA          NA
#> 2: 1995-1996 0.5719159 14.71170 4.230002 44.64854          NA          NA
#> 3: 2002-2003 0.5396034 13.26502 4.106290 41.66075          NA          NA
#> 4: 2002-2003 0.5529263 13.57723 3.956181 42.93627   0.5434800   0.5609513
#> 5: 2008-2009 0.5509170 12.63416 3.969188 43.29627          NA          NA
#> 6: 2008-2009 0.5396733 12.98560 3.731454 41.51841   0.5286709   0.5516837
#> 7: 2017-2018 0.5150116 11.37203 3.680590 39.32057          NA          NA
#> 8: 2017-2018 0.5028814 10.65677 3.365933 38.25456   0.4939638   0.5109867
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
