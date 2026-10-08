# Changelog

## pofanalise 0.2.0

### Correções que mudam resultados

- **Estratos de 2002-2003 e 2008-2009.** Nos microdados harmonizados, o
  código de estrato dessas edições é numerado dentro de cada UF (1 a 30
  e 1 a 51).
  [`pof_ler_edicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ler_edicao.md)
  agora usa UF × estrato (443 e 550 estratos). As estimativas pontuais
  não mudam; os intervalos de confiança de 2002 e 2008 mudam. Em
  2017-2018 o código já era único (575 estratos).
- **Bootstrap do Gini.** `pof_desigualdade(B = ...)` passou a usar o
  bootstrap de Rao-Wu (n - 1 UPAs sorteadas por estrato, pesos
  reescalonados). O bootstrap anterior, com n UPAs, subestimava a
  variância com poucas UPAs por estrato.
- **Domínios em
  [`pof_diferenca()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_diferenca.md)
  e
  [`pof_modelo()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_modelo.md).**
  O desenho amostral é montado com todas as UCs e o domínio (casos
  completos, quem gasta) entra por
  [`subset()`](https://rdrr.io/r/base/subset.html).
- **Erro-padrão da curva de Engel.**
  [`pof_engel()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_engel.md)
  usa [`survey::svyglm`](https://rdrr.io/pkg/survey/man/svyglm.html)
  quando há desenho amostral.

### Novidades

- Comparação com o IBGE:
  [`pof_ibge()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ibge.md)
  (1.295 valores oficiais das POFs 2008-2009 e 2017-2018),
  [`pof_validar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_validar.md)
  e
  [`pof_mapa_ibge()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_mapa_ibge.md).
  A validação inclui o coeficiente de variação oficial de 2017-2018: os
  do pacote têm razão mediana próxima de 1.
- Deflacionamento:
  [`pof_ipca()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ipca.md)
  e
  [`pof_deflacionar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_ipca.md).
- Cortes `por = "regiao"` (Grande Região) e `por = "situacao"`
  (urbana/rural).
- Ferramentas:
  [`pof_variacao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_variacao.md),
  [`pof_concentracao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_concentracao.md),
  [`pof_decompor()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_decompor.md),
  [`pof_composicao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_composicao.md),
  [`pof_elasticidade()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_elasticidade.md),
  [`pof_tabela()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_tabela.md),
  [`pof_exportar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_exportar.md).
- `pof_harmonizacao(atualizar = TRUE)` baixa de novo a harmonização;
  aviso quando `ref` não é um commit fixo.
- Documentação do período de referência dos itens em
  [`pof_prevalencia()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_prevalencia.md).
- `data-raw/verificar_microdados.R`: bateria de verificação nos
  microdados reais.

## pofanalise 0.1.0

- Primeira versão: leitura das cinco edições com a harmonização v2 de
  Arthur Welle, estimativas com desenho amostral, camada de pesquisa
  ([`pof_buscar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_buscar.md),
  [`pof_carregar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_carregar.md),
  [`pof_analisar()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_analisar.md),
  [`pof_diferenca()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_diferenca.md),
  [`pof_modelo()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_modelo.md)),
  sete análises e painel interativo.
