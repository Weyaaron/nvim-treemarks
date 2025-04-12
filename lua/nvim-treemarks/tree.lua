local utility = require("nvim-training.utility")

local Tree= {}
Tree.__index = Tree
Tree.metadata = {}

function Tree:new()
	local base = {}
	setmetatable(base, Tree)
	return base
end
function Tree:deserialize(input_data)
    
end

function Tree:serialize()
    
end


return Tree
