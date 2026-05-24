local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("tex", {
	s("tex", {
		t({
			"\\documentclass[11pt]{scrartcl}",
			"\\usepackage[sexy]{evan}",
			"\\usepackage{indentfirst}",
			"\\usepackage{amssymb}",
			"",
			"\\begin{document}",
			"",
			"\\title{Math Article}",
			"\\author{Yudin Yaroslav}",
			"\\maketitle",
			"",
			"\\tableofcontents",
			"\\newpage",
			"",
		}),
		i(1),
		t({
			"",
			"\\end{document}",
		}),
	}),
})

ls.add_snippets("tex", {
	s("lemma", {
		t({ "\\begin{lemma}", "	" }),
		i(0),
		t({ "", "\\end{lemma}" }),
	}),
})
