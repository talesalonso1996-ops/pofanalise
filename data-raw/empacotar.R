# ------------------------------------------------------------------
# data-raw/empacotar.R
# Gera os arquivos da pagina "Baixar" do site em pkgdown/assets/download/:
#   - pofanalise_<versao>.tar.gz  (codigo-fonte, qualquer sistema)
#   - pofanalise_<versao>.zip     (binario para Windows)
#   - pofanalise_resultados.zip   (tabelas das analises em CSV)
#   - pofanalise_scripts.zip      (scripts que geram as analises)
# Uso: Rscript data-raw/empacotar.R   (na pasta do pacote)
# ------------------------------------------------------------------
Sys.setenv(RSTUDIO_PANDOC = "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools")
r_exe <- file.path(R.home("bin"), "R.exe")
versao <- read.dcf("DESCRIPTION", fields = "Version")[1, 1]
dest <- normalizePath(file.path("pkgdown", "assets", "download"), mustWork = FALSE)
dir.create(dest, recursive = TRUE, showWarnings = FALSE)
unlink(list.files(dest, full.names = TRUE))
tmp <- tempfile("empacotar"); dir.create(tmp)
pkg <- normalizePath(".")

# codigo-fonte (com as vinhetas renderizadas)
old <- setwd(tmp)
system2(r_exe, c("CMD", "build", shQuote(pkg)))
tarball <- list.files(tmp, pattern = "[.]tar[.]gz$", full.names = TRUE)
stopifnot(length(tarball) == 1)
file.copy(tarball, dest, overwrite = TRUE)

# compacta com o Python (o Windows nao traz o utilitario zip que o R usa)
zipar <- function(base, itens, destino) {
  py <- tempfile(fileext = ".py")
  writeLines(c("import os, sys, zipfile",
               "base, destino, itens = sys.argv[1], sys.argv[2], sys.argv[3:]",
               "with zipfile.ZipFile(destino, 'w', zipfile.ZIP_DEFLATED) as z:",
               "    for it in itens:",
               "        p = os.path.join(base, it)",
               "        if os.path.isdir(p):",
               "            for r, _, fs in os.walk(p):",
               "                for f in fs:",
               "                    a = os.path.join(r, f); z.write(a, os.path.relpath(a, base))",
               "        else:",
               "            z.write(p, it)"), py)
  stopifnot(system2("python", c(shQuote(py), shQuote(base), shQuote(destino), shQuote(itens))) == 0)
}

# binario para Windows: instala numa biblioteca temporaria e compacta a pasta
lib <- file.path(tmp, "lib"); dir.create(lib)
system2(r_exe, c("CMD", "INSTALL", "--no-multiarch", paste0("--library=", shQuote(lib)), shQuote(tarball)))
zipar(lib, "pofanalise", file.path(dest, paste0("pofanalise_", versao, ".zip")))
setwd(old)

# tabelas de resultados e scripts
zipar(file.path(pkg, "inst", "extdata"), "resultados", file.path(dest, "pofanalise_resultados.zip"))
zipar(pkg, c(file.path("data-raw", list.files("data-raw", pattern = "[.]R$")),
             file.path("vignettes", list.files("vignettes", pattern = "[.]Rmd$"))),
      file.path(dest, "pofanalise_scripts.zip"))
print(file.info(list.files(dest, full.names = TRUE))[, "size", drop = FALSE])
