#!/bin/sh
# Genera en dist/:
# - penalisto.zip: el agente entero, para cargarlo como app personalizada (ADR 0007).
#   Necesita Node y la variable MATERIAL_COMUN_URL. La GitHub Action lo publica en cada cambio.
# - un .zip por skill, para el camino manual del creador de agentes de Copilot.
set -e
raiz="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$raiz/dist"

cd "$raiz/agente/skills"
for d in */; do
  n="${d%/}"
  rm -f "$raiz/dist/$n.zip"
  zip -qr "$raiz/dist/$n.zip" "$n"
done

if [ -z "$MATERIAL_COMUN_URL" ]; then
  echo "Sin MATERIAL_COMUN_URL: no genero penalisto.zip" >&2
else
  cd "$raiz"
  # ATK_FRONTIER hace que la CLI meta las skills en el paquete
  ATK_FRONTIER=true TEAMSFX_AGENT_SKILLS=true npx -y @microsoft/m365agentstoolkit-cli@1.1.18 package \
    --env dev --manifest-file ./agente/manifest.json \
    --output-package-file ./dist/penalisto.zip --output-folder ./build -i false
  # La CLI no falla si faltan las skills, así que lo compruebo
  unzip -l dist/penalisto.zip | grep -q "skills/.*/SKILL.md" || { echo "penalisto.zip sin skills" >&2; exit 1; }
fi
ls "$raiz/dist"
