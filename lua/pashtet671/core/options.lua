local opt = vim.opt
local cmd = vim.cmd
local api = vim.api

cmd("let g:netrw_liststyle = 3")
cmd([[function! IndentWithI()
    if len(getline('.')) == 0
        return "\"_cc"
    else
        return "i"
    endif
endfunction
nnoremap <expr> i IndentWithI()]])

opt.relativenumber = true
opt.number = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true
opt.expandtab = false

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.langmap = "фa,иb,сc,вd,уe,аf,пg,рh,шi,оj,лk,дl,ьm,тn,щo,зp,йq,кr,ыs,еt,гu,мv,цw,чx,нy,яz"

opt.foldmethod = "marker"

opt.autoindent = true
opt.cindent = true
opt.smartindent = true

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.cmd([[highlight WinSeparator guifg=#181818 guibg=#181818]])
	end,
})

vim.opt.fillchars:append({ vert = " " })

vim.g.arduino_recommended_style = 0
vim.g.python_recommended_style = 0

cmd("filetype plugin indent on")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "cc", "cxx", "h", "hpp" },
	callback = function()
		vim.opt_local.autoindent = true
		vim.opt_local.smartindent = true
		vim.opt_local.cindent = true
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = false
		vim.opt_local.indentexpr = ""
	end,
})
