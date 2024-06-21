
local commfiles = COMM_FILES
local write = io.write

for i=1, #commfiles do
	write(commfiles[i])
	write('\n')
end