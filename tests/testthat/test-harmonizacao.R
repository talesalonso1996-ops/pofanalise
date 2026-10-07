test_that("de-para resolve codigos ambiguos e normaliza zeros a esquerda", {
  d <- tempfile(); dir.create(d)
  data.table::fwrite(data.table::data.table(
    ano = c(2017, 2017, 2017, 2017), cod_final = c("09106", "09106", "09108", "16104"),
    nome_final = "x", descri_item = c("a", "b", "c", "d"), codigo = c("07031", "07031", "07031", "24058"),
    cod_harmo_antigo = "0", descr_harmo_antigo = "", qualidade = "Alta", confianca = 1, nota = ""),
    file.path(d, "produtos.csv"))
  data.table::fwrite(data.table::data.table(cod_final = c("09106", "09108", "16104"),
    n1 = c("9. Pescados", "9. Pescados", "16. Outros produtos"), n2 = "", nome = c("p", "q", "Refeição"),
    qualidade = "Alta"), file.path(d, "folhas.csv"))
  h <- pof_harmonizacao(dir_local = d)
  expect_equal(h$depara[codigo == 7031]$cod_final, "09106")
  expect_true(h$depara[codigo == 7031]$ambiguo)
  expect_equal(h$depara[codigo == 24058]$n1, 16L)
})

test_that("correcoes do quadro 44 de 2017 sao aplicadas e podem ser desligadas", {
  d <- tempfile(); dir.create(d)
  data.table::fwrite(data.table::data.table(
    ano = 2017, cod_final = c("26102", "26102"), nome_final = "x", descri_item = c("conta", "aparelho"),
    codigo = c("44002", "44004"), cod_harmo_antigo = "0", descr_harmo_antigo = "",
    qualidade = "Alta", confianca = 1, nota = ""), file.path(d, "produtos.csv"))
  data.table::fwrite(data.table::data.table(cod_final = "26102", n1 = "26. Despesas diversas", n2 = "",
    nome = "Comunicação (outros)", qualidade = "Média"), file.path(d, "folhas.csv"))
  h <- pof_harmonizacao(dir_local = d)
  expect_equal(h$depara[codigo == 44002]$cod_final, "17202")
  expect_equal(h$depara[codigo == 44004]$n1, 24L)
  h0 <- pof_harmonizacao(dir_local = d, correcoes = FALSE)
  expect_equal(h0$depara[codigo == 44002]$cod_final, "26102")
})
