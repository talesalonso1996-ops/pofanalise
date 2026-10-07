#' Base sintética para exemplos e testes
#'
#' Gera uma base no formato de [pof_ler_edicao()] com dados simulados, para
#' rodar os exemplos sem os microdados. Os números não representam a POF.
#'
#' @param n Número de UCs.
#' @param semente Semente aleatória.
#' @return `data.table` com grupos somados, quintis, variáveis de perfil e
#'   um item de exemplo (`Jogos`).
#' @export
#' @examples
#' head(pof_exemplo())
pof_exemplo <- function(n = 2000, semente = 1) {
  set.seed(semente)
  b <- data.table::data.table(
    Edicao = "exemplo", id_uc = seq_len(n), Peso = stats::runif(n, 50, 150),
    RGMT = sample(c(1:11, NA), n, replace = TRUE),
    UPA = rep(seq_len(n / 4), each = 4), ESTRATO = rep(seq_len(n / 40), each = 40),
    N_moradores_UC = sample(1:6, n, replace = TRUE),
    Sexo_ref = sample(1:2, n, replace = TRUE), Idade_ref = sample(20:80, n, replace = TRUE),
    Cor_ref = sample(c(1, 2, 4), n, replace = TRUE))
  b[, UF := sample(c(11L, 23L, 35L, 43L, 53L), n, replace = TRUE)]
  b[, regiao := c("Norte", "Nordeste", "Sudeste", "Sul", "Centro-Oeste")[UF %/% 10]]
  b[, situacao := sample(c("Urbana", "Rural"), n, replace = TRUE, prob = c(0.85, 0.15))]
  renda <- stats::rlnorm(n, 7, 0.8) * b$N_moradores_UC
  alim <- "Alimenta\u00e7\u00e3o"; hab <- "Habita\u00e7\u00e3o"; edu <- "Educa\u00e7\u00e3o"
  data.table::set(b, j = alim, value = renda * stats::runif(n, 0.10, 0.35) * (1 - 0.3 * (renda > stats::median(renda))))
  data.table::set(b, j = hab, value = renda * stats::runif(n, 0.25, 0.40))
  b[, Transporte := renda * stats::runif(n, 0.05, 0.25)]
  data.table::set(b, j = edu, value = renda * stats::runif(n, 0, 0.08) * stats::rbinom(n, 1, 0.5))
  b[, Consumo := b[[alim]] + b[[hab]] + Transporte + b[[edu]]]
  b[, Consumo_pc := Consumo / N_moradores_UC]
  b[, Jogos := renda * 0.01 * stats::rbinom(n, 1, 0.12 + 0.05 * (Sexo_ref == 1))]
  pof_add_perfil(pof_add_quintis(b))
}
