local tm = {}

local dir = {
	NORTH = 1,
	EAST = 2,
	SOUTH = 3,
	WEST = 4
}

tm.pos = vector.new(0, 0, 0)
tm.dir = dir.NORTH

---@param move table
---@return boolean success
function tm.move(move)
	local com
	local add = {}

	if move.y == -1 then
		com = turtle.down
		add = vector.new(0, -1, 0)
	elseif move.y == 1 then
		com = turtle.up
		add = vector.new(0, 1, 0)
	elseif move.z == -1 then
		com = function()
			return tm.trackedRotate(dir.NORTH) and turtle.forward()
		end
		add = vector.new(0, 0, -1)
	elseif move.z == 1 then
		com = function()
			return tm.trackedRotate(dir.SOUTH) and turtle.forward()
		end
		add = vector.new(0, 0, 1)
	elseif move.x == -1 then
		com = function()
			return tm.trackedRotate(dir.WEST) and turtle.forward()
		end
		add = vector.new(-1, 0, 0)
	elseif move.x == 1 then
		com = function()
			return tm.trackedRotate(dir.EAST) and turtle.forward()
		end
		add = vector.new(1, 0, 0)
	end

	local success = com()

	if success then
		tm.pos = tm.pos + add
	end

	print("Moved to " .. tm.pos.x .. " " .. tm.pos.y .. " " .. tm.pos.z)

	return success
end

---@param block table
---@return boolean success, boolean has_block, table | string blockinfo
function tm.inspect(block)
	local com

	if block.y == -1 then
		com = turtle.inspectDown
	elseif block.y == 1 then
		com = turtle.inspectUp
	elseif block.z == -1 then
		com = function()
			if tm.trackedRotate(dir.NORTH) then
				return turtle.inspect()
			else
				return false, "Failed to rotate"
			end
		end
	elseif block.z == 1 then
		com = function()
			if tm.trackedRotate(dir.SOUTH) then
				return turtle.inspect()
			else
				return false, "Failed to rotate"
			end
		end
	elseif block.x == 1 then
		com = function()
			if tm.trackedRotate(dir.WEST) then
				return turtle.inspect()
			else
				return false, "Failed to rotate"
			end
		end
	elseif block.x == -1 then
		com = function()
			if tm.trackedRotate(dir.EAST) then
				return turtle.inspect()
			else
				return false, "Failed to rotate"
			end
		end
	end

	return true, com()
end

---@param block table
---@return boolean success
function tm.dig(block)
	local com

	if block.y == -1 then
		com = turtle.digDown()
	elseif block.y == 1 then
		com = turtle.digUp()
	elseif block.z == -1 then
		com = function()
			local rs = tm.trackedRotate(dir.NORTH)

			if rs then
				return turtle.dig()
			else
				return false, "Failed turn"
			end
		end
	elseif block.z == 1 then
		com = function()
			local rs = tm.trackedRotate(dir.SOUTH)

			if rs then
				return turtle.dig()
			else
				return false, "Failed turn"
			end
		end
	elseif block.x == -1 then
		com = function()
			local rs = tm.trackedRotate(dir.WEST)

			if rs then
				return turtle.dig()
			else
				return false, "Failed turn"
			end
		end
	elseif block.x == 1 then
		com = function()
			local rs = tm.trackedRotate(dir.EAST)

			if rs then
				return turtle.dig()
			else
				return false, "Failed turn"
			end
		end
	end

	return com()
end

---@param amt integer
function tm.loopedRotate(amt)
	tm.dir = tm.dir + amt

	while tm.dir < 1 do
		tm.dir = tm.dir + 4
	end

	while tm.dir > 4 do
		tm.dir = tm.dir - 4
	end
end

---@param to integer
function tm.trackedRotate(to)
	if to < tm.dir then
		to = to + 4
	end

	local turnAmt = to - tm.dir
	if turnAmt > 2 then
		turnAmt = turnAmt - 4
	end

	while turnAmt > 0 do
		local success = turtle.turnLeft()

		if success then
			turnAmt = turnAmt - 1
			tm.loopedRotate(-1)
		else
			return false
		end
	end

	while turnAmt < 0 do
		local success = turtle.turnRight()

		if success then
			turnAmt = turnAmt + 1
			tm.loopedRotate(1)
		else
			return false
		end
	end

	return true
end

return tm
