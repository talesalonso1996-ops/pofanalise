# ------------------------------------------------------------------
# data-raw/ibge_oficial.R
# Le as tabelas oficiais de despesa da POF (IBGE, FTP) e o IPCA (SIDRA) e
# grava em inst/extdata/ibge/:
#   oficial.csv : despesa media mensal familiar (R$) por tipo de despesa,
#                 POF 2008-2009 e 2017-2018, por recorte
#   ipca.csv    : IPCA numero-indice mensal (SIDRA, tabela 1737, var. 2266)
# Fontes (baixadas em data-raw/ibge/):
#   2017-2018: ftp.ibge.gov.br/Orcamentos_Familiares/Pesquisa_de_Orcamentos_Familiares_2017_2018/
#              Primeiros_resultados/tabelas_despesas/tabelas_despesas_xls_20191108.zip
#   2008-2009: ftp.ibge.gov.br/Orcamentos_Familiares/Pesquisa_de_Orcamentos_Familiares_2008_2009/
#              Despesas_rendimentos_e_condicoes_de_vida/tab_despesas.zip
# Uso: Rscript data-raw/ibge_oficial.R  (na pasta do pacote)
# ------------------------------------------------------------------
suppressMessages({ library(readxl); library(data.table); library(jsonlite) })
dir_ib <- "data-raw/ibge"
out <- "inst/extdata/ibge"; dir.create(out, recursive = TRUE, showWarnings = FALSE)

norm <- function(x) {
  x <- gsub("[\r\n]+", " ", x); x <- gsub("\\s+", " ", trimws(x))
  x <- gsub("\\(\\d\\)$", "", x); trimws(x)
}
chave <- function(x) tolower(iconv(norm(x), "UTF-8", "ASCII//TRANSLIT"))

# grupos de primeiro nivel das tabelas do IBGE (o resto sao itens do grupo corrente)
topo <- chave(c("Despesa total", "Despesas correntes", "Despesas de consumo", "Alimentação", "Habitação",
                "Vestuário", "Transporte", "Higiene e cuidados pessoais", "Assistência a saúde", "Assistência à saúde",
                "Educação", "Recreação e cultura", "Fumo", "Serviços pessoais", "Despesas diversas",
                "Outras despesas correntes", "Aumento do ativo", "Diminuição do passivo",
                "Número de famílias", "Tamanho médio da família (pessoas)"))
sub_hab <- chave(c("Aluguel", "Serviços e taxas"))

# tabela "longa": rotulos na coluna 1, valores na coluna `col`
ler_linhas <- function(arq, aba = 1, col = 2, edicao, recorte, fonte) {
  x <- suppressMessages(read_excel(arq, sheet = aba, col_names = FALSE, col_types = "text"))
  lab <- norm(x[[1]]); val <- suppressWarnings(as.numeric(x[[col]]))
  ini <- which(chave(lab) == "despesa total")[1]
  fim <- max(which(grepl("^tamanho medio da familia", chave(lab))))
  grupo <- NA_character_; res <- list()
  for (i in ini:fim) {
    if (is.na(lab[i]) || is.na(val[i])) next
    k <- chave(lab[i])
    if (k %in% topo) { grupo <- lab[i]; item <- NA_character_ } else item <- lab[i]
    res[[length(res) + 1]] <- data.table(Edicao = edicao, Recorte = recorte, Grupo_ibge = grupo,
                                         Item_ibge = item, Valor = val[i], Fonte = fonte)
  }
  rbindlist(res)
}

ar17 <- function(p) list.files(file.path(dir_ib, "pof2017"), pattern = p, full.names = TRUE)
ed17 <- "2017-2018"; ed08 <- "2008-2009"
f17 <- ar17("^Tab_1.1.1_")
r <- list(
  ler_linhas(f17, "1.1.1", 2, ed17, "Brasil", "POF 2017-2018, Tabela 1.1.1"),
  ler_linhas(f17, "1.1.3", 2, ed17, "Urbana", "POF 2017-2018, Tabela 1.1.3"),
  ler_linhas(f17, "1.1.5", 2, ed17, "Rural", "POF 2017-2018, Tabela 1.1.5"))
regs <- c("Norte", "Nordeste", "Sudeste", "Sul", "Centro-Oeste")
for (k in 1:5) {
  f <- ar17(sprintf("^Tab_1.2.%d.1_", k))
  r[[length(r) + 1]] <- ler_linhas(f, sprintf("1.2.%d.1", k), 2, ed17, regs[k], sprintf("POF 2017-2018, Tabela 1.2.%d.1", k))
}
p08 <- function(f) file.path(dir_ib, "pof2008", f)
r <- c(r, list(
  ler_linhas(p08("tab1101.xls"), 1, 2, ed08, "Brasil", "POF 2008-2009, Tabela 1.1.1"),
  ler_linhas(p08("tab1103.xls"), 1, 2, ed08, "Urbana", "POF 2008-2009, Tabela 1.1.3"),
  ler_linhas(p08("tab1105.xls"), 1, 2, ed08, "Rural", "POF 2008-2009, Tabela 1.1.5"),
  ler_linhas(p08("tab1119.xls"), 1, 3, ed08, "Homem", "POF 2008-2009, Tabela 1.1.19"),
  ler_linhas(p08("tab1119.xls"), 1, 4, ed08, "Mulher", "POF 2008-2009, Tabela 1.1.19"),
  ler_linhas(p08("tab1121.xls"), 1, 3, ed08, "Branca", "POF 2008-2009, Tabela 1.1.21"),
  ler_linhas(p08("tab1121.xls"), 1, 4, ed08, "Preta", "POF 2008-2009, Tabela 1.1.21"),
  ler_linhas(p08("tab1121.xls"), 1, 5, ed08, "Parda", "POF 2008-2009, Tabela 1.1.21")))

# 2008, Grandes Regioes: tabela 1.1.10 (regioes nas linhas, grupos de consumo nas colunas)
x <- suppressMessages(read_excel(p08("tab1110.xls"), col_names = FALSE, col_types = "text"))
lin_cab <- which(apply(x, 1, function(l) any(grepl("^Alimen", l))))[1]
cab <- norm(gsub("-\\s*", "", unlist(x[lin_cab, ])))
cab[2] <- "Despesas de consumo"
cab <- sub("^Assis.*", "Assistência à saúde", cab)
for (rg in regs) {
  i <- which(norm(x[[1]]) == rg)[1]
  for (j in 2:ncol(x)) {
    v <- suppressWarnings(as.numeric(x[[j]][i]))
    if (is.na(v) || is.na(cab[j])) next
    r[[length(r) + 1]] <- data.table(Edicao = ed08, Recorte = rg, Grupo_ibge = cab[j], Item_ibge = NA_character_,
                                     Valor = v, Fonte = "POF 2008-2009, Tabela 1.1.10")
  }
}
of <- rbindlist(r)

# coeficientes de variacao oficiais (2017-2018, Brasil, total): mesma estrutura
# de linhas da Tabela 1.1.1
fcv <- ar17("Coeficientes")
cvt <- ler_linhas(fcv, "Tabela 1", 2, ed17, "Brasil", "POF 2017-2018, Tabelas de coeficientes de variação, Tabela 1")
setnames(cvt, "Valor", "CV_oficial")
of <- merge(of, cvt[, .(Edicao, Recorte, Grupo_ibge, Item_ibge, CV_oficial)],
            by = c("Edicao", "Recorte", "Grupo_ibge", "Item_ibge"), all.x = TRUE, sort = FALSE)
cat("linhas com CV oficial:", sum(!is.na(of$CV_oficial)), "\n")
of[chave(Grupo_ibge) == "assistencia a saude", Grupo_ibge := "Assistência à saúde"]
of[chave(Grupo_ibge) == "higiene e cuidados pessoais", Grupo_ibge := "Higiene e cuidados pessoais"]
of[, Grupo_ibge := sub("^Higiene.*", "Higiene e cuidados pessoais", Grupo_ibge)]
fwrite(of, file.path(out, "oficial.csv"), sep = ";")
cat("oficial.csv:", nrow(of), "linhas\n"); print(of[, .N, by = .(Edicao, Recorte)])
print(of[Recorte == "Brasil" & Edicao == ed17][1:12])

# IPCA (numero-indice, dez/1993 = 100), toda a serie mensal
js <- fromJSON(paste0("https://apisidra.ibge.gov.br/values/t/1737/n1/all/v/2266/p/all/f/c"))
ip <- data.table(js[-1, c("D3C", "V")])
setnames(ip, c("mes", "ipca"))
ip[, ipca := as.numeric(ipca)]
ip <- ip[!is.na(ipca)]
fwrite(ip, file.path(out, "ipca.csv"), sep = ";")
cat("ipca.csv:", nrow(ip), "meses, de", ip$mes[1], "a", tail(ip$mes, 1), "\n")
