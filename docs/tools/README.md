# CLI Tools Guide

Rust製を中心とした高速で便利なCLIツール集

---

## ツール一覧

### [Git & GitHub](./git.md)

Git操作とGitHub連携を強化するツール

- **git-delta** - Git差分の美しい表示
- **lazygit** - Git TUI（ターミナルUI）
- **gh** - GitHub公式CLI

### [Shell Tools](./shell.md)

シェル体験を向上させるコア置き換えツール

- **bat** - `cat`の代替（シンタックスハイライト）
- **eza** - `ls`の代替（アイコン、カラー）
- **fd** - `find`の代替（高速検索）
- **ripgrep (rg)** - `grep`の代替（超高速）
- **zoxide** - `cd`の代替（スマートジャンプ）
- **atuin** - シェル履歴強化（Ctrl+R）
- **navi** - インタラクティブなチートシート

### [Development Tools](./dev.md)

開発ワークフローを効率化するツール

- **jq** - JSON処理
- **jless** - JSONビューア
- **httpie** - HTTP client
- **hyperfine** - ベンチマーク
- **watchexec** - ファイル監視
- **just** - タスクランナー
- **direnv** - 環境変数管理
- **tldr** - 簡易マニュアル
- **glow** - Markdownビューア
- **sd** - 直感的な置換
- **tokei** - コード統計

### [System Tools](./system.md)

システム監視・管理ツール

- **bottom** - システムモニター
- **procs** - プロセス一覧
- **dust** - ディスク使用量
- **duf** - ディスク容量
- **bandwhich** - ネットワーク帯域幅
- **doggo** - DNS lookup
- **pv** - パイプ進捗
- **mkcert** - ローカルSSL証明書
- **zellij** - ターミナルマルチプレクサ
- **silicon** - コードスクリーンショット

---

## クイックスタート

### インストール

```bash
# 全てのツールをインストール
make install-deps

# または個別に
brew install bat eza fd ripgrep zoxide
```

### よく使うコマンド

```bash
# ファイル表示（シンタックスハイライト）
cat file.txt

# ファイル一覧（アイコン付き）
ls

# ファイル検索
find pattern

# テキスト検索
grep pattern

# ディレクトリジャンプ
cd project  # または z project

# Git TUI
lg

# JSON処理
curl api.example.com | jq .

# システムモニター
top

# プロセス一覧
pps
```

---

## エイリアス一覧

コア置き換えツールは自動的にエイリアスが設定されています：

| 元のコマンド | 新しいツール | エイリアス |
| ------------ | ------------ | ---------- |
| `cat`        | bat          | `cat`      |
| `ls`         | eza          | `ls`       |
| `find`       | fd           | `find`     |
| `grep`       | ripgrep      | `grep`     |
| `cd`         | zoxide       | `z`, `cd`  |
| `top`        | bottom       | `top`      |
| `htop`       | bottom       | `htop`     |
| `ps`         | procs        | `pps`      |
| `df`         | duf          | `df`       |

その他のエイリアス：

- `lg` - lazygit
- `get` / `post` / `put` / `delete` - httpie
- `bench` - hyperfine
- `md` - glow

詳細は [../.zsh/README.md](../../.zsh/README.md) を参照

---

## 参考リンク

- [Zsh設定](../../.zsh/README.md) - エイリアス、設定の詳細
- [Makefile](../../Makefile) - インストールコマンド
- [README](../../README.md) - dotfiles全体の説明
