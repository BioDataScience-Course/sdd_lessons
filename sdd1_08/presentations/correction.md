<!-- README.md is generated from README.Rmd. Please edit that file -->
Correction par les pairs
========================

Guyliann Engels & Philippe grosjean
-----------------------------------

Cette activité porte sur la correction par les pairs. La liste des correcteurs par étudiant vous est proposée ci-dessous.

``` r
correction <- read$rds("../data/organisation.rds")
knitr::kable(correction, col.names = c("Etudiant (nom d'utilisateur GitHub)", "Correcteur (nom d'utilisateur GitHub)"))
```

| Etudiant (nom d'utilisateur GitHub) | Correcteur (nom d'utilisateur GitHub) |
|:------------------------------------|:--------------------------------------|
| Guillaumecorbisier                  | LucieMarin                            |
| oregore                             | Guillaumecorbisier                    |
| Youri-Nonclercq                     | oregore                               |
| LambertGuillaume                    | Youri-Nonclercq                       |
| LauraB09                            | LambertGuillaume                      |
| alissiasavu                         | LauraB09                              |
| Remi-Devorsine                      | alissiasavu                           |
| clement-tourbez                     | Remi-Devorsine                        |
| Clemence-Terzo                      | clement-tourbez                       |
| Charlotte-Terzo                     | Clemence-Terzo                        |
| vincentFlorquin                     | Charlotte-Terzo                       |
| elisa-pellegrino                    | vincentFlorquin                       |
| aymerichoyois                       | elisa-pellegrino                      |
| margauxrenier                       | aymerichoyois                         |
| Descal0411                          | margauxrenier                         |
| lauratoubeau                        | Descal0411                            |
| jolysarah                           | lauratoubeau                          |
| Remy-Courtoy                        | jolysarah                             |
| carinedongmo                        | Remy-Courtoy                          |
| SamuelKINDYLIDES                    | carinedongmo                          |
| Mathilde-Vion                       | SamuelKINDYLIDES                      |
| Victoria-Fragapane                  | Mathilde-Vion                         |
| mussoi-lisa                         | Victoria-Fragapane                    |
| Mathilde181930                      | mussoi-lisa                           |
| Eva-Michel                          | Mathilde181930                        |
| Remi-Santerre                       | Eva-Michel                            |
| MatheoLESNE                         | Remi-Santerre                         |
| Brieuxcollette                      | MatheoLESNE                           |
| gloria-scalzo                       | Brieuxcollette                        |
| 180112                              | gloria-scalzo                         |
| marie-dendievel                     | 180112                                |
| Ali-Alexandre                       | marie-dendievel                       |
| Hassane-Rolland                     | Ali-Alexandre                         |
| thomas-debont                       | Hassane-Rolland                       |
| GoireEleonore                       | thomas-debont                         |
| Apolline-michel                     | GoireEleonore                         |
| famgbertrand                        | Apolline-michel                       |
| LucieMarin                          | famgbertrand                          |

Tâches
======

Réaliser un push sur github
---------------------------

Chaque étudiant doit:

-   Dans R Studio, sauvegarder les dernières modifications dans le projet : sdd1\_urchin\_bio-...(nom d'utilisateur)

exemple : sdd1\_urchin\_bio-Guyliann

-   Réaliser un **push**

Donner l'accès à son dépot
--------------------------

Chaque étudiant doit :

-   Aller sur la page internet de GitHub et plus précisément dans l'organisation BioDataScience-Course via l'URL suivant :

<https://github.com/BioDataScience-Course>

-   Accéder à son dépot en ligne dont le nom est : **sdd1\_urchin\_bio-...(nom d'utilisateur)**

exemple : sdd1\_urchin\_bio-Guyliann

-   Cliquer sur l'onglet **Settings** puis **Collaborators and teams**

-   Dans la section Collaborators, ajouter le nom de votre correcteur.

Le correcteur a maintenant l'accès à votre dépôt

Cloner le dépot à corriger
--------------------------

Chaque correcteur doit :

-   Cloner le dépôt de l'étudiant qu'il doit corriger.

-   Placer le projet dans **shared/projects/**

Correction
----------

### Le projet

Créez un fichier au format markdown que vous allez nommer "review.md" pour répondre à la question suivante :

-   Est-ce que le projet comprend un ensemble de sous-dossiers cohérent (R, analysis,...) ?

Ajoutez y vos commentaires globaux sur le travail

### Le rapport

Les corrections dans le rapport se font à l'aide d'un block quote, dont la syntaxe se trouve la section Pandoc's Markdown, directement dans le rapport (dans les zones de texte et non dans les chunks).

Il est également autorisé de barer le texte avec des doubles tildes.

<https://github.com/rstudio/cheatsheets/blob/master/rmarkdown-2.0.pdf>

**Ne corrigez pas la discussion et la conclusion (les rapports ne sont pas terminés)**

-   Est-ce que le rapport est entièrement exécutable ? Pouvez-vous cliquer sur **Run All** ?

Employez l'annexe portant sur la rédaction scientifique

<http://biodatascience-course.sciviews.org/sdd-umons/redaction-scientifique.html>

-   Est-ce que le rapport comprend l'ensemble des sections que doit contenir un rapport scientifique ?

-   Est-ce que chaque section du rapport est complète ? Par exemple, est ce que l'introduction remet l'expérience dnas son contexte ?

-   Est-ce que le rapport comprend des graphiques et des tableaux permettant de décrire les données ?

-   Est-ce que les graphiques et tableaux sont décrits dans le rapport ?
