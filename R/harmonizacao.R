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
                             correcoes = TRUE) {
  versao <- match.arg(versao)
  sub <- if (versao == "v2") "data" else "inicial/data"
  if (is.null(dir_local)) {
    dir_local <- file.path(cache, paste0("harmoniza_", versao, "_", substr(ref, 1, 12)))
    dir.create(dir_local, recursive = TRUE, showWarnings = FALSE)
    for (f in c("produtos.csv", "folhas.csv")) {
      dest <- file.path(dir_local, f)
      if (!file.exists(dest)) {
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

#' Correções aplicadas à harmonização v2
#'
#' Ajustes pontuais no de-para v2, encontrados ao comparar os resultados com
#' os números oficiais do IBGE. Cada linha diz o código original do produto,
#' a folha de destino e o motivo. São aplicados por [pof_harmonizacao()]
#' com `correcoes = TRUE` (padrão) e foram reportados ao autor da
#' harmonização.
#'
#' * **2017, quadro 44 (telefonia celular).** Na v2 os itens vão para
#'   `26102 Comunicação (outros)`, em Despesas diversas. Contas e cartões de
#'   celular passam para `17202 Telefone celular (plano/serviço)`, em
#'   Habitação, como nas edições anteriores e no IBGE; aparelho e acessórios
#'   passam para `24201 Telefone celular e acessórios (aquisição)`.
#'
#' @return `data.table` com `ano`, `codigo`, `cod_final` e `motivo`.
#' @export
#' @examples
#' pof_correcoes()
pof_correcoes <- function() {
  data.table::data.table(
    ano = 2017L,
    codigo = c(44001L, 44002L, 44003L, 44007L, 44004L, 44006L),
    cod_final = c("17202", "17202", "17202", "17202", "24201", "24201"),
    motivo = c("Cart\u00e3o de telefonia celular", "Conta de celular (voz e internet)",
               "Conta de celular (internet)", "Pacote de voz",
               "Aparelho de telefone celular", "Acess\u00f3rios de telefone celular"))
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
