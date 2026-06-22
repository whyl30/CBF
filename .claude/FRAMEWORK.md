# CMF v1.5
> Claude Memory Framework — gouvernance et opérations.
> Lire après MEMORY_PROTOCOL.md

# PRINCIPES
code_immuable:hors_session stateless:Claude→tout_injecter
mémoire=index_sémantique !réplique_code #code_reste_arbitre
source_vérité:log_conversation honnêteté:!brosse_sens_du_poil
scope:vibe_coding_binôme dev_senior+Claude_Code uniquement

# FICHIERS
## CMF .claude/ — mémoire projet, injection manuelle
MEMORY_PROTOCOL.md  !compresser #bootstrap_problem injecter:1er+toujours
PROJECT.md          PERMANENT+PROVISOIRE injecter:toujours
SCRATCH.md          ÉPHÉMÈRE+PROVISOIRE+compteurs injecter:si_pertinent
HISTORY.md          archive_opérationnelle !injecté_par_défaut créé:première_archivage_SESSION_LOG !inclus_bundle

## Mémoire native Claude Code — automatique, bootstrap garanti
MEMORY.md           index_fichiers_natifs #créer_si_absent
rôle_natif:         bootstrap_auto+règles_collaboration+profil_humain
rôle_CMF:           arch|stack|decisions|SESSION_LOG|CODE_MAP
!duplication        → rôles_distincts_sans_overlap

# RÈGLE_0
tout_fichier_mémoire→compressé
!exception:MEMORY_PROTOCOL.md #bootstrap_problem
!exception:frontmatter_YAML_Claude_Code #imposé_outil_hôte

# TEMPORALITÉ
SESSION    jamais_persisté → contexte_uniquement
ÉPHÉMÈRE   scratch uniquement expires:session_CC+1
           si: debug|tmp|test_ponctuel|Claude_incertain
PROVISOIRE scratch→PROJECT.md compteurs_actif/passif
           si: param_tunable|convention_à_valider|workaround
PERMANENT  PROJECT.md direct #1_vérité_courante_écrase
           si_direct: décision_archi|contrainte_externe|!exclusion_validée
           sinon: promotion_explicite_depuis_PROVISOIRE

# UNITÉ_DE_RÉFÉRENCE
session_CC: PR/branche = unité_mémoire_de_référence
commit:     unité_code !unité_mémoire #trop_granulaire

# PROMOTION_ÉPHÉMÈRE→PROVISOIRE
session_CC-N   : éphémère_créé
session_CC-N+1 : référencé → PROVISOIRE immédiat
                 absent    → supprimé #use_it_or_lose_it
!compteur_nécessaire → binaire

# PROMOTION_PROVISOIRE→DESTINATION
validation_active:  Claude_applique+humain_ne_corrige_pas @session_CC → signal_fort
validation_passive: session_CC_sans_mention_ni_contradiction → signal_faible
seuil:              2_actifs OU 4_passifs #point_de_départ_à_calibrer
contradiction:      reset_compteurs_à_0

destination_auto:
  même_humain_autre_projet? → native_CC (humain-relatif: préférences|workflow)
  autre_humain_même_projet? → PERMANENT_CMF (projet-spécifique: arch|stack|decisions)
classification: automatique(règle_auto) Claude_annonce humain_peut_contrer

# GOUVERNANCE
priorité: humain>règle_auto>Claude
Claude: classifier|détecter|proposer|argumenter_si_désaccord !modifier_silencieux
humain: surcharger_tout|valider_promotions|veto_toujours_possible
règle_auto: classifier_destination|incrémenter_compteurs|signaler_expires|supprimer_éphémères
!blanc_seing→Claude_argumente_sincèrement
si_humain_maintient→appliquer+noter_si_toujours_désaccord

# CONFLITS
évident: Claude_résout+SESSION_LOG !demander_confirmation
ambigu:  ?CONFLICT flag→arbitrage_à_deux !résoudre_silencieux
format:  ?CONFLICT clé:val_mémoire≠val_code #contexte
posture: mémoire_dit_A+code_dit_B → !conclure_mémoire_fausse → signaler+attendre

# DÉRIVE
scope:  fichiers_touchés_session_uniquement !audit_complet
types:  VALEUR(val_changée)|EXISTENCE(!x+x_dans_code)|OUBLI(fichier_inconnu)
timing: début(code_collé→comparer)|pendant(contradiction→flag)|fin(passe_légère)
résolution→voir CONFLITS

# FIN_SESSION
!terminer_si_code_modifié_sans_sync
checklist:
  1.lister_fichiers_modifiés
  2.màj_sections_impactées_PROJECT.md
  3.màj_CODE_MAP_si_nouveaux_fichiers
  4.màj_compteurs_PROVISOIRE
  5.supprimer_ÉPHÉMÈRE_expirés(session_CC+1_passée)
  6.proposer_promotions_si_seuil_atteint
  7.ajouter_SESSION_LOG
  8.incrémenter_v:META
  9.màj_mémoire_native_si_env_changé
SESSION_LOG_format: [date] fichiers|décisions|?points_ouverts [files:N redirect:N scope:✓|✗ conv:✓|✗]
SESSION_LOG_métriques: optionnelles #overhead_zéro ajout_dans_entrée_existante
  files:N    = fichiers_lus_avant_1ère_action
  redirect:N = corrections_humaines_pendant_session
  scope:✓|✗  = respect_périmètre_PR
  conv:✓|✗   = conventions_projet_appliquées_spontanément

# SESSION_LOG_GESTION
structurelle: arch|design|contrainte_fondamentale → !archiver_sans_discussion
opérationnelle: feature|bug|merge|fix → candidate_archive_~15sessions_sans_ref
signal_archivage: SESSION_LOG>~20_entrées → Claude_propose_révision
action: opérationnelles_anciennes → HISTORY.md !injecté_par_défaut
!archiver_sur_ancienneté_seule !archiver_automatiquement

# RISKS
git_branch: .claude/→commité_dans_git → suit_branche_automatiquement ✓
            !commité → désync_mémoire_sur_branch_switch #risque
            squash_merge: SCRATCH.md_feature_branch_perdu → comme_commits #voir_SESSION_LOG[2026-06-13]
mitigation: .claude/→toujours_commité|squash→sync_mémoire_avant_merge

# CHANGELOG
v1.0 [2024-11] framework_initial
v1.1 [2026-06] +mémoire_native_CC|+MEMORY.md|+RÈGLE_0_étendue
v1.2 [2026-06] +validation_empirique|+métriques
v1.3 [2026-06] +propriété_émergente|+référentiel_partagé|+posture_agent
v1.4 [2026-06] +SESSION_LOG_gestion|+archivage_HISTORY.md
v1.5 [2026-06] +mécanisme_promotion_complet|+unité_session_CC|+destination_auto
               refactor:séparation_format(MEMORY_PROTOCOL)/gouvernance(FRAMEWORK)
               supprimé:métriques_validation(→papier_uniquement)
