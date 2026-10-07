.onLoad <- function(libname, pkgname) {
  if (is.null(getOption("survey.lonely.psu"))) options(survey.lonely.psu = "adjust")
  invisible()
}
