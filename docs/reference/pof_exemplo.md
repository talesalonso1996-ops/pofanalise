# Base sintética para exemplos e testes

Gera uma base no formato de
[`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md)
com dados simulados, para rodar os exemplos sem os microdados. Os
números não representam a POF.

## Uso

``` r
pof_exemplo(n = 2000, semente = 1)
```

## Argumentos

- n:

  Número de UCs.

- semente:

  Semente aleatória.

## Valor

`data.table` com grupos somados, quintis, variáveis de perfil e um item
de exemplo (`Jogos`).

## Exemplos

``` r
head(pof_exemplo())
#>     Edicao id_uc      Peso  RGMT   UPA ESTRATO N_moradores_UC Sexo_ref
#>     <char> <int>     <num> <int> <int>   <int>          <int>    <int>
#> 1: exemplo     1  76.55087    11     1       1              3        2
#> 2: exemplo     2  87.21239     3     1       1              1        1
#> 3: exemplo     3 107.28534     2     1       1              1        1
#> 4: exemplo     4 140.82078     4     1       1              4        1
#> 5: exemplo     5  70.16819     5     2       1              3        1
#> 6: exemplo     6 139.83897     8     2       1              4        2
#>    Idade_ref Cor_ref Alimentação  Habitação Transporte  Educação   Consumo
#>        <int>   <num>       <num>      <num>      <num>     <num>     <num>
#> 1:        80       4   420.60240  594.46140  271.11568 139.96420 1426.1437
#> 2:        23       4    47.85434   75.25539   32.35404   0.00000  155.4638
#> 3:        74       2   620.78057  843.12372  619.14412 151.97227 2235.0207
#> 4:        30       4   667.80196 1940.10855  257.20624 245.29957 3110.4163
#> 5:        55       4   917.58246 1108.71761  248.86038  46.21892 2321.3794
#> 6:        70       2  1269.02107 2506.65138 1162.71085   0.00000 4938.3833
#>    Consumo_pc    Jogos Quintil Quintil_RM   sexo      idade            cor
#>         <num>    <num>   <int>      <int> <char>     <char>         <char>
#> 1:   475.3812  0.00000       2          2 Mulher 60 ou mais Preta ou parda
#> 2:   155.4638  0.00000       1          1  Homem     Até 29 Preta ou parda
#> 3:  2235.0207  0.00000       5          5  Homem 60 ou mais Preta ou parda
#> 4:   777.6041  0.00000       3          3  Homem    30 a 44 Preta ou parda
#> 5:   773.7931  0.00000       3          3  Homem    45 a 59 Preta ou parda
#> 6:  1234.5958 70.87326       4          4 Mulher 60 ou mais Preta ou parda
#>            tamanho             rm
#>             <char>         <char>
#> 1: 3 a 4 moradores        Goiânia
#> 2:       1 morador Belo Horizonte
#> 3:       1 morador   Porto Alegre
#> 4: 3 a 4 moradores         Recife
#> 5: 3 a 4 moradores      São Paulo
#> 6: 3 a 4 moradores      Fortaleza
```
