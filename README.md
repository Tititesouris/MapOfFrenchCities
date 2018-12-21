# TP NIHM Carte intéractive

# Objectif
Cette interface a pour but de permettre à un utilisateur de visualiser les différentes caractéristiques des villes françaises. Cette interface met pour cela à disposition des outils de visualisation et de comparaison afin de permettre une perception par 3 points de vue.  
D'abord la visualisation des villes dans leur ensemble pour comprendre les effets d'ensemble et de proximité.  
Ensuite la comparaison d'une ville par rapport à toutes les autres pour comprendre en quoi elle se démarque.  
Enfin la comparaison directe d'une ville à une autre pour comprendre les propriétés communes et uniques.  
Ces outils sont exploitables à travers l'interface décrite ci-dessous.

### Les filtres histogrammes
En bas à droite de l'interface se situes deux histogrammes. Le premier représente la répartition de la populations des villes sur une échelle logarithmique. Le deuxième représente la répartition de la densité des villes sur une échelle logarithmique.  
Sur chaqun de ces histogrammes sont situés 2 sliders. Ces sliders permettent de filtrer les villes qui apparaissent sur la carte. Les sliders du haut permettent d'ajuster la valeur maximale des villes devant apparaitre, et les sliders du bas permettent d'ajuster la valeur minimale.  
À défaut d'avoir des axes labélisés sur les histogrammes, le titre indique les unités et la valeur correspondant à chaque slider est affichée au dessus de ceux-ci. La hauteur des histogrammes est linéaire et proportionelle à la valeur la plus élevée.  
J'ai choisi une échelle logarithmique pour pouvoir filtrer de manière précise. Sur une échelle linéaire il aurait été simple de filtrer les outliers, mais impossible de séparer des villes avec des valeurs proches. De plus, on voit plus clairement la répartition des valeurs sur une échelle logarithmique.  
Pour qu'il n'y ait pas de confusion, les valeurs exclues par les filtres sont représentées en gris et les valeurs inclues en vert.

### Carte
J'ai choisi de représenter les villes sur la carte par rapport à leur population. L'aire du cercle est linéairement proportionnel à la population. C'est à dire que le rayon du cercle est linéairement proportionnel à la racine carré de la population.  J'ai fais ce choix car on perçoit l'aire de manière beaucoup plus intuitive que le rayon.  
J'ai choisi des cercles pour représenter les villes plûtot qu'une autre forme d'abord par habitude, car les villes sont généralement représentée par des cercles ou des points, mais aussi car cela donnait une impression intéressante de zone d'influence.  

La couleur d'une ville est interpolée entre le vert et le rouge logarithmiquement en fonction de sa densité. J'ai choisis une échelle logarithmique car une échelle linéaire ne permettrait pas de comparer les densités. En effet, la majorité des densités sont proches et il y a quelques densités très élevées et très basses. Avec seulement 512 valeurs de couleur possible et encore moins en terme de perception des différences de couleurs, il fallait donc une échelle logarithmique. Cette couleur nous permet donc d'ordonner les ville par leur densité, mais elle ne permet pas de réellement juger de leur différence de densité à cause de l'échelle logarithmique.  
La couleur des villes est semi-transparent afin de pouvoir dinstuinguer les villes proches les unes des autres qui seraient autrement cachées. De plus, l'addition des couleurs par transparence permet de représenter le mix de densité sur une zone donnée.  

Autour de chaque ville se situe un cercle gris de taille constante. Celui-ci existe principalement pour permettre à l'utilisateur de repérer facilement la position de ville très peu peuplée (et donc avec une toute petite représentation), pour pouvoir ensuite zoomer dans leur direction si nécessaire.  
J'en ai cependant profité pour encoder l'altitude des villes dans la valeur du gris de ces cercles. Un gris clair indique une altitude élevée, un gris foncé une basse altitude. J'ai choisis du gris pour que la couleur de ces cercles ne rendent pas la lecture des couleurs des villes difficile.  

En passant son curseur au dessus d'une ville, celle-ci est mise en évidence par une bordure et son nom est indiqué au dessus du curseur. De plus, les informations de la ville apparaissent dans le cadrant "Compared city".  
Les villes les moins peuplées (donc les plus petites) apparaissent toujours au dessus des villes plus grandes afin de pouvoir sélectionner n'importe quelle ville (Il faudra cependant parfois devoir zoomer pour facilement sélectionner la ville).  
En cliquant sur une ville, celle-ci est mise en évidence par une large bordure et son nom est indiqué au dessus de la ville. De plus, les informations de cette ville apparaissent dans le cadrant "Selected city". La ville est dé-sélectionnée si on clique dessus une nouvelle fois.  
La ville survolée par le curseur est toujours dessinnée par dessus toutes les autres, avec la ville sélectionnée étant toujours au deuxième plan. Cela permet de pouvoir sélectionner une nouvelle ville se situant sous la ville sélectionnée.  
La ville sélectionnée est toujours affichée, même si des filtres qui devraient l'exclure de la carte sont choisit. Cela permet de comparer cette ville à un groupe de villes en filtrant sur les caractéristiques qui nous intéressent.  

Il est possible de zoomer sur la carte avec la molette de la souris. Attention, la position du zoom sur la carte se fait en fonction de la position du curseur dans le cadre, et non pas en fonction de la position du curseur par rapport à la portion de carte affichée. Cela est plutot désorientant, mais je n'ai malhereusement pas réussis à faire fonctionner le zoom autrement.  
En appuyant sur la touche entrée, la page wikipédia de ville sélectionnée s'ouvrira dans le navigateur.

### Les cadrants
En haut à droite de l'interface se situent 4 cadrants.  
Le cadrant "Information" liste des informations globales qui sont utiles à la compréhension et à la manipulation.  
Le cadrant "Interactions" liste les moyens d'intéragir avec l'interface.  
Les cadrants "Selected city" et "Compared city" listent respectivement les informations sur la ville sélectionnée et la ville survolée.  
Les informations de la ville survolée ayant une valeur plus grande sont écrit en vert et les informations ayant une valeur plus petites sont écrit en rouge. Cela permet, sans nécessairement regarder les valeurs, de pouvoir comparer les deux villes.  
Les deux cadrants des villes analysées sont placés côte à côte afin de pouvoir facilement comparer ligne à ligne leurs propriétés.

### Les filtres prédéfinis
Afin de permettre à l'utilisateur de se familiariser avec les filtres et de l'inspirer à tester différentes combinaisons, une série de boutons sont placés à droite de l'interface au dessus des histogrammes. Ces boutons, losrqu'on clique dessus, vont modifier les valeurs minimales et maximales des deux filtres pour mettre en évidence un groupe de villes ayant des caractéristiques particulières.  
Le bouton "Villages" affiche les villes de moins de 100 habitants.  
Le bouton "Ghost towns" affiche les villes avec une population de 0 habitants (Appuyer sur la touche entrée sur une de ces villes pour en savoir plus, c'est vraiment cool).  
Le bouton "Dense cities" affiche les villes avec une densité supérieure à 5000 habitants par km².  
Le bouton "Chill municipalities" affiche les villes avec une population d'au moins 3000 habitants et une densité de population inférieure à 50 habitants par km².

### Les fonctionnalités à ajouter dans le futur
- Faire fonctionner le zoom correctement
- Afficher les valeurs moyenne et médiane sur les histogrammes
- Changer l'apparence des boutons pour qu'ils ressemblent plus à des boutons

### Sources
Documentation Processing : [https://processing.org/reference/]()