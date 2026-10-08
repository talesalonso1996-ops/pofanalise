# ------------------------------------------------------------------
# data-raw/conferir_tradutor_ibge.R
# Investigacao que identificou os erros listados em pof_correcoes().
#  1. Recalcula o gasto mensal de cada registro direto dos microdados brutos
#     da POF 2017-2018 (valor deflacionado x fator de anualizacao / 12, como
#     no programa "Tabela de Despesa Geral" da memoria de calculo do IBGE) e
#     compara, quadro a quadro, com o arquivo de despesas do HarmonizaPOF2026.
#  2. Classifica os mesmos registros com o tradutor oficial do IBGE
#     (Tradutor_Despesa_Geral.xls) e reproduz a Tabela 1.1.1.
#  3. Compara, codigo a codigo, o tradutor do IBGE com o de-para da v2 e
#     lista os codigos que caem em grupos diferentes, com o valor em R$.
# Entradas (do arquivo HarmonizaPOF2026, pasta POF2017): RDS/*.rds (texto,
# lidos com fread), Tradutores/Tradutor_Despesa_Geral.xls e
# Documentacao/Cadastro de Produtos.xls.
# Uso: Rscript data-raw/conferir_tradutor_ibge.R <pasta com esses arquivos> <pasta dos microdados harmonizados>
# ------------------------------------------------------------------
suppressMessages({ library(pofanalise); library(data.table); library(readxl) })
args <- commandArgs(trailingOnly = TRUE)
D <- args[1]; dir_micro <- args[2]
idu <- function(d) as.numeric(paste0(sprintf("%09d", d$COD_UPA), sprintf("%02d", d$NUM_DOM), sprintf("%01d", d$NUM_UC)))
le <- function(f, meses) {
  d <- fread(file.path(D, f))
  mult <- if (is.null(meses)) 1 else ifelse(d$QUADRO %in% meses, d$V9011, 1)
  d[, .(id_uc = idu(d), Quadro = QUADRO, cod = trunc(V9001 / 100), vm = V8000_DEFLA * mult * FATOR_ANUALIZACAO / 12, peso = PESO_FINAL)]
}
b <- rbindlist(list(le("DESPESA_COLETIVA.rds", c(10, 19)), le("CADERNETA_COLETIVA.rds", NULL),
                    le("DESPESA_INDIVIDUAL.rds", c(44, 47, 48, 49, 50)), le("ALUGUEL_ESTIMADO.rds", 0:99)))
mor <- fread(file.path(D, "MORADORES.rds"))
FAM <- sum(unique(mor[, .(id_uc = idu(mor), PESO_FINAL)])$PESO_FINAL)

# 1. bruto x pipeline, por quadro
p <- fread(file.path(dir_micro, pof_arquivos(2017)$despesas), select = c("id_uc", "Quadro", "Tipo", "Valor_Mensal"))
w <- unique(b[, .(id_uc, peso)])
q <- merge(b[, .(bruto = sum(vm * peso) / FAM), by = Quadro],
           merge(p[Tipo != "INSS" & !grepl("^Deducao", Tipo)], w, by = "id_uc")[, .(pipeline = sum(Valor_Mensal * peso) / FAM), by = Quadro], by = "Quadro")
cat("Maior diferenca bruto x pipeline por quadro (R$):", max(abs(q$bruto - q$pipeline)), "\n")

# 2. tradutor do IBGE
tr <- as.data.table(read_excel(file.path(D, "Tradutor_Despesa_Geral.xls"))); setnames(tr, tolower(names(tr)))
b <- merge(b, tr[variavel == "V8000_DEFLA", .(cod = codigo, nivel_2, ibge = descricao_3)], by = "cod", all.x = TRUE)
cat("Despesa de consumo pelo tradutor do IBGE:", round(b[nivel_2 == 11, sum(vm * peso)] / FAM, 2), "(Tabela 1.1.1: 3764,51)\n")

# 3. tradutor x de-para v2 (sem as correcoes do pacote)
h0 <- pof_harmonizacao(correcoes = FALSE)
g <- pof_grupos()[, .(n1, grupo)]
b <- merge(b, merge(h0$depara[ano == 2017, .(cod = codigo, cod_final, n1)], g, by = "n1", all.x = TRUE), by = "cod", all.x = TRUE)
cat("Despesa de consumo pelo de-para v2:", round(b[n1 <= 26, sum(vm * peso)] / FAM, 2), "\n")
cad <- as.data.table(read_excel(file.path(D, "Cadastro de Produtos.xls"))); setnames(cad, c("quadro", "cod7", "nome"))
cad <- cad[, .(cod = trunc(as.numeric(cod7) / 100), nome)][!is.na(cod), .(nome = nome[1]), by = cod]
norm <- function(x) tolower(iconv(x, "UTF-8", "ASCII//TRANSLIT"))
b[, `:=`(g_ibge = fifelse(nivel_2 %in% 11, ibge, "(fora do consumo)"), g_v2 = fifelse(n1 <= 26 & !is.na(n1), grupo, "(fora do consumo)"))]
f <- merge(b[norm(g_ibge) != norm(g_v2) & !(norm(g_ibge) == "fumo" & g_v2 == "Serviços pessoais"),
             .(R = sum(vm * peso) / FAM), by = .(cod, g_ibge, g_v2, cod_final)], cad, by = "cod", all.x = TRUE)[order(-R)]
print(f[R >= 0.3])
fwrite(f, "conferencia_tradutor_ibge_2017.csv", sep = ";")
