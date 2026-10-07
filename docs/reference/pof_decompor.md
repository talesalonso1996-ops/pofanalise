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
#> 1: Alimentação tamanho 2008-2009 2017-2018        25.38023          25.40596
#>    Variacao_total Efeito_comportamento Efeito_composicao
#>             <num>                <num>             <num>
#> 1:     0.02572938           0.07012173       -0.04439236
#> 
#> $grupos
#> Key: <Grupo>
#>                  Grupo   Peso_de Peso_para  Part_de Part_para Comportamento
#>                 <char>     <num>     <num>    <num>     <num>         <num>
#> 1:           1 morador  5.592231  4.796146 29.69339  30.46992   0.040334589
#> 2:         2 moradores  8.966169  9.659177 27.09766  26.75237  -0.032156124
#> 3:     3 a 4 moradores 33.816076 31.379199 25.29407  25.45637   0.052905876
#> 4: 5 ou mais moradores 51.625524 54.165478 24.67118  24.68826   0.009037392
#>    Composicao
#>         <num>
#> 1: -0.2394757
#> 2:  0.1865924
#> 3: -0.6183628
#> 4:  0.6268537
#> 
```
