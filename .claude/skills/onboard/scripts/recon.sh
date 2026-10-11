#!/usr/bin/env bash
# プロジェクトの下調べ用に、事実だけを集めて表示する (読み取り専用)
#
# 使い方: bash recon.sh [ディレクトリ]   (省略時はカレント)
# 出力  : セクション見出し付きのプレーンテキスト。各セクションは行数を絞ってある。
#
# 安全性:
#   - ファイルを書き換えない。ネットワークに接続しない。リポジトリ内のスクリプトを実行しない。
#   - .env や秘密鍵などは「存在する」ことだけを名前で報告し、中身は読まない。

set -uo pipefail

TARGET="${1:-.}"
if [[ ! -d "$TARGET" ]]; then
  echo "error: ディレクトリが存在しません: $TARGET" >&2
  exit 1
fi
cd "$TARGET" || exit 1

# 直近何コミットを「よく変更されるファイル」の集計対象にするか。
# 短すぎると偶然に左右され、長すぎると過去の構成を拾うため、数か月分に当たる 300 とした。
HOTSPOT_COMMITS=300

# 一覧系の出力の上限 (プロンプトを埋めないため)
LIST_LIMIT=40

IS_GIT=0
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  IS_GIT=1
  cd "$(git rev-parse --show-toplevel)" || exit 1
fi

section() { printf '\n== %s ==\n' "$1"; }

# 追跡ファイル一覧 (git なら .gitignore を尊重。そうでなければ主要な生成物ディレクトリを除外)
list_files() {
  if [[ "$IS_GIT" -eq 1 ]]; then
    git ls-files
  else
    find . -type f \
      -not -path '*/.git/*' -not -path '*/node_modules/*' -not -path '*/.venv/*' \
      -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/target/*' \
      -not -path '*/__pycache__/*' | sed 's#^\./##'
  fi
}

section "Repo"
echo "path: $PWD"
if [[ "$IS_GIT" -eq 1 ]]; then
  echo "branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  echo "head: $(git rev-parse --short HEAD 2>/dev/null) ($(git log -1 --format=%cd --date=short 2>/dev/null))"
  echo "commits: $(git rev-list --count HEAD 2>/dev/null)"
  echo "first commit: $(git log --reverse --format=%cd --date=short 2>/dev/null | head -1)"
  echo "contributors: $(git shortlog -sn HEAD 2>/dev/null | wc -l | tr -d ' ')"
  echo "uncommitted changes: $(git status --porcelain 2>/dev/null | wc -l | tr -d ' ') file(s)"
  echo "remote: $(git remote 2>/dev/null | head -3 | tr '\n' ' ')"
else
  echo "(git リポジトリではありません)"
fi

if [[ "$IS_GIT" -eq 1 ]]; then
  section "Recent commits (15)"
  git log -15 --format='%h %ad %s' --date=short 2>/dev/null

  section "Hotspots (last $HOTSPOT_COMMITS commits, most changed files)"
  # 履歴上の上位から、現在も存在するファイルだけを 15 件まで表示する (削除・移動済みは除く)
  git log -n "$HOTSPOT_COMMITS" --name-only --pretty=format: 2>/dev/null |
    grep -v '^$' | sort | uniq -c | sort -rn | head -60 |
    while read -r count path; do
      [[ -e "$path" ]] && printf '%5s %s\n' "$count" "$path"
    done | head -15

  section "Top contributors"
  git shortlog -sn HEAD 2>/dev/null | head -5
fi

section "Languages (tracked files by extension)"
list_files | awk -F. 'NF>1 && $NF !~ /\// {print tolower($NF)}' | sort | uniq -c | sort -rn | head -10

section "Top-level layout (file count per directory)"
list_files | awk -F/ '{ if (NF>1) print $1"/"; else print "(root files)" }' | sort | uniq -c | sort -rn | head -25

section "Second-level layout (top 30 directories)"
list_files | awk -F/ 'NF>2 {print $1"/"$2"/"}' | sort | uniq -c | sort -rn | head -30

section "Docs and project instructions"
for f in README README.md README.rst README.ja.md CLAUDE.md AGENTS.md CONTRIBUTING.md ARCHITECTURE.md CHANGELOG.md SECURITY.md; do
  [[ -f "$f" ]] && echo "$f ($(wc -l <"$f" | tr -d ' ') lines)"
done
for d in docs doc documentation .claude; do
  [[ -d "$d" ]] && echo "$d/ ($(list_files | grep -c "^$d/") files)"
done

section "Manifests and build config"
list_files | awk -F/ 'NF<=4' | grep -E \
  '(^|/)(package\.json|pnpm-workspace\.yaml|tsconfig[^/]*\.json|pyproject\.toml|setup\.py|setup\.cfg|requirements[^/]*\.txt|Pipfile|go\.mod|Cargo\.toml|pom\.xml|build\.gradle(\.kts)?|settings\.gradle(\.kts)?|Gemfile|composer\.json|mix\.exs|Package\.swift|CMakeLists\.txt|Makefile|justfile|Taskfile\.ya?ml|Dockerfile[^/]*|docker-compose[^/]*\.ya?ml|compose\.ya?ml|\.tool-versions|\.nvmrc|\.python-version|flake\.nix|terraform\.tf|main\.tf)$' |
  head "-$LIST_LIMIT"

section "CI / automation"
list_files | grep -E '^(\.github/workflows/|\.gitlab-ci\.yml|\.circleci/|azure-pipelines|Jenkinsfile|\.buildkite/|cloudbuild)' | head -15

section "Lint / format config"
list_files | awk -F/ 'NF<=3' | grep -E \
  '(^|/)(\.editorconfig|\.prettierrc[^/]*|prettier\.config\.[^/]*|\.eslintrc[^/]*|eslint\.config\.[^/]*|biome\.jsonc?|ruff\.toml|\.flake8|\.pylintrc|mypy\.ini|\.rubocop\.yml|\.golangci\.ya?ml|rustfmt\.toml|stylua\.toml|\.pre-commit-config\.yaml)$' |
  head -15

section "Entry-point candidates"
list_files | awk -F/ 'NF<=4' | grep -E \
  '(^|/)(main|index|app|server|cli|manage|__main__|wsgi|asgi|handler|lambda_function)\.(py|js|jsx|ts|tsx|mjs|go|rs|rb|java|kt|swift|php|sh|lua)$' |
  head -15

section "Tests"
echo "test files: $(list_files | grep -Ec '(^|/)(tests?|__tests__|spec|e2e)/|[._-](test|spec)\.[a-z]+$')"
list_files | grep -E '(^|/)(tests?|__tests__|spec|e2e)/' | awk -F/ '{print $1"/"$2"/"}' | sort | uniq -c | sort -rn | head -8

section "Runnable commands (names only)"
if [[ -f package.json ]] && command -v jq >/dev/null 2>&1; then
  echo "package.json scripts:"
  jq -r '.scripts // {} | keys[]' package.json 2>/dev/null | head "-$LIST_LIMIT" | sed 's/^/  /'
fi
if [[ -f Makefile ]]; then
  echo "Makefile targets:"
  grep -E '^[a-zA-Z0-9_-][a-zA-Z0-9_.-]*:' Makefile | cut -d: -f1 | sort -u | head "-$LIST_LIMIT" | sed 's/^/  /'
fi
if [[ -f justfile ]]; then
  echo "justfile recipes:"
  grep -E '^[a-zA-Z0-9_-]+( .*)?:' justfile | cut -d: -f1 | cut -d' ' -f1 | sort -u | head "-$LIST_LIMIT" | sed 's/^/  /'
fi

section "Sensitive files present (names only, contents NOT read)"
find . -maxdepth 4 \( -path ./.git -o -path ./node_modules -o -path ./.venv \) -prune -o -type f \
  \( -name '.env' -o -name '.env.*' -o -name '*.pem' -o -name '*.p12' -o -name '*.pfx' -o -name 'id_rsa*' \
  -o -name 'id_ed25519*' -o -name 'credentials*' -o -name '*.tfstate' -o -name '.netrc' \) \
  -print 2>/dev/null | sed 's#^\./##' | head -20
echo "(.env.example / *.sample / *.template は設定項目の把握に使ってよいが、実値入りのファイルは読まないこと)"
