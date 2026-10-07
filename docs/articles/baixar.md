# Baixar e instalar

## O pacote

| Arquivo | Para quem |
|----|----|
| [pofanalise_0.1.0.zip](https://talesalonso1996-ops.github.io/pofanalise/download/pofanalise_0.1.0.zip) (0,6 MB) | **Windows**: pacote pronto, não precisa compilar |
| [pofanalise_0.1.0.tar.gz](https://talesalonso1996-ops.github.io/pofanalise/download/pofanalise_0.1.0.tar.gz) (0,4 MB) | **Mac, Linux** ou quem prefere instalar do código-fonte |

### Instalar

1.  Instale as dependências, uma vez só:

``` r
install.packages(c("data.table", "survey", "ggplot2"))
```

2.  Instale o arquivo baixado. No RStudio: **Tools → Install Packages… →
    Install from: Package Archive File** e escolha o arquivo. Ou pelo
    console:

``` r
install.packages("C:/Users/voce/Downloads/pofanalise_0.1.0.zip", repos = NULL)       # Windows
install.packages("~/Downloads/pofanalise_0.1.0.tar.gz", repos = NULL, type = "source") # Mac/Linux
```

3.  Teste com a base de exemplo, que não precisa dos microdados:

``` r
library(pofanalise)
r <- pof_analisar(pof_exemplo(), "Jogos", por = "quintil")
r
plot(r)
```

Quem tiver acesso ao repositório no GitHub também pode instalar direto:
`remotes::install_github("talesalonso1996-ops/pofanalise")`.

## Os dados

O pacote analisa os **microdados harmonizados** das cinco edições da
POF, gerados pelo pipeline HarmonizaPOF2026 (arquivos
`POF<ano>__GZ__Despesas_POF_<ano>.gz` e
`POF<ano>__RDS__MORADORES_H.RDS`). Eles não são distribuídos aqui. Com
os arquivos numa pasta, o fluxo é o do [Guia de
pesquisa](https://talesalonso1996-ops.github.io/pofanalise/articles/pesquisa.md):

``` r
dados <- pof_carregar(dir = "pasta/dos/microdados", itens = list(apostas = "26101"))
pof_analisar(dados, "apostas", por = "quintil")
```

A harmonização de produtos é baixada automaticamente do [repositório de
Arthur Welle](https://github.com/arthurwelle/Harmoniza_Produtos) na
primeira vez que você roda
[`pof_harmonizacao()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_harmonizacao.md).

## Resultados e scripts das análises

| Arquivo | Conteúdo |
|----|----|
| [pofanalise_resultados.zip](https://talesalonso1996-ops.github.io/pofanalise/download/pofanalise_resultados.zip) (0,1 MB) | Todas as tabelas das análises deste site, em CSV (separador `;`). As mesmas de [`pof_resultado()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_resultado.md). |
| [pofanalise_scripts.zip](https://talesalonso1996-ops.github.io/pofanalise/download/pofanalise_scripts.zip) (0 MB) | Scripts que geram os resultados a partir dos microdados e o código de cada página de análise. |

Dentro do R, as mesmas tabelas estão disponíveis sem baixar nada:
[`pof_resultado()`](https://talesalonso1996-ops.github.io/pofanalise/reference/pof_resultado.md)
lista os nomes e `pof_resultado("desigualdade")` lê uma delas.
