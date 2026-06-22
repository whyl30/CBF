# bridge_calibration.md
> CBF — compteurs calibration cross-projet
> emplacement: ~/.claude/bridge_calibration.md
> grammaire: compression CMF | !modifier_manuellement sauf forçage_humain

# CALIBRATION
# (vide au démarrage — catégories émergent à l'usage)
#
# format:
# cat:id #ex:"motif_exemple_1|motif_exemple_2"
#   actif:N passif:N !contredit:N
#   →statut:strict
#
# statuts: strict(défaut) | promu_propose(seuil atteint) | autonome(promu|forcé)
# promotion: actif≥2 OU passif≥4 → promu_propose
# contradiction: actif+passif→0, !contredit+1 (historique conservé)
# forçage_manuel: humain peut passer directement à autonome
