#!/bin/bash

# Liste de chaînes de caractères à nettoyer
# Le format est comme suit:
# >Chaîne à trouver<::>Chaîne de remplacement<
#
# Attention, les chaînes sont lues dans l'ordre, soyez prudent sur les modifications apportée par une chaîne précédente.
# Les occurences les plus courtes doivent être à la fin

# Attention, il existe plusieurs points médians... Même au fond, on peut encore creuser...
# Toujours utiliser [·⋅•] pour tous les considérer.

# Écriture inclusive en "français".
chaine_a_nettoyer="
# auteur\/autrice
# auteur/autrice
>\\\\\\\\/autrices?<::><
>/autrices?<::><
# auteurs ou autrices
# Auteur ou autrice
> ou autrices?<::><
# de l’auteur ou de l’autrice
> ou de l’autrice<::><
# l’auteur ou l’autrice
> ou l’autrice<::><
# d’auteur ou d’autrice
> ou d’autrice<::><
# un auteur ou une autrice
> ou une autrice<::><

# administrateurs/administratrices
# administrateur/administratrice
>\\\\\\\\/administratrices?<::><
>/administratrices?<::><
# administrateurs ou administratrices
# administrateur ou administratrice
> ou administratrices?<::><
# l’administrateur ou l’administratrice
> ou l’administratrice<::><
# l’administrateur ou de l’administratrice
> ou de l’administratrice<::><
# l’administrateur ou à l’administratrice
> ou à l’administratrice<::><
# les administrateurs et les administratrices
> et les administratrices<::><
# un administrateur ou une administratrice
> ou une administratrice<::><
# administrateur, administratrice
>, administratrice<::><

# une développeuse ou un développeur
>une développeuse ou <::><
# les développeurs et les développeuses
> et les développeuses<::><

# éditeur/éditrice
>\\\\\\\\/éditrices?<::><
>/éditrices?<::><
# éditeurs ou éditrices
> ou éditrices?<::><

# contributeur/contributrice
>\\\\\\\\/contributrices?<::><
>/contributrices?<::><
# Contributrices & contributeurs
>Contributrices & c<::>C<

# Traductrices & traducteurs
>Traductrices & t<::>T<

# utilisateur/utilisatrice
>\\\\\\\\/utilisatrices?<::><
>/utilisatrices?<::><
# utilisateur ou utilisatrice
> ou utilisatrice<::><
# l’utilisateur ou l’utilisatrice
> ou l’utilisatrice<::><
# l’utilisateur ou à l’utilisatrice
> ou à l’utilisatrice<::><
# l’utilisateur ou de l’utilisatrice
> ou de l’utilisatrice<::><
# l’utilisateur et l’utilisatrice
> et l’utilisatrice<::><
# Utilisateurs et utilisatrices
> et utilisatrices<::><

# du commentateur ou de la commentatrice
> ou de la commentatrice<::><

# abonné/abonnée
>\\\\\\\\/abonnées?<::><
>/abonnées?<::><

# nouveaux·elles
# nouveau·elle
# ceux·elles
# qu\'il·elle·s
>[·⋅•]elle[·⋅•]s<::>s<
>[·⋅•]elles?<::><

# connecté·e
# déconnecté·e
# notifié·e
# reconnecté·e
# invité·e
# rencontré·e
>é[·⋅•]e[·⋅•]s<::>és<
>é[·⋅•]e<::>é<
# certain·e
# prêt·e
# petit·e ami·e
>[·⋅•]e[·⋅•]s<::>s<
>[·⋅•]e<::><

# administrateur·ice
# utilisateur·ice
# administrateur·ices
>s?[·⋅•]rices<::>s<
>[·⋅•]rice[·⋅•]s<::>s<
>[·⋅•]rice<::><
>s?[·⋅•]ices<::>s<
>[·⋅•]ice[·⋅•]s<::>s<
>[·⋅•]ice<::><
"

# Écriture inclusive en "anglais".
chaine_a_nettoyer="
$chaine_a_nettoyer
# h·er·is -> modifié par >·e<::>< en hr·is
>hr[·⋅•]is<::>his<
"
