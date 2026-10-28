#!/usr/bin/env bash
# Preflight check before any exercise. Usage: ./check.sh
# Python is not checked: uv downloads the version each exercise needs.

fail=0
ok()  { echo "  OK   $1"; }
bad() { echo "  FAIL $1"; echo "       fix: $2"; fail=1; }

echo "Checking environment..."

for tool in uv aws node; do
  command -v "$tool" >/dev/null && ok "$tool" || bad "$tool not found" "brew bundle (from the repo root)"
done

if command -v node >/dev/null; then
  if node -e 'const [a,b]=process.versions.node.split(".").map(Number); process.exit(a>20||(a==20&&b>=12)?0:1)'; then
    ok "node $(node -v) (>= 20.12)"
  else
    bad "node $(node -v) is too old, agentcore-cli needs >= 20.12" "brew upgrade node"
  fi
fi

command -v agentcore >/dev/null && ok "agentcore" || bad "agentcore not found" "npm install -g @aws/agentcore"

if ! command -v docker >/dev/null; then
  bad "docker not found" "brew bundle (from the repo root)"
elif ! docker info >/dev/null 2>&1; then
  bad "docker daemon not reachable (colima not running?)" \
    "brew services start colima (first start takes a few minutes, then re-run). Logs: $(brew --prefix)/var/log/colima.log"
else
  ok "docker daemon"
  if docker compose version >/dev/null 2>&1; then
    ok "docker compose"
  else
    bad "docker compose plugin not found" \
      "add to ~/.docker/config.json: \"cliPluginsExtraDirs\": [\"$(brew --prefix)/lib/docker/cli-plugins\"]"
  fi
fi

port="${FLOCI_PORT:-4566}"
if /usr/sbin/lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1 \
  && [ -z "$(docker compose -f "$(dirname "$0")/docker-compose.yml" ps -q floci 2>/dev/null)" ]; then
  bad "port $port is used by something else (another floci?)" \
    "stop it, or pick another port: export FLOCI_PORT=4599"
else
  ok "port $port"
fi

expected="http://localhost:$port"
if [ "$AWS_ENDPOINT_URL" = "$expected" ]; then
  ok "AWS_ENDPOINT_URL=$expected"
else
  bad "AWS_ENDPOINT_URL is '${AWS_ENDPOINT_URL:-unset}', expected $expected (else commands hit real AWS)" \
    "source env-config.sh (from the repo root, in every new terminal)"
fi

[ "$fail" = 0 ] && echo "All good." || { echo "Fix the FAIL items above, then re-run ./check.sh"; exit 1; }
