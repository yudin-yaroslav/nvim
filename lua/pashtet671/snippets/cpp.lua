local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cpp", {
	s("fori", {
		t("for (int i = 0; i < "),
		i(1, "n"),
		t("; i++) {"),
		t({ "", "    " }),
		i(2),
		t({ "", "}" }),
	}),
})
