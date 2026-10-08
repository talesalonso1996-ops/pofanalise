# ------------------------------------------------------------------
# data-raw/validar_ibge_v2_original.R
# Mesma comparacao de validar_ibge.R, com a harmonizacao v2 SEM as
# correcoes de pof_correcoes() (Brasil). Mostra o efeito das correcoes na
# pagina "Erros conhecidos na harmonizacao". Grava
# inst/extdata/resultados/validacao_ibge_v2_original.csv.
# Uso: Rscript data-raw/validar_ibge_v2_original.R <pasta dos microdados>
# ------------------------------------------------------------------
suppressMessages({ library(pofanalise); library(data.table) })
args <- commandArgs(trailingOnly = TRUE)
dir_micro <- if (length(args)) args[1] else "c:/Users/Tales/Downloads/Pasta_Teste_VS/HarmonizaPOF2026_data"
h0 <- pof_harmonizacao(correcoes = FALSE)
v <- rbindlist(lapply(c(2008, 2017), function(a) {
  b <- pof_somar_grupos(pof_ler_edicao(a, dir_micro, h0, manter_sem_consumo = TRUE))
  pof_validar(b, recortes = "Brasil")
}))
fwrite(v, file.path("inst", "extdata", "resultados", "validacao_ibge_v2_original.csv"), sep = ";")
print(v[is.na(Item_ibge) & Grupo_ibge == "Despesas de consumo", .(Edicao, Oficial, Estimado, Dif_pct)])
