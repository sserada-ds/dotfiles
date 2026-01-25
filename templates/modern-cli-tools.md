# Modern CLI Tools Guide

Rust製を中心としたモダンなCLIツールの総合ガイド

---

## Git & GitHub

### git-delta

Git差分を美しく表示します。

**特徴:**

- 構文ハイライト
- 行番号表示
- side-by-side表示（オプション）
- Gruvboxテーマ対応

**使い方:**

```bash
# 自動的に使用される（設定済み）
git diff
git diff --staged
git log -p
git show HEAD

# side-by-side表示
git -c delta.side-by-side=true diff

# 特定のファイルのみ
git diff path/to/file.js
```

**設定:**

`.gitconfig`に自動設定されます。カスタマイズは`git config`で：

```bash
git config --global delta.side-by-side true
git config --global delta.line-numbers false
```

---

### lazygit

Git操作のターミナルUI。

**起動:**

```bash
lazygit
lg  # エイリアス
```

**主要キーバインド:**
| キー | 動作 |
|------|------|
| `1-5` | パネル切り替え（Status, Files, Branches, Commits, Stash） |
| `space` | ステージング/アンステージング |
| `c` | コミット |
| `p` | プッシュ/プル |
| `P` | プッシュ（force） |
| `n` | 新規ブランチ作成 |
| `m` | マージ |
| `r` | リベース |
| `u` | アンドゥ（元に戻す） |
| `?` | ヘルプ |
| `q` | 終了 |

**便利な機能:**

- **ビジュアルdiff**: ファイルを選択してenterで詳細表示
- **インタラクティブrebase**: コミット選択して`e`
- **チェリーピック**: コミット選択して`c`
- **ステージング一部選択**: ファイル選択して`space`で行単位選択

---

### gh

GitHub公式CLI。

**認証:**

```bash
gh auth login
```

**PR操作:**

```bash
# PR作成
gh pr create

# PR一覧
gh pr list

# PRレビュー
gh pr view 123
gh pr review 123

# PRチェックアウト
gh pr checkout 123

# PRマージ
gh pr merge 123
```

**Issue操作:**

```bash
# Issue作成
gh issue create

# Issue一覧
gh issue list

# Issue詳細
gh issue view 123

# Issueクローズ
gh issue close 123
```

**リポジトリ操作:**

```bash
# リポジトリ情報
gh repo view

# リポジトリクローン
gh repo clone owner/repo

# リポジトリ作成
gh repo create my-new-repo

# Forkする
gh repo fork
```

**その他:**

```bash
# GitHub Actions実行状況
gh run list
gh run view 123

# Gistを作成
gh gist create file.txt

# リリース作成
gh release create v1.0.0
```

---

## データ処理

### jq

JSON処理の強力なツール。

**基本:**

```bash
# JSON整形
echo '{"name":"test","value":123}' | jq .

# ファイルから読み込み
cat data.json | jq .

# APIレスポンスを整形
curl https://api.github.com/users/octocat | jq .
```

**フィルタリング:**

```bash
# 特定フィールドを抽出
cat users.json | jq '.users[].name'

# 条件フィルタ
cat users.json | jq '.users[] | select(.age > 20)'

# 複数フィールド
cat users.json | jq '.users[] | {name: .name, email: .email}'
```

**変換:**

```bash
# 配列の要素数
cat data.json | jq '.items | length'

# キーの一覧
cat data.json | jq 'keys'

# JSON to CSV
cat users.json | jq -r '.users[] | [.name, .email] | @csv'
```

**実用例:**

```bash
# package.jsonから依存関係を取得
jq '.dependencies' package.json

# AWS CLIの出力を加工
aws ec2 describe-instances | jq '.Reservations[].Instances[] | {id: .InstanceId, type: .InstanceType, state: .State.Name}'

# 複数JSONファイルをマージ
jq -s '.[0] * .[1]' file1.json file2.json
```

---

## システム情報

### bottom

topやhtopの現代的な代替品。CPU、メモリ、ネットワークを視覚的に表示します。

**基本的な使い方:**

```bash
# 起動（終了はq）
btm
bottom

# topの代わり
top  # エイリアス設定済み
htop # エイリアス設定済み
```

**表示モード:**

```bash
# デフォルトモード（全情報）
btm

# CPUのみ
btm --basic

# 特定のプロセスのみ
btm --regex "chrome"

# ツリー表示
btm --tree
```

**インタラクティブ操作:**

起動後のキーバインド：
| キー | 動作 |
|------|------|
| `Tab` / `Shift+Tab` | ウィジェット切り替え |
| `↑` `↓` | 項目選択 |
| `Enter` | プロセス詳細 |
| `dd` | プロセス終了（kill） |
| `c` | CPU使用率でソート |
| `m` | メモリ使用率でソート |
| `p` | PIDでソート |
| `n` | 名前でソート |
| `/` | 検索 |
| `?` | ヘルプ |
| `q` | 終了 |

**実用例:**

```bash
# CPUを多く使うプロセスを確認
btm

# メモリリークを調査
btm --mem_utilization

# ネットワーク使用量を監視
btm --network_use_binary_prefix

# 特定のアプリのみ表示
btm --regex "node|python"
```

---

### procs

psの改良版。カラフルで読みやすい出力。

**基本的な使い方:**

```bash
# 全プロセス表示
procs
pps  # エイリアス

# 特定のプロセスを検索
procs chrome
procs python

# ツリー表示
procs --tree
```

**ソートとフィルタ:**

```bash
# CPU使用率でソート
procs --sortd cpu

# メモリ使用率でソート
procs --sortd mem

# 特定ユーザーのプロセス
procs --user $(whoami)

# 実行時間でソート
procs --sortd time
```

**表示カスタマイズ:**

```bash
# 特定カラムのみ表示
procs --only pid,user,cpu,mem,name

# 詳細表示
procs --watch

# JSON形式
procs --json
```

**実用例:**

```bash
# メモリを多く使うプロセスTop 10
procs --sortd mem | head -11

# 特定のポートを使っているプロセス
lsof -i :3000

# 長時間実行中のプロセス
procs --sortd time

# 自分のプロセスのみ
procs --user $(whoami)
```

---

### dust

ディスク使用量を視覚的なツリーで表示します。

**基本的な使い方:**

```bash
# カレントディレクトリ
dust

# 特定のディレクトリ
dust ~/projects

# ホームディレクトリ全体
dust ~
```

**表示深度:**

```bash
# 深度1（直下のみ）
dust -d 1

# 深度2
dust -d 2

# 深度3（デフォルト）
dust -d 3

# すべて表示
dust -d 0
```

**ソートとフィルタ:**

```bash
# サイズでソート（デフォルト）
dust

# 名前でソート
dust -n

# 逆順
dust -r

# 件数制限
dust -n 10  # 上位10件のみ
```

**その他のオプション:**

```bash
# 隠しファイルも表示
dust -a

# 数値を人間が読みやすい形式で
dust -b  # バイト単位
dust -k  # KB単位
dust -m  # MB単位
dust -g  # GB単位

# パーセンテージ非表示
dust -p
```

**実用例:**

```bash
# 大きなディレクトリを見つける
dust -d 1 ~/projects

# node_modulesを探す
dust | grep node_modules

# 特定のディレクトリのサイズ比較
dust -d 1 ~/projects/app1 ~/projects/app2

# ディスク容量圧迫の調査
dust -d 2 ~

# 最も大きいファイル/ディレクトリを特定
dust -d 1 / | head -20
```

**duとの比較:**

```bash
# 従来のdu
du -h -d 1 ~/projects | sort -hr

# dust（より見やすい）
dust -d 1 ~/projects
```

---

### duf

dfの改良版。視覚的で読みやすいディスク使用量表示。

**基本的な使い方:**

```bash
# 全ドライブ表示
duf
df  # エイリアス

# 特定のマウントポイント
duf /home

# JSON形式
duf --json
```

**表示オプション:**

```bash
# ソート
duf --sort size

# 特定のファイルシステムタイプのみ
duf --only local

# ネットワークドライブを除外
duf --hide-fs nfs,cifs

# 詳細表示
duf --all
```

**実用例:**

```bash
# システム全体の容量確認
duf

# 特定ディレクトリのサイズ
du -sh /path/to/dir  # 従来の方法
dust /path/to/dir    # より詳細

# ディスク使用率アラート
if duf --json | jq '.[0].usage.percent' | awk '$1 > 90'; then
  echo "Disk usage critical!"
fi
```

---

### tokei

プロジェクトのコード行数を言語別に集計します。

**基本的な使い方:**

```bash
# カレントディレクトリの統計
tokei

# 特定のディレクトリ
tokei ~/projects/myapp

# 特定の言語のみ
tokei --type rust
tokei -t python
```

**ソート:**

```bash
# 行数でソート
tokei --sort lines

# ファイル数でソート
tokei --sort files

# コード行数でソート
tokei --sort code

# 降順
tokei --sort lines --reverse
```

**出力形式:**

```bash
# JSON形式
tokei --output json

# YAML形式
tokei --output yaml

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

# 特定の拡張子を除外
tokei --exclude "*.test.js" --exclude "*.spec.ts"

# Gitignoreされたファイルも含める
tokei --hidden

# コンパクト表示
tokei --compact
```

**CI/CDでの活用:**

```bash
# JSONで出力してjqで加工
tokei --output json | jq '.Total.code'

# ベースラインとの比較
tokei --output json > current.json
# (変更後)
tokei --output json > after.json
diff <(jq .Total.code current.json) <(jq .Total.code after.json)
```

---

## 開発ワークフロー

### hyperfine

コマンドのベンチマーク。

**基本:**

```bash
# 単一コマンド
hyperfine 'sleep 1'

# 複数コマンド比較
hyperfine 'grep pattern file' 'rg pattern file'
bench 'grep pattern file' 'rg pattern file'  # エイリアス
```

**オプション:**

```bash
# ウォームアップ（キャッシュ効果を減らす）
hyperfine --warmup 3 'command'

# 実行回数指定
hyperfine --runs 10 'command'

# パラメータ変更
hyperfine --parameter-scan num 1 10 'command --size {num}'

# 結果をJSONで出力
hyperfine --export-json results.json 'command1' 'command2'

# 事前準備コマンド実行
hyperfine --prepare 'sync; echo 3 > /proc/sys/vm/drop_caches' 'command'
```

**実用例:**

```bash
# ビルド時間比較
hyperfine 'make build' 'cargo build --release'

# テスト実行時間
hyperfine --warmup 1 'npm test' 'jest'

# スクリプト最適化前後
hyperfine 'python old_script.py' 'python new_script.py'
```

---

### watchexec

ファイル変更時に自動的にコマンドを実行します。

**基本的な使い方:**

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

# 複数コマンド実行
watchexec --exts js "npm run lint && npm test"
```

**オプション:**

```bash
# 変更時に画面クリア
watchexec --clear command

# デバウンス（連続変更を防ぐ）
watchexec --debounce 2000 command  # 2秒待つ

# 無視パターン
watchexec --ignore "*.log" --ignore "node_modules" command

# 初回実行しない
watchexec --postpone command

# プロセス再起動
watchexec --restart command
```

---

### just

makeの現代的な代替品。プロジェクトのタスクを管理します。

**セットアップ:**

プロジェクトルートに`justfile`を作成：

```just
# デフォルトレシピ（just実行時）
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

# 依存関係インストール
install:
  npm install

# クリーンアップ
clean:
  rm -rf dist node_modules
```

**基本的な使い方:**

```bash
# レシピ一覧表示
just --list
just -l

# レシピ実行
just test
just build

# 引数付きレシピ
# justfile: greet name:
#   @echo "Hello, {{name}}!"
just greet World
```

**高度な機能:**

```bash
# 変数使用
# justfile:
# version := "1.0.0"
# release:
#   echo "Releasing {{version}}"

# 条件分岐
# justfile:
# test os:
#   @if [ "{{os}}" = "macos" ]; then echo "Mac"; fi

# 依存関係
# justfile:
# build: install
#   npm run build
```

**実用例:**

```bash
# プロジェクト全体の操作を一元管理
just setup     # 初期セットアップ
just test      # テスト
just deploy    # デプロイ

# Makefileより直感的
just format    # コードフォーマット
just lint      # リンター実行
just docker-up # Docker起動
```

---

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

**使い方:**

```bash
# cdするだけで自動的に環境変数が設定される
cd ~/projects/myapp
echo $DATABASE_URL  # postgres://localhost/mydb

# ディレクトリを出ると自動的にアンロード
cd ..
echo $DATABASE_URL  # (空)
```

**.envrcの便利な使い方:**

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

## テキスト処理

### sd

sedの代替品。より直感的な構文。

**基本的な使い方:**

```bash
# 文字列置換
echo "hello world" | sd "world" "universe"

# ファイル内置換（直接書き換え）
sd "old" "new" file.txt

# 複数ファイル
sd "old" "new" *.txt
```

**正規表現:**

```bash
# 数字を削除
echo "test123" | sd '\d+' ''

# グループ参照
echo "2024-01-26" | sd '(\d{4})-(\d{2})-(\d{2})' '$3/$2/$1'

# 大文字小文字を無視
sd -i "error" "ERROR" log.txt
```

**実用例:**

```bash
# import文の一括変更
sd 'import \* from' 'import' **/*.js

# URLの一括変更
sd 'http://' 'https://' *.html

# 改行コード変更
sd '\r\n' '\n' file.txt

# 先頭の空白を削除
sd '^\s+' '' file.txt

# ファイル名の一括変更（renameと組み合わせ）
for f in *.txt; do
  mv "$f" "$(echo $f | sd 'old' 'new')"
done
```

**sedとの比較:**

```bash
# sed（複雑）
sed -i '' 's/old/new/g' file.txt

# sd（シンプル）
sd 'old' 'new' file.txt
```

---

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

**man vs tldr:**

```bash
# 従来（長い）
man tar  # 数百行のマニュアル

# tldr（簡潔）
tldr tar  # 実用的な例のみ
```

---

### glow

READMEやドキュメントをターミナルで美しく表示します。

**基本的な使い方:**

```bash
# ファイルを表示
glow README.md
md README.md  # エイリアス

# カレントディレクトリのMarkdownを検索
glow -p .

# 特定のディレクトリを検索
glow -p ~/projects
```

**ページャーモード:**

```bash
# ページャーとして使用（長いファイル）
glow -p README.md

# スタイル変更
glow -s dark README.md
glow -s light README.md
```

**実用例:**

```bash
# プロジェクトのREADMEをすぐ確認
cd ~/projects/myapp
glow README.md

# GitHub風スタイルで表示
glow -s auto CONTRIBUTING.md

# すべてのMarkdownを検索
glow -p ~/Documents

# 標準入力から読み込み
echo "# Hello\nThis is **bold**" | glow -
```

**便利なエイリアス:**

```bash
# すでに設定済み
md README.md  # glow README.md

# 追加で設定したい場合
alias docs='glow -p .'
alias readme='glow README.md'
```

---

## HTTP/API

### httpie

人間向けHTTP client。

**基本:**

```bash
# GET
http GET https://api.github.com/users/octocat
get https://api.github.com/users/octocat  # エイリアス

# POST (JSONを自動生成)
http POST https://api.example.com/users name=john email=john@example.com
post https://api.example.com/users name=john email=john@example.com

# PUT
http PUT https://api.example.com/users/1 name=jane

# DELETE
http DELETE https://api.example.com/users/1
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

# セッション保存（Cookie等）
http --session=mysession GET https://api.example.com/login username=user password=pass
http --session=mysession GET https://api.example.com/profile

# デバッグ（リクエスト全体を表示）
http --verbose GET https://api.example.com/
```

---

## 実用的なワークフロー

### プロジェクト分析

```bash
# 1. READMEを確認
cd ~/projects/myapp
glow README.md

# 2. コード規模を把握
tokei

# 3. ディスク使用量を確認
dust -d 2

# 4. 大きなディレクトリを特定
dust -d 1 | head -10
```

### システム監視

```bash
# 1. システムリソースを確認
btm  # CPUとメモリを視覚的に確認

# 2. 重いプロセスを特定
procs --sortd mem | head -20

# 3. ディスク容量を確認
duf

# 4. 特定ディレクトリのサイズを詳細表示
dust -d 2 ~/projects
```

### 開発ワークフロー自動化

```bash
# 1. justfileでタスク定義
cat > justfile <<'EOF'
dev:
  watchexec --exts js,jsx npm run dev

test-watch:
  watchexec --clear --exts js,jsx npm test

format:
  prettier --write .
EOF

# 2. 開発サーバーを自動再起動
just dev

# 3. テストを自動実行
just test-watch
```

### 一括ファイル編集

```bash
# 1. 現状確認
tokei src/

# 2. import文を一括変更
sd 'import React from "react"' 'import { React } from "react"' src/**/*.jsx

# 3. 変更結果を確認
git diff

# 4. プロジェクト統計を再確認
tokei src/
```

### Git & GitHub ワークフロー

```bash
# 1. direnvでプロジェクト環境設定
cd myproject  # DATABASE_URL自動設定

# 2. lazygitでコミット
lg

# 3. ghでPR作成
gh pr create

# 4. APIテスト
get $API_URL/health

# 5. JSON結果確認
get $API_URL/users | jq '.users[] | .name'
```

### リポジトリクリーンアップ

```bash
# 1. 現状確認
dust -d 1

# 2. 不要なファイルを特定
dust -d 2 | grep -E "node_modules|dist|build|.cache"

# 3. 削除前のサイズ記録
dust -d 0 > before.txt

# 4. クリーンアップ
rm -rf node_modules dist build .cache

# 5. 削減量確認
dust -d 0 > after.txt
```

### ドキュメント管理

```bash
# すべてのREADMEを一覧
find . -name "README.md" -exec echo {} \; -exec glow {} \;

# プロジェクトのドキュメント検索
glow -p ~/projects

# ドキュメント化されていないプロジェクトを見つける
for dir in ~/projects/*/; do
  if [ ! -f "$dir/README.md" ]; then
    echo "No README: $dir"
  fi
done
```

### パイプライン活用

```bash
# APIからデータ取得 → jqで加工 → ファイル保存
http GET https://api.github.com/users/octocat | jq '.name' > name.txt

# 複数コマンドのベンチマーク結果をJSON保存
hyperfine --export-json bench.json 'cmd1' 'cmd2'
cat bench.json | jq '.results[] | {command: .command, mean: .mean}'

# Git差分をファイルに保存（色付き）
git diff --color=always | cat > diff.txt
```

---

## エイリアス一覧

すでに設定済みのエイリアス：

```bash
# Git
lg              # lazygit

# HTTP
get url         # http GET url
post url data   # http POST url data
put url data    # http PUT url data
delete url      # http DELETE url

# ベンチマーク
bench cmd1 cmd2 # hyperfine cmd1 cmd2

# Markdown
md file.md      # glow file.md

# システムモニター
top             # btm
htop            # btm

# プロセス一覧
pps             # procs

# ディスク容量
df              # duf
```

追加で設定したい便利なエイリアス：

```bash
# ~/.zshrcまたは~/.zsh/alias.zshに追加
alias stats='tokei && dust -d 1'
alias readme='glow README.md'
alias docs='glow -p .'
alias big='dust -d 1 | head -20'
alias monitor='btm'
alias processes='procs --sortd mem'
```

---

## Tips

### パフォーマンス

- **tokei**: 大規模プロジェクトでも数秒
- **dust**: 数百GBでも高速
- **glow**: 即座にレンダリング
- **procs**: psより高速で読みやすい

### 除外パターン

```bash
# tokei: .gitignoreを尊重
tokei  # 自動的にnode_modules等を除外

# dust: 隠しファイルを含める
dust -a

# glow: 特定のファイルのみ
glow README.md CONTRIBUTING.md
```

### カラースキーム

```bash
# glowのテーマ変更
glow -s dark README.md
glow -s light README.md
glow -s auto README.md  # 自動判定
```
