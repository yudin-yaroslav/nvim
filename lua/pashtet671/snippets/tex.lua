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

-- ls.add_snippets("tex", {
-- 	s({ trig = "begin", name = "Begin env", priority = 2000 }, {
-- 		t("\\begin{"),
-- 		i(1, "env"),
-- 		t("}"),
-- 		t({ "", "\t" }),
--
-- 		ls.function_node(function(args)
-- 			local env = args[1][1] or ""
-- 			if env == "itemize" or env == "enumerate" or env == "list" then
-- 				return "\\item "
-- 			elseif env == "description" then
-- 				return "\\item[] "
-- 			end
-- 			return ""
-- 		end, { 1 }),
--
-- 		i(0),
-- 		t({ "", "\\end{" }),
-- 		ls.function_node(function(args)
-- 			return args[1][1] or ""
-- 		end, { 1 }),
-- 		t("}"),
-- 	}),
-- })
