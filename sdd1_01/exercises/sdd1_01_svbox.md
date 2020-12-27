Exercice du cours de [Science des Données Biologiques I de l'Université de Mons, module 01](http://biodatascience-course.sciviews.org/sdd-umons/decouverte-des-outils.html#machine-virtuelle).

![](../../template/biodatascience.png)

Objectif
--------

-   Repérer le fonctionnement général de la SciViews Box 2018

Procédure
---------

Une fois votre machine virtuelle configurée, vous vous trouvez face à cet écran lorsque vous la démarrez.

![](../images/desktop.png)

Découvrez ce nouvel environnement de travail et répondez aux questions suivantes :

-   Citez une application permettant d'écrire des équations mathématiques[1]. <iframe src="http://hosting.umons.ac.be/html/s807/sdd/sdd1_01/equalx.gif" width="1026" height="768" style="border:none;"></iframe>

Ensuite, utilisez cette application pour écrire la formule chimique suivante :

$$2H\_2 + O\_2 \\xrightarrow{n,m}2H\_2O$$

------------------------------------------------------------------------

-   Trouvez une application permettant de choisir des charactères spéciaux[2]. <iframe src="http://hosting.umons.ac.be/html/s807/sdd/sdd1_01/characters.gif" width="1026" height="768" style="border:none;"></iframe>

------------------------------------------------------------------------

-   Trouvez une application permettant de visualiser l'occupation de l'espace sur le disque[3]. <iframe src="http://hosting.umons.ac.be/html/s807/sdd/sdd1_01/disk.gif" width="1026" height="768" style="border:none;"></iframe>

-   Dans l'analyseur de disque, entrez dans le disque principal de la machine virtuel `box2018a` (l'application calcule l'occupation des fichiers qu'il contient... soyez patient, cela prend un peu de temps).
    -   Quel dossier occupe le plus de place sur le disque ?[4]
    -   Au sein de ce dossier quel sous-dossier occupe le plus de place ?[5]
    -   Au sein de ce second dossier quel sous-dossier occupe le plus de place ?[6]

Vous pouvez également observer que le graphique de l'application s'adapte lorsque vous entrez dans chaque répertoire.

------------------------------------------------------------------------

Lancez l'application `Mousepad` (un éditeur de texte simple). Vous pouvez y accéder également depuis le menu système `Applications`, à partir des favoris, ou de la section `Accessories`. Vous pouvez également y accéder depuis le **dock** qui se trouve en bas de la fenêtre de la SciViews Box[7]. Une fois `Mousepad` ouvert, écrivez-y la phrase suivante :

> **Je découvre un partie des applications présentes de la SciViews Box 2018.**

-   Sauvegardez votre fichier dans le dossier `~/Documents` sous le nom `test.txt`.

-   Recherchez votre fichier `test.txt` dans votre ordinateur hôte (Windows ou MacOS, par exemple) et notez la position du fichier[8].

-   Déplacez maintenant ce fichier `test.txt` vers le bureau de la machine virtuelle[9].

-   Déplacez à nouveau ce fichier dans le sous-dossier `projects` du dossier `shared`. Qu'observez-vous à partir de la machine hôte ?[10]

Bilan
-----

**Bravo ! Via ces quelques petits exercices ludiques, vous venez de comprendre le fonctionnement général de la SciViews Box.** Ce n'est pas très différent de Windows ou MacOS. Vous savez maintenant :

-   Accéder à vos applications depuis la barre système ou depuis le Dock,

-   Enregistrer vos documents au bon endroit si vous voulez pouvoir y accéder à la fois depuis la SciViews Box et depuis l'ordinateur hôte (dans le dossier partagé `shared`).

[1] Vous devez allez dans le menu `Applications` en haut à gauche dans la barre système puis recherchez `EqualX` soit dans les favoris, soit dans la section `Office`.

[2] Vous devez aller dans le menu système `Applications` puis dans la section `Accessoires`, pour sélectionner `Characters` ou `Character Map`.

[3] Dans le menu système `Applications` et dans la section `System`, vous sélectionnez `Disk Usage Analyzer`.

[4] Le dossier `usr` est le plus volumnieux.

[5] Le sous-dossier `local` est le plus gros au sein de `/usr`.

[6] Le sous-dossier `lib` occupe le plus de place dans `/usr/local`.

[7] Vous noterez que le dock se replie automatiquement lorsqu'une fenêtre le recouvre, mais il réapparait lorsque vous placer le curseur de la souris en bas de la fenêtre. Notez aussi que les applications que vous lancez y apparaissent et leurs fenêtres sont représentée par un point coloré en dessous de l'icône pour chaque fenêtre ouverte.

[8] Le fichier n'est pas accessible depuis la machine hôte.

[9] Ce fichier n'est toujours pas accessible depuis la machine hôte.

[10] Le fichier `test.txt` est à présent visible et manipulable également depuis la machine hôte. Il s'y trouve bien dans le sous-dossier `projects` du dossier `shared`.
