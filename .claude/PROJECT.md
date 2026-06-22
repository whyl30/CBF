# PROJECT — CBF (Claude Brokering Framework)
> mémoire projet CMF — PERMANENT+PROVISOIRE

# META
proj:CBF v:0.2 updated:[2026-06-22]
phase:pré-pilote team:odumas+Claude
spec:v0.4 statut:pilote-ready
adjacent:CMF #CMF=mémoire_projet CBF=brokering_consultation
chapeau:à_nommer_après_pilote #CMF+CBF+extensions_futures

# PROBLÈME
friction:context_switch VSC→claude.ai pour décision_structurante_non_actée
!problème_collaboration_IA → problème_détection+accessibilité
solution:CC relaie question vers agent_Claude_externe via API #sans quitter VSC

# STACK
format:Markdown #règles_comportementales comme CMF
script:JS|TS #appel_API /v1/messages
hooks:? #à_évaluer_pilote
api:provider-agnostic CBF_PROVIDER=anthropic(défaut)|groq model:claude-sonnet-4-6(anthropic)|llama-3.3-70b-versatile(groq) #fixé !Opus

# ARCH
composants:
  règle_détection → CLAUDE.md|FRAMEWORK.md #!skill → instruction_comportementale
  script_appel_API → déclenché_par_règle #bridge.js|ts à créer
  system_prompt → embarqué_dans_script §2.4 verbatim
  artefact_transfert → JSON §2.3
  calibration → ~/.claude/bridge_calibration.md #cross-projet !CLAUDE.md

fichiers_cibles:
  src/bridge.js|ts                  script appel API principal
  src/templates/bridge_calibration.md  template compteurs cross-projet
  src/templates/claude_instruction.md  snippet règle détection → injecter CLAUDE.md cible
  cbf-init.ps1|sh                   scripts init à la racine repo #pattern cmf-init.ps1|sh
  ~/.claude/bridge_calibration.md   destination runtime (copié par cbf-init)
!scripts_init_dans_src #racine_repo comme CMF

# PIPELINE
séquence: humain[mot-clé]>>CC[forme_artefact]>>CC[affiche_transparence]>>CC[appel_API]>>CC[restitue]>>humain[décide]
!confirmation_séparée #mot-clé=confirmation
!application_auto → validation_humaine_toujours

thread_mode:
  isolated:défaut #Mode_A hypothèses_explicites !clarification
  continued:aller-retour → toute_relance_passe_par_humain #Mode_B !défaut

# MODELS
artefact_transfert:
  type:consultation_request
  thread_status:isolated|continued thread_id:string|null
  trigger_reason:string question:string
  constraints:[{statement, source:session_courante|inconnu_de_claude}]
  thread_history:[{role:claude|human_via_cc, content}]
  !historique_complet !code_source !CMF_brute
  règle_thread_history: référence_élément_précis→inclure | rappel_général→résumé_dans_question

calibration_entry:
  cat:id #ex:"motifs_exemples" actif:N passif:N !contredit:N →statut:strict
  statuts: strict(défaut)|promu_propose(seuil_atteint)|autonome(promu|forcé)
  promotion: actif≥2 OU passif≥4 → promu_propose → humain_valide → autonome
  contradiction: actif+passif→0 !contredit+1 #historique_contradictions_conservé

# RELATION_CMF
CBF_vérifie:CMF_avant_artefact #contrainte_connue? !retransmettre
!mécanisme_dédié_CBF→CMF → décision_consultation suit sync_CMF_standard
risque:décalage_fraîcheur claude.ai↔PROJECT.md #hors_périmètre_CBF, hérite_sans_résoudre

# ENV_KEY
CBF_PROVIDER:anthropic(défaut)|groq
ANTHROPIC_API_KEY|GROQ_API_KEY:user_env_var persisté par cbf-init #registry Windows, profil shell Linux/Mac
CBF_MODEL:optionnel override modèle
max_tokens:1000 #à calibrer usage réel
!clé_exposée_auto_session_CC_courante → restart_CC_après_init

# TODO
✓ mot-clé:bridge: #POC, NL trop ambigu (overlap recherche_session vs consultation_externe)
✓ src/bridge.js #appel API + system_prompt §2.4 verbatim embarqué, stdin JSON
✓ src/templates/bridge_calibration.md #template compteurs cross-projet
✓ src/templates/claude_instruction.md #snippet règle détection+séquence complète
✓ cbf-init.ps1|sh #racine repo, bridge.js→~/.claude/cbf/, calibration+instruction injectés
✓ clé_API:user_env_var persisté cbf-init #provider-agnostic, restart CC requis après 1er init
✓ bridge.js:provider-agnostic CBF_PROVIDER=anthropic|groq #Groq pour POC test (free tier)
* pilote: observer catégories_émergentes §2.8 + fatigue_confirmation §2.8

# RISKS
faux_positifs:mot-clé_ambigu → bruit_calibration #!risque_archi géré_usage
sous-déclenchement:mot-clé_mal_choisi → problème_initial_persiste
dilution_responsabilité:boucle_humain→CC→Claude→CC→humain → mitigation:validation_systématique
coût_tokens:Mode_B_récurrent → surveiller

# !SCOPE
!détection_autonome_CC_au_départ #autonomie=promotion_méritée_uniquement
!fusion_mémoire CMF↔agent_consulté
!historique_brut dans artefact
!classifieur_externe !orchestrateur !taxonomie_a_priori
!résoudre_décalage_fraîcheur_claude.ai→PROJECT.md

# NON_SPÉCIFIÉ_PILOTE
mot-clé_exact:bridge: #POC → adapter après pilote si besoin
clé_API:user_env_var #POC→keytar post-pilote si distribution hors dev-context
max_tokens:à_calibrer
re-proposition_après_refus_promu_propose:cadence_non_définie
catégorie_autonome+contradictions_répétées:retour_strict=auto_ou_humain?
fiabilité_classification_simple:observer_empiriquement §1.7bis

# NEXT
1. ✓ mot-clé: bridge:
2. ✓ src/bridge.js + templates/
3. ✓ cbf-init.ps1|sh
4. pilote → observer §2.8

# SESSION_LOG
[2026-06-22] CC-1 init_projet|structure complète spec v0.4|mot-clé:bridge:|cbf-init.ps1+sh|provider-agnostic groq|clé API user_env_var|git:dev+main alignés ?test_bridge_bloqué_restart_CC [files:4 redirect:2 scope:✓ conv:✓]
