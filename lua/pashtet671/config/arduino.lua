local M = {}

function M.detect_arduino_port(fqbn)
	local output = vim.fn.system("arduino-cli board list --format json")
	if vim.v.shell_error ~= 0 or output == "" then
		return nil, "Failed to run arduino-cli"
	end

	local ok, boards = pcall(vim.json.decode, output)
	if not ok or not boards then
		return nil, "Failed to parse JSON"
	end

	local ports = boards.detected_ports or {}
	for _, port_entry in ipairs(ports) do
		local matching_boards = port_entry.matching_boards or {}
		for _, board in ipairs(matching_boards) do
			if board.fqbn == fqbn then
				return port_entry.port.address, nil
			end
		end
	end

	return nil, "Board not found"
end

M.arduino_config = {
	fqbn = "arduino:avr:micro",
	sketch_path = vim.fn.expand("%:p:h"),
}

return M
