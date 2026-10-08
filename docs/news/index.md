# Changelog

## pofanalise 0.2.0

### Correções que mudam resultados

- **Estratos de 2002-2003 e 2008-2009.** Nos microdados harmonizados, o
  código de estrato dessas edições é numerado dentro de cada UF (1 a 30
  e 1 a 51). [`pof_ler_edicao()`](../reference/pof_ler_edicao.md) agora
  usa UF × estrato (443 e 550 estratos). As estimativas pontuais não
  mudam; os intervalos de confiança de 2002 e 2008 mudam. Em 2017-2018 o
  código já era único (575 estratos).
- **Bootstrap do Gini.** `pof_desigualdade(B = ...)` passou a usar o
  bootstrap de Rao-Wu (n - 1 UPAs sorteadas por estrato, pesos
  reescalonados). O bootstrap anterior, com n UPAs, subestimava a
  variância com poucas UPAs por estrato.
- **Domínios em [`pof_diferenca()`](../reference/pof_diferenca.md) e
  [`pof_modelo()`](../reference/pof_modelo.md).** O desenho amostral é
  montado com todas as UCs e o domínio (casos completos, quem gasta)
  entra por [`subset()`](https://rdrr.io/r/base/subset.html).
- **Erro-padrão da curva de Engel.**
  [`pof_engel()`](../reference/pof_engel.md) usa
  [`survey::svyglm`](https://rdrr.io/pkg/survey/man/svyglm.html) quando
  há desenho amostral.

### Novidades

- Comparação com o IBGE: [`pof_ibge()`](../reference/pof_ibge.md) (1.295
  valores oficiais das POFs 2008-2009 e 2017-2018),
  [`pof_validar()`](../reference/pof_validar.md) e
  [`pof_mapa_ibge()`](../reference/pof_mapa_ibge.md). A validação inclui
  o coeficiente de variação oficial de 2017-2018: os do pacote têm razão
  mediana próxima de 1.
- Deflacionamento: [`pof_ipca()`](../reference/pof_ipca.md) e
  [`pof_deflacionar()`](../reference/pof_ipca.md).
- Cortes `por = "regiao"` (Grande Região) e `por = "situacao"`
  (urbana/rural).
- Ferramentas: [`pof_variacao()`](../reference/pof_variacao.md),
  [`pof_concentracao()`](../reference/pof_concentracao.md),
  [`pof_decompor()`](../reference/pof_decompor.md),
  [`pof_composicao()`](../reference/pof_composicao.md),
  [`pof_elasticidade()`](../reference/pof_elasticidade.md),
  [`pof_tabela()`](../reference/pof_tabela.md),
  [`pof_exportar()`](../reference/pof_exportar.md).
- `pof_harmonizacao(atualizar = TRUE)` baixa de novo a harmonização;
  aviso quando `ref` não é um commit fixo.
- Documentação do período de referência dos itens em
  [`pof_prevalencia()`](../reference/pof_prevalencia.md).
- `data-raw/verificar_microdados.R`: bateria de verificação nos
  microdados reais.

## pofanalise 0.1.0

- Primeira versão: leitura das cinco edições com a harmonização v2 de
  Arthur Welle, estimativas com desenho amostral, camada de pesquisa
  ([`pof_buscar()`](../reference/pof_buscar.md),
  [`pof_carregar()`](../reference/pof_carregar.md),
  [`pof_analisar()`](../reference/pof_analisar.md),
  [`pof_diferenca()`](../reference/pof_diferenca.md),
  [`pof_modelo()`](../reference/pof_modelo.md)), sete análises e painel
  interativo.
