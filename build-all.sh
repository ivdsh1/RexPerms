#!/usr/bin/env sh
set -eu
cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
if [ ! -f ../RexPermsGuard/pom.xml ]; then
  echo 'Clone ivdsh1/RexPermsGuard beside RexPerms first.' >&2
  exit 1
fi
exec mvn -B -f bundle/pom.xml clean verify "$@"
