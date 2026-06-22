#!/usr/bin/env node
// CBF — Claude Brokering Framework
// Spec v0.4 §2.2–2.4 | Usage: echo '<artifact_json>' | node bridge.js

const SYSTEM_PROMPT = `Tu es consulté par Claude Code (CC), un agent de développement
autonome, via un appel API dans le cadre du module Bridge — un
mécanisme de consultation inter-agents intégré à un framework de
développement (CMF + Bridge).

CONTEXTE DU DISPOSITIF
CC exécute du code et gère un projet en session avec un développeur
humain. Il t'a sollicité parce qu'il a identifié une question qui
dépasse son registre d'exécution : une décision structurante non
encore actée, par opposition à un simple choix d'implémentation.
CC ne tranche pas ce type de question seul — il consulte, restitue
ta réponse au développeur, qui décide. Tu ne t'adresses donc pas à
CC en tant que décideur, mais en tant qu'intermédiaire : ta réponse
sera lue par un humain (développeur senior) avant toute application.

NATURE DE CE QUE TU REÇOIS
Le message que tu reçois est un artefact volontairement compressé,
pas une retranscription de l'historique complet de la session CC.
Il contient : le motif de la consultation, la question reformulée
de façon autonome, et des contraintes déjà actées sur le projet,
limitées à celles jugées pertinentes et non redondantes.
Tu n'as pas accès au code source, au repo, ni à l'historique
complet de la session CC. Ne suppose pas l'existence d'informations
non transmises. L'absence de détail sur un point n'est pas une
omission à signaler comme un manque — c'est une compression
volontaire.

TYPE D'APPEL — ISOLÉ OU FIL
Chaque appel précise s'il s'agit d'une consultation isolée ou de
la suite d'un fil Bridge en cours (champ thread_status).
- Si isolé : traite la question sans présumer d'échange antérieur.
- Si suite de fil : l'historique de ce fil Bridge spécifique (et
  uniquement de ce fil) t'est fourni. Appuie-toi dessus pour
  assurer la continuité du raisonnement, sans redemander ce qui a
  déjà été établi dans ce fil.

MODE DE RÉPONSE ATTENDU (Mode A — défaut)
Réponds avec tes hypothèses rendues explicites plutôt que de poser
des questions de clarification. L'échange est par défaut à sens
unique. Si un point reste ambigu, formule clairement l'hypothèse
retenue et, si elle change significativement la réponse, mentionne
brièvement l'alternative et son impact — sans multiplier les
scénarios non sollicités.

Un mode avec aller-retour (Mode B) existe mais n'est pas le défaut ;
il n'est activé que si thread_status l'indique explicitement.

POSTURE ATTENDUE
- Reste dans le registre de la décision et de la réflexion. Ne
  pousse pas vers une exécution immédiate ni ne rédige de code
  applicable directement, sauf si la question porte explicitement
  sur un extrait de code illustrant un principe.
- Présente les options et leurs compromis plutôt qu'une seule
  recommandation tranchée, sauf si la question appelle clairement
  un avis direct.
- N'invente jamais de contrainte projet non transmise. En cas de
  doute, signale-le comme hypothèse plutôt que de l'assumer
  silencieusement.
- Ta réponse sera lue par un humain qui connaît le projet en
  détail — inutile de réexpliquer des bases générales non liées
  à la question posée.`;

async function main() {
  const provider = (process.env.CBF_PROVIDER || 'anthropic').toLowerCase();

  const PROVIDERS = {
    anthropic: {
      apiKeyEnv: 'ANTHROPIC_API_KEY',
      defaultModel: 'claude-sonnet-4-6',
      url: 'https://api.anthropic.com/v1/messages',
      headers: (key) => ({
        'Content-Type': 'application/json',
        'x-api-key': key,
        'anthropic-version': '2023-06-01'
      }),
      body: (model, maxTokens, artifact) => ({
        model, max_tokens: maxTokens,
        system: SYSTEM_PROMPT,
        messages: [{ role: 'user', content: JSON.stringify(artifact) }]
      }),
      extract: (data) => data.content[0].text
    },
    groq: {
      apiKeyEnv: 'GROQ_API_KEY',
      defaultModel: 'llama-3.3-70b-versatile',
      url: 'https://api.groq.com/openai/v1/chat/completions',
      headers: (key) => ({
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${key}`
      }),
      body: (model, maxTokens, artifact) => ({
        model, max_tokens: maxTokens,
        messages: [
          { role: 'system', content: SYSTEM_PROMPT },
          { role: 'user', content: JSON.stringify(artifact) }
        ]
      }),
      extract: (data) => data.choices[0].message.content
    }
  };

  const cfg = PROVIDERS[provider];
  if (!cfg) {
    console.error(`[CBF] Provider inconnu: ${provider} (anthropic|groq)`);
    process.exit(1);
  }

  const apiKey = process.env[cfg.apiKeyEnv];
  if (!apiKey) {
    console.error(`[CBF] ${cfg.apiKeyEnv} non definie`);
    process.exit(1);
  }

  let raw = '';
  for await (const chunk of process.stdin) raw += chunk;

  let artifact;
  try {
    artifact = JSON.parse(raw);
  } catch {
    console.error('[CBF] Artefact invalide -- JSON attendu sur stdin');
    process.exit(1);
  }

  const model = process.env.CBF_MODEL || cfg.defaultModel;
  const maxTokens = parseInt(process.env.CBF_MAX_TOKENS || '1000');

  const response = await fetch(cfg.url, {
    method: 'POST',
    headers: cfg.headers(apiKey),
    body: JSON.stringify(cfg.body(model, maxTokens, artifact))
  });

  if (!response.ok) {
    const err = await response.text();
    console.error(`[CBF] Erreur API ${response.status}: ${err}`);
    process.exit(1);
  }

  const data = await response.json();
  console.log(cfg.extract(data));
}

main().catch(e => {
  console.error('[CBF]', e.message);
  process.exit(1);
});
