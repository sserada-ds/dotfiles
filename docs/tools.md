# CLI ツール

この dotfiles で導入するモダンな CLI ツールの一覧と、有効になるエイリアスです。**各ツールの使い方は、`tldr <ツール名>` か `<ツール名> --help` を参照してください。**

エイリアスの正本は [.zsh/alias.zsh](../.zsh/alias.zsh)、初期化は [.zsh/tools.zsh](../.zsh/tools.zsh) です。ツールが未導入のときは、対応するエイリアスは設定されません。

## 導入

```bash
make install ONLY=deps
```

macOS は Homebrew で全て入ります。Linux（apt）では次のツールは自動導入されないため、各公式の手順で入れてください: lazygit、glow、navi、jless、doggo、bandwhich、silicon、zellij。

## ツール一覧

### Git と GitHub

| ツール                                              | 用途                      | エイリアス |
| --------------------------------------------------- | ------------------------- | ---------- |
| [git-delta](https://github.com/dandavison/delta)    | `git diff` の見やすい表示 |            |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git の TUI                | `lg`       |
| [gh](https://cli.github.com/)                       | GitHub 公式 CLI           |            |

### シェル

| ツール                                           | 用途                           | エイリアス                                         |
| ------------------------------------------------ | ------------------------------ | -------------------------------------------------- |
| [bat](https://github.com/sharkdp/bat)            | `cat` の代替（構文ハイライト） | `cat`（`--paging=never` 付き）、`bcat`（素の bat） |
| [eza](https://github.com/eza-community/eza)      | `ls` の代替                    | `ls`、`la`、`ll`、`lt`（ツリー）、`l`              |
| [fd](https://github.com/sharkdp/fd)              | `find` の代替                  | `find`                                             |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` の代替                  | `grep`（コマンドは `rg`）                          |
| [zoxide](https://github.com/ajeetdsouza/zoxide)  | 頻度で学習する `cd`            | `cd`（`z`）                                        |
| [atuin](https://github.com/atuinsh/atuin)        | シェル履歴の検索               | `Ctrl+R`                                           |
| [navi](https://github.com/denisidoro/navi)       | 対話式のチートシート           |                                                    |

### 開発

| ツール                                               | 用途                       | エイリアス                                    |
| ---------------------------------------------------- | -------------------------- | --------------------------------------------- |
| [jq](https://github.com/jqlang/jq)                   | JSON の加工                |                                               |
| [jless](https://github.com/PaulJuliusMartinez/jless) | JSON ビューア              |                                               |
| [httpie](https://httpie.io/cli)                      | HTTP クライアント          | `get`、`post`、`put`、`delete`（`http` 経由） |
| [hyperfine](https://github.com/sharkdp/hyperfine)    | コマンドのベンチマーク     | `bench`                                       |
| [watchexec](https://github.com/watchexec/watchexec)  | ファイル変更でコマンド実行 |                                               |
| [just](https://github.com/casey/just)                | タスクランナー             |                                               |
| [direnv](https://direnv.net/)                        | ディレクトリ別の環境変数   | `.envrc` を自動で読み込み                     |
| [glow](https://github.com/charmbracelet/glow)        | Markdown ビューア          | `md`                                          |
| [sd](https://github.com/chmln/sd)                    | 直感的な置換（`sed` 代替） |                                               |
| [tokei](https://github.com/XAMPPRocky/tokei)         | コード行数の統計           |                                               |
| [tldr](https://tldr.sh/)（tlrc）                     | 簡易マニュアル             |                                               |

### システム

| ツール                                           | 用途                         | エイリアス    |
| ------------------------------------------------ | ---------------------------- | ------------- |
| [bottom](https://github.com/ClementTsang/bottom) | システムモニター（`btm`）    | `top`、`htop` |
| [procs](https://github.com/dalance/procs)        | `ps` の代替                  | `pps`         |
| [dust](https://github.com/bootandy/dust)         | ディレクトリごとの使用量     |               |
| [duf](https://github.com/muesli/duf)             | `df` の代替                  | `df`          |
| [bandwhich](https://github.com/imsnif/bandwhich) | プロセス別のネットワーク帯域 |               |
| [doggo](https://github.com/mr-karan/doggo)       | DNS 検索（`dig` 代替）       |               |
| [pv](https://www.ivarch.com/programs/pv.shtml)   | パイプの進捗表示             |               |
| [mkcert](https://github.com/FiloSottile/mkcert)  | ローカル開発用の SSL 証明書  |               |
| [zellij](https://github.com/zellij-org/zellij)   | ターミナルマルチプレクサ     |               |
| [silicon](https://github.com/Aloxaf/silicon)     | コードのスクリーンショット   |               |

## キーバインド

| キー     | 動作                                   | 定義                           |
| -------- | -------------------------------------- | ------------------------------ |
| `Ctrl+R` | 履歴検索（atuin）                      | [tools.zsh](../.zsh/tools.zsh) |
| `Ctrl+F` | fzf でファイルを検索し、エディタで開く | [fzf.zsh](../.zsh/fzf.zsh)     |
| `Ctrl+G` | fzf でディレクトリを検索して移動       | [fzf.zsh](../.zsh/fzf.zsh)     |

## 注意点

- **エイリアスは対話シェルだけで有効**です。スクリプトの中の `cat` や `grep` は、本来のコマンドのままです。
- **`grep` は ripgrep に置き換わっています。** フラグが GNU grep と異なります（例: 既定で再帰検索になり、`-r` は再帰ではなく置換の指定です）。本来の `grep` を使うには、`command grep` か `\grep`。
- 同様に、`cat`、`ls`、`find` も、`command cat` のように呼べば、元のコマンドになります。
- `cd` は zoxide の `z` です。パスを渡せば通常の `cd` と同様に動き、キーワードを渡すと、履歴から最も近い候補へ移動します。
