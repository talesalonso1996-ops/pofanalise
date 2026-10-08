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

test_that("tabela de correcoes e integra", {
  cr <- pof_correcoes()
  expect_named(cr, c("ano", "codigo", "cod_final", "erro", "item"))
  expect_equal(anyDuplicated(cr[, .(ano, codigo)]), 0L)
  expect_true(all(cr$ano %in% c(1987L, 1995L, 2002L, 2008L, 2017L)))
  expect_true(all(grepl("^[0-9]{5}$", cr$cod_final)))
  expect_false(anyNA(cr))
})

test_that("condominio de 2008 volta para o consumo e pode ser desligado", {
  d <- tempfile(); dir.create(d)
  data.table::fwrite(data.table::data.table(
    ano = 2008, cod_final = c("27203", "26105"), nome_final = "x", descri_item = c("CONDOMINIO", "VALOR DE OUTRO IMOVEL ADQUIRIDO"),
    codigo = c("10004", "47094"), cod_harmo_antigo = "0", descr_harmo_antigo = "",
    qualidade = "Alta", confianca = 1, nota = ""), file.path(d, "produtos.csv"))
  data.table::fwrite(data.table::data.table(cod_final = c("27203", "26105"), n1 = c("27. Outras despesas correntes", "26. Despesas diversas"),
    n2 = "", nome = c("Outras despesas correntes", "Imoveis de uso ocasional"), qualidade = "Alta"), file.path(d, "folhas.csv"))
  h <- pof_harmonizacao(dir_local = d)
  expect_equal(h$depara[codigo == 10004]$cod_final, "17301")
  expect_equal(h$depara[codigo == 47094]$n1, 28L)
  expect_true(all(h$depara$corrigido))
  h0 <- pof_harmonizacao(dir_local = d, correcoes = FALSE)
  expect_equal(h0$depara[codigo == 10004]$n1, 27L)
})

test_that("INSS domestico e deducoes saem do consumo pelo tipo de registro", {
  desp <- data.table::data.table(Codigo = c(19001L, 19001L, 53001L, 53001L, 1L),
    Tipo = c("Despesa_Coletiva", "INSS", "Deducao_Individua_Previdencia_Pública", "Deducao_Individua_IR", NA),
    cod_final = c("18101", "18101", "30101", "30101", "01101"), n1 = c(18L, 18L, 30L, 30L, 1L))
  r <- pofanalise:::.corrigir_tipo(data.table::copy(desp))
  expect_equal(r$cod_final, c("18101", "27102", "27102", "27101", "01101"))
  expect_equal(r$n1, c(18L, 27L, 27L, 27L, 1L))
  sem_tipo <- desp[, -"Tipo"]
  expect_identical(pofanalise:::.corrigir_tipo(data.table::copy(sem_tipo)), sem_tipo)
})
