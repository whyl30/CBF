# CBF — Claude Brokering Framework

## Déclenchement Bridge

Quand un message commence par `bridge:`, exécuter la séquence suivante (spec v0.4 §1.3) :

### 1. Former l'artefact (§2.3)

Construire le JSON de transfert :
- `trigger_reason` : motif précis qui pousse à consulter
- `question` : reformulée de façon autonome, compréhensible sans l'historique complet
- `constraints` : contraintes déjà actées pertinentes (vérifier CMF si présent — ne pas retransmettre ce qui y est déjà)
- `thread_status` : `isolated` (défaut) ou `continued` si suite d'un fil Bridge
- `thread_id` : null si isolé, sinon identifiant du fil en cours
- `thread_history` : inclure verbatim si la question référence un élément précis d'un échange Bridge précédent ; résumer dans `question` sinon
- Exclure : historique complet, code source, CMF brute

### 2. Afficher l'artefact (§2.5)

Montrer à l'utilisateur avant l'appel : motif, question reformulée, contraintes retenues.
!demander de confirmation séparée — `bridge:` vaut confirmation.

### 3. Appeler le script

```bash
echo '<artifact_json>' | node ~/.claude/cbf/bridge.js
```

Variables d'environnement :
- `ANTHROPIC_API_KEY` (obligatoire)
- `CBF_MODEL` (optionnel, défaut : `claude-sonnet-4-6`)
- `CBF_MAX_TOKENS` (optionnel, défaut : `1000`)

### 4. Restituer la réponse (§2.5)

Afficher la réponse à l'utilisateur sans l'appliquer.
Toute action issue de la réponse suit le circuit de validation humaine standard.

### 5. Calibration (§2.6)

Après restitution, poser : "Cette consultation était-elle pertinente ?"
- Réponse positive → `actif+1` dans la catégorie correspondante de `~/.claude/bridge_calibration.md`
- Réponse négative → `!contredit+1`, `actif` et `passif` remis à zéro
- Si nouvelle catégorie : créer l'entrée avec `trigger_reason` comme premier `#ex:`, statut `strict`
- Si `actif≥2 OU passif≥4` → proposer passage en mode `autonome` pour cette catégorie

## Règles strictes

- !appliquer_réponse_automatiquement
- !répondre_à_la_place_agent_consulté (Mode B : toute relance passe par l'humain)
- !transmettre historique_complet|code_source|CMF_brute dans l'artefact
- !déclencher_bridge_sans_mot-clé_explicite (sauf catégorie `autonome` dans bridge_calibration.md)
