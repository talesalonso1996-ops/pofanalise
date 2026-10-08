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
#> [37] "validacao_ibge_v2_original"  "variacao_2008_2017"         
#> [39] "verificacao"                
pof_resultado("desigualdade")
#>       Edicao      Gini  P90_P10  P90_P50    Top10 Gini_IC_inf Gini_IC_sup
#>       <char>     <num>    <num>    <num>    <num>       <num>       <num>
#> 1: 1987-1988 0.5382268 12.09729 3.993236 41.46728          NA          NA
#> 2: 1995-1996 0.5656313 14.64351 4.212658 43.82785          NA          NA
#> 3: 2002-2003 0.5261770 12.83321 3.983325 40.07390          NA          NA
#> 4: 2002-2003 0.5412567 13.28829 3.883955 41.48932   0.5326364   0.5488236
#> 5: 2008-2009 0.5403788 12.82143 4.019318 41.77905          NA          NA
#> 6: 2008-2009 0.5334024 13.09198 3.759679 40.73749   0.5252861   0.5401744
#> 7: 2017-2018 0.5210985 11.81591 3.741414 39.86788          NA          NA
#> 8: 2017-2018 0.5074551 10.89322 3.429877 38.72489   0.4982266   0.5159023
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
