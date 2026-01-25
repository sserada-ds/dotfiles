# Modern CLI Tools Guide

モダンなCLIツールの使い方ガイド

## Level 1: 必須ツール

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

## Level 2: 開発サポート

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

## Tips

### パイプライン例

```bash
# APIからデータ取得 → jqで加工 → ファイル保存
http GET https://api.github.com/users/octocat | jq '.name' > name.txt

# 複数コマンドのベンチマーク結果をJSON保存
hyperfine --export-json bench.json 'cmd1' 'cmd2'
cat bench.json | jq '.results[] | {command: .command, mean: .mean}'

# Git差分をファイルに保存（色付き）
git diff --color=always | cat > diff.txt
```

### エイリアス活用

```bash
# すでに設定済み
get url    # http GET url
post url data    # http POST url data
bench cmd1 cmd2  # hyperfine cmd1 cmd2
lg             # lazygit
```

### 組み合わせワークフロー

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
