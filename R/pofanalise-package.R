#' pofanalise: análises da POF harmonizada
#'
#' Funções para analisar as cinco edições da Pesquisa de Orçamentos
#' Familiares (1987-1988 a 2017-2018) harmonizadas por Arthur Welle.
#' Comece por [pof_harmonizacao()] e [pof_ler_edicao()].
#'
#' @keywords internal
#' @import data.table
"_PACKAGE"

utils::globalVariables(c(
  ".", "..cols", "n1", "n1_num", "nome", "consumo", "grupo", "codigo", "codigo_int", "cod_final",
  "ano", "n", "n_folhas", "confianca", "ambiguo", "Codigo", "Valor_Mensal", "id_uc", "id_dom",
  "V0030", "V0050", "V0060", "V0065", "V0518", "UF", "NUM_SEQ", "NUM_DV", "UPA", "ESTRATO",
  "PESO_FINAL", "Peso", "Cor", "PosDom", "Consumo", "Consumo_pc", "N_moradores_UC", "Edicao",
  "RGMT", "Quintil", "Quintil_RM", "tem_", "x_", "w_", "Gini_IC_inf", "Gini_IC_sup",
  "corrigido", "Significativa", "ep", "ep_a", "ep_b", "De", "Para", "Diferenca", "Classificacao", "cons", "it", "w", "s", "s_de", "s_para", "w_de", "w_para", "Comportamento", "Composicao", "Parte", "Codigo", "txt", "elasticidade", "beta", "w_medio", "N", "quintil", "Nivel", "Perc", "IC_inf", "IC_sup", "N_UC", "Estimativa", "Grupo", "Jogos", "Sexo_ref", "Idade_ref", "Cor_ref", "n2", "descri_item", "nome_final", "y_", "g_", "..vars", "i.cod_final", "Alimentação", "Habitação", "Transporte", "Educação", "Habitação"))
