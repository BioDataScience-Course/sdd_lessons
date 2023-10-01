# Interprétation des métriques en classification supervisée

L'interprétation des métriques est un peu complexe car\ :

- Leur interprétation est *relative* (comparer deux ou plusieurs classifieurs),

- Leurs valeurs sont soumises à variation par rapport à la *probabilité a priori*

- La *valeur de référence* varie également


## Valeur de référence

Vous pouvez établir une valeur de référence (valeur qu'il faut améliorer pour que le classifieur valle la peine d'être utilisé) en considérant comme classifieur le plus simple celui qui prédit tous les individus dans la classe la plus abondante.

Dans un cas à deux classes et 50% dans chacune, la valeur de référence pour le taux global de reconnaissance (= accuracy) est donc de 50%. Le classifieur devra faire mieux obligatoirement. Par contre, si les classes sont très mal balancées (par exemple 99% *versus* 1%), la valeur de référence est alors de 99% d'un point de vue global (mais d'autres métriques peuvent, par exemple, focaliser sur la classe rare, tel recall et precision pour cette classe-là). Il faudra de toutes manières que le classifieur fasse mieux que les résultats obtenu pour le classifieur naïf, tout dans la classe la plus abondante.


## Probabilité a priori

La probabilité *a priori* correspond à l'estimation des probabilités à classer les particules en fonction de leur abondance relative dans l'échantillon. Dans le cas à deux classes, 50%/50% ou 99%/1% **aura un effet non négligeable** sur le résultat final de la classification. En fait, le résultat final est une combinaison des performances intrinsèques du classifieur et les probabilités *a priori* de telle façon que, plus une classe est rare, plus les performances de classification pour cette classe seront faibles (recall, precision, etc.). Cela peut se comprendre de plusieurs façon\ :

1. En utilisant l'arbre des probabilités

2. En utilisant le théorème de Bayes qui prédit la probabilité conditionnel d'appartenir à une classe `A` étant donné que le classifieur a indiqué que l'item est de cette classe = `PredA` (probabilité conditionnelle $P(A | PredA)$)\ :

$$P(A | PredA) = \frac{P(PredA | A) . P(A)}{P(PredA)}$$

qui peut aussi s'écrire (la prédiction de A étant la somme des vrais positifs ($P(PredA | A)$) et des faux positifs ($P(PredA | \bar{A})$) avec $\bar{A}$ correspondant à tout ce qui n'est pas A)\ :

$$P(A | PredA) = \frac{P(PredA | A) . P(A)}{P(PredA | A) . P(A) + P(PredA | \bar{A}) . P(\bar{A})}$$


Comme exercice, vous pouvez comparer les résultats de classification d'un classifier qui sépare les iris versicolor et virginica avec la matrice de confusion suivante (50 fleurs dans chaque classe dans le set d'apprentissage)\ :

|    | Ve | Vi |
|----|----|----|
| Ve | 49 | 1  |
| Vi | 4  | 46 |

Dans ce cas, on a du point de vue de versicolor (faites l'arbre des probabilités, si les calculs ne sont pas clair tels quels)\ :

- Vrais positifs (TP) = 0.5 * 0.98 = 0.49
- Faux positifs (FP) = 0.5 * 0.08 = 0.04
- Vrais négatifs (TN) = 0.5 * 0.92 = 0.46
- Faux négatifs (FN) = 0.5 * 0.02 = 0.01

Deux remarques : (1) les valeurs obtenues correspondent à celles comptabilisées dans la matrice de confusion quand les probabilités *a priori* sont les mêmes 50%/50%. Par contre (2), ces probabilités *a priori* interviennent dans les calculs. Cela implique que d'autres répartitions de fleurs changera la matrice de confusion et toutes les métriques calculées.

Prenons l'exemple d'un échantillon de 1090 fleurs, mais contenant 99% de virginica. Dan s ce cas, du point de vue de versicolor (la classe rare), nous obtenons ceci :

- Vrais positifs (TP) = 0.01 * 0.98 = 0.01
- Faux positifs (FP) = 0.99 * 0.08 = 0.08
- Vrais négatifs (TN) = 0.99 * 0.92 = 0.91
- Faux négatifs (FN) = 0.01 * 0.02 = 0.00

Comparez, en particulier, les taux de vrais négatifs et de faux négatifs. Dans le cas 50%/50%, on avait 49 TP versus 4 FP. Soit un très bon recall de 49/(49 + 4) = 92%. Mais dans le cas 1%/99%, on a 1 TP pour 8 FP, ce qui donne un recall de 1/(1 + 8) = 11%.

**Donc, avec le même classifieur, et sans que ses propriétés ne soient modifiées**, on passe d'un recall de 92% pour versicolor (cas abondant) à un recall de 11% pour la même classe lorsqu'elle est rare dans le cas 1%/99% !

