# Decomposição demográfica de uma mudança

Separa a variação da participação de um item no consumo entre duas
edições em dois efeitos (decomposição *shift-share* simétrica):

## Uso

``` r
pof_decompor(
  dados,
  item,
  por,
  de,
  para,
  recorte = c("auto", "brasil", "rms"),
  sem_aluguel = NULL
)
```

## Argumentos

- dados:

  Resultado de
  [`pof_carregar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_carregar.md)
  ou uma base única.

- item:

  Nome de coluna: um item de
  [`pof_carregar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_carregar.md),
  um grupo (`"Alimentação"`) ou um Nível 1 (`"n07"`).

- por:

  Corte que define os grupos: `"quintil"` não faz sentido aqui (o peso
  de cada quintil é fixo); use `"idade"`, `"tamanho"`, `"sexo"`, `"cor"`
  ou `"rm"`.

- de, para:

  Edições, como `"1995-1996"` e `"2017-2018"`.

- recorte:

  `"auto"`, `"brasil"` ou `"rms"`.

- sem_aluguel:

  `NULL` (automático), `TRUE` ou `FALSE`.

## Valor

Lista com `resumo` (variação total e os dois efeitos, em pontos
percentuais) e `grupos` (contribuição de cada grupo).

## Detalhes

- **Comportamento**: mudança da participação dentro de cada grupo,
  mantida a composição média.

- **Composição**: mudança no peso de cada grupo no consumo total (por
  exemplo, mais UCs de idosos ou de uma pessoa), mantido o comportamento
  médio.

A soma dos dois efeitos é exatamente a variação total.

## Exemplos

``` r
a <- pof_exemplo(semente = 1); a$Edicao <- "2008-2009"
b <- pof_exemplo(semente = 2); b$Edicao <- "2017-2018"
pof_decompor(list(a, b), "Alimentação", por = "tamanho", de = "2008-2009", para = "2017-2018")
#> $resumo
#>           Item     Por        De      Para Participacao_de Participacao_para
#>         <char>  <char>    <char>    <char>           <num>             <num>
#> 1: Alimentação tamanho 2008-2009 2017-2018        25.10789          25.93531
#>    Variacao_total Efeito_comportamento Efeito_composicao
#>             <num>                <num>             <num>
#> 1:      0.8274194            0.8208683       0.006551145
#> 
#> $grupos
#> Key: <Grupo>
#>                  Grupo   Peso_de Peso_para  Part_de Part_para Comportamento
#>                 <char>     <num>     <num>    <num>     <num>         <num>
#> 1:           1 morador  4.937976  4.913930 29.32503  28.59313   -0.03605281
#> 2:         2 moradores  8.862293  9.466389 27.13112  27.58409    0.04151198
#> 3:     3 a 4 moradores 33.891357 32.747131 25.09952  25.95637    0.28549804
#> 4: 5 ou mais moradores 52.308374 52.872549 24.37243  25.38005    0.52991106
#>     Composicao
#>          <num>
#> 1: -0.00696331
#> 2:  0.16526625
#> 3: -0.29209732
#> 4:  0.14034553
#> 
```
