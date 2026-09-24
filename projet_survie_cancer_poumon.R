# =====================================================================
# Projet : Analyse de survie de patients atteints d'un cancer du poumon avancé
# Données : NCCTG Lung Cancer (package R "survival", jeu "lung", 228 patients)
# Auteur  : Amadou LY
# =====================================================================
# Variables utiles :
#   time    : durée de suivi (jours)
#   status  : 1 = censuré, 2 = décédé
#   age     : âge (années)
#   sex     : 1 = homme, 2 = femme
#   ph.ecog : score ECOG (0 = asymptomatique ... 3 = alité > 50 % du temps)

# install.packages(c("survival", "survminer", "ggplot2"))
library(survival)
library(survminer)
library(ggplot2)

# ---- 1. Chargement et préparation des données ----------------------
data(cancer, package = "survival")      # charge le jeu "lung"
df <- lung
df$sex  <- factor(df$sex, levels = c(1, 2), labels = c("Homme", "Femme"))
df$ecog <- factor(df$ph.ecog)
df$event <- as.integer(df$status == 2)  # 1 = décès, 0 = censure

str(df)
summary(df)
colSums(is.na(df))                       # valeurs manquantes

# Statistiques descriptives
table(df$sex)
table(df$ecog, useNA = "ifany")
mean(df$event)                            # proportion de décès observés

# ---- 2. Kaplan-Meier global ----------------------------------------
km_all <- survfit(Surv(time, event) ~ 1, data = df)
print(km_all)                             # médiane de survie + IC 95 %
ggsurvplot(km_all, conf.int = TRUE, risk.table = TRUE,
           xlab = "Jours", ylab = "Probabilité de survie",
           title = "Survie globale (Kaplan-Meier)")

# ---- 3. Kaplan-Meier par sexe + test du log-rank -------------------
km_sex <- survfit(Surv(time, event) ~ sex, data = df)
print(km_sex)
survdiff(Surv(time, event) ~ sex, data = df)   # test du log-rank
ggsurvplot(km_sex, pval = TRUE, conf.int = TRUE, risk.table = TRUE,
           xlab = "Jours", ylab = "Probabilité de survie",
           title = "Survie selon le sexe")

# ---- 4. Kaplan-Meier par score ECOG --------------------------------
# (ECOG = 3 ne concerne qu'un patient : on le regroupe avec ECOG = 2)
df$ecog3 <- factor(ifelse(df$ph.ecog >= 2, "2-3", as.character(df$ph.ecog)))
km_ecog <- survfit(Surv(time, event) ~ ecog3, data = df)
survdiff(Surv(time, event) ~ ecog3, data = df)
ggsurvplot(km_ecog, pval = TRUE, risk.table = TRUE,
           xlab = "Jours", ylab = "Probabilité de survie",
           title = "Survie selon le score ECOG")

# ---- 5. Modèle de Cox multivarié -----------------------------------
cox <- coxph(Surv(time, event) ~ age + sex + ecog3, data = df)
summary(cox)             # exp(coef) = hazard ratio, avec IC 95 % et p-valeurs
ggforest(cox, data = df) # forest plot des hazard ratios

# ---- 6. Vérification de l'hypothèse des risques proportionnels -----
ph_test <- cox.zph(cox)
print(ph_test)           # p > 0,05 : pas de violation détectée
ggcoxzph(ph_test)

# ---- 7. À rédiger (README GitHub) ----------------------------------
# - Médiane de survie globale et par groupe (lue dans print(km_...))
# - Résultat du log-rank (sexe, ECOG)
# - HR du sexe et de l'ECOG avec IC 95 % : interprétation clinique
#   ex. "À âge et ECOG égaux, les femmes ont un risque instantané de décès
#        plus faible que les hommes (HR = ..., IC 95 % [...; ...])."
# - Limites : petit effectif, données anciennes, valeurs manquantes.
