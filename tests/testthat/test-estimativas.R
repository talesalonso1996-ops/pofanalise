test_that("Gini tem os valores conhecidos", {
  expect_equal(pof_gini(c(1, 1, 1, 1), rep(1, 4)), 0)
  expect_equal(pof_gini(c(0, 0, 0, 1), rep(1, 4)), 0.75)
  # pesos inteiros equivalem a repetir observacoes
  expect_equal(pof_gini(c(1, 3), c(2, 1)), pof_gini(c(1, 1, 3), c(1, 1, 1)))
})

test_that("quintis dividem a populacao ponderada em cinco partes", {
  q <- pof_quintil(1:100, rep(1, 100))
  expect_equal(as.vector(table(q)), rep(20, 5))
  expect_true(all(diff(q) >= 0))
})

test_that("quantil ponderado", {
  expect_equal(pof_quantil(1:10, rep(1, 10), 0.5), 5)
})

test_that("participacoes somam 100 quando os itens esgotam o consumo", {
  b <- pof_exemplo()
  p <- pof_participacao(b, c("Alimentação", "Habitação", "Transporte", "Educação"), ic = FALSE)
  expect_equal(sum(p$Perc), 100)
})

test_that("IC da participacao contem a estimativa pontual", {
  b <- pof_exemplo()
  p <- pof_participacao(b, "Alimentação", por = "Quintil")
  expect_equal(nrow(p), 5)
  expect_true(all(p$IC_inf <= p$Perc & p$Perc <= p$IC_sup))
})

test_that("filtro restringe o recorte", {
  b <- pof_exemplo()
  p <- pof_participacao(b, "Alimentação", filtro = quote(!is.na(RGMT)), ic = FALSE)
  expect_equal(p$N_UC, sum(!is.na(b$RGMT)))
})

test_that("prevalencia fica entre 0 e 100", {
  v <- pof_prevalencia(pof_exemplo(), "Educação")
  expect_true(v$Perc > 0 && v$Perc < 100)
  expect_true(v$IC_inf < v$Perc && v$Perc < v$IC_sup)
})

test_that("Engel: alimentacao com elasticidade menor que 1 no exemplo", {
  e <- pof_engel(pof_exemplo(), c("Alimentação", "Habitação"))
  expect_lt(e[Grupo == "Alimentação"]$elasticidade, 1)
})

test_that("grupos de consumo cobrem os Niveis 1 a 26 na v2", {
  g <- pof_grupos()
  expect_equal(g[consumo == TRUE]$n1, 1:26)
  expect_equal(g[n1 %in% 17:18]$grupo, c("Habitação", "Habitação"))
  gi <- pof_grupos("inicial")
  expect_equal(gi[consumo == TRUE]$n1, c(1:16, 31:40))
})

test_that("pof_analisar devolve uma linha por grupo com IC", {
  r <- pof_analisar(pof_exemplo(), "Jogos", medida = "prevalencia", por = "quintil")
  expect_s3_class(r, "pof_analise")
  expect_equal(nrow(r), 5)
  expect_true(all(r$IC_inf <= r$Estimativa & r$Estimativa <= r$IC_sup))
  expect_equal(attr(r, "escolhas")$recorte, "brasil")
  expect_s3_class(plot(r), "ggplot")
})

test_that("pof_analisar: participacao e gasto medio", {
  b <- pof_exemplo()
  expect_equal(nrow(pof_analisar(b, "Educação", medida = "participacao")), 1)
  g <- pof_analisar(b, "Jogos", medida = "gasto_medio", por = "sexo")
  expect_equal(sort(g$Grupo), c("Homem", "Mulher"))
})

test_that("pof_diferenca detecta a diferenca simulada entre sexos", {
  d <- pof_diferenca(pof_exemplo(n = 4000), "Jogos", por = "sexo", referencia = "Mulher")
  expect_equal(d$Grupo, "Homem")
  expect_gt(d$Diferenca, 0)
})

test_that("pof_modelo devolve razoes de chance", {
  m <- pof_modelo(pof_exemplo(), "Jogos", ~ quintil + sexo)
  expect_true("sexoMulher" %in% m$Termo)
  expect_true(all(m$Estimativa > 0))
})
