ed <- function(sem, nome) { b <- pof_exemplo(semente = sem); b$Edicao <- nome; b }
dois <- list(ed(1, "2008-2009"), ed(2, "2017-2018"))

test_that("pof_variacao calcula diferenca com IC e p-valor", {
  r <- pof_analisar(dois, "Jogos", por = "sexo")
  v <- pof_variacao(r, "2008-2009", "2017-2018")
  expect_equal(nrow(v), 2)
  expect_equal(v$Diferenca, v$Para - v$De)
  expect_true(all(v$IC_inf < v$Diferenca & v$Diferenca < v$IC_sup))
  expect_error(pof_variacao(r, "1987-1988", "2017-2018"))
})

test_that("pof_concentracao: item proporcional ao consumo tem K = 0", {
  b <- pof_exemplo()
  b[, prop := Consumo * 0.1]
  k <- pof_concentracao(b, c("prop", "Alimentação", "Educação"))
  expect_equal(k[Item == "prop"]$K, 0, tolerance = 1e-10)
  expect_lt(k[Item == "Alimentação"]$K, 0)      # simulado como necessidade
  expect_true(all(k$Base40 + k$Topo20 < 100))
})

test_that("pof_decompor: efeitos somam a variacao total", {
  d <- pof_decompor(dois, "Alimentação", por = "tamanho", de = "2008-2009", para = "2017-2018")
  r <- d$resumo
  expect_equal(r$Efeito_comportamento + r$Efeito_composicao, r$Variacao_total, tolerance = 1e-10)
  expect_equal(nrow(d$grupos), 4)
})

test_that("pof_elasticidade por grupo e pof_tabela", {
  e <- pof_elasticidade(pof_exemplo(), "Alimentação", por = "sexo")
  expect_equal(sort(e$Grupo), c("Homem", "Mulher"))
  t <- pof_tabela(pof_analisar(dois, "Jogos", por = "quintil"))
  expect_equal(names(t), c("Grupo", "2008-2009", "2017-2018"))
  f <- tempfile(fileext = ".csv"); pof_exportar(t, f); expect_true(file.exists(f))
})
