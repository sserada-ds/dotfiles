# 外部由来の skill

上流の差分を追えるよう、これらは prettier の整形対象外です (`.prettierignore`)。

| skill             | 取得元                                                          | コミット  | ライセンス                             |
| ----------------- | --------------------------------------------------------------- | --------- | -------------------------------------- |
| `webapp-testing`  | https://github.com/anthropics/skills (`skills/webapp-testing`)  | `dbd4588` | Apache 2.0 (各 skill の `LICENSE.txt`) |
| `frontend-design` | https://github.com/anthropics/skills (`skills/frontend-design`) | `dbd4588` | Apache 2.0 (各 skill の `LICENSE.txt`) |

取り込まないと決めたもの:

- `doc-coauthoring`: ライセンス表記がなく、public リポジトリで再配布できる根拠がないため
- `mcp-builder`: 会社の規約で MCP を使用できないため
- `docx` / `pdf` / `pptx` / `xlsx`: source-available (オープンソースではない) のため。Anthropic 側の同期スキルを使う
