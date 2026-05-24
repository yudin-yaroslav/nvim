vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>qo", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>qx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>qn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>qp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>qf", "<cmd>tabnew %<CR>]", { desc = "Open current buffer in new tab" })

keymap.set("t", "<ESC>", [[<C-\><C-n>]], { desc = "Exit terminal mode with <ESC>" })

keymap.set("t", "<A-h>", [[<C-\><C-N><C-w>h]], { desc = "" })
keymap.set("t", "<A-j>", [[<C-\><C-N><C-w>j]], { desc = "" })
keymap.set("t", "<A-k>", [[<C-\><C-N><C-w>k]], { desc = "" })
keymap.set("t", "<A-l>", [[<C-\><C-N><C-w>l]], { desc = "" })
keymap.set("i", "<A-h>", [[<C-\><C-N><C-w>h]], { desc = "" })
keymap.set("i", "<A-j>", [[<C-\><C-N><C-w>j]], { desc = "" })
keymap.set("i", "<A-k>", [[<C-\><C-N><C-w>k]], { desc = "" })
keymap.set("i", "<A-l>", [[<C-\><C-N><C-w>l]], { desc = "" })
keymap.set("n", "<A-h>", [[<C-w>h]], { desc = "" })
keymap.set("n", "<A-j>", [[<C-w>j]], { desc = "" })
keymap.set("n", "<A-k>", [[<C-w>k]], { desc = "" })
keymap.set("n", "<A-l>", [[<C-w>l]], { desc = "" })

keymap.set("n", "<leader>tx", ":bd!<CR>", { desc = "Close terminal" })

keymap.set("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
keymap.set("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Run or continue the debugger" })

-- COMPILERS' KEYMAPS

-- python
keymap.set("n", "<leader>tp", "<cmd>split | term python3 % <CR>", { desc = "Compile and run python" })
-- c++
-- keymap.set("n", "<leader>tc", ":sp <CR> :term g++ % -o %:r.out ; ./%:r.out <CR> I", { desc = "Compile and run c++" })
keymap.set(
	"n",
	"<leader>tg",
	"<cmd>split | term bash -c 'mkdir -p build && if [ -f compile_flags.txt ]; then g++ @compile_flags.txt % -o build/%:t:r.out; else g++ % -o build/%:t:r.out; fi && ./build/%:t:r.out'<CR>",
	{ desc = "Compile and run C++ (build dir)" }
)
-- c++ (CMAKE)
local function cmake_build_and_run()
	local cwd = vim.fn.getcwd()
	local cmake_file = cwd .. "/CMakeLists.txt"

	local out_path = nil

	if vim.fn.filereadable(cmake_file) == 1 then
		for _, line in ipairs(vim.fn.readfile(cmake_file)) do
			local match = line:match("^#%s*out%s*=%s*(.+)$")
			if match then
				out_path = vim.trim(match)
				break
			end
		end
	end

	if not out_path then
		out_path = "./" .. vim.fn.expand("%:r") .. ".out"
	end

	if not out_path:match("^/") then
		out_path = "../" .. out_path
	end

	local cmd = "split | term "
		.. "mkdir -p build && "
		.. "cd build && "
		.. "cmake .. && "
		.. "make && "
		.. "clear && "
		.. out_path

	vim.cmd(cmd)
end

keymap.set("n", "<leader>tc", cmake_build_and_run, { desc = "CMake build project" })

-- latex
keymap.set(
	"n",
	"<leader>tl",
	"<cmd>!latexmk -pdflua -output-directory='./build/' --shell-escape<CR>",
	{ desc = "Render LaTeX with latexmk" }
)
keymap.set("i", "<C-d>", "$$<Left>", { noremap = true })
keymap.set(
	"i",
	"<C-f>",
	[[<Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>"]]
)
keymap.set(
	"n",
	"<C-f>",
	[[: silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>]]
)

-- arduino:
local arduino = require("pashtet671.config.arduino")

local function run_cmd(cmd_list)
	local cmd = table.concat(cmd_list, " ")
	vim.cmd("!" .. cmd)
end

local function stop_monitor_for_port(port)
	if not port or port == "" then
		return
	end
	vim.fn.system({ "pkill", "-f", "arduino-monitor-loop.sh " .. port })
end

vim.api.nvim_create_user_command("ArduinoDetectPort", function()
	print(arduino.detect_arduino_port(arduino.arduino_config.fqbn))
end, {})

-- Compile
vim.api.nvim_create_user_command("ArduinoCompile", function()
	run_cmd({
		"arduino-cli",
		"compile",
		"--fqbn",
		arduino.arduino_config.fqbn,
		arduino.arduino_config.sketch_path,
	})
end, {})

vim.api.nvim_create_user_command("ArduinoUpload", function()
	local port, err = arduino.detect_arduino_port(arduino.arduino_config.fqbn)
	if not port then
		vim.notify("Upload failed: cannot detect port: " .. (err or "unknown"), vim.log.levels.ERROR)
		return
	end

	stop_monitor_for_port(port)
	vim.wait(300) -- 300 ms

	run_cmd({
		"arduino-cli",
		"upload",
		"-p",
		port,
		"--fqbn",
		arduino.arduino_config.fqbn,
		arduino.arduino_config.sketch_path,
	})

	if vim.v.shell_error ~= 0 then
		vim.notify("Upload failed (exit code: " .. tostring(vim.v.shell_error) .. ")", vim.log.levels.ERROR)
	end

	if vim.fn.executable("alacritty") == 1 then
		vim.fn.jobstart({
			"alacritty",
			"-e",
			"arduino-monitor-loop.sh",
			port,
			arduino.arduino_config.fqbn,
		}, { detach = true })
	else
		vim.notify("Alacritty not found in PATH; monitor not restarted.", vim.log.levels.WARN)
	end
end, {})

vim.api.nvim_create_user_command("ArduinoSerial", function()
	local port, err = arduino.detect_arduino_port(arduino.arduino_config.fqbn)
	if not port then
		vim.notify("Serial failed: " .. (err or "Unknown error"), vim.log.levels.ERROR)
		return
	end

	if vim.fn.executable("alacritty") == 0 then
		vim.notify("Alacritty not found in PATH", vim.log.levels.ERROR)
		return
	end

	vim.fn.jobstart({
		"alacritty",
		"-e",
		"arduino-monitor-loop.sh",
		port,
		arduino.arduino_config.fqbn,
	}, { detach = true })
end, {})

keymap.set("n", "<leader>taa", function()
	vim.cmd("ArduinoCompile")
	if vim.v.shell_error == 0 then
		vim.cmd("ArduinoUpload")
	else
		vim.notify("Compile failed, skipping upload", vim.log.levels.WARN)
	end
end, { desc = "Compile and Upload Arduino sketch" })

keymap.set("n", "<leader>tac", function()
	vim.cmd("ArduinoCompile")
end, { desc = "Compile Arduino sketch" })

keymap.set("n", "<leader>tau", function()
	vim.cmd("ArduinoUpload")
end, { desc = "Upload Arduino sketch" })

keymap.set("n", "<leader>tad", function()
	vim.cmd("ArduinoDetectPort")
end, { desc = "Detect Arduino port" })

keymap.set("n", "<leader>tas", function()
	vim.cmd("ArduinoSerial")
end, { desc = "Open Arduino serial monitor" })

-- javascript
keymap.set("n", "<leader>tj", "<cmd>! node % <CR>")

-- log export
vim.api.nvim_create_user_command("SaveOutput", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	vim.fn.mkdir("logs", "p")
	local filename = os.date("logs/output-%Y%m%d_%H%M%S.log")

	local fd = io.open(filename, "w")
	if not fd then
		vim.notify("Failed to open file for writing: " .. filename, vim.log.levels.ERROR)
		return
	end

	for _, line in ipairs(lines) do
		fd:write(line .. "\n")
	end
	fd:close()

	vim.notify("Log written to " .. filename, vim.log.levels.INFO)
end, {})

vim.keymap.set("n", "<leader>to", "<cmd>SaveOutput<CR>", { desc = "Save output to logs" })

-- temp keymaps for german
local function append_and_move(suffix)
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_get_current_line()
	vim.api.nvim_set_current_line(line .. suffix)

	local total_lines = vim.api.nvim_buf_line_count(0)
	if row < total_lines then
		vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
	end
end

vim.keymap.set("n", "<C-A-P>", function()
	append_and_move(" p")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-V>", function()
	append_and_move(" v")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-N>", function()
	append_and_move(" n")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-A>", function()
	append_and_move(" a")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-M>", function()
	append_and_move(" m")
end, { noremap = true, silent = true })

vim.keymap.set("i", "<A-,>", "«»<Left>", { noremap = true })
vim.keymap.set("i", "<A-.>", "»", { noremap = true })

vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true })

local function run_manim(scene)
	local out = {}

	local function push(_, data)
		for _, l in ipairs(data or {}) do
			if l ~= "" then
				out[#out + 1] = l
			end
		end
	end

	vim.fn.jobstart({ "manim", "-pql", "main.py", scene }, {
		pty = true,
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = push,
		on_stderr = push,
		on_exit = function(_, code)
			if code == 0 then
				return
			end
			vim.schedule(function()
				local b = vim.api.nvim_create_buf(false, true)
				local w = vim.api.nvim_open_win(b, true, {
					relative = "editor",
					width = math.floor(vim.o.columns * 0.51),
					height = math.floor(vim.o.lines * 0.9),
					row = 2,
					col = 4,
					style = "minimal",
					border = "rounded",
					title = " Manim error ",
				})

				vim.wo[w].wrap = false
				vim.bo[b].bufhidden = "wipe"
				vim.bo[b].swapfile = false

				local term = vim.api.nvim_open_term(b, {})
				vim.api.nvim_chan_send(term, table.concat(out, "\n") .. "\n")
				vim.keymap.set("n", "q", function()
					vim.api.nvim_win_close(w, true)
				end, { buffer = b })
			end)
		end,
	})
end

local cache_file = vim.fn.stdpath("cache") .. "/manim_last_scene"

local function save_last_scene(scene)
	if scene == "" then
		return
	end
	vim.fn.writefile({ scene }, cache_file)
end

local function load_last_scene()
	if vim.fn.filereadable(cache_file) == 0 then
		return nil
	end

	local lines = vim.fn.readfile(cache_file)
	local scene = lines[1]
	if scene == nil or scene == "" then
		return nil
	end

	return scene
end

vim.g.manim_last_scene = load_last_scene()

vim.keymap.set("v", "<leader>tm", function()
	vim.cmd('normal! "zy')
	local scene = vim.fn.trim(vim.fn.getreg("z") or "")

	if scene == "" then
		return
	end

	vim.g.manim_last_scene = scene
	save_last_scene(scene)
	run_manim(scene)
end, { silent = true, desc = "Run selected Manim scene" })

vim.keymap.set("n", "<leader>tm", function()
	local scene = vim.g.manim_last_scene
	if scene and scene ~= "" then
		run_manim(scene)
	end
end, { silent = true, desc = "Run last Manim scene" })
