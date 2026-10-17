#!/bin/sh
# Genera un .zip por skill en dist/, listo para subirlo al creador de agentes de Copilot.
set -e
cd "$(dirname "$0")/agente/skills"
mkdir -p ../../dist
for d in */; do
  n="${d%/}"
  rm -f "../../dist/$n.zip"
  zip -qr "../../dist/$n.zip" "$n"
done
ls ../../dist
