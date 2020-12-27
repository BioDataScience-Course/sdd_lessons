# Utilisation de devtools::install_github("gadenbuie/regexplain")
# Ouverture d'un nouveau R Notebook
# => recherche des parties en italique + remplacement par du gras
# Que faire par rapport à du texte déjà en gras?
pattern <- "\\*([a-zA-Z ]+)\\*" # perl=TRUE
replacement <- "**\\1**"
txt <- "Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Cmd+Option+I*."
gsub(pattern, replacement, txt, perl = TRUE)
# [1] "Add a new chunk by clicking the **Insert Chunk** button on the toolbar or by pressing *Cmd+Option+I*."
gsub("\\*([a-zA-Z ]+)\\*", "**\\1**", txt, perl = TRUE)
# Idem
gsub("\\*([a-zA-Z ]+)\\*", "**\\1**", txt, perl = TRUE) -> txt2
gsub("\\*([a-zA-Z ]+)\\*", "**\\1**", txt2, perl = TRUE)

## Split string
strsplit(txt, "*", fixed = TRUE)

## Donc, comment remplacer seulement si pas déjà en gras?
to_bold <- function(txt) {
  # We accept tags on several lines => first merge all lines in txt
  txt <- paste(txt, collapse = "\n")
  # Preserve ** or ***
  txt <- gsub("\\*{3}", "§°§°§°", txt)
  txt <- gsub("\\*{2}", "§°§°", txt)
  # Replace *text* by **text**
  txt <- gsub("\\*([^*]+)\\*", "**\\1**", txt)
  # Restore ** and *** (considering §° should not appear otherwise)
  txt <- gsub("§°", "*", txt)
  txt
}

to_bold(txt) -> txt2
to_bold(txt2)

# Problème quand on va à la ligne
(txt_multi <- c("Texte avec *italique", "sur deux lignes*."))
to_bold(txt_multi)

txt_chunk <- '---
title: "R Notebook"
output: html_notebook
---

This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. When you execute code within the notebook, the results appear beneath the code.

Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Cmd+Shift+Enter*.

```{r}
plot(cars)
```

Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Cmd+Option+I*.

```{r}
cat("J\'adore les expressions régulières!")
```


When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Cmd+Shift+K* to preview the HTML file).
'

# Extraire le code R

tangle <- function(txt) {
  # Collapse all the text in in single string
  txt <- paste(txt, collapse = "\n")
  # Split the string on chunk tags
  split <- strsplit(txt, "\n```(\\{r[^\\}]*\\})?\\s*\n")[[1]]
  # If there are no chunks, return an empty string
  if (length(split) < 2)
    return(character(0))
  # Collect even sections which should be inside chunks
  split[1:length(split) %% 2 == 0]
}

tangle(txt_chunk)

tangle2 <- function(txt) {
  # Each line is a separate item in a character vector
  txt <- unlist(strsplit(txt, "\n", fixed = TRUE))
  # Look for chunk starts
  chunk_start <- grepl("^```\\{r.*\\}\\s*$", txt)
  # Look for chunk ends
  chunk_end <- grepl("^```\\s*$", txt)
  # Code inside chunks (thus one line after chunk_start!)
  in_chunk <- as.logical(
    cumsum(c(0, chunk_start[-length(chunk_start)])) -
      cumsum(chunk_end))
  # Keep only code inside chunks
  txt[in_chunk]
}

tangle2(txt_chunk)




txt <- c(
	"Hello world!",
	"Hello everybody",
	"How are you, with your 1.567e+2 cm?",
	"I am fine, and I am 42 years old..."
)

# Recherche
regexpr("Hello", txt)
grep("Hello", txt)
grepl("Hello", txt)
# Extraire
txt[grepl("Hello", txt)]

# Remplacement
sub("Hello", "Salut", txt)
sub("you", "YOU", txt)
gsub("you", "YOU", txt)

# Début et fin de chaine
regexpr("y", txt)
regexpr("y$", txt)
regexpr("^y", txt)
# Caractères spéciaux
regexpr("a.. ", txt)
regexpr("\\.", txt)
regexpr("old\\.+$", txt)

# pattern1 ou pattern2
regexpr("I|you", txt)

# Multicaractères
regexpr("a[nr][de] ", txt)
regexpr("a[^nm]", txt)

# Capture de sous-chaine
sub("Hello ([a-zA-Z]+)", "Salut \\1", txt)

# Exercices...
#- Rechercher les chaines qui contiennent un nombre
grep("[0-9]", txt)

# - Remplacer o par O (une fois ou partout)
sub("o", "O", txt)
gsub("o", "O", txt)

# - Hello XXXX => Hello très cher XXXX
sub("Hello ([a-zA-Z]+)", "Hello très cher \\1", txt)

# - extraire le premier nombre
regmatches(txt, regexpr("[+-]?[0-9]+\\.?[0-9]*[eE]?[+-]?[0-9]*", txt))
sub("^[^0-9]*([0-9]*\\.?[0-9]*[eE]?[+-]?[0-9]*).*$", "\\1", txt)
# Forme plus évoluée...
res <- regexpr("[\\-\\+]?[0-9]*[\\.,]?[0-9]+[eE]?[\\-\\+]?[0-9]*", txt)
res2 <- regmatches(txt, res)
as.numeric(res2)

# - Hello XXXX => XXXX, Hello
sub("Hello ([a-zA-Z]+)", "\\1, hello", txt)

# - Nom de quelqu'un qui est salué...
res <- regexpr("[Hh]ello [a-zA-Z]+", txt)
substring(regmatches(txt, res), 7, 100)
# Par remplacement
sub("^.*[Hh]ello ([a-zA-Z\\-]+).*$", "\\1", txt) # But does not work if not found!
sub("^.*[Hh]ello ([a-zA-Z\\-]+).*$|^.*()$", "\\1", txt)

## Exercices
# - Dates anglais MM-JJ-YYYY -> français JJ-MM-YYYY
dates <- c("02-23-2015", "10-06-1999")
sub("([0-1][0-9])\\-([0-3][0-9])\\-", "\\2-\\1-", dates)

# - Dates => YYYY-MM-JJ
sub("([0-1][0-9])\\-([0-3][0-9])\\-([0-9]{4})", "\\3-\\1-\\2", dates)

# - Heures hh:mm:ss am/pm (heure 1-12) => hh:mm:ss (heure 1-24)
heures <- c("Time is 11:22:33 am", "11:22:33 pm")

# Récupère l'heure
h <- sub("^.*([0-1][0-9])[0-9:]{6} [a|p]m.*$|^.*()$", "\\1", heures)
# postion de l'heure
hpos <- regexpr("[0-1][0-9][0-9:]{6} [a|p]m", heures)
# Est-ce pm?
ispm <- grepl("^.*[0-9:]{8} pm", heures)
# Pour toutes les heures pm, remplacer par l'heure + 12
h[ispm] <- as.numeric(h[ispm]) + 12
substring(heures, hpos, 2) <- as.character(h)

for (i in 1:length(heures)) {
  if (ispm[i])
    substring(heures[i], hpos[i], 2) <- as.character(as.integer(h[i]) + 12)
}
# Eliminer am et pm
sub("([0-9:]{8}) [a|p]m", "\\1", heures)

## Exercice de coupure d'adn à agg ou aga avec exp. reg.
adn <- paste(sample(c("a", "g", "c", "t"), 500, replace = TRUE), collapse = "")
adn
regexpr("aga", adn)
regexpr("agg", adn)

# Simulation un grand nombre de fois:
adn_search <- function(codon, n = 1000) {
  adn <- character(n)
  for (i in 1:n)
    adn[i] <- paste(sample(c("a", "g", "c", "t"), n, replace = TRUE), collapse = "")
  res <- regexpr(codon, adn)
  res[res == -1] <- NA
  mean(res, na.rm = TRUE)
}
adn_search("agg")
adn_search("aga")

# Séparer une chaine en fonction d'un séparateur
# Exemple fichier de config clé = valeur
config <- c("nom=Obama", "prénom=Barak", "rôle=président")
strsplit(config, "=", fixed = TRUE)
# longueur de chaine
length(config) # Pas ça!
nchar(config)
# Transformer en majuscules ou minuscules
toupper(config)
tolower(config)
