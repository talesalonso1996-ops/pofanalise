#' Tabelas oficiais de despesa da POF (IBGE)
#'
#' Despesa monetária e não monetária média mensal familiar (R$), por tipo de
#' despesa, publicada pelo IBGE para a POF 2008-2009 e 2017-2018. Recortes:
#' Brasil, situação do domicílio (Urbana, Rural), Grandes Regiões e, em
#' 2008-2009, sexo (Homem, Mulher) e cor ou raça (Branca, Preta, Parda) da
#' pessoa de referência. Inclui o número de famílias e o tamanho médio da
#' família. Lidas das planilhas do FTP do IBGE por
#' `data-raw/ibge_oficial.R`; a coluna `Fonte` indica a tabela.
#'
#' @param edicao Filtro opcional, ex. `"2017-2018"`.
#' @param recorte Filtro opcional, ex. `"Brasil"` ou `"Nordeste"`.
#' @return `data.table` com `Edicao`, `Recorte`, `Grupo_ibge`, `Item_ibge`
#'   (vazio nas linhas de grupo), `Valor` e `Fonte`.
#' @export
#' @examples
#' pof_ibge("2017-2018", "Brasil")[1:6]
pof_ibge <- function(edicao = NULL, recorte = NULL) {
  f <- system.file("extdata", "ibge", "oficial.csv", package = "pofanalise")
  d <- data.table::fread(f, sep = ";", encoding = "UTF-8", na.strings = c("", "NA"))
  if (!is.null(edicao)) d <- d[d$Edicao %in% edicao]
  if (!is.null(recorte)) d <- d[d$Recorte %in% recorte]
  d[]
}

#' Correspondência entre as linhas das tabelas do IBGE e as colunas do pacote
#'
#' Cada linha diz como reproduzir um tipo de despesa das tabelas oficiais com
#' as colunas de [pof_ler_edicao()] (harmonização v2): uma expressão em R
#' sobre as colunas de grupo, de Nível 1 (`n27`...) e de folha (`f17101`...).
#' Linhas sem correspondência direta na harmonização (aluguel monetário e não
#' monetário, condomínio, pacote de telefone, TV e internet, itens de
#' outras despesas correntes) ficam de fora.
#'
#' @return `data.table` com `Grupo_ibge`, `Item_ibge` e `expr`.
#' @export
#' @examples
#' head(pof_mapa_ibge())
pof_mapa_ibge <- function() {
  g <- function(grupo, item, expr) data.table::data.table(Grupo_ibge = grupo, Item_ibge = item, expr = expr)
  H <- "Habita\u00e7\u00e3o"; V <- "Vestu\u00e1rio"; T <- "Transporte"; Hi <- "Higiene e cuidados pessoais"
  S <- "Assist\u00eancia \u00e0 sa\u00fade"; E <- "Educa\u00e7\u00e3o"; R <- "Recrea\u00e7\u00e3o e cultura"; P <- "Servi\u00e7os pessoais"; D <- "Despesas diversas"
  rbind(
    g("Despesa total", NA, "Consumo + n27 + n28 + n29"),
    g("Despesas correntes", NA, "Consumo + n27"),
    g("Despesas de consumo", NA, "Consumo"),
    g("Alimenta\u00e7\u00e3o", NA, "`Alimenta\u00e7\u00e3o`"),
    g(H, NA, "`Habita\u00e7\u00e3o`"), g(H, "Aluguel", "f17101"),
    g(H, "Servi\u00e7os e taxas", "f17102 + f17103 + f17104 + f17201 + f17202 + f17301"),
    g(H, "Energia el\u00e9trica", "f17102"), g(H, "Telefone fixo", "f17201"), g(H, "Telefone celular", "f17202"),
    g(H, "G\u00e1s dom\u00e9stico", "f17103"), g(H, "\u00c1gua e esgoto", "f17104"), g(H, "Outros", "f17301"),
    g(H, "Manuten\u00e7\u00e3o do lar", "f18101"), g(H, "Artigos de limpeza", "f18102"),
    g(H, "Mobili\u00e1rios e artigos do lar", "f18201"), g(H, "Eletrodom\u00e9sticos", "f18202"),
    g(H, "Consertos artigos do lar", "f18103"),
    g(V, NA, "`Vestu\u00e1rio`"), g(V, "Roupa de homem", "f19101"), g(V, "Roupa de mulher", "f19102"),
    g(V, "Roupa de crian\u00e7a", "f19103"), g(V, "Cal\u00e7ados e apetrechos", "f19201"),
    g(V, "Joias e bijuterias", "f19202"), g(V, "Tecidos e armarinhos", "f19104"),
    g(T, NA, "Transporte"), g(T, "Urbano", "f20101"), g(T, "Gasolina - ve\u00edculo pr\u00f3prio", "f20201"),
    g(T, "\u00c1lcool - ve\u00edculo pr\u00f3prio", "f20202"), g(T, "Manuten\u00e7\u00e3o e acess\u00f3rios", "f20203"),
    g(T, "Aquisi\u00e7\u00e3o de ve\u00edculos", "f20301"), g(T, "Viagens espor\u00e1dicas", "f20302"), g(T, "Outras", "f20303"),
    g(Hi, NA, "`Higiene e cuidados pessoais`"), g(Hi, "Perfume", "f21101"), g(Hi, "Produtos para cabelo", "f21102"),
    g(Hi, "Sabonete", "f21103"), g(Hi, "Instrumentos e produtos de uso pessoal", "f21104"),
    g(S, NA, "`Assist\u00eancia \u00e0 sa\u00fade`"), g(S, "Rem\u00e9dios", "f22101"), g(S, "Plano/Seguro sa\u00fade", "f22301"),
    g(S, "Consulta e tratamento dent\u00e1rio", "f22201"), g(S, "Consulta m\u00e9dica", "f22202"),
    g(S, "Tratamento m\u00e9dico e ambulatorial", "f22203"), g(S, "Servi\u00e7os de cirurgia", "f22204"),
    g(S, "Hospitaliza\u00e7\u00e3o", "f22205"), g(S, "Exames diversos", "f22206"),
    g(S, "Material de tratamento", "f22102"), g(S, "Outras", "f22302"),
    g(E, NA, "`Educa\u00e7\u00e3o`"), g(E, "Cursos regulares", "f23101"), g(E, "Cursos superiores", "f23102"),
    g(E, "Outros cursos e atividades", "f23103"), g(E, "Livros did\u00e1ticos e revistas t\u00e9cnicas", "f23201"),
    g(E, "Artigos escolares", "f23202"), g(E, "Outras", "f23203"),
    g(R, NA, "`Recrea\u00e7\u00e3o e cultura`"), g(R, "Brinquedos e jogos", "f24101"), g(R, "Celular e acess\u00f3rios", "f24201"),
    g(R, "Peri\u00f3dicos, livros e revistas n\u00e3o did\u00e1ticos", "f24202"), g(R, "Recrea\u00e7\u00f5es e esportes", "f24102"),
    g(R, "Outras", "f24301"),
    g("Fumo", NA, "f25101"),
    g(P, NA, "`Servi\u00e7os pessoais` - f25101"), g(P, "Cabeleireiro", "f25102"), g(P, "Manicuro e pedicuro", "f25103"),
    g(P, "Consertos de artigos pessoais", "f25104"), g(P, "Outras", "f25105"),
    g(D, NA, "`Despesas diversas`"), g(D, "Jogos e apostas", "f26101"), g(D, "Comunica\u00e7\u00e3o", "f26102"),
    g(D, "Cerim\u00f4nias e festas", "f26103"), g(D, "Servi\u00e7os profissionais", "f26104"),
    g(D, "Im\u00f3veis de uso ocasional", "f26105"), g(D, "Outras", "f26106"),
    g("Outras despesas correntes", NA, "n27"),
    g("Aumento do ativo", NA, "n28"),
    g("Diminui\u00e7\u00e3o do passivo", NA, "n29"))
}

.chave_rotulo <- function(x) {
  x <- tolower(iconv(ifelse(is.na(x), "", x), "UTF-8", "ASCII//TRANSLIT"))
  x <- gsub("\\bde\\b|\\bdo\\b|\\bda\\b|\\bdos\\b|\\bdas\\b", "", x)
  gsub("[^a-z]", "", x)
}

.filtro_recorte <- function(b, recorte) {
  switch(recorte,
    Brasil = rep(TRUE, nrow(b)),
    Urbana = b$situacao %in% "Urbana", Rural = b$situacao %in% "Rural",
    Norte = b$regiao %in% "Norte", Nordeste = b$regiao %in% "Nordeste", Sudeste = b$regiao %in% "Sudeste",
    Sul = b$regiao %in% "Sul", `Centro-Oeste` = b$regiao %in% "Centro-Oeste",
    Homem = b$Sexo_ref %in% 1, Mulher = b$Sexo_ref %in% 2,
    Branca = b$Cor_ref %in% 1, Preta = b$Cor_ref %in% 2, Parda = b$Cor_ref %in% 4,
    stop("Recorte desconhecido: ", recorte))
}

#' Compara as estimativas do pacote com as tabelas oficiais do IBGE
#'
#' Reproduz, com os microdados harmonizados, a despesa média mensal
#' familiar publicada pelo IBGE (ver [pof_ibge()]) para cada tipo de despesa
#' com correspondência em [pof_mapa_ibge()], e para o número de famílias e o
#' tamanho médio da família. A estimativa usa todas as UCs do recorte,
#' inclusive as sem despesa de consumo, como o IBGE; o IC de 95% vem do
#' desenho amostral.
#'
#' @param dados Bases de [pof_ler_edicao()] lidas com
#'   `manter_sem_consumo = TRUE` e com grupos somados
#'   ([pof_somar_grupos()]), ou o resultado de [pof_carregar()] (que remove as
#'   UCs sem consumo e por isso subestima levemente o número de famílias).
#'   Edições sem tabela oficial no pacote são ignoradas.
#' @param recortes Recortes a validar (padrão: todos os disponíveis).
#' @return `data.table` com `Edicao`, `Recorte`, `Grupo_ibge`, `Item_ibge`,
#'   `Oficial`, `Estimado`, `IC_inf`, `IC_sup`, `CV_oficial` (coeficiente
#'   de variação publicado pelo IBGE, %; 2017-2018, Brasil), `Dif_pct`
#'   (diferença relativa, %), `Oficial_no_IC` e `CV_estimado` (coeficiente
#'   de variação do pacote, %).
#' @export
#' @examples
#' \dontrun{
#' h <- pof_harmonizacao()
#' b <- pof_somar_grupos(pof_ler_edicao(2017, dir, h, manter_sem_consumo = TRUE))
#' v <- pof_validar(b)
#' v[Recorte == "Brasil"]
#' }
pof_validar <- function(dados, recortes = NULL) {
  dados <- .lista(dados)
  of_all <- pof_ibge()
  mapa <- pof_mapa_ibge()
  res <- data.table::rbindlist(lapply(dados, function(b) {
    ed <- b$Edicao[1]
    of <- of_all[Edicao == ed]
    if (!nrow(of)) { message(ed, ": sem tabela oficial no pacote, edi\u00e7\u00e3o ignorada."); return(NULL) }
    rec <- intersect(if (is.null(recortes)) unique(of$Recorte) else recortes, unique(of$Recorte))
    b <- data.table::copy(b)
    # os rotulos mudam entre edicoes ("Telefone Celular", "Plano/seguro-saude"):
    # casa por uma chave sem acentos, caixa e pontuacao
    ch <- function(g, i) paste(.chave_rotulo(g), .chave_rotulo(i), sep = "|")
    of[, k := ch(Grupo_ibge, Item_ibge)]
    mp <- data.table::copy(mapa)[, k := ch(Grupo_ibge, Item_ibge)][, .(k, expr)]
    m <- merge(of, mp, by = "k", all.x = TRUE, sort = FALSE)[, k := NULL]
    exprs <- unique(stats::na.omit(m$expr))
    cols <- paste0("v_", seq_along(exprs))
    for (i in seq_along(exprs)) b[, (cols[i]) := eval(parse(text = exprs[i]))]
    des <- pof_desenho(b)
    data.table::rbindlist(lapply(rec, function(r) {
      idx <- .filtro_recorte(b, r)
      if (!any(idx)) return(NULL)
      sub <- b[idx]
      est <- vapply(cols, function(cl) stats::weighted.mean(sub[[cl]], sub$Peso), 0)
      li <- ls <- rep(NA_real_, length(cols))
      if (!is.null(des)) {
        sv <- survey::svymean(stats::as.formula(paste("~", paste(cols, collapse = "+"))), subset(des, idx))
        ci <- stats::confint(sv); li <- ci[, 1]; ls <- ci[, 2]
      }
      e <- data.table::data.table(expr = exprs, Estimado = est, IC_inf = li, IC_sup = ls)
      mr <- merge(m[Recorte == r], e, by = "expr", all.x = TRUE, sort = FALSE)
      # numero de familias e tamanho medio
      nf <- mr[grepl("^N.mero de fam", Grupo_ibge)]
      if (nrow(nf)) mr[grepl("^N.mero de fam", Grupo_ibge), Estimado := sum(sub$Peso)]
      mr[grepl("^Tamanho m", Grupo_ibge), Estimado := stats::weighted.mean(sub$N_moradores_UC, sub$Peso)]
      if (!"CV_oficial" %in% names(mr)) mr[, CV_oficial := NA_real_]
      mr[, .(Edicao, Recorte, Grupo_ibge, Item_ibge, Oficial = Valor, Estimado, IC_inf, IC_sup, CV_oficial)]
    }))
  }))
  if (!nrow(res)) return(res)
  res[, `:=`(Dif_pct = 100 * (Estimado / Oficial - 1),
             Oficial_no_IC = !is.na(IC_inf) & Oficial >= IC_inf & Oficial <= IC_sup,
             CV_estimado = 100 * (IC_sup - IC_inf) / (2 * 1.96) / Estimado)][]
}

#' IPCA e deflacionamento
#'
#' `pof_ipca()` devolve o número-índice mensal do IPCA (IBGE, SIDRA, tabela
#' 1737). `pof_deflacionar()` leva valores em reais de uma data para outra.
#' As datas de referência das POFs em real são: 1995-1996, setembro de
#' 1996; 2002-2003, janeiro de 2003; 2008-2009, janeiro de 2009; 2017-2018,
#' janeiro de 2018. A POF 1987-1988 está em cruzados e não é deflacionada.
#'
#' @param x Valores, ou um resultado de [pof_analisar()] com
#'   `medida = "gasto_medio"` (estimativa e IC são deflacionados edição a
#'   edição).
#' @param de Mês de origem (`"AAAAMM"`) ou edição (`"2008-2009"`). Ignorado
#'   quando `x` é resultado de [pof_analisar()].
#' @param para Mês de destino (`"AAAAMM"`) ou edição. Padrão: janeiro de
#'   2018, a referência da POF 2017-2018.
#' @return `pof_ipca()`: `data.table` com `mes` e `ipca`. `pof_deflacionar()`:
#'   o mesmo tipo de `x`, em reais da data de destino.
#' @export
#' @examples
#' pof_deflacionar(1000, de = "2008-2009")    # R$ 1.000 de jan/2009 em jan/2018
pof_ipca <- function() {
  data.table::fread(system.file("extdata", "ibge", "ipca.csv", package = "pofanalise"), sep = ";",
                    colClasses = c(mes = "character"))
}

#' @rdname pof_ipca
#' @export
pof_deflacionar <- function(x, de = NULL, para = "201801") {
  ref <- c("1995-1996" = "199609", "2002-2003" = "200301", "2008-2009" = "200901", "2017-2018" = "201801")
  mes <- function(v) {
    if (v %in% names(ref)) return(ref[[v]])
    if (v == "1987-1988") stop("A POF 1987-1988 est\u00e1 em cruzados; n\u00e3o h\u00e1 deflacionamento direto para reais.")
    v
  }
  ip <- pof_ipca()
  idx <- function(m) { r <- ip$ipca[ip$mes == mes(m)]; if (!length(r)) stop("M\u00eas sem IPCA: ", m); r }
  if (inherits(x, "pof_analise")) {
    if (attr(x, "escolhas")$medida != "gasto_medio") stop("S\u00f3 resultados com medida = \"gasto_medio\" t\u00eam valores em reais.")
    y <- data.table::copy(x)
    f <- vapply(y$Edicao, function(e) if (e == "1987-1988") NA_real_ else idx(para) / idx(e), 0)
    if (anyNA(f)) warning("A POF 1987-1988 est\u00e1 em cruzados: seus valores ficam NA no resultado deflacionado.")
    for (v in c("Estimativa", "IC_inf", "IC_sup")) data.table::set(y, j = v, value = y[[v]] * f)
    data.table::setattr(y, "class", class(x))
    data.table::setattr(y, "escolhas", c(attr(x, "escolhas"), list(deflacionado_para = mes(para))))
    return(y)
  }
  if (is.null(de)) stop("Informe `de`.")
  x * idx(para) / idx(de)
}
