# ------------------------------------------------------------------
# data-raw/verificar_microdados.R
# Bateria de verificacao com os microdados reais: roda cada funcao publica
# e confere invariantes (somas, intervalos, consistencia entre funcoes e
# com o IBGE). Imprime um relatorio PASSOU/FALHOU e grava
# inst/extdata/resultados/verificacao.csv.
# Uso: Rscript data-raw/verificar_microdados.R <pasta dos microdados>
# ------------------------------------------------------------------
suppressMessages({ library(pofanalise); library(data.table) })
args <- commandArgs(trailingOnly = TRUE)
dir_micro <- if (length(args)) args[1] else "c:/Users/Tales/Downloads/Pasta_Teste_VS/HarmonizaPOF2026_data"
R <- list()
checar <- function(nome, ok, detalhe = "") {
  ok <- isTRUE(all(ok))
  R[[length(R) + 1]] <<- data.table(Teste = nome, Resultado = if (ok) "PASSOU" else "FALHOU", Detalhe = detalhe)
  cat(sprintf("[%s] %s %s\n", if (ok) "ok" else "FALHOU", nome, detalhe))
}
tol <- 1e-6

h <- pof_harmonizacao()
checar("harmonização v2 com 307 folhas", nrow(h$folhas) == 307)
checar("correções aplicadas ao de-para", h$correcoes && all(h$depara[corrigido == TRUE, .N] == nrow(pof_correcoes())))

dados <- pof_carregar(c(1995, 2008, 2017), dir_micro, itens = list(apostas = "26101", celular = c("17202", "24201")))
for (b in dados) {
  ed <- b$Edicao[1]
  checar(paste(ed, "100% do valor casa com o de-para"), abs(attr(b, "mapeamento")$perc_casado - 100) < tol,
         sprintf("(%.4f%%)", attr(b, "mapeamento")$perc_casado))
  g <- pof_grupos_consumo()
  checar(paste(ed, "soma dos grupos = consumo"), max(abs(rowSums(b[, ..g]) - b$Consumo)) < 1e-6)
  checar(paste(ed, "item composto = soma das folhas"), max(abs(b$celular - b$f17202 - b$f24201)) < 1e-6)
  rec <- if (ed == "1995-1996") "rms" else "brasil"
  p <- pof_participacao(if (rec == "rms") b[!is.na(RGMT)] else b, g, ic = FALSE)
  checar(paste(ed, "participações dos grupos somam 100"), abs(sum(p$Perc) - 100) < tol, sprintf("(%.6f)", sum(p$Perc)))
  bq <- pof_add_quintis(data.table::copy(b))
  pq <- bq[, .(p = sum(Peso * N_moradores_UC)), by = Quintil][, p := 100 * p / sum(p)]
  checar(paste(ed, "cada quintil tem ~20% das pessoas"), all(abs(pq$p - 20) < 0.5), sprintf("(%s)", paste(round(sort(pq$p), 2), collapse = " / ")))
}

br <- dados[c("2008-2009", "2017-2018")]
a <- pof_analisar(br, "apostas", por = "quintil")
checar("IC contém a estimativa (prevalência por quintil)", all(a$IC_inf <= a$Estimativa & a$Estimativa <= a$IC_sup))
checar("prevalências entre 0 e 100", all(a$Estimativa >= 0 & a$Estimativa <= 100))
pa <- pof_analisar(br, "Alimentação", medida = "participacao")
pd <- rbindlist(lapply(br, function(b) pof_participacao(b, "Alimentação")))
checar("pof_analisar = pof_participacao", max(abs(pa$Estimativa - pd$Perc)) < tol)
s <- pof_analisar(br, "apostas", por = "sexo")
dif <- pof_diferenca(br, "apostas", por = "sexo", referencia = "Homem")
esp <- s[Grupo == "Mulher"]$Estimativa - s[Grupo == "Homem"]$Estimativa
checar("pof_diferenca = diferença das prevalências", max(abs(dif$Diferenca - esp)) < 1e-6, sprintf("(%s)", paste(round(dif$Diferenca, 3), collapse = " / ")))
vv <- pof_variacao(s, "2008-2009", "2017-2018")
checar("pof_variacao: diferença = para - de", max(abs(vv$Diferenca - (vv$Para - vv$De))) < tol)
dc <- pof_decompor(dados, "Assistência à saúde", por = "idade", de = "1995-1996", para = "2017-2018")$resumo
checar("decomposição fecha com a variação total", abs(dc$Efeito_comportamento + dc$Efeito_composicao - dc$Variacao_total) < 1e-9)
cc <- pof_concentracao(br[2], c("Consumo", "f17103", "f22301"), recorte = "brasil", sem_aluguel = FALSE)
checar("concentração do próprio consumo: K = 0", abs(cc[Item == "Consumo"]$K) < 1e-9)
checar("gás regressivo e plano de saúde progressivo", cc[Item == "f17103"]$K < 0 && cc[Item == "f22301"]$K > 0)
co <- pof_composicao(br, "22")
checar("composição da saúde soma 100 em cada edição", all(abs(co[, sum(Perc), by = Edicao]$V1 - 100) < tol))
el <- pof_elasticidade(dados, "Alimentação")
checar("alimentação é bem necessário (elasticidade < 1) em todas as edições", all(el$elasticidade < 1), sprintf("(%s)", paste(round(el$elasticidade, 2), collapse = " / ")))
m <- pof_modelo(br[2], "apostas", ~ quintil + sexo)
checar("modelo: razões de chance positivas e IC ordenado", all(m$Estimativa > 0 & m$IC_inf < m$IC_sup))
gm <- pof_analisar(br, "apostas", medida = "gasto_medio")
gr <- pof_deflacionar(gm)
checar("deflacionamento: 2017 inalterado, 2008 corrigido pelo IPCA",
       abs(gr$Estimativa[2] - gm$Estimativa[2]) < tol && gr$Estimativa[1] > gm$Estimativa[1])

# contra o IBGE
for (a in c(2008, 2017)) {
  b <- pof_somar_grupos(pof_ler_edicao(a, dir_micro, h, manter_sem_consumo = TRUE))
  v <- pof_validar(b, recortes = "Brasil")
  nf <- v[grepl("^N.mero", Grupo_ibge)]
  checar(paste(pof_edicao(a), "número de famílias = IBGE"), abs(nf$Estimado / nf$Oficial - 1) < 1e-6, sprintf("(%s)", format(round(nf$Estimado), big.mark = ".")))
  dc <- v[Grupo_ibge == "Despesas de consumo" & is.na(Item_ibge)]
  checar(paste(pof_edicao(a), "despesa de consumo a menos de 2% do IBGE"), abs(dc$Dif_pct) < 2, sprintf("(%.2f%%)", dc$Dif_pct))
  ne <- uniqueN(b$ESTRATO)
  checar(paste(pof_edicao(a), "estratos = UF x estrato"), ne == c(`2008` = 550, `2017` = 575)[[as.character(a)]], sprintf("(%d)", ne))
  if (a == 2017) {
    cv <- v[!is.na(CV_oficial) & !is.na(CV_estimado) & Estimado > 0]
    rz <- median(cv$CV_estimado / cv$CV_oficial)
    # "outras despesas correntes" fica de fora: impostos e contribuicoes estao no arquivo de rendimentos
    gr <- cv[is.na(Item_ibge) & !grepl("^(N.mero|Tamanho|Outras despesas correntes)", Grupo_ibge)]
    checar("2017-2018 CV do pacote reproduz o CV do IBGE (razão mediana entre 0,9 e 1,1)", rz > 0.9 && rz < 1.1, sprintf("(%.3f)", rz))
    checar("2017-2018 CV dos grupos a menos de 0,7 p.p. do oficial", all(abs(gr$CV_estimado - gr$CV_oficial) < 0.7),
           sprintf("(maior desvio %.2f)", max(abs(gr$CV_estimado - gr$CV_oficial))))
  }
}
b02 <- pof_ler_edicao(2002, dir_micro, h)
checar("2002-2003 estratos = UF x estrato", uniqueN(b02$ESTRATO) == 443, sprintf("(%d)", uniqueN(b02$ESTRATO)))

r <- rbindlist(R)
fwrite(r, file.path("inst", "extdata", "resultados", "verificacao.csv"), sep = ";")
cat(sprintf("\n%d testes: %d passaram, %d falharam\n", nrow(r), sum(r$Resultado == "PASSOU"), sum(r$Resultado == "FALHOU")))
