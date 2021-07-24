# Nettoyeur de traduction pour projets open-source adeptes du langage épicène

Le langage épicène, ou inclusif, s'impose par la force, sans laisser le choix aux utilisateurs qui souhaitent bénéficier d'un français intact et non militant.

Il est désolant de voir notre belle langue écorchée de la sorte par une minorité bien-pensante qui ne se soucis guère de débattre ou de laisser le libre choix à chacun de la langue à employer.

Ce script bash entend rendre aux administrateurs utilisant des logiciels open-source le droit à un français normal, non militant, et respectueux de la grammaire française.

---

Ce projet fait suite à la création du plugin [wordpress-sans-epicene](https://github.com/Zeldemir/wordpress-sans-epicene) visant au même objectif pour le logiciel Wordpress.

---

### Usage:

Le script `nettoyeur_epicene.sh` est conçu pour être utilisé dans une tâche [cron](https://fr.wikipedia.org/wiki/Cron) régulière afin de débarrasser les traductions de toute trace de langage inclusif.

Le script `nettoyeur_epicene.sh` prend en premier argument le chemin du dossier à traiter.
Il est utile de réduire la cible au plus petit dénominateur commun, afin d'éviter une surcharge de travail inutile.

Il prend également en second argument optionnel un filtre à appliquer aux fichiers à analyser.
Ce filtre est une [regex](https://fr.wikipedia.org/wiki/Expression_r%C3%A9guli%C3%A8re) au format ERE (Extended Regular Expressions) appliqué par [grep](https://fr.wikipedia.org/wiki/Grep).

Le filtre par défaut est `.php$|.json$|.js$|.po$|.yml$`

*Exemple:*
```bash
nettoyeur_epicene.sh "/var/www/wordpress/wp-content/languages"
nettoyeur_epicene.sh "/var/www/opensondage" "json"
```

Un dossier de backup est créé pour chaque chemin à traiter par le script. Celui-ci contient les fichiers de traductions originaux avant modification par le script.

Un somme de contrôle est également calculée pour chaque dossier à traiter. Si aucun fichier n'est modifié entre 2 exécutions du script, celui-ci ne vérifiera pas à nouveau les fichiers.

À l'issue de l'exécution du script, un diff est calculé afin d'afficher les corrections faites par le script. Dans le cas d'une tâche cron, il sera envoyé par mail à l'adresse `root`.

---

### Fonctionnement:

Le script `nettoyeur_epicene.sh` cherche dans le dossier indiqué tout les fichiers correspondants au filtre utilisé.
Dans ces fichiers, il cherche les occurrences à des termes inclusifs et les retire.

La liste des termes inclusifs à rechercher et remplacer est contenu dans le fichier `chaines_epicene.sh` sous la forme de 2 chaînes de caractères acceptant les regex ERE (Extended Regular Expressions) sous la forme suivante:
```
>Chaîne à trouver<::>Chaîne de remplacement<
```

> Une recherche des termes "fr", "locale" ou "i18" peut aider à repérer les dossiers de traductions dans une application.

---

Il est vivement conseiller de surveiller les résultats du diff à la fin de l’exécution du script, afin de s'assurer qu'aucune erreur n'a été introduite dans les traductions.

Si vous êtes confrontés à des formes de langage inclusif non pris en charge par ce script, une [Pull Request](https://github.com/maniackcrudelis/nettoyeur_epicene/pulls) ou une [Issue](https://github.com/maniackcrudelis/nettoyeur_epicene/issues) sont les bienvenues
