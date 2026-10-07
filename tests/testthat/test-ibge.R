test_that("tabelas oficiais estao completas e coerentes", {
  o <- pof_ibge()
  expect_setequal(unique(o$Edicao), c("2008-2009", "2017-2018"))
  b17 <- pof_ibge("2017-2018", "Brasil")
  expect_equal(b17[Grupo_ibge == "Despesa total" & is.na(Item_ibge)]$Valor, 4649.03)
  expect_equal(b17[Grupo_ibge == "Despesas de consumo" & is.na(Item_ibge)]$Valor, 3764.51)
  # os grupos de consumo somam a despesa de consumo publicada
  grupos <- c("Alimentação", "Habitação", "Vestuário", "Transporte", "Higiene e cuidados pessoais",
              "Assistência à saúde", "Educação", "Recreação e cultura", "Fumo", "Serviços pessoais", "Despesas diversas")
  for (ed in c("2008-2009", "2017-2018")) {
    x <- pof_ibge(ed, "Brasil")
    expect_equal(sum(x[Grupo_ibge %in% grupos & is.na(Item_ibge)]$Valor),
                 x[Grupo_ibge == "Despesas de consumo" & is.na(Item_ibge)]$Valor, tolerance = 0.01)
  }
})

test_that("mapa IBGE usa so colunas que o pacote produz", {
  m <- pof_mapa_ibge()
  expect_false(any(duplicated(m[, .(Grupo_ibge, Item_ibge)])))
  vars <- unique(unlist(lapply(m$expr, function(e) all.vars(parse(text = e)))))
  ok <- grepl("^(f[0-9]{5}|n[0-9]{2})$", vars) | vars %in% c("Consumo", pof_grupos_consumo())
  expect_true(all(ok))
  # toda folha citada existe na harmonizacao v2 (tabela de rotulos do pacote)
  fol <- grep("^f", vars, value = TRUE)
  expect_true(all(fol %in% pof_resultado("rotulos")$Item))
})

test_that("IPCA e deflacionamento", {
  expect_equal(pof_deflacionar(100, de = "201801"), 100)
  ip <- pof_ipca()
  f <- ip[mes == "201801"]$ipca / ip[mes == "200901"]$ipca
  expect_equal(pof_deflacionar(100, de = "2008-2009"), 100 * f)
  expect_error(pof_deflacionar(100, de = "1987-1988"))
  a <- pof_exemplo(semente = 1); a$Edicao <- "2008-2009"
  r <- pof_analisar(a, "Jogos", medida = "gasto_medio")
  rd <- pof_deflacionar(r)
  expect_equal(rd$Estimativa, r$Estimativa * f)
  expect_error(pof_deflacionar(pof_analisar(a, "Jogos")))
})

test_that("cortes de regiao e situacao", {
  r <- pof_analisar(pof_exemplo(), "Jogos", por = "regiao")
  expect_setequal(r$Grupo, c("Norte", "Nordeste", "Sudeste", "Sul", "Centro-Oeste"))
  expect_equal(nrow(pof_analisar(pof_exemplo(), "Jogos", por = "situacao")), 2)
})
