ed <- function(sem, nome) { b <- pof_exemplo(semente = sem); b$Edicao <- nome; b }

test_that("resultado filtrado continua imprimivel", {
  r <- pof_analisar(pof_exemplo(), "Jogos", por = "sexo")
  expect_s3_class(plot(r[Grupo == "Homem"]), "ggplot")   # filtrar linhas preserva as escolhas
  ag <- r[, .(m = mean(Estimativa))]                       # agregar perde
  expect_output(print(ag))
  expect_error(plot(ag), "perdeu")
})

test_that("corte ausente numa edicao gera aviso e nao quebra", {
  a <- ed(1, "2002-2003"); a[, situacao := NA_character_]
  b <- ed(2, "2017-2018")
  expect_message(r <- pof_analisar(list(a, b), "Jogos", por = "situacao"), "sem a vari")
  expect_equal(unique(r$Edicao), "2017-2018")
})

test_that("variacao sem IC fica com significancia indefinida", {
  a <- ed(1, "1987-1988"); a[, UPA := NULL]
  r <- suppressWarnings(pof_analisar(list(a, ed(2, "2017-2018")), "Jogos", recorte = "brasil"))
  v <- suppressWarnings(pof_variacao(r, "1987-1988", "2017-2018"))
  expect_true(is.na(v$Significativa))
})

test_that("concentracao de item sem gasto devolve NA", {
  b <- pof_exemplo(); b[, zero := 0]
  k <- pof_concentracao(b, "zero")
  expect_true(is.na(k$K) && is.na(k$Classificacao))
})

test_that("mensagens claras para referencia, variavel e aluguel ausentes", {
  b <- pof_exemplo()
  expect_error(pof_diferenca(b, "Jogos", por = "sexo", referencia = "Homens"), "Categorias: Homem, Mulher")
  expect_error(pof_modelo(b, "Jogos", ~ renda), "renda")
  expect_error(pof_sem_aluguel(b, col_aluguel = "f17101"), "coluna do aluguel")
})

test_that("validar sem tabela oficial devolve vazio", {
  expect_message(v <- pof_validar(ed(1, "1995-1996")), "sem tabela oficial")
  expect_equal(nrow(v), 0)
})

test_that("deflacionar serie com 1987 deixa 1987 NA e avisa", {
  a <- ed(1, "1987-1988"); b <- ed(2, "2017-2018")
  r <- suppressWarnings(pof_analisar(list(a, b), "Jogos", medida = "gasto_medio", recorte = "brasil", sem_aluguel = FALSE))
  expect_warning(d <- pof_deflacionar(r), "cruzados")
  expect_true(is.na(d[Edicao == "1987-1988"]$Estimativa))
  expect_output(print(d), "IPCA")
})
