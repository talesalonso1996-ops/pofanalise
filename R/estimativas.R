#' Desenho amostral da POF
#'
#' Monta o desenho amostral (`survey::svydesign`) com UPA e estrato quando a
#' base os tem (2002 em diante). Para 1987 e 1995 devolve `NULL`.
#'
#' @param b Base de [pof_ler_edicao()].
#' @return Objeto `survey.design2` ou `NULL`.
#' @export
pof_desenho <- function(b) {
  if (!all(c("UPA", "ESTRATO") %in% names(b))) return(NULL)
  # estratos com uma unica UPA (comuns em recortes pequenos): variancia
  # centrada na media geral, a opcao conservadora do survey
  if (is.null(getOption("survey.lonely.psu"))) options(survey.lonely.psu = "adjust")
  survey::svydesign(ids = ~UPA, strata = ~ESTRATO, weights = ~Peso, data = b, nest = TRUE)
}

.niveis <- function(b, por, sel) {
  if (is.null(por)) return(list(Total = sel))
  nv <- sort(unique(b[[por]][sel]))
  stats::setNames(lapply(nv, function(v) sel & b[[por]] %in% v), as.character(nv))
}

.sel <- function(b, filtro) {
  if (is.null(filtro)) return(rep(TRUE, nrow(b)))
  s <- eval(filtro, b, parent.frame(2))
  s & !is.na(s)
}

#' Participação no consumo
#'
#' Razão entre a soma ponderada de cada variável e a soma ponderada do
#' denominador (por padrão, `Consumo`), em percentual. Com desenho amostral,
#' o intervalo de confiança de 95% vem de `survey::svyratio`, com o desenho
#' definido na base inteira e o recorte aplicado por `subset()`.
#'
#' @param b Base de [pof_ler_edicao()].
#' @param vars Colunas do numerador.
#' @param por Coluna de agrupamento (opcional).
#' @param filtro Expressão de recorte, ex. `quote(!is.na(RGMT))`.
#' @param den Coluna do denominador.
#' @param ic Calcular IC quando houver desenho.
#' @return `data.table` com `Edicao`, `Nivel`, `Item`, `N_UC`, `Perc`,
#'   `IC_inf`, `IC_sup`.
#' @export
#' @examples
#' b <- pof_exemplo()
#' pof_participacao(b, c("Alimentação", "Habitação"), por = "Quintil")
pof_participacao <- function(b, vars, por = NULL, filtro = NULL, den = "Consumo", ic = TRUE) {
  sel <- .sel(b, filtro)
  des <- if (ic) pof_desenho(b) else NULL
  out <- list()
  for (nv in names(niv <- .niveis(b, por, sel))) {
    idx <- niv[[nv]]
    sub <- b[idx]
    for (v in vars) {
      p <- 100 * sum(sub[[v]] * sub$Peso) / sum(sub[[den]] * sub$Peso)
      li <- ls <- NA_real_
      if (!is.null(des)) {
        r <- tryCatch(stats::confint(survey::svyratio(stats::as.formula(paste0("~`", v, "`")),
                                                      stats::as.formula(paste0("~`", den, "`")),
                                                      subset(des, idx))), error = function(e) NULL)
        if (!is.null(r)) { li <- 100 * r[1]; ls <- 100 * r[2] }
      }
      out[[length(out) + 1]] <- data.table::data.table(Edicao = b$Edicao[1], Nivel = nv, Item = v,
                                                       N_UC = nrow(sub), Perc = p, IC_inf = li, IC_sup = ls)
    }
  }
  data.table::rbindlist(out)
}

#' Prevalência de gasto
#'
#' Percentual ponderado de UCs com gasto positivo na variável, com IC de 95%
#' (`survey::svymean`) quando há desenho amostral.
#'
#' A prevalência depende do período de referência com que o item é
#' investigado na POF: 7 dias (caderneta de despesa coletiva, alimentos e
#' artigos de limpeza), 30 ou 90 dias (serviços e despesas individuais
#' frequentes) ou 12 meses (bens duráveis, viagens, cursos). Uma UC sem
#' gasto no período pode gastar fora dele. Compare prevalências do mesmo
#' item entre edições e grupos, não entre itens com períodos diferentes.
#'
#' @inheritParams pof_participacao
#' @param var Coluna de gasto.
#' @return `data.table` com `Edicao`, `Nivel`, `Item`, `N_UC`, `Perc`,
#'   `IC_inf`, `IC_sup`.
#' @export
#' @examples
#' b <- pof_exemplo()
#' pof_prevalencia(b, "Educação", por = "Quintil")
pof_prevalencia <- function(b, var, por = NULL, filtro = NULL, ic = TRUE) {
  b <- data.table::copy(b)
  b[, tem_ := as.numeric(get(var) > 0)]
  sel <- .sel(b, filtro)
  des <- if (ic) pof_desenho(b) else NULL
  niv <- .niveis(b, por, sel)
  data.table::rbindlist(lapply(names(niv), function(nv) {
    idx <- niv[[nv]]; sub <- b[idx]
    p <- 100 * sum(sub$tem_ * sub$Peso) / sum(sub$Peso)
    li <- ls <- NA_real_
    if (!is.null(des)) {
      r <- tryCatch(stats::confint(survey::svymean(~tem_, subset(des, idx))), error = function(e) NULL)
      if (!is.null(r)) { li <- 100 * r[1]; ls <- 100 * r[2] }
    }
    data.table::data.table(Edicao = b$Edicao[1], Nivel = nv, Item = var, N_UC = nrow(sub),
                           Perc = p, IC_inf = li, IC_sup = ls)
  }))
}

#' Quintis ponderados
#'
#' Classifica cada UC no quintil da variável (por padrão, consumo per
#' capita), com peso por pessoa (peso da UC vezes moradores).
#'
#' @param x Variável de ordenação.
#' @param w Pesos.
#' @param k Número de grupos (5 = quintis).
#' @return Inteiro de 1 a `k`.
#' @export
#' @examples
#' pof_quintil(c(10, 20, 30, 40, 50), rep(1, 5))
pof_quintil <- function(x, w, k = 5L) {
  o <- order(x); cw <- cumsum(w[o]) / sum(w[o])
  q <- integer(length(x)); q[o] <- pmin(k, as.integer(ceiling(cw * k - 1e-9)))
  pmax(q, 1L)
}

#' Acrescenta quintis de consumo per capita
#'
#' Cria `Quintil` (base inteira) e `Quintil_RM` (só regiões metropolitanas).
#'
#' @param b Base de [pof_ler_edicao()].
#' @return A base com as colunas de quintil.
#' @export
pof_add_quintis <- function(b) {
  b[, Quintil := pof_quintil(Consumo_pc, Peso * N_moradores_UC)]
  b[!is.na(RGMT), Quintil_RM := pof_quintil(Consumo_pc, Peso * N_moradores_UC)]
  b[]
}

#' Curva de Engel (Working-Leser)
#'
#' Estima, por mínimos quadrados ponderados pelo peso amostral,
#' \deqn{w_i = \alpha + \beta \ln(c) + \gamma \ln(n) + \varepsilon,}
#' em que \eqn{w_i} é a participação do grupo no consumo da UC, \eqn{c} o
#' consumo per capita e \eqn{n} o número de moradores. A elasticidade-despesa
#' na média é \eqn{1 + \beta / \bar{w}}. Com desenho amostral (2002 em
#' diante), o erro-padrão de \eqn{\beta} vem de `survey::svyglm`; sem ele,
#' do MQO ponderado.
#'
#' @param b Base com grupos somados.
#' @param grupos Colunas de grupo.
#' @return `data.table` com `Edicao`, `Grupo`, `beta`, `ep`, `w_medio`,
#'   `elasticidade`, `R2`, `N`.
#' @export
pof_engel <- function(b, grupos) {
  ln_c <- log(b$Consumo_pc); ln_n <- log(b$N_moradores_UC)
  des <- pof_desenho(b)
  data.table::rbindlist(lapply(grupos, function(g) {
    w <- b[[g]] / b$Consumo
    m <- stats::lm(w ~ ln_c + ln_n, weights = b$Peso)
    co <- summary(m)$coefficients
    # com desenho amostral, o erro-padrao vem de svyglm (mesma estimativa
    # pontual do MQO ponderado, variancia que respeita estratos e UPAs)
    ep <- co["ln_c", 2]
    if (!is.null(des)) {
      d2 <- stats::update(des, w_ = w, ln_c_ = ln_c, ln_n_ = ln_n)
      ep <- summary(survey::svyglm(w_ ~ ln_c_ + ln_n_, design = d2))$coefficients["ln_c_", 2]
    }
    wm <- stats::weighted.mean(w, b$Peso)
    data.table::data.table(Edicao = b$Edicao[1], Grupo = g, beta = co["ln_c", 1], ep = ep,
                           w_medio = 100 * wm, elasticidade = 1 + co["ln_c", 1] / wm,
                           R2 = summary(m)$r.squared, N = nrow(b))
  }))
}
