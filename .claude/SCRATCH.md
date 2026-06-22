# SCRATCH
> ÉPHÉMÈRE + PROVISOIRE uniquement
> PERMANENT → PROJECT.md | humain-relatif → native_CC

## ÉPHÉMÈRE
> expire session_CC+1 si non référencé — use it or lose it
> format: règle #raison @CC-N

# (vide au démarrage — exemples commentés)
# user_debug_verbose #utilisé_une_fois @CC-7
# threshold_test:0.001 #debug_surface_réfléchissante @CC-3

## PROVISOIRE
> format: règle:val #raison @CC-N→prov act:X pas:Y ✓[CC-a(a),CC-b(p)] →dest?
> ★ = seuil atteint (2 actifs OU 4 passifs) → promotion proposée
> ✗CC-N = contradiction → reset act/pas à 0

# Légende:
# act:X   = nb validations actives (Claude applique, humain ne corrige pas)
# pas:Y   = nb validations passives (session sans mention ni contradiction)
# (a)     = actif, (p) = passif
# →dest   = native_CC (humain-relatif) | perm_CMF (projet-spécifique) | ? (incertain)

# Exemples:
# user_commit_push_fin_session #pas_de_correction_3_commits
#   @CC-3→prov act:2 pas:1 ✓[CC-3(a),CC-4(p),CC-5(a)] →native_CC ★
#
# module_auth_JWT_sans_refresh #décision_archi
#   @CC-1→prov act:1 pas:3 ✓[CC-1(a),CC-2(p),CC-4(p),CC-5(p)] →perm_CMF
