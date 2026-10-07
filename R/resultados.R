#' Resultados agregados distribuídos com o pacote
#'
#' Tabelas geradas por `data-raw/gerar_resultados.R` a partir dos microdados
#' harmonizados (harmonização v2). Permitem reproduzir as vinhetas e o site
#' sem acesso aos microdados.
#'
#' @param nome Nome da tabela. Sem argumento, lista as disponíveis.
#' @return `data.table` (ou vetor de nomes).
#' @export
#' @examples
#' pof_resultado()
#' pof_resultado("desigualdade")
pof_resultado <- function(nome = NULL) {
  dir <- system.file("extdata", "resultados", package = "pofanalise")
  if (is.null(nome)) return(sub("[.]csv$", "", list.files(dir, pattern = "[.]csv$")))
  f <- file.path(dir, paste0(nome, ".csv"))
  if (!file.exists(f)) stop("Tabela inexistente: ", nome, ". Veja pof_resultado().")
  data.table::fread(f, sep = ";", encoding = "UTF-8")
}

#' Rótulos de Nível 1 e de folha
#'
#' Troca códigos de coluna (`n01`, `f17101`) pelos nomes da harmonização.
#'
#' @param x Vetor de códigos.
#' @return Vetor de rótulos (o próprio código quando não há rótulo).
#' @export
#' @examples
#' pof_rotulo(c("n07", "f17101", "Alimentação"))
pof_rotulo <- function(x) {
  r <- pof_resultado("rotulos")
  out <- r$Rotulo[match(x, r$Item)]
  ifelse(is.na(out), x, out)
}
