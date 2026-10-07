# Funcoes de alto nivel para pesquisa: o usuario informa o item (produto,
# categoria ou codigo), a medida e o corte; o pacote cuida de recorte
# comparavel, aluguel, quintis, desenho amostral e grafico.

#' Busca produtos e categorias na harmonização
#'
#' Procura um termo (sem diferenciar maiúsculas ou acentos) nos nomes das
#' categorias e nas descrições dos produtos originais, e devolve os códigos
#' para usar em [pof_carregar()].
#'
#' @param termo Texto a procurar (expressão regular).
#' @param harmonizacao Resultado de [pof_harmonizacao()].
#' @param produtos Procurar também nas descrições dos produtos originais.
#' @return `data.table` com `codigo` (folha, Nível 2 ou Nível 1), `nivel`,
#'   `nome`, `n1` e, para produtos, `ano` e `descricao`.
#' @export
#' @examples
#' \dontrun{
#' pof_buscar("celular")
#' pof_buscar("aposta|loteria")
#' }
pof_buscar <- function(termo, harmonizacao = pof_harmonizacao(), produtos = TRUE) {
  norm <- function(x) tolower(iconv(x, "UTF-8", "ASCII//TRANSLIT"))
  t <- norm(termo)
  fo <- harmonizacao$folhas
  r <- list(
    fo[grepl(t, norm(nome)), .(codigo = cod_final, nivel = "folha", nome, n1)],
    unique(fo[grepl(t, norm(n2)), .(codigo = gsub("[.]", "", sub(" .*", "", n2)), nivel = "nível 2", nome = n2, n1)]),
    unique(fo[grepl(t, norm(n1)), .(codigo = sprintf("%02d", n1_num), nivel = "nível 1", nome = n1, n1)]))
  if (produtos) {
    p <- data.table::fread(file.path(.cache_dir(harmonizacao), "produtos.csv"), encoding = "UTF-8",
                           colClasses = list(character = c("cod_final", "codigo")))
    p <- p[grepl(t, norm(descri_item)), .(anos = paste(sort(unique(ano)), collapse = ", "),
                                          descricao = descri_item[1]), by = .(codigo = cod_final, nome = nome_final)]
    p <- merge(p, fo[, .(codigo = cod_final, n1)], by = "codigo", all.x = TRUE)
    r[[4]] <- p[, .(codigo, nivel = "produto", nome = paste0(nome, " (", descricao, ")"), n1, anos)]
  }
  unique(data.table::rbindlist(r, fill = TRUE))[]
}

.cache_dir <- function(h) {
  d <- attr(h, "dir")
  if (is.null(d)) stop("Rode pof_harmonizacao() de novo para registrar a pasta dos arquivos.")
  d
}

#' Carrega várias edições com os itens de interesse
#'
#' Lê as edições pedidas com [pof_ler_edicao()], soma os grandes grupos e
#' cria uma coluna para cada item. Um item é um ou mais códigos da
#' harmonização: Nível 1 (2 dígitos, ex. `"26"`), Nível 2 (3 dígitos, ex.
#' `"172"`) ou folha (5 dígitos, ex. `"26101"`). Use [pof_buscar()] para
#' achar os códigos.
#'
#' @param anos Anos iniciais das edições.
#' @param dir Pasta com os arquivos do HarmonizaPOF2026.
#' @param itens Lista nomeada (ou vetor nomeado) de códigos. Ex.:
#'   `list(apostas = "26101", celular = c("17202", "24201"))`.
#' @param harmonizacao Resultado de [pof_harmonizacao()].
#' @return Lista de bases (classe `pof_dados`), uma por edição.
#' @export
#' @examples
#' \dontrun{
#' dados <- pof_carregar(c(2002, 2008, 2017), "HarmonizaPOF2026_data",
#'                       itens = list(apostas = "26101"))
#' }
pof_carregar <- function(anos = c(1987, 1995, 2002, 2008, 2017), dir, itens = list(),
                         harmonizacao = pof_harmonizacao()) {
  itens <- as.list(itens)
  if (length(itens) && is.null(names(itens))) stop("Dê nomes aos itens, ex. list(apostas = \"26101\").")
  out <- lapply(anos, function(a) {
    message("Lendo ", pof_edicao(a), "...")
    b <- pof_ler_edicao(a, dir, harmonizacao, itens = itens)
    pof_add_perfil(pof_somar_grupos(b))
  })
  names(out) <- pof_edicao(anos)
  class(out) <- c("pof_dados", "list")
  out
}

#' @export
print.pof_dados <- function(x, ...) {
  cat("<pof_dados>", length(x), "edição(ões):", paste(names(x), collapse = ", "), "\n")
  cat("UCs:", paste(vapply(x, nrow, 1L), collapse = " / "), "\n")
  invisible(x)
}

#' Variáveis de perfil da UC
#'
#' Acrescenta rótulos de sexo, faixa etária e cor da pessoa de referência,
#' tamanho da UC e região metropolitana, usados no argumento `por` de
#' [pof_analisar()].
#'
#' @param b Base de [pof_ler_edicao()].
#' @return A base com `sexo`, `idade`, `cor`, `tamanho` e `rm`.
#' @export
pof_add_perfil <- function(b) {
  b[, `:=`(
    sexo = data.table::fifelse(Sexo_ref == 1, "Homem", data.table::fifelse(Sexo_ref == 2, "Mulher", NA_character_)),
    idade = as.character(cut(Idade_ref, c(-Inf, 29, 44, 59, Inf), labels = c("Até 29", "30 a 44", "45 a 59", "60 ou mais"))),
    cor = data.table::fcase(Cor_ref == 1, "Branca", Cor_ref %in% c(2, 4), "Preta ou parda", default = NA_character_),
    tamanho = data.table::fcase(N_moradores_UC == 1, "1 morador", N_moradores_UC == 2, "2 moradores",
                                N_moradores_UC <= 4, "3 a 4 moradores", default = "5 ou mais moradores"),
    rm = data.table::fifelse(is.na(RGMT), "Fora das RMs", pof_rms()[as.character(RGMT)]))]
  b[]
}

.cortes <- c(quintil = "quintil", sexo = "sexo", idade = "idade", cor = "cor", tamanho = "tamanho", rm = "rm")

.preparar <- function(b, recorte, sem_aluguel) {
  versao <- attr(b, "harmonizacao")
  if (sem_aluguel) b <- pof_sem_aluguel(b) else b <- data.table::copy(b)
  if (recorte == "rms") b <- b[!is.na(RGMT)]
  data.table::setattr(b, "harmonizacao", versao)
  b[, quintil := as.character(pof_quintil(Consumo_pc, Peso * N_moradores_UC))]
  b[]
}

#' Analisa um item ao longo das edições
#'
#' Calcula, para cada edição carregada, uma medida do item, com intervalo de
#' confiança de 95% quando a edição tem desenho amostral (2002 em diante).
#'
#' Medidas:
#' * `"prevalencia"`: % de UCs com gasto no item.
#' * `"participacao"`: % do item na despesa de consumo.
#' * `"gasto_medio"`: gasto mensal médio por UC, em moeda da edição. Os
#'   valores são nominais: compare só dentro de cada edição.
#'
#' Recorte: com `"auto"`, usa as regiões metropolitanas quando há edição
#' anterior a 2002 entre as carregadas e o Brasil caso contrário. Com
#' `sem_aluguel = NULL`, o aluguel sai do consumo sempre que o recorte é das
#' RMs (comparação com 1987 e 1995). Os quintis são de consumo per capita,
#' calculados dentro de cada edição e recorte.
#'
#' @param dados Resultado de [pof_carregar()] ou uma base única.
#' @param item Nome de coluna: um item de [pof_carregar()], um grupo
#'   (`"Alimentação"`) ou um Nível 1 (`"n07"`).
#' @param medida `"prevalencia"`, `"participacao"` ou `"gasto_medio"`.
#' @param por Corte: `NULL`, `"quintil"`, `"sexo"`, `"idade"`, `"cor"`,
#'   `"tamanho"` ou `"rm"`.
#' @param recorte `"auto"`, `"brasil"` ou `"rms"`.
#' @param sem_aluguel `NULL` (automático), `TRUE` ou `FALSE`.
#' @return `data.table` (classe `pof_analise`) com `Edicao`, `Grupo`,
#'   `Estimativa`, `IC_inf`, `IC_sup`, `N_UC` e atributos com as escolhas
#'   feitas.
#' @export
#' @examples
#' r <- pof_analisar(pof_exemplo(), "Educação", medida = "prevalencia", por = "quintil")
#' r
pof_analisar <- function(dados, item, medida = c("prevalencia", "participacao", "gasto_medio"),
                         por = NULL, recorte = c("auto", "brasil", "rms"), sem_aluguel = NULL) {
  medida <- match.arg(medida); recorte <- match.arg(recorte)
  if (data.table::is.data.table(dados)) dados <- list(dados)
  if (!is.null(por)) por <- .cortes[[match.arg(por, names(.cortes))]]
  anos <- vapply(dados, function(b) suppressWarnings(as.integer(substr(b$Edicao[1], 1, 4))), 1L)
  if (recorte == "auto") recorte <- if (any(anos < 2002, na.rm = TRUE)) "rms" else "brasil"
  if (recorte == "brasil" && any(anos < 2002, na.rm = TRUE))
    warning("1987 e 1995 só cobrem as RMs: o recorte 'brasil' não é comparável nessas edições.")
  if (is.null(sem_aluguel)) sem_aluguel <- recorte == "rms"
  if (!item %in% names(dados[[1]])) stop("Coluna '", item, "' não encontrada. Inclua o item em pof_carregar(itens = ...).")

  res <- data.table::rbindlist(lapply(dados, function(b) {
    b <- .preparar(b, recorte, sem_aluguel && "f17101" %in% names(b))
    if (!is.null(por) && all(is.na(b[[por]]))) return(NULL)
    r <- switch(medida,
      prevalencia = pof_prevalencia(b, item, por = por, filtro = if (!is.null(por)) bquote(!is.na(.(as.name(por))))),
      participacao = pof_participacao(b, item, por = por, filtro = if (!is.null(por)) bquote(!is.na(.(as.name(por))))),
      gasto_medio = .gasto_medio(b, item, por))
    r[, .(Edicao, Grupo = Nivel, Estimativa = Perc, IC_inf, IC_sup, N_UC)]
  }))
  data.table::setattr(res, "class", c("pof_analise", class(res)))
  data.table::setattr(res, "escolhas", list(item = item, medida = medida, por = por, recorte = recorte, sem_aluguel = sem_aluguel))
  res
}

.gasto_medio <- function(b, item, por) {
  des <- pof_desenho(b)
  niv <- .niveis(b, por, if (is.null(por)) rep(TRUE, nrow(b)) else !is.na(b[[por]]))
  data.table::rbindlist(lapply(names(niv), function(nv) {
    idx <- niv[[nv]]; sub <- b[idx]
    m <- stats::weighted.mean(sub[[item]], sub$Peso)
    li <- ls <- NA_real_
    if (!is.null(des)) {
      r <- tryCatch(stats::confint(survey::svymean(stats::as.formula(paste0("~`", item, "`")), subset(des, idx))), error = function(e) NULL)
      if (!is.null(r)) { li <- r[1]; ls <- r[2] }
    }
    data.table::data.table(Edicao = b$Edicao[1], Nivel = nv, Item = item, N_UC = nrow(sub), Perc = m, IC_inf = li, IC_sup = ls)
  }))
}

#' @export
print.pof_analise <- function(x, ...) {
  e <- attr(x, "escolhas")
  un <- c(prevalencia = "% das UCs com gasto", participacao = "% da despesa de consumo", gasto_medio = "gasto mensal médio por UC (moeda nominal)")
  cat("Item:", e$item, "|", un[[e$medida]], "\n")
  cat("Recorte:", if (e$recorte == "rms") "regiões metropolitanas" else "Brasil",
      if (isTRUE(e$sem_aluguel)) "| consumo sem aluguel" else "", if (!is.null(e$por)) paste("| por", e$por) else "", "\n\n")
  y <- data.table::copy(x); data.table::setattr(y, "class", c("data.table", "data.frame"))
  for (v in c("Estimativa", "IC_inf", "IC_sup")) data.table::set(y, j = v, value = round(y[[v]], 2))
  print(y, ...)
  invisible(x)
}

#' Gráfico de uma análise
#'
#' @param x Resultado de [pof_analisar()].
#' @param ... Não usado.
#' @return Objeto `ggplot`.
#' @export
plot.pof_analise <- function(x, ...) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) stop("Instale o ggplot2.")
  e <- attr(x, "escolhas")
  d <- data.table::as.data.table(x)
  rot <- c(prevalencia = "% das UCs com gasto", participacao = "% da despesa de consumo", gasto_medio = "Gasto mensal médio por UC")
  sub <- paste0(if (e$recorte == "rms") "Regiões metropolitanas" else "Brasil",
                if (isTRUE(e$sem_aluguel)) ", consumo sem aluguel" else "", "
Barras: IC 95% do desenho amostral (2002 em diante)")
  rot_por <- c(quintil = "Quintil de consumo per capita (1 = 20% com menor consumo)", sexo = "Sexo da pessoa de referência",
               idade = "Idade da pessoa de referência", cor = "Cor da pessoa de referência",
               tamanho = "Moradores na UC", rm = "Região metropolitana")
  xlab <- if (is.null(e$por)) NULL else rot_por[[e$por]]
  dg <- ggplot2::position_dodge(width = 0.3)
  if (is.null(e$por)) {
    p <- ggplot2::ggplot(d, ggplot2::aes(Edicao, Estimativa, group = 1)) +
      ggplot2::geom_line(color = "#1c5cab", linewidth = 1) + ggplot2::geom_point(color = "#1c5cab", size = 2.5) +
      ggplot2::geom_errorbar(ggplot2::aes(ymin = IC_inf, ymax = IC_sup), width = 0.12, color = "#1c5cab", na.rm = TRUE)
  } else if (length(unique(d$Edicao)) > 1) {
    p <- ggplot2::ggplot(d, ggplot2::aes(Grupo, Estimativa, color = Edicao, group = Edicao)) +
      ggplot2::geom_line(linewidth = 0.9, position = dg) + ggplot2::geom_point(size = 2, position = dg) +
      ggplot2::geom_errorbar(ggplot2::aes(ymin = IC_inf, ymax = IC_sup), width = 0.2, na.rm = TRUE, position = dg) +
      ggplot2::scale_color_manual(values = c("1987-1988" = "#86b6ef", "1995-1996" = "#5598e7", "2002-2003" = "#2a78d6",
                                             "2008-2009" = "#1c5cab", "2017-2018" = "#0d366b"))
  } else {
    p <- ggplot2::ggplot(d, ggplot2::aes(Grupo, Estimativa)) +
      ggplot2::geom_col(fill = "#1c5cab", width = 0.6) +
      ggplot2::geom_errorbar(ggplot2::aes(ymin = IC_inf, ymax = IC_sup), width = 0.2, na.rm = TRUE)
  }
  p + ggplot2::labs(title = e$item, subtitle = sub, x = xlab, y = rot[[e$medida]], color = NULL,
                    caption = "Fonte: IBGE, POF, microdados harmonizados. Pacote pofanalise.") +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(legend.position = "bottom", panel.grid.minor = ggplot2::element_blank(),
                   plot.title = ggplot2::element_text(face = "bold"), plot.title.position = "plot",
                   plot.subtitle = ggplot2::element_text(color = "grey30", size = 10))
}

#' Diferença entre grupos
#'
#' Compara a prevalência ou o gasto médio do item entre as categorias de um
#' corte, dentro de cada edição, por regressão com desenho amostral
#' (`survey::svyglm`). Cada linha é a diferença em relação à categoria de
#' referência, com IC de 95% e p-valor. Exige desenho amostral (2002 em
#' diante).
#'
#' @inheritParams pof_analisar
#' @param medida `"prevalencia"` (diferença em pontos percentuais) ou
#'   `"gasto_medio"`.
#' @param referencia Categoria de referência (padrão: a primeira).
#' @return `data.table` com `Edicao`, `Grupo`, `Referencia`, `Diferenca`,
#'   `IC_inf`, `IC_sup`, `p_valor`.
#' @export
#' @examples
#' pof_diferenca(pof_exemplo(), "Educação", por = "sexo")
pof_diferenca <- function(dados, item, por, medida = c("prevalencia", "gasto_medio"),
                          recorte = c("auto", "brasil", "rms"), referencia = NULL) {
  medida <- match.arg(medida); recorte <- match.arg(recorte)
  if (data.table::is.data.table(dados)) dados <- list(dados)
  por <- .cortes[[match.arg(por, names(.cortes))]]
  if (recorte == "auto") recorte <- "brasil"
  data.table::rbindlist(lapply(dados, function(b) {
    b <- .preparar(b, recorte, FALSE)
    b <- b[!is.na(get(por))]
    des <- pof_desenho(b)
    if (is.null(des)) { message(b$Edicao[1], ": sem desenho amostral, edição ignorada."); return(NULL) }
    niveis <- sort(unique(b[[por]]))
    ref <- if (is.null(referencia)) niveis[1] else referencia
    des$variables$y_ <- if (medida == "prevalencia") 100 * (des$variables[[item]] > 0) else des$variables[[item]]
    des$variables$g_ <- stats::relevel(factor(des$variables[[por]]), ref = ref)
    m <- survey::svyglm(y_ ~ g_, design = des)
    co <- summary(m)$coefficients[-1, , drop = FALSE]
    ci <- stats::confint(m)[-1, , drop = FALSE]
    data.table::data.table(Edicao = b$Edicao[1], Grupo = sub("^g_", "", rownames(co)), Referencia = ref,
                           Diferenca = co[, 1], IC_inf = ci[, 1], IC_sup = ci[, 2], p_valor = co[, 4])
  }))
}

#' Modelo de regressão para um item
#'
#' Ajusta, em cada edição com desenho amostral, um modelo para a chance de
#' ter gasto com o item (logístico, `tipo = "prevalencia"`) ou para o log do
#' gasto entre quem gasta (`tipo = "gasto"`), com `survey::svyglm`. As
#' variáveis explicativas podem ser os cortes de [pof_add_perfil()],
#' `quintil` ou qualquer coluna da base.
#'
#' @inheritParams pof_analisar
#' @param formula Lado direito da fórmula, ex. `~ quintil + sexo + cor`.
#' @param tipo `"prevalencia"` ou `"gasto"`.
#' @return `data.table` com `Edicao`, `Termo`, `Estimativa` (razão de
#'   chances no modelo logístico; coeficiente do log do gasto no outro),
#'   `IC_inf`, `IC_sup`, `p_valor`, `N_UC`.
#' @export
#' @examples
#' pof_modelo(pof_exemplo(), "Educação", ~ quintil + sexo)
pof_modelo <- function(dados, item, formula, tipo = c("prevalencia", "gasto"), recorte = c("auto", "brasil", "rms")) {
  tipo <- match.arg(tipo); recorte <- match.arg(recorte)
  if (data.table::is.data.table(dados)) dados <- list(dados)
  if (recorte == "auto") recorte <- "brasil"
  data.table::rbindlist(lapply(dados, function(b) {
    b <- .preparar(b, recorte, FALSE)
    vars <- all.vars(formula)
    b <- b[stats::complete.cases(b[, ..vars])]
    if (tipo == "gasto") b <- b[get(item) > 0]
    des <- pof_desenho(b)
    if (is.null(des)) { message(b$Edicao[1], ": sem desenho amostral, edição ignorada."); return(NULL) }
    des$variables$y_ <- if (tipo == "prevalencia") as.numeric(des$variables[[item]] > 0) else log(des$variables[[item]])
    f <- stats::update(formula, y_ ~ .)
    m <- if (tipo == "prevalencia") survey::svyglm(f, design = des, family = stats::quasibinomial()) else survey::svyglm(f, design = des)
    co <- summary(m)$coefficients; ci <- suppressMessages(stats::confint(m))
    tr <- if (tipo == "prevalencia") exp else identity
    data.table::data.table(Edicao = b$Edicao[1], Termo = rownames(co), Estimativa = tr(co[, 1]),
                           IC_inf = tr(ci[, 1]), IC_sup = tr(ci[, 2]), p_valor = co[, 4], N_UC = nrow(b))
  }))
}
