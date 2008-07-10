#!/usr/bin/env lua

-- prints the daily mehfil menu
require("socket.http")
html = socket.http.request("http://mehfilindian.com/LunchMenuTakeOut.htm")

function normalize_line(line)
	while line:find("  ") do
		line = line:gsub("  ", " ")
	end
	line = line:gsub(" ,", ",")
	return line
end

function format_entree(entree)
end

lines = {}
for line in html:gmatch("[^\n]*\n") do
	lines[#lines + 1] = line:gsub("\n", "")
end

-- Print out what day the menu is for
for _, line in ipairs(lines) do
	if line:find("Menu.*For") then
		line = normalize_line(line:gsub("&nbsp;", " "))
		line = line:gsub("<.*", "")
		print(line)
		break
	end
end

-- Now we need to print out the menu items... the way we do this is we search
-- for the text (n) where n is some number, and use that to identify the start
-- of a menu item.
entrees = {}
stacked = false
entry = {}
for _, line in ipairs(lines) do
	if line:find('%([0-5]%)') then stacked = true end
	if stacked then
		entry[#entry + 1] = line:gsub('<.*>', ''):gsub('^%s*', ''):gsub('%s*$', '')
		print(entry[#entry])
	end
	if stacked and line:find('%$%s*[0-9]%.[0-9][0-9]') then
		stacked = false
		entrees[#entrees + 1] = entry
		entry = {}
		print()
	end
end

-- TODO: canonicalize the entrees
