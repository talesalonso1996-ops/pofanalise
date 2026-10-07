# ------------------------------------------------------------------
# data-raw/gerar_resultados_extras.R
# Analises feitas com a camada de pesquisa do pacote (pof_carregar,
# pof_analisar, pof_variacao, pof_concentracao, pof_decompor,
# pof_composicao, pof_modelo). Grava em inst/extdata/resultados/.
# Uso: Rscript data-raw/gerar_resultados_extras.R <pasta dos microdados>
# ------------------------------------------------------------------
suppressMessages({ library(pofanalise); library(data.table) })
args <- commandArgs(trailingOnly = TRUE)
dir_micro <- if (length(args)) args[1] else "c:/Users/Tales/Downloads/Pasta_Teste_VS/HarmonizaPOF2026_data"
dir_res <- file.path("inst", "extdata", "resultados")
salvar <- function(d, nome) fwrite(d, file.path(dir_res, paste0(nome, ".csv")), sep = ";")

dados <- pof_carregar(c(1987, 1995, 2002, 2008, 2017), dir_micro, itens = list(apostas = "26101"))
br <- dados[c("2002-2003", "2008-2009", "2017-2018")]

# itens analisados (folhas da v2) e grupos
folhas <- c(f17101 = "Aluguel", f17102 = "Energia elétrica", f17103 = "Gás doméstico", f17104 = "Água e esgoto",
            f17201 = "Telefone fixo", f17202 = "Telefone celular (serviço)", f20101 = "Transporte coletivo",
            f20201 = "Gasolina", f20301 = "Aquisição de veículos", f20302 = "Viagens",
            f22101 = "Remédios", f22301 = "Plano de saúde", f22202 = "Consulta médica", f22201 = "Dentista",
            f23101 = "Cursos regulares", f23102 = "Curso superior", f16104 = "Refeição",
            f25101 = "Fumo", f25102 = "Cabeleireiro", f24102 = "Diversões e esportes", f26101 = "Jogos e apostas",
            f19102 = "Roupa de mulher", f18202 = "Eletrodomésticos")
grupos <- pof_grupos_consumo()
nome <- function(x) ifelse(x %in% names(folhas), folhas[x], x)

# A. concentracao / progressividade (Brasil, consumo completo)
conc <- pof_concentracao(br, c(grupos, names(folhas)), recorte = "brasil", sem_aluguel = FALSE)
conc[, Nome := nome(Item)][, Tipo := fifelse(Item %in% grupos, "Grupo", "Item")]
salvar(conc, "concentracao")
conc_rms <- pof_concentracao(dados, c("Alimentação", "f22101", "f22301", "f20101", "f17102", "f17103", "f20301", "f23102"))
conc_rms[, Nome := nome(Item)]
salvar(conc_rms, "concentracao_rms")
print(conc[Edicao == "2017-2018"][order(K), .(Nome, C = round(C, 3), K = round(K, 3), Base40 = round(Base40, 1), Topo20 = round(Topo20, 1))])

# B. o que mudou de 2008 para 2017 (Brasil, consumo completo)
mud <- rbindlist(lapply(c(grupos, names(folhas)), function(it) {
  rp <- pof_variacao(pof_analisar(br[2:3], it, medida = "participacao", recorte = "brasil", sem_aluguel = FALSE), "2008-2009", "2017-2018")
  rv <- pof_variacao(pof_analisar(br[2:3], it, medida = "prevalencia", recorte = "brasil", sem_aluguel = FALSE), "2008-2009", "2017-2018")
  rbind(rp[, Medida := "participacao"], rv[, Medida := "prevalencia"])[, Item := it]
}))
mud[, Nome := nome(Item)][, Tipo := fifelse(Item %in% grupos, "Grupo", "Item")]
salvar(mud, "variacao_2008_2017")
print(mud[Medida == "participacao"][order(-abs(Diferenca)), .(Nome, De = round(De, 2), Para = round(Para, 2), Dif = round(Diferenca, 2), p = signif(p_valor, 2))][1:12])

# composicao da saude e da habitacao, Brasil
comp <- rbind(pof_composicao(br, "22", recorte = "brasil")[, Grupo_pai := "Assistência à saúde"],
              pof_composicao(br, "17", recorte = "brasil")[, Grupo_pai := "Serviços e taxas de habitação"])
salvar(comp, "composicao_saude_habitacao")

# C. decomposicao demografica (RMs, consumo sem aluguel)
dec <- list(); decg <- list()
for (it in c("Alimentação", "Assistência à saúde", "Educação", "Habitação", "Transporte")) for (pr in c("idade", "tamanho", "sexo")) {
  for (par in list(c("1995-1996", "2017-2018"), c("2002-2003", "2017-2018"))) {
    d <- pof_decompor(dados, it, por = pr, de = par[1], para = par[2])
    dec[[length(dec) + 1]] <- d$resumo
    decg[[length(decg) + 1]] <- d$grupos[, `:=`(Item = it, Por = pr, De = par[1], Para = par[2])]
  }
}
salvar(rbindlist(dec), "decomposicao")
salvar(rbindlist(decg), "decomposicao_grupos")
print(rbindlist(dec)[De == "1995-1996", .(Item, Por, Total = round(Variacao_total, 2), Comport = round(Efeito_comportamento, 2), Compos = round(Efeito_composicao, 2))])

# D. jogos e apostas
ja <- list()
ja$serie_rms <- pof_analisar(dados, "apostas")[, Recorte := "RMs"]
ja$serie_br <- pof_analisar(br, "apostas", recorte = "brasil")[, Recorte := "Brasil"]
for (pr in c("quintil", "sexo", "cor", "idade", "tamanho")) {
  ja[[paste0("prev_", pr)]] <- pof_analisar(br, "apostas", por = pr, recorte = "brasil")[, Corte := pr]
  ja[[paste0("part_", pr)]] <- pof_analisar(br, "apostas", medida = "participacao", por = pr, recorte = "brasil")[, Corte := pr]
}
salvar(rbindlist(ja[c("serie_rms", "serie_br")]), "apostas_serie")
salvar(rbindlist(ja[grep("^prev_", names(ja))]), "apostas_prevalencia_perfil")
salvar(rbindlist(ja[grep("^part_", names(ja))]), "apostas_participacao_perfil")
salvar(rbindlist(lapply(c("quintil", "sexo", "cor", "idade"), function(pr)
  pof_variacao(pof_analisar(br, "apostas", por = pr, recorte = "brasil"), "2002-2003", "2017-2018")[, Corte := pr])), "apostas_variacao")
mod <- pof_modelo(br, "apostas", ~ quintil + sexo + cor + idade + tamanho)
salvar(mod, "apostas_modelo")
salvar(pof_modelo(br[3], "apostas", ~ quintil + sexo + cor + idade + tamanho, tipo = "gasto"), "apostas_modelo_gasto")
salvar(pof_concentracao(br, "apostas", recorte = "brasil", sem_aluguel = FALSE), "apostas_concentracao")
print(mod[Edicao == "2017-2018"])
cat("\nOK\n")
