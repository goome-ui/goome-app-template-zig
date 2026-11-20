#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

source_repo=goome-ui/zig-goome

latest=$(gh api "repos/$source_repo/releases/latest" -q .tag_name)
latest=${latest#v}
current=$(sed -n 's#.*zig-goome/archive/refs/tags/v\([0-9.]*\)\.tar\.gz.*#\1#p' build.zig.zon | head -n1)
echo "latest $latest, pinned $current"

if ! [[ $latest =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || [ -z "$current" ]; then
  echo "cannot read a clean version, nothing to do"
  exit 0
fi
highest=$(printf '%s\n%s\n' "$latest" "$current" | sort -V | tail -n1)
if [ "$latest" = "$current" ] || [ "$highest" != "$latest" ]; then
  echo "up to date"
  exit 0
fi

pin_version() {
  zig fetch --save=goome "https://github.com/$source_repo/archive/refs/tags/v$latest.tar.gz"
}

smoke_test() {
  export GOOME_BACKEND=test
  zig fmt --check build.zig build.zig.zon src
  zig build
  rm -rf shots
  mkdir shots
  out=$(GOOME_TEST_SHOTS=shots GOOME_TEST_SCRIPT="screen 1280x720 1; 3 click 60,28; end 6" ./zig-out/bin/my-goome-app)
  echo "$out"
  ls shots | grep -q ppm
  rm -rf shots
}

pin_version
git diff --stat

if [ -z "${GOOME_NOSMOKE:-}" ]; then
  smoke_test
fi

if [ -n "${GOOME_DRY:-}" ]; then
  echo "dry run, not committing"
  exit 0
fi

git config user.name "$(git log -1 --format=%an)"
git config user.email "$(git log -1 --format=%ae)"

git add build.zig.zon
git commit -q -m "Bump goome to $latest"
git push -q origin HEAD:dev

git checkout -q -B main origin/main
pin_version
if git diff --quiet; then
  echo "main already pinned to $latest"
  exit 0
fi
git add build.zig.zon
git commit -q -m "Update to goome $latest"
git push -q origin main
