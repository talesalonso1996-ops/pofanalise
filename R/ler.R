#' Nomes dos arquivos de uma edição
#'
#' Nomes dos arquivos gerados pelo pipeline HarmonizaPOF2026 para cada edição.
#' Altere se os seus arquivos tiverem outro nome.
#'
#' @param ano Ano inicial da edição: 1987, 1995, 2002, 2008 ou 2017.
#' @return Lista com `despesas`, `moradores` e, em 1995, `domicilios`.
#' @export
#' @examples
#' pof_arquivos(2017)
pof_arquivos <- function(ano) {
  ano <- as.character(ano)
  stopifnot(ano %in% c("1987", "1995", "2002", "2008", "2017"))
  x <- list(despesas = sprintf("POF%s__GZ__Despesas_POF_%s.gz", ano, ano),
            moradores = sprintf("POF%s__RDS__MORADORES_H.RDS", ano))
  if (ano == "1995") x$domicilios <- "POF1995__RDS__DOMICILIOS.RDS"
  x
}

#' Rótulo da edição
#' @param ano Ano inicial da edição.
#' @return Texto como `"2017-2018"`.
#' @export
#' @examples
#' pof_edicao(2017)
pof_edicao <- function(ano) {
  c(`1987` = "1987-1988", `1995` = "1995-1996", `2002` = "2002-2003",
    `2008` = "2008-2009", `2017` = "2017-2018")[as.character(ano)]
}

#' Regiões metropolitanas
#' @return Vetor nomeado pelo código `RGMT`.
#' @export
pof_rms <- function() {
  c(`1` = "Rio de Janeiro", `2` = "Porto Alegre", `3` = "Belo Horizonte", `4` = "Recife",
    `5` = "S\u00e3o Paulo", `6` = "Bras\u00edlia", `7` = "Bel\u00e9m", `8` = "Fortaleza",
    `9` = "Salvador", `10` = "Curitiba", `11` = "Goi\u00e2nia")
}

#' Lê uma edição da POF harmonizada no nível da unidade de consumo
#'
#' Lê despesas e moradores de uma edição, aplica a harmonização de produtos
#' e devolve uma linha por unidade de consumo (UC) com peso, desenho
#' amostral, características da pessoa de referência e gasto mensal por
#' Nível 1 (`n01` a `n34`) e por folha de consumo selecionada.
#'
#' Os valores estão na moeda nominal de cada edição: compare participações,
#' índices e medidas de desigualdade entre edições, nunca valores.
#'
#' Detalhes por edição:
#' * 1987 e 1995 cobrem só as regiões metropolitanas e não têm UPA e estrato;
#'   o peso de 1995 vem do arquivo de domicílios.
#' * Desenho amostral: UPA e estrato em 2002 (UPA composta por UF, sequência
#'   e dígito), 2008 e 2017.
#'
#' @param ano Ano inicial da edição.
#' @param dir Pasta com os arquivos do HarmonizaPOF2026.
#' @param harmonizacao Resultado de [pof_harmonizacao()].
#' @param arquivos Nomes dos arquivos, ver [pof_arquivos()].
#' @param folhas Códigos de folha (`cod_final`) a manter como colunas
#'   individuais (`f` + código). Por padrão, todas as folhas de consumo não
#'   alimentar e a folha de refeições.
#' @param itens Lista nomeada de códigos da harmonização para somar numa
#'   coluna própria: Nível 1 (2 dígitos), Nível 2 (3 dígitos) ou folha (5
#'   dígitos). Ex.: `list(apostas = "26101", celular = c("17202", "24201"))`.
#'   Ver [pof_buscar()].
#' @param manter_sem_consumo Manter as UCs sem despesa de consumo
#'   registrada (o IBGE as inclui nas médias por família). Por padrão saem,
#'   porque as participações no orçamento não são definidas para elas.
#' @return `data.table` com uma linha por UC. Colunas:
#'   `Edicao`, `id_uc`, `Peso`, `RGMT`, `UPA`, `ESTRATO` (quando há),
#'   `UF`, `regiao` e `situacao` (urbano/rural; 2002 em diante, quando a
#'   edição tem a informação),
#'   `N_moradores_UC`, `Sexo_ref`, `Idade_ref`, `Cor_ref`, `n01`...`n34`,
#'   colunas de folha, `Consumo` (Níveis de consumo) e `Consumo_pc`.
#'   O atributo `"mapeamento"` traz a proporção do valor que casou com o
#'   de-para.
#' @export
#' @examples
#' \dontrun{
#' h <- pof_harmonizacao()
#' b <- pof_ler_edicao(2017, dir = "HarmonizaPOF2026_data", harmonizacao = h)
#' }
pof_ler_edicao <- function(ano, dir, harmonizacao = pof_harmonizacao(),
                           arquivos = pof_arquivos(ano), folhas = NULL, itens = list(),
                           manter_sem_consumo = FALSE) {
  ano <- as.integer(ano)
  arq <- function(x) file.path(dir, x)
  grp <- pof_grupos(harmonizacao$versao)
  n1_consumo <- grp[consumo == TRUE]$n1

  if (is.null(folhas)) {
    fo <- harmonizacao$folhas
    folhas <- fo[n1_num %in% setdiff(n1_consumo, 1:16)]$cod_final
    folhas <- c(folhas, fo[grepl("^Refei", nome) & n1_num == 16]$cod_final)
  }

  # despesas e de-para pelo codigo original do produto
  desp <- data.table::fread(arq(arquivos$despesas), select = c("id_uc", "Codigo", "Valor_Mensal"))
  desp[, Codigo := as.integer(Codigo)]
  dpa <- harmonizacao$depara
  ano_sel <- ano
  dp <- dpa[dpa$ano == ano_sel, .(Codigo = codigo, cod_final, n1)]
  desp <- merge(desp, dp, by = "Codigo", all.x = TRUE)
  mapeamento <- desp[, .(valor_total = sum(Valor_Mensal, na.rm = TRUE),
                         perc_casado = 100 * sum(Valor_Mensal[!is.na(n1)], na.rm = TRUE) / sum(Valor_Mensal, na.rm = TRUE))]

  g_n1 <- data.table::dcast(desp[!is.na(n1), .(v = sum(Valor_Mensal, na.rm = TRUE)), by = .(id_uc, n1)],
                            id_uc ~ sprintf("n%02d", n1), value.var = "v", fill = 0)
  g_fo <- data.table::dcast(desp[cod_final %in% folhas, .(v = sum(Valor_Mensal, na.rm = TRUE)), by = .(id_uc, cod_final)],
                            id_uc ~ paste0("f", cod_final), value.var = "v", fill = 0)

  g_it <- NULL
  for (nm in names(itens)) {
    cods <- as.character(itens[[nm]])
    cods <- ifelse(grepl("^[0-9]$", cods), paste0("0", cods), cods)
    hit <- Reduce(`|`, lapply(cods, function(cd) startsWith(desp$cod_final, cd)))
    hit[is.na(hit)] <- FALSE
    gi <- desp[hit, .(v = sum(Valor_Mensal, na.rm = TRUE)), by = id_uc]
    data.table::setnames(gi, "v", nm)
    g_it <- if (is.null(g_it)) gi else merge(g_it, gi, by = "id_uc", all = TRUE)
  }

  # pessoa de referencia, peso e desenho
  mor <- data.table::fread(arq(arquivos$moradores))
  if (ano == 1995) {
    dom <- data.table::fread(arq(arquivos$domicilios))
    dom[, id_dom := as.numeric(paste0(sprintf("%02d", V0030), sprintf("%03d", V0050),
                                      sprintf("%01d", V0060), sprintf("%02d", V0065)))]
    mor <- merge(mor, unique(dom[, .(id_dom, Peso = V0518)], by = "id_dom"), by = "id_dom", all.x = TRUE)
  }
  if (ano == 2002) mor[, UPA := as.numeric(paste0(sprintf("%02d", UF), sprintf("%05d", NUM_SEQ), sprintf("%01d", NUM_DV)))]
  if (ano %in% c(2008, 2017)) data.table::setnames(mor, c("COD_UPA", "ESTRATO_POF"), c("UPA", "ESTRATO"))
  if ("PESO_FINAL" %in% names(mor)) mor[, Peso := PESO_FINAL]
  if (!"Cor" %in% names(mor)) mor[, Cor := NA_integer_]
  if (!"UF" %in% names(mor)) mor[, UF := NA_integer_]
  if (!"TIPO_SITUACAO_REG" %in% names(mor)) mor[, TIPO_SITUACAO_REG := NA_integer_]
  cols <- intersect(c("id_uc", "Peso", "RGMT", "UPA", "ESTRATO", "UF", "TIPO_SITUACAO_REG",
                      "N_moradores_UC", "Sexo", "Idade", "Cor"), names(mor))
  uc <- unique(mor[PosDom == 1, ..cols], by = "id_uc")
  data.table::setnames(uc, c("Sexo", "Idade", "Cor", "TIPO_SITUACAO_REG"), c("Sexo_ref", "Idade_ref", "Cor_ref", "Situacao_cod"))
  uc[, UF := as.integer(UF)]
  uc[, regiao := c("Norte", "Nordeste", "Sudeste", "Sul", "Centro-Oeste")[UF %/% 10]]
  uc[, situacao := data.table::fcase(Situacao_cod == 1, "Urbana", Situacao_cod == 2, "Rural", default = NA_character_)]
  uc[, Situacao_cod := NULL]
  uc <- uc[!is.na(Peso)]

  b <- merge(merge(uc, g_n1, by = "id_uc", all.x = TRUE), g_fo, by = "id_uc", all.x = TRUE)
  if (!is.null(g_it)) b <- merge(b, g_it, by = "id_uc", all.x = TRUE)
  for (v in c(sprintf("n%02d", grp$n1), paste0("f", folhas), names(itens))) {
    if (!v %in% names(b)) b[, (v) := 0] else data.table::set(b, which(is.na(b[[v]])), v, 0)
  }
  b[, Consumo := rowSums(.SD), .SDcols = sprintf("n%02d", n1_consumo)]
  if (!manter_sem_consumo) b <- b[Consumo > 0]
  b[, Consumo_pc := Consumo / N_moradores_UC]
  b[, Edicao := pof_edicao(ano)]
  data.table::setcolorder(b, "Edicao")
  data.table::setattr(b, "mapeamento", mapeamento)
  data.table::setattr(b, "harmonizacao", harmonizacao$versao)
  b[]
}

#' Soma os Níveis 1 em grandes grupos de consumo
#'
#' Acrescenta à base uma coluna por grupo de [pof_grupos()] (Alimentação,
#' Habitação etc.).
#'
#' @param b Base de [pof_ler_edicao()].
#' @return A base, com as colunas de grupo.
#' @export
pof_somar_grupos <- function(b) {
  grp <- pof_grupos(attr(b, "harmonizacao") %||% "v2")[consumo == TRUE]
  for (g in unique(grp$grupo)) {
    cols <- intersect(sprintf("n%02d", grp[grupo == g]$n1), names(b))
    b[, (g) := rowSums(.SD), .SDcols = cols]
  }
  b[]
}

#' Retira o aluguel do consumo
#'
#' O aluguel estimado de quem mora em imóvel próprio só aparece de 2002-2003
#' em diante: em 1995-1996 apenas cerca de 18% das UCs metropolitanas têm
#' aluguel, e em 1987-1988 o valor é muito baixo. Para comparar as cinco
#' edições, o aluguel sai do consumo e da Habitação, e consumo per capita e
#' quintis devem ser recalculados depois.
#'
#' @param b Base com grupos somados ([pof_somar_grupos()]).
#' @param col_aluguel Coluna do aluguel (folha `17101` na v2, `31001` na
#'   versão inicial).
#' @return A base sem o aluguel.
#' @export
pof_sem_aluguel <- function(b, col_aluguel = NULL) {
  if (is.null(col_aluguel)) col_aluguel <- if ((attr(b, "harmonizacao") %||% "v2") == "v2") "f17101" else "f31001"
  b <- data.table::copy(b)
  b[, Consumo := Consumo - get(col_aluguel)]
  hab <- "Habita\u00e7\u00e3o"
  if (hab %in% names(b)) data.table::set(b, j = hab, value = b[[hab]] - b[[col_aluguel]])
  versao <- attr(b, "harmonizacao")
  b <- b[Consumo > 0]
  b[, Consumo_pc := Consumo / N_moradores_UC]
  data.table::setattr(b, "harmonizacao", versao)
  b[]
}

`%||%` <- function(a, b) if (is.null(a)) b else a
