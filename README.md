# analyse-survie-cancer-poumon-
Analyse de survie (Kaplan-Meier, log-rank, Cox) sur données cliniques – R
# Analyse de survie de patients atteints d'un cancer du poumon avancé

Projet personnel de biostatistique réalisé en R.

## Objectif
Identifier les facteurs associés à la survie de patients atteints
d'un cancer du poumon avancé : sexe, âge et état général (score ECOG).

## Données
Essai NCCTG (Mayo Clinic), 228 patients, jeu `lung` du package R `survival`.
165 décès observés, 63 patients censurés.

## Méthodes
- Estimation de la survie par Kaplan-Meier
- Comparaison des groupes par le test du log-rank
- Modèle de Cox multivarié (âge, sexe, ECOG)
- Vérification des risques proportionnels (résidus de Schoenfeld)

## Résultats principaux
- Médiane de survie : 310 jours (270 chez les hommes, 426 chez les femmes ; log-rank p = 0,001)
- Femmes vs hommes : HR = 0,58 (IC 95 % 0,41 – 0,80)
- ECOG 2-3 vs ECOG 0 : HR = 2,50 (IC 95 % 1,60 – 3,90)
- Âge : pas d'effet significatif après ajustement (HR = 1,01 par an)
- Risques proportionnels : [vos p-valeurs de cox.zph]

![Survie selon le sexe](figures/km_sexe.png)
![Hazard ratios](figures/forest_cox.png)

## Limites
Petit échantillon, données anciennes, pas d'information sur le traitement ni le stade.

## Reproduire l'analyse
install.packages(c("survival", "survminer"))
Puis exécuter analyse_survie.R dans RStudio.

## Auteur
Amadou LY – Master 2 Probabilités et Statistiques Appliquées, Université de Lorraine
