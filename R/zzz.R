.onLoad <- function(libname, pkgname) {
  if (is.null(getOption("survey.lonely.psu"))) options(survey.lonely.psu = "adjust")
  invisible()
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Aviso: a harmoniza\u00e7\u00e3o v2 tem erros de classifica\u00e7\u00e3o conhecidos (condom\u00ednio, compra de im\u00f3veis, ",
    "celular e outros). O pacote aplica corre\u00e7\u00f5es provis\u00f3rias at\u00e9 que sejam corrigidos na origem: ",
    "veja ?pof_correcoes.")
}
