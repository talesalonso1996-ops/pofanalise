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
#> [15] "decomposicao"                "decomposicao_grupos"        
#> [17] "desigualdade"                "desigualdade_rm"            
#> [19] "engel"                       "grupos"                     
#> [21] "grupos_rm"                   "itens_quintil_rms"          
#> [23] "itens_rms"                   "jogos_apostas"              
#> [25] "mapeamento"                  "n1_rms"                     
#> [27] "perfil_indice"               "perfil_participacao"        
#> [29] "prevalencia_quintil_brasil"  "prevalencia_rms"            
#> [31] "quintis_brasil"              "quintis_rms"                
#> [33] "rotulos"                     "saude_educacao_quintil_rms" 
#> [35] "validacao_ibge"              "variacao_2008_2017"         
#> [37] "verificacao"                
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
