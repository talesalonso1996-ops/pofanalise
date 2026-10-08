# Ferramentas adicionais de pesquisa: variacao entre edicoes, concentracao
# (progressividade), decomposicao demografica, composicao de grupos,
# elasticidade por item e tabelas para publicacao.

.lista <- function(dados) if (data.table::is.data.table(dados)) list(dados) else dados

.anos_de <- function(dados) vapply(dados, function(b) suppressWarnings(as.integer(substr(b$Edicao[1], 1, 4))), 1L)

.recorte_auto <- function(dados, recorte) {
  if (recorte != "auto") return(recorte)
  if (any(.anos_de(dados) < 2002, na.rm = TRUE)) "rms" else "brasil"
}

#' Variação entre duas edições
#'
#' Compara duas edições de um resultado de [pof_analisar()], grupo a grupo:
#' diferença, IC de 95% e p-valor. As amostras de edições diferentes são
#' independentes, então o erro-padrão da diferença é a raiz da soma dos
#' quadrados dos erros-padrão (recuperados dos intervalos de confiança).
#' Sem IC numa das edições (1987, 1995), devolve só a diferença.
#'
#' @param resultado Resultado de [pof_analisar()].
#' @param de,para Edições, como `"2008-2009"` e `"2017-2018"`.
#' @return `data.table` com `Grupo`, `De`, `Para`, `Diferenca`, `IC_inf`,
#'   `IC_sup`, `p_valor` e `Significativa` (p < 0,05).
#' @export
#' @examples
#' r <- pof_analisar(list(pof_exemplo(semente = 1), pof_exemplo(semente = 2)), "Jogos")
#' r$Edicao <- c("2008-2009", "2017-2018")
#' pof_variacao(r, "2008-2009", "2017-2018")
pof_variacao <- function(resultado, de, para) {
  d <- data.table::as.data.table(resultado)
  a <- d[Edicao == de]; b <- d[Edicao == para]
  if (!nrow(a) || !nrow(b)) stop("Edi\u00e7\u00e3o n\u00e3o encontrada no resultado. Dispon\u00edveis: ", paste(unique(d$Edicao), collapse = ", "))
  m <- merge(a[, .(Grupo, De = Estimativa, ep_a = (IC_sup - IC_inf) / (2 * 1.96))],
             b[, .(Grupo, Para = Estimativa, ep_b = (IC_sup - IC_inf) / (2 * 1.96))], by = "Grupo")
  m[, Diferenca := Para - De]
  m[, ep := sqrt(ep_a^2 + ep_b^2)]
  m[, `:=`(IC_inf = Diferenca - 1.96 * ep, IC_sup = Diferenca + 1.96 * ep,
           p_valor = 2 * stats::pnorm(-abs(Diferenca / ep)))]
  m[, Significativa := data.table::fifelse(is.na(p_valor), NA, p_valor < 0.05)]
  m[, .(Grupo, De, Para, Diferenca, IC_inf, IC_sup, p_valor, Significativa)][]
}

#' Concentração e progressividade de um gasto
#'
#' Mede como o gasto com um item se distribui entre as pessoas ordenadas
#' pelo consumo per capita:
#'
#' * `C`: coeficiente de concentração do item (gasto per capita no item,
#'   pessoas ordenadas pelo consumo per capita). Vai de -1 a 1; positivo
#'   quando o gasto se concentra entre quem consome mais.
#' * `Gini_consumo`: Gini do consumo per capita no mesmo recorte.
#' * `K = C - Gini_consumo` (índice no estilo de Kakwani). Negativo: o item
#'   pesa mais no orçamento de quem consome menos (gasto **regressivo**, como
#'   uma necessidade); positivo: pesa mais para quem consome mais
#'   (**progressivo**, como um bem de luxo).
#' * `Base40` e `Topo20`: parcela do gasto total com o item feita pelos 40%
#'   com menor consumo e pelos 20% com maior consumo.
#'
#' @inheritParams pof_analisar
#' @param itens Uma ou mais colunas.
#' @return `data.table` com `Edicao`, `Item`, `C`, `Gini_consumo`, `K`,
#'   `Classificacao`, `Base40`, `Topo20`.
#' @export
#' @examples
#' pof_concentracao(pof_exemplo(), c("Alimentação", "Educação", "Transporte"))
pof_concentracao <- function(dados, itens, recorte = c("auto", "brasil", "rms"), sem_aluguel = NULL) {
  dados <- .lista(dados); recorte <- .recorte_auto(dados, match.arg(recorte))
  if (is.null(sem_aluguel)) sem_aluguel <- recorte == "rms"
  data.table::rbindlist(lapply(dados, function(b) {
    b <- .preparar(b, recorte, sem_aluguel && "f17101" %in% names(b))
    w <- b$Peso * b$N_moradores_UC
    o <- order(b$Consumo_pc)
    W <- cumsum(w[o]) / sum(w)
    gc <- pof_gini(b$Consumo_pc, w)
    data.table::rbindlist(lapply(itens, function(it) {
      y <- b[[it]][o] / b$N_moradores_UC[o]
      L <- cumsum(y * w[o]) / sum(y * w[o])
      if (!sum(y * w[o]) > 0) return(data.table::data.table(Edicao = b$Edicao[1], Item = it, C = NA_real_, Gini_consumo = gc,
                                                           K = NA_real_, Base40 = NA_real_, Topo20 = NA_real_))
      C <- 1 - sum((W - c(0, utils::head(W, -1))) * (L + c(0, utils::head(L, -1))))
      data.table::data.table(Edicao = b$Edicao[1], Item = it, C = C, Gini_consumo = gc, K = C - gc,
                             Base40 = 100 * L[which(W >= 0.4)[1]], Topo20 = 100 * (1 - L[which(W >= 0.8)[1]]))
    }))
  }))[, Classificacao := data.table::fifelse(is.na(K), NA_character_, data.table::fifelse(K < 0, "Regressivo", "Progressivo"))][]
}

#' Decomposição demográfica de uma mudança
#'
#' Separa a variação da participação de um item no consumo entre duas
#' edições em dois efeitos (decomposição *shift-share* simétrica):
#'
#' * **Comportamento**: mudança da participação dentro de cada grupo,
#'   mantida a composição média.
#' * **Composição**: mudança no peso de cada grupo no consumo total (por
#'   exemplo, mais UCs de idosos ou de uma pessoa), mantido o comportamento
#'   médio.
#'
#' A soma dos dois efeitos é exatamente a variação total.
#'
#' @inheritParams pof_analisar
#' @param por Corte que define os grupos: `"quintil"` não faz sentido aqui
#'   (o peso de cada quintil é fixo); use `"idade"`, `"tamanho"`, `"sexo"`,
#'   `"cor"` ou `"rm"`.
#' @param de,para Edições, como `"1995-1996"` e `"2017-2018"`.
#' @return Lista com `resumo` (variação total e os dois efeitos, em pontos
#'   percentuais) e `grupos` (contribuição de cada grupo).
#' @export
#' @examples
#' a <- pof_exemplo(semente = 1); a$Edicao <- "2008-2009"
#' b <- pof_exemplo(semente = 2); b$Edicao <- "2017-2018"
#' pof_decompor(list(a, b), "Alimentação", por = "tamanho", de = "2008-2009", para = "2017-2018")
pof_decompor <- function(dados, item, por, de, para, recorte = c("auto", "brasil", "rms"), sem_aluguel = NULL) {
  dados <- .lista(dados); recorte <- .recorte_auto(dados, match.arg(recorte))
  if (is.null(sem_aluguel)) sem_aluguel <- recorte == "rms"
  por <- .cortes[[match.arg(por, names(.cortes))]]
  eds <- vapply(dados, function(b) b$Edicao[1], "")
  calc <- function(ed) {
    b <- dados[[which(eds == ed)]]
    b <- .preparar(b, recorte, sem_aluguel && "f17101" %in% names(b))
    b <- b[!is.na(get(por))]
    g <- b[, .(cons = sum(Peso * Consumo), it = sum(Peso * get(item))), by = .(Grupo = get(por))]
    g[, `:=`(w = cons / sum(cons), s = 100 * it / cons)][, .(Grupo, w, s)]
  }
  m <- merge(calc(de), calc(para), by = "Grupo", suffixes = c("_de", "_para"))
  m[, `:=`(Comportamento = (s_para - s_de) * (w_de + w_para) / 2,
           Composicao = (w_para - w_de) * (s_de + s_para) / 2)]
  total <- sum(m$w_para * m$s_para) - sum(m$w_de * m$s_de)
  list(resumo = data.table::data.table(Item = item, Por = por, De = de, Para = para,
                                       Participacao_de = sum(m$w_de * m$s_de), Participacao_para = sum(m$w_para * m$s_para),
                                       Variacao_total = total, Efeito_comportamento = sum(m$Comportamento),
                                       Efeito_composicao = sum(m$Composicao)),
       grupos = m[, .(Grupo, Peso_de = 100 * w_de, Peso_para = 100 * w_para, Part_de = s_de, Part_para = s_para,
                      Comportamento, Composicao)])
}

#' Composição de um grupo de gasto
#'
#' Abre um grupo nas suas partes e mede a participação de cada uma dentro
#' do grupo, por edição. Funciona para os grandes grupos (as partes são os
#' Níveis 1, ex. as 16 categorias de alimentação) e para os Níveis 1 de
#' consumo não alimentar (as partes são as folhas, ex. `"22"` abre a saúde
#' em remédios, plano, consultas etc.).
#'
#' @inheritParams pof_analisar
#' @param grupo Nome de um grande grupo (`"Alimentação"`, `"Habitação"`...) ou
#'   código de Nível 1 com 2 dígitos (`"22"`).
#' @param por Corte opcional.
#' @return `data.table` com `Edicao`, `Grupo`, `Parte`, `Codigo`, `Perc`
#'   (percentual do gasto do grupo).
#' @export
pof_composicao <- function(dados, grupo, por = NULL, recorte = c("auto", "brasil", "rms")) {
  dados <- .lista(dados); recorte <- .recorte_auto(dados, match.arg(recorte))
  if (!is.null(por)) por <- .cortes[[match.arg(por, names(.cortes))]]
  b1 <- dados[[1]]
  if (grepl("^[0-9]{2}$", grupo)) {
    den <- paste0("n", grupo)
    partes <- grep(paste0("^f", grupo), names(b1), value = TRUE)
    if (!length(partes)) stop("As folhas do N\u00edvel ", grupo, " n\u00e3o foram carregadas. Inclua-as em pof_carregar(itens = ...).")
  } else {
    grp <- pof_grupos(attr(b1, "harmonizacao") %||% "v2")
    den <- grupo
    g_sel <- grupo
    partes <- intersect(sprintf("n%02d", grp[grp$grupo == g_sel]$n1), names(b1))
    if (!length(partes)) stop("Grupo n\u00e3o encontrado: ", grupo)
  }
  data.table::rbindlist(lapply(dados, function(b) {
    b <- .preparar(b, recorte, FALSE)
    r <- pof_participacao(b, partes, por = por, den = den, ic = FALSE,
                          filtro = if (!is.null(por)) bquote(!is.na(.(as.name(por)))))
    r[, .(Edicao, Grupo = Nivel, Codigo = Item, Perc)]
  }))[, Parte := tryCatch(pof_rotulo(Codigo), error = function(e) Codigo)][]
}

#' Elasticidade-despesa de um item
#'
#' Especificação de Working-Leser ([pof_engel()]) aplicada a qualquer item,
#' em cada edição e, opcionalmente, dentro de cada categoria de um corte.
#'
#' @inheritParams pof_analisar
#' @return `data.table` com `Edicao`, `Grupo`, `elasticidade`, `beta`, `ep`,
#'   `w_medio`, `N`.
#' @export
#' @examples
#' pof_elasticidade(pof_exemplo(), "Alimentação", por = "sexo")
pof_elasticidade <- function(dados, item, por = NULL, recorte = c("auto", "brasil", "rms"), sem_aluguel = NULL) {
  dados <- .lista(dados); recorte <- .recorte_auto(dados, match.arg(recorte))
  if (is.null(sem_aluguel)) sem_aluguel <- recorte == "rms"
  if (!is.null(por)) por <- .cortes[[match.arg(por, names(.cortes))]]
  data.table::rbindlist(lapply(dados, function(b) {
    b <- .preparar(b, recorte, sem_aluguel && "f17101" %in% names(b))
    gr <- if (is.null(por)) list(Total = b) else split(b[!is.na(get(por))], by = por, keep.by = TRUE)
    data.table::rbindlist(lapply(names(gr), function(g) {
      x <- gr[[g]]
      pof_engel(x, item)[, .(Edicao, Grupo = g, elasticidade, beta, ep, w_medio, N)]
    }))
  }))
}

#' Tabela pronta para publicação
#'
#' Formata um resultado de [pof_analisar()] em tabela larga (grupos nas
#' linhas, edições nas colunas), com vírgula decimal e IC entre colchetes.
#'
#' @param resultado Resultado de [pof_analisar()].
#' @param casas Casas decimais.
#' @param ic Incluir o intervalo de confiança.
#' @return `data.table` de texto.
#' @export
#' @examples
#' pof_tabela(pof_analisar(pof_exemplo(), "Jogos", por = "quintil"))
pof_tabela <- function(resultado, casas = 1, ic = TRUE) {
  d <- data.table::as.data.table(resultado)
  d[, txt := pof_fmt(Estimativa, casas)]
  if (ic) d[!is.na(IC_inf), txt := paste0(txt, " [", pof_fmt(IC_inf, casas), "; ", pof_fmt(IC_sup, casas), "]")]
  data.table::dcast(d, Grupo ~ Edicao, value.var = "txt")
}

#' Exporta um resultado para planilha
#'
#' Grava em CSV com separador `;` e vírgula decimal, que o Excel em
#' português abre direto.
#'
#' @param x Qualquer tabela do pacote.
#' @param arquivo Caminho do arquivo `.csv`.
#' @return O caminho, invisivelmente.
#' @export
pof_exportar <- function(x, arquivo) {
  data.table::fwrite(data.table::as.data.table(x), arquivo, sep = ";", dec = ",", bom = TRUE)
  invisible(arquivo)
}
