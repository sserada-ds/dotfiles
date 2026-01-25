# Development Tools

開発ワークフローを効率化するツール

---

## JSON処理

### jq

JSON処理の強力なツール。

**基本:**

```bash
# JSON整形
echo '{"name":"test","value":123}' | jq .

# フィールド抽出
cat data.json | jq '.users[].name'

# 条件フィルタ
cat data.json | jq '.users[] | select(.age > 20)'

# 複数フィールド
cat data.json | jq '.users[] | {name: .name, email: .email}'
```

**実用例:**

```bash
# package.jsonから依存関係を取得
jq '.dependencies' package.json

# AWS CLI出力を加工
aws ec2 describe-instances | jq '.Reservations[].Instances[] | {id: .InstanceId, type: .InstanceType}'

# JSON to CSV
cat users.json | jq -r '.users[] | [.name, .email] | @csv'
```

### jless

JSONをインタラクティブに探索。

**使い方:**

```bash
# ファイルから
jless data.json

# パイプから
curl https://api.github.com/users/octocat | jless
```

**キーバインド:**

| キー | 動作 |
|------|------|
| `j` / `k` | 上下移動 |
| `h` / `l` | 折りたたみ/展開 |
| `/` | 検索 |
| `.` | パスをコピー |
| `y` | 値をコピー |
| `q` | 終了 |

---

## HTTP/API

### httpie

人間向けHTTP client。

**基本:**

```bash
# GET（エイリアス使用）
get https://api.github.com/users/octocat

# POST
post https://api.example.com/users name=john email=john@example.com

# PUT
put https://api.example.com/users/1 name=jane

# DELETE
delete https://api.example.com/users/1
```

**認証:**

```bash
# Basic認証
http -a username:password GET https://api.example.com/

# Bearer token
http -A bearer -a YOUR_TOKEN GET https://api.example.com/me

# カスタムヘッダー
http GET https://api.example.com/ Authorization:"Bearer YOUR_TOKEN"
```

**高度な使い方:**

```bash
# ファイルアップロード
http -f POST https://api.example.com/upload file@/path/to/file.txt

# JSONファイルから送信
http POST https://api.example.com/users < user.json

# レスポンスを保存
http GET https://api.example.com/data > response.json

# デバッグ
http --verbose GET https://api.example.com/
```

---

## ベンチマーク & 監視

### hyperfine

コマンドのベンチマーク。

**基本:**

```bash
# 単一コマンド
hyperfine 'command'

# 複数コマンド比較
bench 'grep pattern file' 'rg pattern file'

# ウォームアップ
hyperfine --warmup 3 'command'

# 実行回数指定
hyperfine --runs 10 'command'
```

**実用例:**

```bash
# ビルド時間比較
hyperfine 'npm run build' 'vite build'

# テスト実行時間
hyperfine --warmup 1 'npm test' 'jest'

# JSON出力
hyperfine --export-json results.json 'cmd1' 'cmd2'
```

### watchexec

ファイル変更時に自動的にコマンドを実行。

**使い方:**

```bash
# ファイル変更時にコマンド実行
watchexec echo "Changed!"

# 特定の拡張子のみ監視
watchexec --exts js,ts npm test

# 特定のファイルを監視
watchexec --watch src npm run build
```

**実用例:**

```bash
# テストの自動実行
watchexec --clear --exts rs cargo test

# ビルドの自動実行
watchexec --exts js,jsx,ts,tsx npm run build

# サーバーの自動再起動
watchexec --restart --exts py python server.py

# Markdownプレビュー
watchexec --exts md glow README.md
```

---

## タスク管理

### just

makeの現代的な代替品。

**セットアップ:**

プロジェクトルートに`justfile`を作成：

```just
# デフォルトレシピ
default:
  @just --list

# テスト実行
test:
  npm test

# ビルド
build:
  npm run build

# 開発サーバー起動
dev:
  npm run dev
```

**使い方:**

```bash
# レシピ一覧
just --list

# レシピ実行
just test
just build

# 引数付き
just greet World
```

---

## 環境変数

### direnv

ディレクトリ別環境変数管理。

**セットアップ:**

プロジェクトディレクトリで：

```bash
# .envrcファイルを作成
echo 'export DATABASE_URL=postgres://localhost/mydb' > .envrc
echo 'export API_KEY=your-key-here' >> .envrc

# 許可する
direnv allow
```

**.envrcの例:**

```bash
# PATHに追加
PATH_add node_modules/.bin

# pyenvのバージョン指定
use python 3.11

# 他の.envrcを読み込み
source_up

# 条件分岐
if [ -f .env ]; then
  dotenv
fi
```

---

## ドキュメント & テキスト

### tldr

簡潔なマニュアルページ。

**使い方:**

```bash
# コマンドの使い方
tldr tar
tldr git-rebase
tldr docker

# 更新
tldr --update
```

### glow

Markdownビューア。

**使い方:**

```bash
# ファイルを表示
glow README.md
md README.md  # エイリアス

# カレントディレクトリのMarkdownを検索
glow -p .

# スタイル変更
glow -s dark README.md
glow -s light README.md
```

### sd

直感的な置換ツール（sedの代替）。

**使い方:**

```bash
# 文字列置換
echo "hello world" | sd "world" "universe"

# ファイル内置換
sd "old" "new" file.txt

# 複数ファイル
sd "old" "new" *.txt

# 正規表現
echo "test123" | sd '\d+' ''

# グループ参照
echo "2024-01-26" | sd '(\d{4})-(\d{2})-(\d{2})' '$3/$2/$1'
```

---

## コード統計

### tokei

プロジェクトのコード行数を言語別に集計。

**使い方:**

```bash
# カレントディレクトリの統計
tokei

# 特定のディレクトリ
tokei ~/projects/myapp

# 特定の言語のみ
tokei --type rust
tokei -t python

# ソート
tokei --sort lines

# JSON形式
tokei --output json

# ファイル名を含めて詳細表示
tokei --files
```

**実用例:**

```bash
# プロジェクト規模を把握
cd ~/projects/myapp
tokei

# 複数プロジェクトを比較
tokei ~/projects/app1 ~/projects/app2

# CI/CDで使用
tokei --output json | jq '.Total.code'
```

---

## 実用的なワークフロー

### API開発ワークフロー

```bash
# 1. APIテスト
get https://api.example.com/users

# 2. JSON結果確認
get https://api.example.com/users | jless

# 3. データ加工
get https://api.example.com/users | jq '.users[] | .name'

# 4. 性能測定
bench 'curl https://api.example.com/users'
```

### 開発ワークフロー自動化

```bash
# 1. justfileでタスク定義
cat > justfile <<'EOF'
dev:
  watchexec --exts js,jsx npm run dev

test-watch:
  watchexec --clear --exts js,jsx npm test
EOF

# 2. 開発サーバーを自動再起動
just dev

# 3. テストを自動実行
just test-watch
```

### プロジェクト分析

```bash
# 1. READMEを確認
md README.md

# 2. コード規模を把握
tokei

# 3. 特定のパターンを検索
rg "TODO|FIXME"

# 4. ベンチマーク
bench 'npm run build'
```
