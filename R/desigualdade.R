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
#' acrescenta IC de 95% do Gini (percentis) por bootstrap de Rao-Wu: em cada
#' estrato com n UPAs sorteiam-se n - 1 UPAs com reposição e os pesos são
#' reescalonados. Os pesos não são recalibrados às projeções de população.
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
    # bootstrap de Rao-Wu: em cada estrato com n UPAs sorteiam-se n - 1 com
    # reposicao e os pesos sao multiplicados por n / (n - 1) vezes o numero
    # de vezes que a UPA saiu. Sortear n UPAs subestimaria a variancia
    # quando ha poucas UPAs por estrato (a mediana na POF 2017 e' 6).
    set.seed(semente)
    x_ <- b[[var]]; w0 <- b$Peso * b$N_moradores_UC
    upas <- unique(b[, .(ESTRATO, UPA)])[, n_h := .N, by = ESTRATO]
    pos <- match(paste(b$ESTRATO, b$UPA), paste(upas$ESTRATO, upas$UPA))
    g <- replicate(B, {
      upas[, m := if (.N > 1) tabulate(sample.int(.N, .N - 1, replace = TRUE), .N) * .N / (.N - 1) else 1,
           by = ESTRATO]
      wb <- w0 * upas$m[pos]
      pof_gini(x_[wb > 0], wb[wb > 0])
    })
    r[, `:=`(Gini_IC_inf = stats::quantile(g, 0.025), Gini_IC_sup = stats::quantile(g, 0.975))]
  }
  r[]
}
