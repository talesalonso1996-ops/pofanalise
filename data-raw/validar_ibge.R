# ------------------------------------------------------------------
# data-raw/validar_ibge.R
# Compara as estimativas do pacote com as tabelas oficiais do IBGE
# (POF 2008-2009 e 2017-2018), item a item e por recorte, e grava
# inst/extdata/resultados/validacao_ibge.csv.
# Uso: Rscript data-raw/validar_ibge.R <pasta dos microdados>
# ------------------------------------------------------------------
suppressMessages({ library(pofanalise); library(data.table) })
args <- commandArgs(trailingOnly = TRUE)
dir_micro <- if (length(args)) args[1] else "c:/Users/Tales/Downloads/Pasta_Teste_VS/HarmonizaPOF2026_data"
h <- pof_harmonizacao()
res <- list()
for (a in c(2008, 2017)) {
  b <- pof_somar_grupos(pof_ler_edicao(a, dir_micro, h, manter_sem_consumo = TRUE))
  res[[as.character(a)]] <- pof_validar(b)
  rm(b); invisible(gc())
}
v <- rbindlist(res)
fwrite(v, file.path("inst", "extdata", "resultados", "validacao_ibge.csv"), sep = ";")

com <- v[!is.na(Estimado)]
cat("\nLinhas oficiais:", nrow(v), "| com correspondencia:", nrow(com), "\n")
print(com[, .(n = .N, mediana_abs_dif = round(median(abs(Dif_pct)), 2),
              dentro_5pct = round(100 * mean(abs(Dif_pct) <= 5), 1),
              oficial_no_IC = round(100 * mean(Oficial_no_IC), 1)), by = .(Edicao, Recorte)])
cat("\nBrasil, grupos:\n")
print(com[Recorte == "Brasil" & is.na(Item_ibge), .(Edicao, Grupo_ibge, Oficial, Estimado = round(Estimado, 2), Dif_pct = round(Dif_pct, 2), Oficial_no_IC)])
cat("\nMaiores diferencas (Brasil, itens com valor oficial >= R$ 5):\n")
print(com[Recorte == "Brasil" & !is.na(Item_ibge) & Oficial >= 5][order(-abs(Dif_pct))][1:15,
          .(Edicao, Grupo_ibge, Item_ibge, Oficial, Estimado = round(Estimado, 2), Dif_pct = round(Dif_pct, 1))])
