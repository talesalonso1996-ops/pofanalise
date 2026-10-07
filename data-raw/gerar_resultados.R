# ------------------------------------------------------------------
# data-raw/gerar_resultados.R
# Roda as analises do pacote sobre os microdados do HarmonizaPOF2026 e grava
# os resultados agregados em inst/extdata/resultados/, que alimentam as
# vinhetas e o site. Os microdados nao sao distribuidos com o pacote.
#
# Uso: Rscript data-raw/gerar_resultados.R <pasta dos microdados>
# ------------------------------------------------------------------
suppressMessages({ library(pofanalise); library(data.table) })
args <- commandArgs(trailingOnly = TRUE)
dir_micro <- if (length(args)) args[1] else "c:/Users/Tales/Downloads/Pasta_Teste_VS/HarmonizaPOF2026_data"
dir_res <- file.path("inst", "extdata", "resultados")
dir.create(dir_res, recursive = TRUE, showWarnings = FALSE)
# remove o desenho amostral quando so a estimativa pontual interessa
sem_ic <- function(x) { x <- copy(x); if ("UPA" %in% names(x)) x[, UPA := NULL]; x }
salvar <- function(d, nome) fwrite(d, file.path(dir_res, paste0(nome, ".csv")), sep = ";")

anos <- c(1987, 1995, 2002, 2008, 2017)
h2 <- pof_harmonizacao("v2")
h2_orig <- pof_harmonizacao("v2", correcoes = FALSE)

# Cod_harmo gravado nos microdados (harmonizacao antiga): de-para (codigo -> Cod_harmo)
# por edicao, numerado como a versao "inicial" (consumo = Niveis 1-16 e 31-40)
h0 <- list(versao = "inicial", folhas = data.table(cod_final = "31001", n1_num = 31L, nome = "Aluguel"),
           depara = rbindlist(lapply(c(1987, 1995, 2002, 2008, 2017), function(a) {
             d <- unique(fread(file.path(dir_micro, pof_arquivos(a)$despesas), select = c("Codigo", "Cod_harmo")))
             d <- unique(d, by = "Codigo")
             d[, .(ano = a, codigo = as.integer(Codigo), cod_final = sprintf("%05d", Cod_harmo), n1 = as.integer(Cod_harmo %/% 1000))]
           })))
grupos <- pof_grupos_consumo()
rms <- quote(!is.na(RGMT))

# folhas usadas nas analises tematicas (codigos da v2)
fo <- c(aluguel = "f17101", energia = "f17102", gas = "f17103", agua = "f17104",
        tel_fixo = "f17201", tel_celular = "f17202", outros_serv_hab = "f17301",
        transp_coletivo = "f20101", gasolina = "f20201", veiculo = "f20301",
        remedios = "f22101", plano_saude = "f22301", cursos_regulares = "f23101",
        curso_superior = "f23102", jogos_apostas = "f26101", refeicao = "f16104")

R <- list()
add <- function(nome, d) R[[nome]] <<- rbind(R[[nome]], d, fill = TRUE)

for (a in anos) {
  cat("\n=== ", a, " ===\n")
  b <- pof_somar_grupos(pof_ler_edicao(a, dir_micro, h2))
  add("mapeamento", data.table(Edicao = pof_edicao(a), versao = "v2 com correções", perc_casado = attr(b, "mapeamento")$perc_casado))
  b <- pof_add_quintis(b)
  bs <- pof_add_quintis(pof_sem_aluguel(b))
  bs_rm <- bs[!is.na(RGMT)]
  bs_rm_sem_ic <- sem_ic(bs_rm)
  bs[, RM := pof_rms()[as.character(RGMT)]]

  # 01 estrutura do orcamento
  add("grupos", pof_participacao(bs, grupos, filtro = rms)[, Recorte := "RMs, sem aluguel"])
  if (a >= 2002) add("grupos", pof_participacao(b, grupos)[, Recorte := "Brasil"])
  add("grupos_rm", pof_participacao(sem_ic(bs[!is.na(RGMT)]), grupos, por = "RM"))
  add("n1_rms", pof_participacao(bs_rm_sem_ic, sprintf("n%02d", 1:26)))

  # 02 quintis e Engel
  add("quintis_rms", pof_participacao(bs_rm_sem_ic, grupos, por = "Quintil_RM"))
  if (a >= 2002) add("quintis_brasil", pof_participacao(bs, grupos, por = "Quintil"))
  add("engel", pof_engel(bs_rm, grupos))

  # 03 alimentacao: participacao das 16 categorias dentro da alimentacao
  add("alimentacao_rms", pof_participacao(bs_rm_sem_ic, c(sprintf("n%02d", 1:16), "f16104"), den = "Alimentação"))
  if (a == 2017) add("alimentacao_quintil_2017", pof_participacao(sem_ic(bs), c(sprintf("n%02d", 1:16), "f16104"), por = "Quintil", den = "Alimentação"))

  # 04 habitacao e transporte (aluguel sobre o consumo completo)
  itens_ht <- fo[c("energia", "gas", "agua", "tel_fixo", "tel_celular", "outros_serv_hab", "transp_coletivo", "gasolina", "veiculo")]
  add("itens_rms", pof_participacao(bs_rm_sem_ic, c("Habitação", "Transporte", itens_ht)))
  add("itens_rms", pof_participacao(sem_ic(b[!is.na(RGMT)]), fo["aluguel"]))
  add("itens_quintil_rms", pof_participacao(bs_rm_sem_ic, c("Habitação", "Transporte", fo[c("transp_coletivo", "veiculo")]), por = "Quintil_RM"))
  for (v in fo[c("transp_coletivo", "veiculo")]) add("prevalencia_rms", pof_prevalencia(bs_rm_sem_ic, v))
  add("prevalencia_rms", pof_prevalencia(sem_ic(b[!is.na(RGMT)]), fo[["aluguel"]]))

  # 05 saude e educacao
  vse <- c("Assistência à saúde", fo[c("remedios", "plano_saude")], "Educação", fo[c("cursos_regulares", "curso_superior")])
  add("saude_educacao_quintil_rms", pof_participacao(bs_rm_sem_ic, vse, por = "Quintil_RM"))
  if (a >= 2002) for (v in fo[c("plano_saude", "cursos_regulares", "curso_superior")])
    add("prevalencia_quintil_brasil", pof_prevalencia(bs, v, por = "Quintil"))

  # 06 desigualdade
  add("desigualdade", pof_desigualdade(bs_rm)[, Recorte := "RMs"])
  if (a >= 2002) add("desigualdade", pof_desigualdade(bs, B = 200)[, Recorte := "Brasil"])
  for (r in sort(unique(bs_rm$RGMT))) add("desigualdade_rm", pof_desigualdade(bs_rm[RGMT == r])[, RM := pof_rms()[as.character(r)]])

  # 07 perfil da UC
  p <- copy(bs_rm_sem_ic)
  p[, `:=`(Sexo = fifelse(Sexo_ref == 1, "Homem", fifelse(Sexo_ref == 2, "Mulher", NA_character_)),
           Faixa_etaria = as.character(cut(Idade_ref, c(0, 29, 44, 59, 200), labels = c("Até 29", "30 a 44", "45 a 59", "60 ou mais"))),
           Cor = fcase(Cor_ref == 1, "Branca", Cor_ref %in% c(2, 4), "Preta ou parda", default = NA_character_),
           Tamanho = fcase(N_moradores_UC == 1, "1 morador", N_moradores_UC == 2, "2 moradores",
                           N_moradores_UC <= 4, "3 a 4 moradores", default = "5 ou mais moradores"))]
  media <- weighted.mean(p$Consumo_pc, p$Peso * p$N_moradores_UC)
  for (d in c("Sexo", "Faixa_etaria", "Cor", "Tamanho")) {
    x <- p[!is.na(get(d))]
    if (!nrow(x)) next
    add("perfil_participacao", pof_participacao(x, c("Alimentação", "Habitação", "Transporte", "Educação", "Assistência à saúde"), por = d)[, Dimensao := d])
    add("perfil_indice", x[, .(Indice_consumo_pc = 100 * weighted.mean(Consumo_pc, Peso * N_moradores_UC) / media,
                               Perc_UCs = sum(Peso)), by = .(Nivel = get(d))][, Perc_UCs := 100 * Perc_UCs / sum(Perc_UCs)][, `:=`(Edicao = pof_edicao(a), Dimensao = d)])
  }

  # jogos e apostas (prevalencia, para o catalogo)
  if (a >= 2002) add("jogos_apostas", pof_prevalencia(b, fo[["jogos_apostas"]]))

  # comparacao entre versoes da harmonizacao (mesmo conceito de consumo)
  comparar <- function(bb, rotulo, col_al) {
    bbs <- pof_sem_aluguel(bb, col_aluguel = col_al)
    add("comparacao_versoes", pof_participacao(sem_ic(bbs[!is.na(RGMT)]), grupos)[, `:=`(versao = rotulo, Recorte = "RMs, sem aluguel")])
    if (a >= 2002) add("comparacao_versoes", pof_participacao(sem_ic(bb), grupos)[, `:=`(versao = rotulo, Recorte = "Brasil")])
  }
  b0 <- pof_somar_grupos(pof_ler_edicao(a, dir_micro, h0, folhas = "31001"))
  add("mapeamento", data.table(Edicao = pof_edicao(a), versao = "Cod_harmo antigo", perc_casado = attr(b0, "mapeamento")$perc_casado))
  comparar(b0, "Cod_harmo antigo", "f31001"); rm(b0)
  bo <- pof_somar_grupos(pof_ler_edicao(a, dir_micro, h2_orig, folhas = "17101"))
  comparar(bo, "v2 original", "f17101"); rm(bo)
  comparar(b, "v2 com correções", "f17101")
  rm(b, bs, p); invisible(gc())
}

# rotulos das categorias de Nivel 1 e das folhas
rot <- unique(h2$folhas[, .(Item = sprintf("n%02d", n1_num), Rotulo = sub("^[0-9]+[.] ", "", n1))])
rot <- rbind(rot, h2$folhas[, .(Item = paste0("f", cod_final), Rotulo = nome)])
salvar(rot, "rotulos")
for (nm in names(R)) salvar(R[[nm]], nm)

# comparacao com o IBGE (Brasil, consumo completo)
oficial <- data.table(
  Nivel = "Total",
  Item = c("Alimentação", "Habitação", "Vestuário", "Transporte", "Higiene e cuidados pessoais",
           "Assistência à saúde", "Educação", "Recreação e cultura", "Serviços pessoais", "Despesas diversas"),
  Oficial_2008 = c(19.8, 35.9, NA, 19.6, NA, NA, NA, NA, NA, NA),
  Oficial_2017 = c(17.5, 36.6, 4.3, 18.1, 3.6, 8.0, 4.7, 2.6, 1.8, 3.0))
cmp <- dcast(R$comparacao_versoes[Recorte == "Brasil" & Edicao %in% c("2008-2009", "2017-2018")],
             Item ~ versao + Edicao, value.var = "Perc")
cmp <- merge(oficial[, -"Nivel"], cmp, by = "Item")
salvar(cmp, "comparacao_ibge")
print(cmp)
print(R$mapeamento)
cat("\nResultados gravados em", normalizePath(dir_res), "\n")
