# ------------------------------------------------------------------
# data-raw/exportar_atlas.R
# Gera o painel interativo (pkgdown/assets/atlas/index.html) a partir das
# tabelas de pof_resultado(). Os achados sao escritos aqui, a partir dos
# numeros, para que nenhum valor do painel seja digitado a mao.
# Uso: Rscript data-raw/exportar_atlas.R (com o pacote instalado)
# ------------------------------------------------------------------
suppressMessages({ library(pofanalise); library(data.table); library(jsonlite) })
f1 <- function(x) pof_fmt(x, 1); f2 <- function(x) pof_fmt(x, 2); f3 <- function(x) pof_fmt(x, 3)

g   <- pof_resultado("grupos");   grm <- pof_resultado("grupos_rm")
q   <- pof_resultado("quintis_rms"); en <- pof_resultado("engel")
de  <- pof_resultado("desigualdade"); drm <- pof_resultado("desigualdade_rm")
cmp <- pof_resultado("comparacao_ibge"); mp <- pof_resultado("mapeamento")
al  <- pof_resultado("alimentacao_rms"); it <- pof_resultado("itens_rms")
pv  <- pof_resultado("prevalencia_rms"); pb <- pof_resultado("prevalencia_quintil_brasil")
se  <- pof_resultado("saude_educacao_quintil_rms"); pi <- pof_resultado("perfil_indice")
ja  <- pof_resultado("jogos_apostas")

sa <- "RMs, sem aluguel"
v   <- function(gr, ed) g[Recorte == sa & Item == gr & Edicao == ed]$Perc
qv  <- function(gr, ed, k) q[Item == gr & Edicao == ed & Nivel == k]$Perc
rz  <- function(gr, ed) qv(gr, ed, 1) / qv(gr, ed, 5)
el  <- function(gr, ed) en[Grupo == gr & Edicao == ed]$elasticidade
gi  <- function(rec, ed, c = "Gini") de[Recorte == rec & Edicao == ed][[c]]
pbv <- function(cod, ed, k) pb[Item == cod & Edicao == ed & Nivel == k]$Perc
piv <- function(d, nv, ed, col = "Indice_consumo_pc") pi[Dimensao == d & Nivel == nv & Edicao == ed][[col]]
alv <- function(cod, ed) al[Item == cod & Edicao == ed]$Perc
itv <- function(cod, ed) it[Item == cod & Edicao == ed]$Perc
pvv <- function(cod, ed) pv[Item == cod & Edicao == ed]$Perc
v2 <- "v2 com correções_2017-2018"

catalogo <- list(
  list(id = "estrutura", arquivo = "../articles/estrutura-orcamento.html", titulo = "Estrutura do orçamento", script = "pof_participacao()",
       pergunta = "Como a despesa de consumo se distribui entre os grandes grupos e como isso mudou entre 1987 e 2018?",
       metodo = "Razão de totais ponderada com IC do desenho amostral; RMs nas cinco edições e Brasil de 2002 em diante.",
       achados = c(sprintf("Alimentação cai de %s%% para %s%% do consumo sem aluguel nas RMs.", f1(v("Alimentação", "1987-1988")), f1(v("Alimentação", "2017-2018"))),
                   sprintf("Saúde sobe de %s%% para %s%%; educação, de %s%% (1995) para %s%%.", f1(v("Assistência à saúde", "1987-1988")), f1(v("Assistência à saúde", "2017-2018")), f1(v("Educação", "1995-1996")), f1(v("Educação", "2017-2018"))),
                   sprintf("Em 2017, %d dos %d grupos ficam a menos de 1,5 p.p. do IBGE.", sum(abs(cmp[[v2]] - cmp$Oficial_2017) < 1.5), nrow(cmp)))),
  list(id = "engel", arquivo = "../articles/engel.html", titulo = "Quintis e curvas de Engel", script = "pof_engel()",
       pergunta = "Como o peso de cada grupo varia com o nível de consumo?",
       metodo = "Quintis de consumo per capita ponderados por pessoa; Working-Leser por MQO ponderado.",
       achados = c(sprintf("Alimentação no 1º quintil: %s%% em 1987, %s%% em 2017.", f1(qv("Alimentação", "1987-1988", 1)), f1(qv("Alimentação", "2017-2018", 1))),
                   sprintf("Elasticidade-despesa da alimentação: %s em 1987, %s em 2017.", f2(el("Alimentação", "1987-1988")), f2(el("Alimentação", "2017-2018"))),
                   sprintf("Habitação sem aluguel: razão Q1/Q5 de %s em 1987 e %s em 2017.", f2(rz("Habitação", "1987-1988")), f2(rz("Habitação", "2017-2018"))))),
  list(id = "alimentacao", arquivo = "../articles/alimentacao.html", titulo = "Composição da alimentação", script = "pof_participacao(den = \"Alimentação\")",
       pergunta = "O que mudou na cesta alimentar?",
       metodo = "Participação das 16 categorias de alimentos e da folha Refeição no gasto alimentar.",
       achados = c(sprintf("Refeição vai de %s%% para %s%% do gasto alimentar nas RMs.", f1(alv("f16104", "1987-1988")), f1(alv("f16104", "2017-2018"))),
                   sprintf("Carnes: %s%% em 1987, %s%% em 2017.", f1(alv("n07", "1987-1988")), f1(alv("n07", "2017-2018"))),
                   sprintf("Laticínios: %s%% em 1987, %s%% em 2017.", f1(alv("n11", "1987-1988")), f1(alv("n11", "2017-2018"))))),
  list(id = "habitacao", arquivo = "../articles/habitacao-transporte.html", titulo = "Habitação e transporte", script = "pof_prevalencia()",
       pergunta = "Como evoluíram aluguel, energia, telefonia, transporte coletivo e veículo?",
       metodo = "Participação no consumo sem aluguel e prevalência de gasto, por quintil.",
       achados = c(sprintf("Aluguel registrado em %s%% das UCs em 1995 e %s%% em 2002: quebra de série.", f1(pvv("f17101", "1995-1996")), f1(pvv("f17101", "2002-2003"))),
                   sprintf("UCs com gasto em transporte coletivo: %s%% em 2008, %s%% em 2017.", f1(pvv("f20101", "2008-2009")), f1(pvv("f20101", "2017-2018"))),
                   sprintf("Telefone celular (serviço): %s%% do consumo sem aluguel em 2002, %s%% em 2017.", f1(itv("f17202", "2002-2003")), f1(itv("f17202", "2017-2018"))))),
  list(id = "saude", arquivo = "../articles/saude-educacao.html", titulo = "Saúde e educação", script = "pof_prevalencia(por = \"Quintil\")",
       pergunta = "Quem gasta do próprio bolso com saúde e educação?",
       metodo = "Participação e prevalência por quintil, com IC para o Brasil de 2002 em diante.",
       achados = c(sprintf("Plano de saúde em 2017: %s%% das UCs do 1º quintil e %s%% do 5º.", f1(pbv("f22301", "2017-2018", 1)), f1(pbv("f22301", "2017-2018", 5))),
                   sprintf("Remédios: %s%% do consumo do 1º quintil e %s%% do 5º (RMs, 2017).", f1(se[Item == "f22101" & Edicao == "2017-2018" & Nivel == 1]$Perc), f1(se[Item == "f22101" & Edicao == "2017-2018" & Nivel == 5]$Perc)),
                   sprintf("Curso superior pago no 3º quintil: %s%% das UCs em 2002, %s%% em 2017.", f1(pbv("f23102", "2002-2003", 3)), f1(pbv("f23102", "2017-2018", 3))))),
  list(id = "desigualdade", arquivo = "../articles/desigualdade.html", titulo = "Desigualdade do consumo", script = "pof_desigualdade(B = 200)",
       pergunta = "A desigualdade da despesa de consumo per capita diminuiu?",
       metodo = "Gini, P90/P10 e parcela dos 10% de maior consumo; IC por bootstrap de UPAs.",
       achados = c(sprintf("Gini no Brasil: %s em 2008, %s em 2017, sem sobreposição dos IC.", f3(gi("Brasil", "2008-2009")), f3(gi("Brasil", "2017-2018"))),
                   sprintf("Nas RMs, o pico é 1995 (%s); em 2017, %s.", f3(gi("RMs", "1995-1996")), f3(gi("RMs", "2017-2018"))),
                   sprintf("Os 10%% de maior consumo ficam com %s%% do consumo no Brasil em 2017.", f1(gi("Brasil", "2017-2018", "Top10"))))),
  list(id = "perfil", arquivo = "../articles/perfil.html", titulo = "Perfil da unidade de consumo", script = "pof_add_perfil()",
       pergunta = "Como o consumo varia com sexo, idade e cor da pessoa de referência e com o tamanho da UC?",
       metodo = "Consumo per capita como índice da média de cada edição; participação dos grupos.",
       achados = c(sprintf("UCs com mulher como pessoa de referência: %s%% em 1987, %s%% em 2017.", f1(piv("Sexo", "Mulher", "1987-1988", "Perc_UCs")), f1(piv("Sexo", "Mulher", "2017-2018", "Perc_UCs"))),
                   sprintf("Consumo per capita relativo em 2017: %s (branca) e %s (preta ou parda).", f1(piv("Cor", "Branca", "2017-2018")), f1(piv("Cor", "Preta ou parda", "2017-2018"))),
                   sprintf("UCs com 5 ou mais moradores: %s%% em 1987, %s%% em 2017.", f1(piv("Tamanho", "5 ou mais moradores", "1987-1988", "Perc_UCs")), f1(piv("Tamanho", "5 ou mais moradores", "2017-2018", "Perc_UCs")))))
)

transversais <- list(
  list(titulo = "O peso relativo dos mais pobres saiu da comida e foi para a moradia",
       texto = sprintf("A razão entre a participação no 1º e no 5º quintil cai de %s para %s na alimentação e sobe de %s para %s na habitação sem aluguel, de 1987 a 2017.",
                       f2(rz("Alimentação", "1987-1988")), f2(rz("Alimentação", "2017-2018")), f2(rz("Habitação", "1987-1988")), f2(rz("Habitação", "2017-2018"))),
       fontes = c("engel", "habitacao")),
  list(titulo = "A curva de Engel achatou, e as refeições prontas ajudam a explicar",
       texto = sprintf("A alimentação pesa %s%% no 1º quintil e %s%% no 4º em 2017, contra %s%% e %s%% em 1987. A folha Refeição vai de %s%% para %s%% do gasto alimentar.",
                       f1(qv("Alimentação", "2017-2018", 1)), f1(qv("Alimentação", "2017-2018", 4)), f1(qv("Alimentação", "1987-1988", 1)), f1(qv("Alimentação", "1987-1988", 4)),
                       f1(alv("f16104", "1987-1988")), f1(alv("f16104", "2017-2018"))),
       fontes = c("engel", "alimentacao")),
  list(titulo = "Serviços privados crescem no orçamento e seguem concentrados no topo",
       texto = sprintf("Saúde e educação chegam a %s%% e %s%% do consumo sem aluguel em 2017, mas o plano de saúde vai de %s%% das UCs no 1º quintil a %s%% no 5º. O curso superior pago é a exceção: se espalha pelos quintis do meio.",
                       f1(v("Assistência à saúde", "2017-2018")), f1(v("Educação", "2017-2018")), f1(pbv("f22301", "2017-2018", 1)), f1(pbv("f22301", "2017-2018", 5))),
       fontes = c("estrutura", "saude")),
  list(titulo = "Menos desigualdade, com a mesma hierarquia",
       texto = sprintf("O Gini do consumo no Brasil cai de %s para %s entre 2008 e 2017, mas o consumo per capita relativo por cor quase não muda (%s e %s em 2002; %s e %s em 2017).",
                       f3(gi("Brasil", "2008-2009")), f3(gi("Brasil", "2017-2018")), f1(piv("Cor", "Branca", "2002-2003")), f1(piv("Cor", "Preta ou parda", "2002-2003")),
                       f1(piv("Cor", "Branca", "2017-2018")), f1(piv("Cor", "Preta ou parda", "2017-2018"))),
       fontes = c("desigualdade", "perfil"))
)

ia <- function(nm) cmp[Item == nm]
confiab <- list(
  list(estado = "corrigido", item = "Refeições fora de casa em 2017 (quadro 24)",
       texto = sprintf("Sem categoria no código antigo; na v2 vão para 16104 Refeição. A alimentação de 2017 passa de %s%% para %s%%, contra %s%% do IBGE.",
                       f1(ia("Alimentação")[["Cod_harmo antigo_2017-2018"]]), f1(ia("Alimentação")[[v2]]), f1(ia("Alimentação")$Oficial_2017))),
  list(estado = "corrigido", item = "Telefonia celular em 2017 (quadro 44)",
       texto = sprintf("Na v2 original fica em 26102 Comunicação (outros), em Despesas diversas. pof_correcoes() leva contas para 17202 e aparelhos para 24201: habitação vai de %s%% para %s%% (IBGE %s%%) e despesas diversas, de %s%% para %s%% (IBGE %s%%).",
                       f1(ia("Habitação")[["v2 original_2017-2018"]]), f1(ia("Habitação")[[v2]]), f1(ia("Habitação")$Oficial_2017),
                       f1(ia("Despesas diversas")[["v2 original_2017-2018"]]), f1(ia("Despesas diversas")[[v2]]), f1(ia("Despesas diversas")$Oficial_2017))),
  list(estado = "corrigido", item = "Cobertura do de-para",
       texto = sprintf("Com a v2, %s%% do valor das despesas casa com o de-para em todas as edições.", f1(min(mp[versao == "v2 com correções"]$perc_casado)))),
  list(estado = "aberto", item = "Aluguel imputado",
       texto = sprintf("Presente para %s%% a %s%% das UCs metropolitanas de 2002 em diante e para %s%% em 1995. As comparações entre as cinco edições excluem o aluguel.",
                       f1(min(pv[Item == "f17101" & Edicao >= "2002"]$Perc)), f1(max(pv[Item == "f17101" & Edicao >= "2002"]$Perc)), f1(pvv("f17101", "1995-1996")))),
  list(estado = "aberto", item = "Educação e habitação em 1987",
       texto = "A folha de cursos regulares não existe em 1987, e habitação sem aluguel fica bem abaixo de 1995. Trate 1987-1988 como referência aproximada."),
  list(estado = "aberto", item = "Cor em 1987 e 1995",
       texto = "A variável não existe em 1987 e não tem as categorias usadas em 1995. A análise por cor começa em 2002.")
)

anteriores <- list(
  list(titulo = "Explorador da harmonização de produtos (Arthur Welle)", link = "https://arthurwelle.github.io/Harmoniza_Produtos/",
       resumo = "Navegue pelas 307 folhas da harmonização, veja os produtos de cada edição lado a lado e aponte problemas."),
  list(titulo = "Guia de pesquisa", link = "../articles/pesquisa.html",
       resumo = sprintf("Como analisar qualquer item com pof_buscar(), pof_carregar(), pof_analisar(), pof_diferenca() e pof_modelo(). Exemplo: o gasto com jogos e apostas aparece em %s%% das UCs do Brasil em 2017.", f1(ja[Edicao == "2017-2018"]$Perc)))
)

eds <- c("1987-1988", "1995-1996", "2002-2003", "2008-2009", "2017-2018")
seis <- c("Alimentação", "Habitação", "Transporte", "Assistência à saúde", "Educação", "Vestuário")
dados <- list(
  gerado = format(Sys.Date(), "%d/%m/%Y"),
  nUC = sum(unique(g[(Recorte == "Brasil") | (Recorte == sa & Edicao %in% eds[1:2]), .(Edicao, N_UC)])$N_UC),
  edicoes = eds,
  grupos_rms = g[Recorte == sa, .(Edicao, Grupo = Item, Perc = round(Perc, 2))],
  grupos_rm = grm[, .(Edicao, RM = Nivel, Grupo = Item, Perc = round(Perc, 2))],
  grupos_br = g[Recorte == "Brasil", .(Edicao, Grupo = Item, Perc = round(Perc, 2), Li = round(IC_inf, 2), Ls = round(IC_sup, 2))],
  quintis = q[, .(Edicao, Quintil = Nivel, Grupo = Item, Perc = round(Perc, 2))],
  elasticidade = en[Grupo %in% seis, .(Edicao, Grupo, e = round(elasticidade, 3))],
  gini = de[, .(Edicao, Recorte, Gini = round(Gini, 4), Li = round(Gini_IC_inf, 4), Ls = round(Gini_IC_sup, 4), Top10 = round(Top10, 2), P90_P10 = round(P90_P10, 2))],
  gini_rm = drm[, .(Edicao, RM, Gini = round(Gini, 4))],
  ibge = cmp[, .(Grupo = Item, Of08 = Oficial_2008, Ca08 = round(`v2 com correções_2008-2009`, 2), Of17 = Oficial_2017,
                 Ca17 = round(get(v2), 2), Dif17 = round(get(v2) - Oficial_2017, 2))],
  catalogo = catalogo, anteriores = anteriores, transversais = transversais, confiab = confiab)

tpl <- paste(readLines("data-raw/atlas_template.html", encoding = "UTF-8", warn = FALSE), collapse = "\n")
out <- sub("/*DADOS*/", paste0("window.POF = ", toJSON(dados, auto_unbox = TRUE, na = "null", digits = NA), ";"), tpl, fixed = TRUE)
dir.create("pkgdown/assets/atlas", recursive = TRUE, showWarnings = FALSE)
writeLines(enc2utf8(out), "pkgdown/assets/atlas/index.html", useBytes = TRUE)
cat("pkgdown/assets/atlas/index.html gerado\n")
