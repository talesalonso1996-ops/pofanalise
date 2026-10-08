# Commit do repositorio arthurwelle/Harmoniza_Produtos usado por padrao.
# Fixar o commit garante que os resultados sejam reproduziveis mesmo que a
# harmonizacao continue sendo revista no repositorio original.
.harmo_ref_padrao <- "e4f2cc04668e77b4c0eaf718b560e07522935b50"

#' Harmonização de produtos da POF (Arthur Welle)
#'
#' Baixa e prepara o de-para de produtos da POF mantido por Arthur Welle no
#' repositório [Harmoniza_Produtos](https://github.com/arthurwelle/Harmoniza_Produtos)
#' (explorador em <https://arthurwelle.github.io/Harmoniza_Produtos/>).
#' Os arquivos ficam em cache local depois do primeiro download.
#'
#' A versão `"v2"` (padrão) é a harmonização revista, com 307 folhas, nota de
#' qualidade por folha e confiança por produto. A versão `"inicial"` é o
#' esquema anterior, o mesmo do `Cod_harmo` gravado nos microdados.
#'
#' Alguns códigos originais de produto apontam para mais de uma folha (a v2
#' detalha, por exemplo, espécies de pescado que dividem o mesmo código).
#' Nesses casos o código é atribuído à folha com mais descrições associadas,
#' e a coluna `ambiguo` marca a decisão. Em todos os casos verificados as
#' folhas concorrentes pertencem ao mesmo Nível 1, o que não altera análises
#' por grupo.
#'
#' @param versao `"v2"` ou `"inicial"`.
#' @param ref Commit, tag ou ramo do repositório de origem.
#' @param dir_local Pasta com `produtos.csv` e `folhas.csv` já baixados. Se
#'   informado, nada é baixado.
#' @param cache Pasta de cache.
#' @param correcoes Aplicar as correções de [pof_correcoes()] (só na v2).
#' @param atualizar Baixar de novo mesmo que já haja cópia em cache. Útil
#'   quando `ref` é um ramo (ex. `"main"`), cujo conteúdo muda.
#' @return Lista com `depara` (ano, codigo, cod_final, n1, ambiguo,
#'   confianca), `folhas` (taxonomia e qualidade), `versao` e `ref`.
#' @export
#' @examples
#' \dontrun{
#' h <- pof_harmonizacao()
#' h$folhas[n1_num == 22]
#' }
pof_harmonizacao <- function(versao = c("v2", "inicial"), ref = .harmo_ref_padrao,
                             dir_local = NULL,
                             cache = tools::R_user_dir("pofanalise", "cache"),
                             correcoes = TRUE, atualizar = FALSE) {
  versao <- match.arg(versao)
  if (is.null(dir_local) && !grepl("^[0-9a-f]{40}$", ref) && !atualizar)
    message("ref = '", ref, "' n\u00e3o \u00e9 um commit fixo: a c\u00f3pia em cache pode estar desatualizada. ",
            "Use atualizar = TRUE para baixar de novo.")
  sub <- if (versao == "v2") "data" else "inicial/data"
  if (is.null(dir_local)) {
    dir_local <- file.path(cache, paste0("harmoniza_", versao, "_", substr(ref, 1, 12)))
    dir.create(dir_local, recursive = TRUE, showWarnings = FALSE)
    for (f in c("produtos.csv", "folhas.csv")) {
      dest <- file.path(dir_local, f)
      if (atualizar || !file.exists(dest)) {
        url <- sprintf("https://raw.githubusercontent.com/arthurwelle/Harmoniza_Produtos/%s/%s/%s", ref, sub, f)
        utils::download.file(url, dest, mode = "wb", quiet = TRUE)
      }
    }
  }
  prod <- data.table::fread(file.path(dir_local, "produtos.csv"), encoding = "UTF-8",
                            colClasses = list(character = c("cod_final", "codigo")))
  folhas <- data.table::fread(file.path(dir_local, "folhas.csv"), encoding = "UTF-8",
                              colClasses = list(character = "cod_final"))
  folhas[, n1_num := as.integer(sub("[.].*", "", n1))]

  prod[, codigo_int := suppressWarnings(as.integer(codigo))]
  if (!"confianca" %in% names(prod)) prod[, confianca := NA_real_]
  # uma linha por (ano, codigo): folha mais frequente entre as descricoes
  cont <- prod[!is.na(codigo_int), .(n = .N, confianca = mean(confianca)), by = .(ano, codigo_int, cod_final)]
  data.table::setorder(cont, ano, codigo_int, -n, cod_final)
  cont[, n_folhas := .N, by = .(ano, codigo_int)]
  depara <- cont[, .SD[1], by = .(ano, codigo_int)]
  depara <- depara[, .(ano, codigo = codigo_int, cod_final, ambiguo = n_folhas > 1, confianca)]
  depara[, corrigido := FALSE]
  if (correcoes && versao == "v2") {
    cr <- pof_correcoes()
    depara[cr, on = .(ano, codigo), `:=`(cod_final = i.cod_final, corrigido = TRUE)]
  }
  depara[, n1 := as.integer(substr(cod_final, 1, 2))]

  out <- list(depara = depara[], folhas = folhas[], versao = versao, ref = ref,
              correcoes = correcoes && versao == "v2")
  attr(out, "dir") <- dir_local
  out
}

#' Correções provisórias da harmonização v2 (erros conhecidos)
#'
#' **A harmonização v2 tem erros de classificação conhecidos.** Esta tabela
#' lista os códigos de produto que o pacote muda de folha até que sejam
#' corrigidos no repositório de origem (`arthurwelle/Harmoniza_Produtos`).
#' Foram encontrados comparando o de-para com o tradutor oficial do IBGE
#' (`Tradutor_Despesa_Geral`), que aplicado aos mesmos microdados reproduz a
#' Tabela 1.1.1 da POF 2017-2018 ao centavo, e com o mapeamento das outras
#' edições. São aplicados por [pof_harmonizacao()] com `correcoes = TRUE`
#' (padrão) e foram reportados ao autor da harmonização.
#'
#' Erros corrigidos:
#' * **Condomínio fora do consumo (2008 e 2017).** O condomínio do domicílio
#'   principal vai para `27203 Outras despesas correntes`; em 1995 e 2002 está
#'   em `17301 Outros serviços e taxas de habitação`. Quebra de série de 2% a
#'   3% do consumo nas regiões metropolitanas.
#' * **Compra de imóvel como consumo (1987 a 2008).** O valor de "outros
#'   imóveis" adquiridos vai para `26105 Imóveis de uso ocasional`; passa para
#'   `28101 Aquisição de imóvel`. Até 3,9% do consumo nas RMs em 2008.
#' * **Celular em grupo errado (2008 e 2017).** Em 2008, cartão e conta de
#'   celular estão em `24301 Outras recreações`; em 2017 (quadro 44), em
#'   `26102 Comunicação (outros)`. Contas passam para `17202`, aparelhos e
#'   acessórios para `24201`.
#' * **Itens de veículos e de outros imóveis (2017).** Seguro obrigatório
#'   volta para Transporte, como em 2002 e 2008; multas, taxas do Detran, IPVA,
#'   IPTU e ITR saem do consumo (`27101 Impostos e taxas`), como no IBGE.
#' * **Papel higiênico em alimentação (2017).** Volta para `21104`, como em
#'   1987 a 2008.
#'
#' Além destes códigos, [pof_ler_edicao()] classifica por tipo de registro,
#' em todas as edições: o INSS de empregado doméstico (`Tipo == "INSS"`) vai
#' para `27102 Contribuições trabalhistas` (na v2 entra como serviço
#' doméstico, em Habitação), e as deduções de rendimento (`Tipo` começando por
#' "Deducao") vão para `27102` (previdência) ou `27101` (imposto de renda e
#' outras), em vez de Rendimentos.
#'
#' @return `data.table` com `ano`, `codigo`, `cod_final` (folha de destino),
#'   `erro` (o problema da v2) e `item` (descrição do produto).
#' @export
#' @examples
#' pof_correcoes()
#' pof_correcoes()[, .N, by = erro]
pof_correcoes <- function() {
  e_cond <- "Condom\u00ednio fora do consumo"
  e_imov <- "Compra de im\u00f3vel como consumo"
  e_cel <- "Celular em grupo errado"
  e_veic <- "Ve\u00edculos e outros im\u00f3veis"
  e_pap <- "Papel higi\u00eanico em alimenta\u00e7\u00e3o"
  x <- data.table::rbindlist(list(
    list(1987L, 4797L, "28101", e_imov, "Valor escritural do im\u00f3vel adquirido (outros im\u00f3veis)"),
    list(1995L, 4794L, "28101", e_imov, "Valor do im\u00f3vel adquirido em primeira loca\u00e7\u00e3o (outros im\u00f3veis)"),
    list(1995L, 4795L, "28101", e_imov, "Valor do im\u00f3vel adquirido usado (outros im\u00f3veis)"),
    list(2002L, 47094L, "28101", e_imov, "Valor do im\u00f3vel adquirido em primeira loca\u00e7\u00e3o (outros im\u00f3veis)"),
    list(2002L, 47095L, "28101", e_imov, "Valor do im\u00f3vel adquirido usado (outros im\u00f3veis)"),
    list(2002L, 48094L, "28101", e_imov, "Valor do im\u00f3vel adquirido em primeira loca\u00e7\u00e3o (outros im\u00f3veis), quadro 48"),
    list(2002L, 48095L, "28101", e_imov, "Valor do im\u00f3vel adquirido usado (outros im\u00f3veis), quadro 48"),
    list(2008L, 47094L, "28101", e_imov, "Valor de outro im\u00f3vel adquirido em primeira loca\u00e7\u00e3o"),
    list(2008L, 47095L, "28101", e_imov, "Valor de outro im\u00f3vel adquirido usado"),
    list(2008L, 10004L, "17301", e_cond, "Condom\u00ednio"),
    list(2008L, 28023L, "17202", e_cel, "Cart\u00e3o de telefone celular"),
    list(2008L, 28024L, "17202", e_cel, "Conta de telefone celular"),
    list(2017L, 10005L, "17301", e_cond, "Condom\u00ednio"),
    list(2017L, 10004L, "17301", e_cond, "Aluguel de garagem"),
    list(2017L, 10999L, "17301", e_cond, "Agregado do quadro 10 (aluguel, condom\u00ednio e taxas)"),
    list(2017L, 44001L, "17202", e_cel, "Cart\u00e3o de telefonia celular"),
    list(2017L, 44002L, "17202", e_cel, "Conta de celular (voz e internet)"),
    list(2017L, 44003L, "17202", e_cel, "Conta de celular (internet)"),
    list(2017L, 44007L, "17202", e_cel, "Pacote de voz"),
    list(2017L, 44004L, "24201", e_cel, "Aparelho de telefone celular"),
    list(2017L, 44006L, "24201", e_cel, "Acess\u00f3rios de telefone celular"),
    list(2017L, 50002L, "20303", e_veic, "Seguro obrigat\u00f3rio de ve\u00edculo"),
    list(2017L, 50999L, "20303", e_veic, "Agregado do quadro 50 (documenta\u00e7\u00e3o e seguro de ve\u00edculos)"),
    list(2017L, 50005L, "27101", e_veic, "Emplacamento de caminh\u00e3o"),
    list(2017L, 50006L, "27101", e_veic, "Emplacamento de moto"),
    list(2017L, 50007L, "27101", e_veic, "Multas"),
    list(2017L, 50008L, "27101", e_veic, "Taxas do Detran"),
    list(2017L, 50017L, "27101", e_veic, "IPVA, seguro obrigat\u00f3rio e taxas"),
    list(2017L, 47003L, "26105", e_veic, "Aluguel de outros im\u00f3veis"),
    list(2017L, 47006L, "27101", e_veic, "IPTU de outros im\u00f3veis"),
    list(2017L, 47007L, "27101", e_veic, "ITR de outros im\u00f3veis"),
    list(2017L, 47027L, "28101", e_imov, "Cons\u00f3rcio de outros im\u00f3veis (presta\u00e7\u00e3o)"),
    list(2017L, 89001L, "21104", e_pap, "Papel higi\u00eanico")))
  data.table::setnames(x, c("ano", "codigo", "cod_final", "erro", "item"))
  x[]
}

# Reclassificacao por tipo de registro do pipeline HarmonizaPOF2026 (ver
# pof_correcoes()): INSS de empregado domestico e deducoes de rendimento.
.corrigir_tipo <- function(desp) {
  if (!"Tipo" %in% names(desp)) return(desp)
  desp[Tipo == "INSS", `:=`(cod_final = "27102", n1 = 27L)]
  desp[grepl("^Deducao", Tipo) & grepl("Previd", Tipo), `:=`(cod_final = "27102", n1 = 27L)]
  desp[grepl("^Deducao", Tipo) & !grepl("Previd", Tipo), `:=`(cod_final = "27101", n1 = 27L)]
  desp
}

#' Grandes grupos de consumo
#'
#' Tabela que associa cada Nível 1 da harmonização aos grupos de despesa do
#' IBGE. Na v2, a despesa de consumo é a soma dos Níveis 1 a 26; os Níveis 27
#' a 34 (outras despesas correntes, variação patrimonial, rendimentos e
#' inventário) ficam fora. Na versão inicial, os mesmos papéis cabem aos
#' Níveis 1 a 16 e 31 a 40 (consumo) e 41 a 47 e 88 (fora do consumo).
#'
#' @param versao `"v2"` ou `"inicial"`.
#' @return `data.table` com `n1`, `grupo` e `consumo` (lógico).
#' @export
#' @examples
#' pof_grupos()
pof_grupos <- function(versao = c("v2", "inicial")) {
  versao <- match.arg(versao)
  nomes <- c("Habita\u00e7\u00e3o", "Vestu\u00e1rio", "Transporte", "Higiene e cuidados pessoais",
             "Assist\u00eancia \u00e0 sa\u00fade", "Educa\u00e7\u00e3o", "Recrea\u00e7\u00e3o e cultura",
             "Servi\u00e7os pessoais", "Despesas diversas")
  if (versao == "v2") {
    data.table::data.table(
      n1 = 1:34,
      grupo = c(rep("Alimenta\u00e7\u00e3o", 16), "Habita\u00e7\u00e3o", nomes, "Outras despesas correntes",
                "Aumento do ativo", "Diminui\u00e7\u00e3o do passivo", rep("Rendimentos", 4), "Invent\u00e1rio"),
      consumo = c(rep(TRUE, 26), rep(FALSE, 8)))
  } else {
    data.table::data.table(
      n1 = c(1:16, 31:47, 88),
      grupo = c(rep("Alimenta\u00e7\u00e3o", 16), "Habita\u00e7\u00e3o", nomes, "Outras despesas correntes",
                "Aumento do ativo", "Diminui\u00e7\u00e3o do passivo", rep("Rendimentos", 4), "Invent\u00e1rio"),
      consumo = c(rep(TRUE, 26), rep(FALSE, 8)))
  }
}

#' @rdname pof_grupos
#' @export
pof_grupos_consumo <- function() unique(pof_grupos()[consumo == TRUE]$grupo)
