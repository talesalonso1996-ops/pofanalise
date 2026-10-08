# Começando

O `pofanalise` reúne as funções usadas nas análises deste site. Ele
parte de duas peças que já existem:

- **Os microdados harmonizados** das cinco edições da POF (1987-1988,
  1995-1996, 2002-2003, 2008-2009 e 2017-2018), gerados pelo pipeline
  HarmonizaPOF2026. São os arquivos
  `POF<ano>__GZ__Despesas_POF_<ano>.gz` e
  `POF<ano>__RDS__MORADORES_H.RDS`. Eles não acompanham o pacote.
- **A harmonização de produtos** de Arthur Welle, que associa cada
  produto original de cada edição a uma categoria comum. O pacote baixa
  o de-para do repositório
  [Harmoniza_Produtos](https://github.com/arthurwelle/Harmoniza_Produtos).
  Veja a vinheta [Harmonização de
  produtos](https://talesalonso1996-ops.github.io/pofanalise/articles/harmonizacao.md).

## Instalação

``` r
# install.packages("remotes")
remotes::install_github("talesalonso1996-ops/pofanalise")
```

## Fluxo básico

``` r
library(pofanalise)

h <- pof_harmonizacao()                       # de-para v2, com cache local
b <- pof_ler_edicao(2017, dir = "HarmonizaPOF2026_data", harmonizacao = h)
b <- pof_somar_grupos(b)                      # Alimentação, Habitação, ...
b <- pof_add_quintis(b)                       # quintis de consumo per capita

# participação dos grupos no consumo, Brasil, com IC 95% do desenho amostral
pof_participacao(b, pof_grupos_consumo())

# para comparar com 1987 e 1995: só RMs e sem aluguel
bs <- pof_add_quintis(pof_sem_aluguel(b))
pof_participacao(bs, "Alimentação", por = "Quintil_RM", filtro = quote(!is.na(RGMT)))
```

[`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md)
devolve uma linha por unidade de consumo, com:

- peso e desenho amostral (UPA e estrato, de 2002 em diante);
- sexo, idade e cor da pessoa de referência;
- gasto mensal por Nível 1 da harmonização (`n01` a `n34`) e pelas
  folhas de consumo (`f` + código da folha).

## Exemplo sem microdados

[`pof_exemplo()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_exemplo.md)
gera uma base sintética no mesmo formato, útil para testar código. Os
números não representam a POF.

``` r
b <- pof_exemplo()
pof_participacao(b, c("Alimentação", "Habitação"), por = "Quintil")[, .(Nivel, Item, Perc = round(Perc, 1), IC_inf = round(IC_inf, 1), IC_sup = round(IC_sup, 1))]
#>      Nivel        Item  Perc IC_inf IC_sup
#>     <char>      <char> <num>  <num>  <num>
#>  1:      1 Alimentação  30.0   29.0   31.0
#>  2:      1   Habitação  47.4   46.3   48.4
#>  3:      2 Alimentação  27.8   26.8   28.7
#>  4:      2   Habitação  48.3   47.2   49.3
#>  5:      3 Alimentação  25.8   25.0   26.6
#>  6:      3   Habitação  49.0   48.2   49.8
#>  7:      4 Alimentação  24.8   24.0   25.6
#>  8:      4   Habitação  49.2   48.3   50.0
#>  9:      5 Alimentação  24.0   23.1   24.9
#> 10:      5   Habitação  49.6   48.8   50.4
pof_desigualdade(b)
#>     Edicao      Gini  P90_P10  P90_P50    Top10 Gini_IC_inf Gini_IC_sup
#>     <char>     <num>    <num>    <num>    <num>       <num>       <num>
#> 1: exemplo 0.4272836 7.740449 2.871468 31.66169          NA          NA
```

## Três regras para comparar edições

1.  **Recorte.** 1987-1988 e 1995-1996 só cobrem as onze regiões
    metropolitanas. Compare as cinco edições com
    `filtro = quote(!is.na(RGMT))`.
2.  **Aluguel.** O aluguel estimado de quem mora em imóvel próprio só
    existe de 2002-2003 em diante. Para comparar com as edições
    anteriores, use
    [`pof_sem_aluguel()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_sem_aluguel.md)
    e recalcule os quintis.
3.  **Moeda.** Os valores são nominais (cruzado em 1987, real depois).
    Compare participações, índices e medidas de desigualdade, nunca
    valores em moeda.

## Resultados prontos

As tabelas usadas nas vinhetas acompanham o pacote:

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
```
