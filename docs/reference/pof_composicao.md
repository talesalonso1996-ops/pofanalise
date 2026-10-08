# Composição de um grupo de gasto

Abre um grupo nas suas partes e mede a participação de cada uma dentro
do grupo, por edição. Funciona para os grandes grupos (as partes são os
Níveis 1, ex. as 16 categorias de alimentação) e para os Níveis 1 de
consumo não alimentar (as partes são as folhas, ex. `"22"` abre a saúde
em remédios, plano, consultas etc.).

## Uso

``` r
pof_composicao(dados, grupo, por = NULL, recorte = c("auto", "brasil", "rms"))
```

## Argumentos

- dados:

  Resultado de [`pof_carregar()`](pof_carregar.md) ou uma base única.

- grupo:

  Nome de um grande grupo (`"Alimentação"`, `"Habitação"`...) ou código
  de Nível 1 com 2 dígitos (`"22"`).

- por:

  Corte opcional.

- recorte:

  `"auto"`, `"brasil"` ou `"rms"`.

## Valor

`data.table` com `Edicao`, `Grupo`, `Parte`, `Codigo`, `Perc`
(percentual do gasto do grupo).
