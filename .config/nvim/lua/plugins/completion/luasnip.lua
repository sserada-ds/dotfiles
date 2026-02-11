return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",            -- 多言語対応のスニペット集
    "saadparwaiz1/cmp_luasnip",                -- nvim-cmp連携用ソース
  },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
