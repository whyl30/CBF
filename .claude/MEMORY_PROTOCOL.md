# MEMORY_PROTOCOL — Format mémoire compressé Claude
> Coller ce fichier en début de session pour activer le protocole.
> Estimation : ~120 tokens — à injecter une fois par session.

---

## INSTRUCTION_CLAUDE

Tu utilises un format mémoire compressé optimisé pour minimiser les tokens.
Quand tu lis un fichier mémoire au format ci-dessous, tu le comprends nativement.
Quand tu mets à jour la mémoire en fin de session, tu appliques ces règles.

## GRAMMAIRE

### Opérateurs
:   assignation        clé:valeur
|   liste              a|b|c
>   dépendance         A>B
>>  flux               input>>transform>>output
!   interdit/rejeté    !redux
?   incertain          ?perf
~   approximatif       ~2k_users
@   localisation       Docker@AWS
#   raison/note        #perf_critique
*   priorité haute     *auth
[t] timestamp          [2024-11]
↔   correspondance     A↔B
→   produit/résultat   input→output

### Règles de compression
- !articles (le/la/les/un/une)
- !verbes_état (est/utilise/contient) → implicite via :
- !prose_narrative → clé:valeur dense
- !tableaux_markdown → une ligne aplatie
- !répétitions
- blocs_code_bash → 1-2 lignes max
- nuances_techniques_non_triviales → prose_courte_1ligne max

### Structure sections
# META      — projet, phase, date, équipe
# STACK     — technologies
# ARCH      — arborescence, patterns
# PIPELINE  — flux de traitement
# API_FLOW  — endpoints
# MODELS    — structures de données
# ENV_KEY   — variables config importantes
# START     — commandes démarrage
# TODO      — tâches (* = priorité)
# RISKS     — risques techniques + mitigations
# !SCOPE    — hors périmètre explicite
# NEXT      — prochaines étapes ordonnées
# SESSION_LOG — historique sessions (ajout en fin de session)

## PROTOCOLE_FIN_DE_SESSION

→ voir FRAMEWORK.md#FIN_SESSION (source unique — !dupliquer ici)

## REPRISE_SESSION_INTERROMPUE

Si mémoire désynchronisée détectée (session précédente incomplète) :
- log conversation = source de vérité, toujours disponible sauf suppression volontaire
- relire log depuis dernier SESSION_LOG → reconstruire état → proposer sync avant de continuer
- coût : tokens supplémentaires, acceptable car exceptionnel

---

## EXEMPLE_VALIDE

```
# META
proj:MonProjet v:0.2 updated:[2024-11]
phase:dev team:1dev+Claude

# STACK
be:FastAPI|Python3.12 fe:React|TypeScript
db:PostgreSQL@Supabase !Redux

# SESSION_LOG
[2024-11-01] auth_service:done décision:!graphql#surcoût ?perf_db_N+1
[2024-11-08] report_generator:wip ICP_params_tuned#RMSE↓0.003
```
