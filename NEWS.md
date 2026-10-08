# pofanalise 0.3.0

## Erros conhecidos na harmonização v2: correções provisórias que mudam resultados

A harmonização v2 tem erros de classificação, identificados comparando o de-para, código a código, com o tradutor oficial do IBGE (que aplicado aos mesmos microdados reproduz a Tabela 1.1.1 de 2017-2018 ao centavo). Até que sejam corrigidos no repositório de origem, `pof_correcoes()` passa de 6 para 33 códigos e `pof_ler_edicao()` reclassifica dois tipos de registro. Todos os resultados e páginas do site foram recalculados. Ver o artigo "Erros conhecidos na harmonização".

* **Condomínio fora do consumo em 2008 e 2017** (estava em 27203 Outras despesas correntes; em 1995 e 2002 já estava em Habitação). A queda da habitação sem aluguel nas regiões metropolitanas depois de 2002 era, em boa parte, efeito disso.
* **Compra de outros imóveis como consumo, de 1987 a 2008** (estava em 26105 Imóveis de uso ocasional; passa para 28101 Aquisição de imóvel). Inflava as despesas diversas e o consumo total, até 3,9% nas RMs em 2008.
* **Celular em recreação em 2008** (cartão e conta passam para 17202), além da correção do quadro 44 de 2017 que já existia.
* **2017: seguro obrigatório, multas, taxas do Detran, IPVA, IPTU e ITR de outros imóveis, aluguel e consórcio de outros imóveis, papel higiênico** em grupos errados.
* **INSS de empregado doméstico** (todas as edições) deixa de contar como consumo e vai para 27102; **deduções de rendimento** (imposto de renda, previdência) saem de Rendimentos e vão para Outras despesas correntes.
* Com as correções, a despesa de consumo fica a −0,01% e −0,05% do IBGE em 2017-2018 e 2008-2009 (antes, −1,59% e +1,02%), a despesa total de 2017-2018 fica idêntica à oficial e os 10 grupos de consumo de 2017-2018 ficam a menos de 1,5 ponto percentual do IBGE.
* Aviso ao carregar o pacote e em todas as páginas do site enquanto os erros não forem corrigidos na origem.
* Novos scripts: `data-raw/conferir_tradutor_ibge.R` (a investigação) e `data-raw/validar_ibge_v2_original.R`.

# pofanalise 0.2.0

## Correções que mudam resultados

* **Estratos de 2002-2003 e 2008-2009.** Nos microdados harmonizados, o código de estrato dessas edições é numerado dentro de cada UF (1 a 30 e 1 a 51). `pof_ler_edicao()` agora usa UF × estrato (443 e 550 estratos). As estimativas pontuais não mudam; os intervalos de confiança de 2002 e 2008 mudam. Em 2017-2018 o código já era único (575 estratos).
* **Bootstrap do Gini.** `pof_desigualdade(B = ...)` passou a usar o bootstrap de Rao-Wu (n - 1 UPAs sorteadas por estrato, pesos reescalonados). O bootstrap anterior, com n UPAs, subestimava a variância com poucas UPAs por estrato.
* **Domínios em `pof_diferenca()` e `pof_modelo()`.** O desenho amostral é montado com todas as UCs e o domínio (casos completos, quem gasta) entra por `subset()`.
* **Erro-padrão da curva de Engel.** `pof_engel()` usa `survey::svyglm` quando há desenho amostral.

## Novidades

* Comparação com o IBGE: `pof_ibge()` (1.295 valores oficiais das POFs 2008-2009 e 2017-2018), `pof_validar()` e `pof_mapa_ibge()`. A validação inclui o coeficiente de variação oficial de 2017-2018: os do pacote têm razão mediana próxima de 1.
* Deflacionamento: `pof_ipca()` e `pof_deflacionar()`.
* Cortes `por = "regiao"` (Grande Região) e `por = "situacao"` (urbana/rural).
* Ferramentas: `pof_variacao()`, `pof_concentracao()`, `pof_decompor()`, `pof_composicao()`, `pof_elasticidade()`, `pof_tabela()`, `pof_exportar()`.
* `pof_harmonizacao(atualizar = TRUE)` baixa de novo a harmonização; aviso quando `ref` não é um commit fixo.
* Documentação do período de referência dos itens em `pof_prevalencia()`.
* `data-raw/verificar_microdados.R`: bateria de verificação nos microdados reais.

# pofanalise 0.1.0

* Primeira versão: leitura das cinco edições com a harmonização v2 de Arthur Welle, estimativas com desenho amostral, camada de pesquisa (`pof_buscar()`, `pof_carregar()`, `pof_analisar()`, `pof_diferenca()`, `pof_modelo()`), sete análises e painel interativo.
