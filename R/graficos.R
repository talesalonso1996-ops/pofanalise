#' Tema, cores e formatação para gráficos e textos
#'
#' `pof_tema()` é o tema `ggplot2` usado nas análises. `pof_cores_edicao()`
#' devolve uma escala sequencial de azuis, do mais claro (1987) ao mais
#' escuro (2017). `pof_fmt()` formata números com vírgula decimal.
#'
#' @param base_size Tamanho base da fonte.
#' @param x Números.
#' @param casas Casas decimais.
#' @return Tema `ggplot2`, vetor nomeado de cores ou texto.
#' @export
#' @examples
#' pof_fmt(12.345)
#' pof_cores_edicao()
pof_tema <- function(base_size = 12) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) stop("Instale o ggplot2.")
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(), legend.position = "bottom",
                   plot.title = ggplot2::element_text(face = "bold"), plot.title.position = "plot",
                   plot.caption = ggplot2::element_text(color = "grey40", hjust = 0))
}

#' @rdname pof_tema
#' @export
pof_cores_edicao <- function() {
  c("1987-1988" = "#86b6ef", "1995-1996" = "#5598e7", "2002-2003" = "#2a78d6",
    "2008-2009" = "#1c5cab", "2017-2018" = "#0d366b")
}

#' @rdname pof_tema
#' @export
pof_fmt <- function(x, casas = 1) formatC(x, format = "f", digits = casas, decimal.mark = ",", big.mark = ".")
