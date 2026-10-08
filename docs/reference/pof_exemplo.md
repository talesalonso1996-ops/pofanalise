# Base sintética para exemplos e testes

Gera uma base no formato de [`pof_ler_edicao()`](pof_ler_edicao.md) com
dados simulados, para rodar os exemplos sem os microdados. Os números
não representam a POF.

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
#>    Idade_ref Cor_ref    UF       regiao situacao Alimentação Habitação
#>        <int>   <num> <int>       <char>   <char>       <num>     <num>
#> 1:        80       4    35      Sudeste    Rural   1019.6235 3993.0444
#> 2:        23       4    53 Centro-Oeste   Urbana     88.4438  142.5899
#> 3:        74       2    23     Nordeste    Rural    226.0733  247.7343
#> 4:        30       4    23     Nordeste   Urbana    423.5392  542.4120
#> 5:        55       4    53 Centro-Oeste   Urbana    143.4530  326.3950
#> 6:        70       2    23     Nordeste   Urbana   2163.3135 2322.6718
#>    Transporte  Educação   Consumo Consumo_pc    Jogos Quintil Quintil_RM   sexo
#>         <num>     <num>     <num>      <num>    <num>   <int>      <int> <char>
#> 1: 2321.22301  56.44972 7390.3406  2463.4469  0.00000       5          5 Mulher
#> 2:   52.11648   0.00000  283.1502   283.1502  5.00919       1          1  Homem
#> 3:  118.62578  47.19044  639.6238   639.6238  0.00000       3          3  Homem
#> 4:  190.60489 118.58079 1275.1369   318.7842  0.00000       1          1  Homem
#> 5:   87.75685   0.00000  557.6048   185.8683 12.25525       1          1  Homem
#> 6: 1600.22240 509.44359 6595.6512  1648.9128  0.00000       5          5 Mulher
#>         idade            cor         tamanho             rm
#>        <char>         <char>          <char>         <char>
#> 1: 60 ou mais Preta ou parda 3 a 4 moradores        Goiânia
#> 2:     Até 29 Preta ou parda       1 morador Belo Horizonte
#> 3: 60 ou mais Preta ou parda       1 morador   Porto Alegre
#> 4:    30 a 44 Preta ou parda 3 a 4 moradores         Recife
#> 5:    45 a 59 Preta ou parda 3 a 4 moradores      São Paulo
#> 6: 60 ou mais Preta ou parda 3 a 4 moradores      Fortaleza
```
