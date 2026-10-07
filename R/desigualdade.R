#' Quantil ponderado
#' @param x Valores.
#' @param w Pesos.
#' @param p Probabilidades.
#' @return Quantis.
#' @export
#' @examples
#' pof_quantil(1:10, rep(1, 10), c(0.1, 0.5, 0.9))
pof_quantil <- function(x, w, p) {
  o <- order(x); x <- x[o]; w <- w[o]; cw <- cumsum(w) / sum(w)
  vapply(p, function(pp) x[which(cw >= pp)[1]], numeric(1))
}

#' Coeficiente de Gini ponderado
#' @param x Valores (ex. consumo per capita).
#' @param w Pesos (ex. peso da UC vezes moradores).
#' @return Gini entre 0 e 1.
#' @export
#' @examples
#' pof_gini(c(1, 1, 1, 1), rep(1, 4))   # 0
#' pof_gini(c(0, 0, 0, 1), rep(1, 4))   # 0,75
pof_gini <- function(x, w) {
  o <- order(x); x <- x[o]; w <- w[o]
  W <- cumsum(w) / sum(w); L <- cumsum(x * w) / sum(x * w)
  1 - sum((W - c(0, utils::head(W, -1))) * (L + c(0, utils::head(L, -1))))
}

#' Medidas de desigualdade do consumo per capita
#'
#' Gini, razões P90/P10 e P90/P50 e parcela do consumo apropriada pelos 10%
#' de maior consumo, ponderadas por pessoa. Com `B > 0` e desenho amostral,
#' acrescenta IC de 95% do Gini por bootstrap de UPAs dentro de estrato (sem
#' recalibrar pesos).
#'
#' @param b Base de [pof_ler_edicao()].
#' @param var Variável (padrão: `Consumo_pc`).
#' @param B Réplicas de bootstrap (0 = sem IC).
#' @param semente Semente aleatória.
#' @return `data.table` de uma linha.
#' @export
#' @examples
#' pof_desigualdade(pof_exemplo())
pof_desigualdade <- function(b, var = "Consumo_pc", B = 0, semente = 20261007) {
  x <- b[[var]]; w <- b$Peso * b$N_moradores_UC
  q <- pof_quantil(x, w, c(0.1, 0.5, 0.9))
  o <- order(-x); top <- cumsum(w[o]) / sum(w) <= 0.10
  r <- data.table::data.table(Edicao = b$Edicao[1], Gini = pof_gini(x, w), P90_P10 = q[3] / q[1],
                              P90_P50 = q[3] / q[2], Top10 = 100 * sum((x * w)[o][top]) / sum(x * w),
                              Gini_IC_inf = NA_real_, Gini_IC_sup = NA_real_)
  if (B > 0 && all(c("UPA", "ESTRATO") %in% names(b))) {
    set.seed(semente)
    upas <- unique(b[, .(ESTRATO, UPA)])
    bb <- data.table::copy(b)[, `:=`(x_ = get(var), w_ = Peso * N_moradores_UC)]
    g <- replicate(B, {
      s <- upas[, .(UPA = sample(UPA, .N, replace = TRUE)), by = ESTRATO]
      a <- bb[s, on = .(ESTRATO, UPA), allow.cartesian = TRUE]
      pof_gini(a$x_, a$w_)
    })
    r[, `:=`(Gini_IC_inf = stats::quantile(g, 0.025), Gini_IC_sup = stats::quantile(g, 0.975))]
  }
  r[]
}
