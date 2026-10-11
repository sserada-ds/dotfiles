-- Alma Sakura colorscheme for Neovim
-- VSCode "Alma Dimmed Sakura" のパレットを Neovim に移植したもの。
-- 出典: hoshinokanade.alma-sakura (https://github.com/as-alma/Alma-Sakura)

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "alma-sakura"

local p = {
  bg         = "#2e2b2c",
  bg_alt     = "#372d2d",
  bg_dim     = "#322a2d",
  bg_panel   = "#413036",
  bg_sel     = "#443838",
  bg_visual  = "#563440",
  bg_float   = "#3e2e33",
  bg_dark    = "#1f191b",
  bg_darker  = "#272022",

  fg         = "#cbbec2",
  fg_alt     = "#c4b0b3",
  fg_dim     = "#a48e96",
  fg_muted   = "#705b5f",
  fg_subtle  = "#8b747c",
  fg_bright  = "#edebff",

  pink       = "#f18eb0",
  pink_soft  = "#ffb3cd",
  pink_dim   = "#bb778f",
  pink_dark  = "#824a5e",
  pink_deep  = "#57313a",

  red        = "#e34e1c",
  red_soft   = "#ffb3a7",
  red_alt    = "#db5a6b",
  orange     = "#e66533",
  orange_alt = "#e69533",
  yellow     = "#e4b781",
  gold       = "#d5971a",
  green      = "#16b673",
  green_soft = "#49e9a6",
  cyan       = "#40d4e7",
  cyan_alt   = "#49d6e9",
  cyan_dim   = "#16a3b6",
  blue       = "#49ace9",
  purple     = "#7060eb",
  purple_alt = "#b267e6",

  add        = "#16b673",
  change     = "#49e9a6",
  delete     = "#e34e1c",

  none       = "NONE",
}

local hl = function(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

-- Terminal colors (used by :terminal and many plugins)
vim.g.terminal_color_0  = p.bg_dark
vim.g.terminal_color_1  = p.red
vim.g.terminal_color_2  = p.green
vim.g.terminal_color_3  = p.yellow
vim.g.terminal_color_4  = p.blue
vim.g.terminal_color_5  = p.pink
vim.g.terminal_color_6  = p.cyan
vim.g.terminal_color_7  = p.fg
vim.g.terminal_color_8  = p.fg_muted
vim.g.terminal_color_9  = p.red_soft
vim.g.terminal_color_10 = p.green_soft
vim.g.terminal_color_11 = p.gold
vim.g.terminal_color_12 = p.cyan_alt
vim.g.terminal_color_13 = p.pink_soft
vim.g.terminal_color_14 = p.cyan_dim
vim.g.terminal_color_15 = p.fg_bright

-- ===== Editor =====
hl("Normal",         { fg = p.fg, bg = p.bg })
hl("NormalNC",       { fg = p.fg, bg = p.bg })
hl("NormalFloat",    { fg = p.fg, bg = p.bg_float })
hl("FloatBorder",    { fg = p.pink_dim, bg = p.bg_float })
hl("FloatTitle",     { fg = p.pink, bg = p.bg_float, bold = true })
hl("ColorColumn",    { bg = p.bg_alt })
hl("Conceal",        { fg = p.fg_muted })
hl("Cursor",         { fg = p.bg, bg = p.pink_soft })
hl("lCursor",        { fg = p.bg, bg = p.pink_soft })
hl("CursorIM",       { fg = p.bg, bg = p.pink_soft })
hl("CursorColumn",   { bg = "#423636" })
hl("CursorLine",     { bg = "#423636" })
hl("Directory",      { fg = p.pink })
hl("DiffAdd",        { bg = "#2a4037" })
hl("DiffChange",     { bg = "#32483f" })
hl("DiffDelete",     { bg = "#5d3a2e", fg = p.red })
hl("DiffText",       { bg = "#355e4d" })
hl("EndOfBuffer",    { fg = p.bg })
hl("ErrorMsg",       { fg = p.red })
hl("VertSplit",      { fg = p.bg_dark })
hl("WinSeparator",   { fg = p.bg_dark })
hl("Folded",         { fg = p.fg_dim, bg = p.bg_dim })
hl("FoldColumn",     { fg = p.fg_muted, bg = p.bg })
hl("SignColumn",     { fg = p.fg_muted, bg = p.bg })
hl("IncSearch",      { fg = p.bg, bg = p.pink })
hl("CurSearch",      { fg = p.bg, bg = p.pink_soft, bold = true })
hl("Search",         { bg = "#5f434c" })
hl("Substitute",     { fg = p.bg, bg = p.orange })
hl("LineNr",         { fg = p.fg_muted })
hl("CursorLineNr",   { fg = p.pink_dim, bold = true })
hl("MatchParen",     { fg = p.pink, bold = true, underline = true })
hl("ModeMsg",        { fg = p.fg_alt, bold = true })
hl("MsgArea",        { fg = p.fg })
hl("MsgSeparator",   { fg = p.pink_dim, bg = p.bg_alt })
hl("MoreMsg",        { fg = p.green_soft })
hl("NonText",        { fg = p.fg_muted })
hl("Pmenu",          { fg = p.fg, bg = p.bg_float })
hl("PmenuSel",       { fg = p.fg_bright, bg = p.bg_visual })
hl("PmenuSbar",      { bg = p.bg_panel })
hl("PmenuThumb",     { bg = p.pink_dim })
hl("Question",       { fg = p.green_soft })
hl("QuickFixLine",   { bg = p.bg_visual })
hl("SpecialKey",     { fg = p.fg_muted })
hl("SpellBad",       { undercurl = true, sp = p.red })
hl("SpellCap",       { undercurl = true, sp = p.cyan })
hl("SpellLocal",     { undercurl = true, sp = p.cyan_dim })
hl("SpellRare",      { undercurl = true, sp = p.purple_alt })
hl("StatusLine",     { fg = p.fg_alt, bg = p.bg_alt })
hl("StatusLineNC",   { fg = p.fg_muted, bg = p.bg_alt })
hl("TabLine",        { fg = p.fg_dim, bg = p.bg_alt })
hl("TabLineFill",    { bg = p.bg_alt })
hl("TabLineSel",     { fg = p.pink, bg = p.bg, bold = true })
hl("Title",          { fg = p.pink, bold = true })
hl("Visual",         { bg = p.bg_visual })
hl("VisualNOS",      { bg = p.bg_sel })
hl("WarningMsg",     { fg = p.orange_alt })
hl("Whitespace",     { fg = "#494043" })
hl("WildMenu",       { fg = p.fg_bright, bg = p.pink_dark })
hl("WinBar",         { fg = p.fg_alt, bg = p.bg })
hl("WinBarNC",       { fg = p.fg_muted, bg = p.bg })

-- ===== Syntax (legacy groups) =====
hl("Comment",        { fg = p.fg_subtle, italic = true })
hl("Constant",       { fg = p.orange })
hl("String",         { fg = p.yellow })
hl("Character",      { fg = p.yellow })
hl("Number",         { fg = p.gold })
hl("Boolean",        { fg = p.orange })
hl("Float",          { fg = p.gold })
hl("Identifier",     { fg = p.fg })
hl("Function",       { fg = p.cyan_alt })
hl("Statement",      { fg = p.pink })
hl("Conditional",    { fg = p.pink })
hl("Repeat",         { fg = p.pink })
hl("Label",          { fg = p.pink })
hl("Operator",       { fg = p.green })
hl("Keyword",        { fg = p.pink })
hl("Exception",      { fg = p.red_alt })
hl("PreProc",        { fg = p.purple_alt })
hl("Include",        { fg = p.pink })
hl("Define",         { fg = p.purple_alt })
hl("Macro",          { fg = p.purple_alt })
hl("PreCondit",      { fg = p.purple_alt })
hl("Type",           { fg = p.purple })
hl("StorageClass",   { fg = p.purple })
hl("Structure",      { fg = p.purple })
hl("Typedef",        { fg = p.purple })
hl("Special",        { fg = p.cyan_dim })
hl("SpecialChar",    { fg = p.cyan_dim })
hl("Tag",            { fg = p.pink })
hl("Delimiter",      { fg = p.fg_dim })
hl("SpecialComment", { fg = p.pink_dim, italic = true })
hl("Debug",          { fg = p.orange })
hl("Underlined",     { underline = true })
hl("Ignore",         { fg = p.fg_muted })
hl("Error",          { fg = p.red })
hl("Todo",           { fg = p.bg, bg = p.pink, bold = true })

-- ===== Treesitter =====
hl("@variable",                 { fg = p.fg })
hl("@variable.builtin",         { fg = p.purple, italic = true })
hl("@variable.parameter",       { fg = p.red_soft })
hl("@variable.member",          { fg = p.cyan })
hl("@constant",                 { fg = p.orange })
hl("@constant.builtin",         { fg = p.orange })
hl("@constant.macro",           { fg = p.purple_alt })
hl("@module",                   { fg = p.cyan_dim })
hl("@label",                    { fg = p.pink })
hl("@string",                   { fg = p.yellow })
hl("@string.escape",            { fg = p.cyan_dim })
hl("@string.special",           { fg = p.cyan_dim })
hl("@string.regexp",            { fg = p.orange })
hl("@character",                { fg = p.yellow })
hl("@number",                   { fg = p.gold })
hl("@number.float",             { fg = p.gold })
hl("@boolean",                  { fg = p.orange })
hl("@function",                 { fg = p.cyan_alt })
hl("@function.builtin",         { fg = p.cyan_alt })
hl("@function.call",            { fg = p.cyan_alt })
hl("@function.macro",           { fg = p.purple_alt })
hl("@function.method",          { fg = p.cyan_alt })
hl("@function.method.call",     { fg = p.cyan_alt })
hl("@constructor",              { fg = p.cyan_dim })
hl("@operator",                 { fg = p.green })
hl("@keyword",                  { fg = p.pink })
hl("@keyword.function",         { fg = p.pink })
hl("@keyword.return",           { fg = p.pink })
hl("@keyword.operator",         { fg = p.pink })
hl("@keyword.import",           { fg = p.pink })
hl("@keyword.exception",        { fg = p.red_alt })
hl("@keyword.conditional",      { fg = p.pink })
hl("@keyword.repeat",           { fg = p.pink })
hl("@type",                     { fg = p.purple })
hl("@type.builtin",             { fg = p.purple, italic = true })
hl("@type.definition",          { fg = p.purple })
hl("@type.qualifier",           { fg = p.pink })
hl("@property",                 { fg = p.cyan })
hl("@attribute",                { fg = p.purple_alt })
hl("@punctuation.delimiter",    { fg = p.fg_dim })
hl("@punctuation.bracket",      { fg = p.fg_alt })
hl("@punctuation.special",      { fg = p.pink })
hl("@comment",                  { fg = p.fg_subtle, italic = true })
hl("@comment.documentation",    { fg = p.pink_dim, italic = true })
hl("@comment.todo",             { fg = p.bg, bg = p.pink, bold = true })
hl("@comment.note",             { fg = p.bg, bg = p.cyan, bold = true })
hl("@comment.warning",          { fg = p.bg, bg = p.orange_alt, bold = true })
hl("@comment.error",            { fg = p.bg, bg = p.red, bold = true })
hl("@tag",                      { fg = p.pink })
hl("@tag.attribute",            { fg = p.purple })
hl("@tag.delimiter",            { fg = p.fg_dim })
-- Markup
hl("@markup.heading",           { fg = p.pink, bold = true })
hl("@markup.strong",            { fg = p.fg, bold = true })
hl("@markup.italic",            { fg = p.fg, italic = true })
hl("@markup.strikethrough",     { fg = p.fg, strikethrough = true })
hl("@markup.underline",         { fg = p.fg, underline = true })
hl("@markup.link",              { fg = p.blue, underline = true })
hl("@markup.link.url",          { fg = p.blue, underline = true })
hl("@markup.link.label",        { fg = p.cyan_alt })
hl("@markup.raw",               { fg = p.yellow })
hl("@markup.list",              { fg = p.pink })
hl("@markup.quote",             { fg = p.fg_subtle, italic = true })
hl("@diff.plus",                { fg = p.add })
hl("@diff.minus",               { fg = p.delete })
hl("@diff.delta",               { fg = p.change })

-- ===== LSP semantic tokens =====
hl("@lsp.type.namespace",       { link = "@module" })
hl("@lsp.type.type",            { link = "@type" })
hl("@lsp.type.class",           { link = "@type" })
hl("@lsp.type.enum",            { link = "@type" })
hl("@lsp.type.interface",       { link = "@type" })
hl("@lsp.type.struct",          { link = "@type" })
hl("@lsp.type.parameter",       { link = "@variable.parameter" })
hl("@lsp.type.variable",        { link = "@variable" })
hl("@lsp.type.property",        { link = "@property" })
hl("@lsp.type.function",        { link = "@function" })
hl("@lsp.type.method",          { link = "@function.method" })
hl("@lsp.type.macro",           { link = "@function.macro" })
hl("@lsp.type.decorator",       { link = "@attribute" })
hl("@lsp.type.enumMember",      { fg = p.orange })
hl("@lsp.type.comment",         { link = "@comment" })

-- ===== Diagnostics =====
hl("DiagnosticError",           { fg = p.red })
hl("DiagnosticWarn",            { fg = p.orange_alt })
hl("DiagnosticInfo",            { fg = p.cyan })
hl("DiagnosticHint",            { fg = p.green_soft })
hl("DiagnosticOk",              { fg = p.green })
hl("DiagnosticVirtualTextError",{ fg = p.red, bg = "#451c10" })
hl("DiagnosticVirtualTextWarn", { fg = p.orange_alt, bg = "#4a4036" })
hl("DiagnosticVirtualTextInfo", { fg = p.cyan, bg = "#244146" })
hl("DiagnosticVirtualTextHint", { fg = p.green_soft, bg = "#2b3e35" })
hl("DiagnosticUnderlineError",  { undercurl = true, sp = p.red })
hl("DiagnosticUnderlineWarn",   { undercurl = true, sp = p.orange_alt })
hl("DiagnosticUnderlineInfo",   { undercurl = true, sp = p.cyan })
hl("DiagnosticUnderlineHint",   { undercurl = true, sp = p.green_soft })

-- ===== Git / Diff plugins =====
hl("GitSignsAdd",               { fg = p.add })
hl("GitSignsChange",            { fg = p.change })
hl("GitSignsDelete",            { fg = p.delete })
hl("GitGutterAdd",              { fg = p.add })
hl("GitGutterChange",           { fg = p.change })
hl("GitGutterDelete",           { fg = p.delete })
hl("diffAdded",                 { fg = p.add })
hl("diffRemoved",               { fg = p.delete })
hl("diffChanged",               { fg = p.change })
hl("diffFile",                  { fg = p.fg_dim })
hl("diffLine",                  { fg = p.cyan })

-- ===== Telescope =====
hl("TelescopeNormal",           { fg = p.fg, bg = p.bg_float })
hl("TelescopeBorder",           { fg = p.pink_dim, bg = p.bg_float })
hl("TelescopePromptNormal",     { fg = p.fg, bg = p.bg_panel })
hl("TelescopePromptBorder",     { fg = p.pink_dim, bg = p.bg_panel })
hl("TelescopePromptTitle",      { fg = p.bg, bg = p.pink, bold = true })
hl("TelescopePromptPrefix",     { fg = p.pink })
hl("TelescopePromptCounter",    { fg = p.fg_dim })
hl("TelescopeResultsTitle",     { fg = p.bg_float, bg = p.bg_float })
hl("TelescopePreviewTitle",     { fg = p.bg, bg = p.green_soft, bold = true })
hl("TelescopeSelection",        { fg = p.fg_bright, bg = p.bg_visual })
hl("TelescopeSelectionCaret",   { fg = p.pink, bg = p.bg_visual })
hl("TelescopeMatching",         { fg = p.pink, bold = true })
hl("TelescopeMultiSelection",   { fg = p.green_soft })

-- ===== Neo-tree =====
hl("NeoTreeNormal",             { fg = p.fg_alt, bg = p.bg_alt })
hl("NeoTreeNormalNC",           { fg = p.fg_alt, bg = p.bg_alt })
hl("NeoTreeRootName",           { fg = p.pink, bold = true })
hl("NeoTreeDirectoryName",      { fg = p.fg_alt })
hl("NeoTreeDirectoryIcon",      { fg = p.pink_dim })
hl("NeoTreeFileName",           { fg = p.fg })
hl("NeoTreeFileIcon",           { fg = p.fg_dim })
hl("NeoTreeIndentMarker",       { fg = "#4d3030" })
hl("NeoTreeExpander",           { fg = p.pink_dim })
hl("NeoTreeCursorLine",         { bg = p.bg_sel })
hl("NeoTreeGitAdded",           { fg = p.add })
hl("NeoTreeGitConflict",        { fg = p.orange_alt })
hl("NeoTreeGitDeleted",         { fg = p.delete })
hl("NeoTreeGitIgnored",         { fg = p.fg_muted })
hl("NeoTreeGitModified",        { fg = p.change })
hl("NeoTreeGitUntracked",       { fg = p.cyan })
hl("NeoTreeTitleBar",           { fg = p.bg, bg = p.pink, bold = true })

-- ===== Bufferline =====
hl("BufferLineFill",            { bg = p.bg_alt })
hl("BufferLineBackground",      { fg = p.fg_dim, bg = p.bg_alt })
hl("BufferLineBufferSelected",  { fg = p.pink, bg = p.bg, bold = true })
hl("BufferLineBufferVisible",   { fg = p.fg_alt, bg = p.bg_alt })
hl("BufferLineSeparator",       { fg = p.bg_dark, bg = p.bg_alt })
hl("BufferLineSeparatorSelected", { fg = p.bg_dark, bg = p.bg })
hl("BufferLineSeparatorVisible",{ fg = p.bg_dark, bg = p.bg_alt })
hl("BufferLineIndicatorSelected", { fg = p.pink, bg = p.bg })
hl("BufferLineModified",        { fg = p.green_soft, bg = p.bg_alt })
hl("BufferLineModifiedSelected",{ fg = p.green_soft, bg = p.bg })

-- ===== Indent-blankline =====
hl("IblIndent",                 { fg = "#4d3030" })
hl("IblScope",                  { fg = p.pink_dark })
hl("IblWhitespace",             { fg = p.bg_dark })

-- ===== Noice / nvim-cmp =====
hl("NoiceCmdline",              { fg = p.fg, bg = p.bg_float })
hl("NoiceCmdlinePopup",         { fg = p.fg, bg = p.bg_float })
hl("NoiceCmdlinePopupBorder",   { fg = p.pink, bg = p.bg_float })
hl("NoiceCmdlinePopupTitle",    { fg = p.pink, bold = true })
hl("NoiceCmdlineIcon",          { fg = p.pink })
hl("NoiceConfirm",              { fg = p.fg, bg = p.bg_float })
hl("NoiceConfirmBorder",        { fg = p.pink, bg = p.bg_float })
hl("NoiceMini",                 { fg = p.fg, bg = p.bg_alt })
hl("NoicePopup",                { fg = p.fg, bg = p.bg_float })
hl("NoicePopupBorder",          { fg = p.pink_dim, bg = p.bg_float })

hl("CmpItemAbbr",               { fg = p.fg })
hl("CmpItemAbbrDeprecated",     { fg = p.fg_muted, strikethrough = true })
hl("CmpItemAbbrMatch",          { fg = p.pink, bold = true })
hl("CmpItemAbbrMatchFuzzy",     { fg = p.pink_soft, bold = true })
hl("CmpItemKind",               { fg = p.purple })
hl("CmpItemKindFunction",       { fg = p.cyan_alt })
hl("CmpItemKindMethod",         { fg = p.cyan_alt })
hl("CmpItemKindVariable",       { fg = p.cyan })
hl("CmpItemKindKeyword",        { fg = p.pink })
hl("CmpItemKindSnippet",        { fg = p.green_soft })
hl("CmpItemKindClass",          { fg = p.cyan_dim })
hl("CmpItemKindInterface",      { fg = p.purple })
hl("CmpItemMenu",               { fg = p.fg_dim, italic = true })

-- ===== Which-key =====
hl("WhichKey",                  { fg = p.pink })
hl("WhichKeyGroup",             { fg = p.cyan_alt })
hl("WhichKeyDesc",              { fg = p.fg })
hl("WhichKeySeparator",         { fg = p.fg_dim })
hl("WhichKeyFloat",             { bg = p.bg_float })
hl("WhichKeyBorder",            { fg = p.pink_dim, bg = p.bg_float })
hl("WhichKeyValue",             { fg = p.green_soft })

-- ===== Trouble =====
hl("TroubleNormal",             { fg = p.fg, bg = p.bg })
hl("TroubleText",               { fg = p.fg })
hl("TroubleCount",              { fg = p.pink, bg = p.bg_panel })
hl("TroubleSource",             { fg = p.fg_dim })
hl("TroubleFile",               { fg = p.cyan_alt })
hl("TroubleLocation",           { fg = p.fg_dim })

-- ===== Flash =====
hl("FlashBackdrop",             { fg = p.fg_muted })
hl("FlashMatch",                { fg = p.bg, bg = p.pink_soft, bold = true })
hl("FlashCurrent",              { fg = p.bg, bg = p.pink, bold = true })
hl("FlashLabel",                { fg = p.bg, bg = p.green_soft, bold = true })

-- ===== LSP misc =====
hl("LspReferenceText",          { bg = "#52473d" })
hl("LspReferenceRead",          { bg = "#52473d" })
hl("LspReferenceWrite",         { bg = "#4e4123" })
hl("LspSignatureActiveParameter", { fg = p.pink, bold = true })
hl("LspInlayHint",              { fg = p.fg_muted, italic = true })

-- ===== Misc plugins =====
hl("NotifyERRORBorder",         { fg = p.red })
hl("NotifyWARNBorder",          { fg = p.orange_alt })
hl("NotifyINFOBorder",          { fg = p.cyan })
hl("NotifyDEBUGBorder",         { fg = p.fg_muted })
hl("NotifyTRACEBorder",         { fg = p.purple_alt })
hl("NotifyERRORIcon",           { fg = p.red })
hl("NotifyWARNIcon",            { fg = p.orange_alt })
hl("NotifyINFOIcon",            { fg = p.cyan })

hl("RainbowDelimiterRed",       { fg = p.pink })
hl("RainbowDelimiterYellow",    { fg = p.yellow })
hl("RainbowDelimiterBlue",      { fg = p.cyan_alt })
hl("RainbowDelimiterOrange",    { fg = p.orange })
hl("RainbowDelimiterGreen",     { fg = p.green_soft })
hl("RainbowDelimiterViolet",    { fg = p.purple })
hl("RainbowDelimiterCyan",      { fg = p.cyan_dim })
