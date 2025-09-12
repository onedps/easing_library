local easing_lib = {}
easing_lib.__index = easing_lib

-- все методы взяты с easings.net 
local bounce_out = function(t)
	if t < 1 / 2.75 then return 7.5625 * t * t
	elseif t < 2 / 2.75 then t = t - 1.5 / 2.75 return 7.5625 * t * t + 0.75
	elseif t < 2.5 / 2.75 then t = t - 2.25 / 2.75 return 7.5625 * t * t + 0.9375
	else t = t - 2.625 / 2.75 return 7.5625 * t * t + 0.984375 end
end
local bounce_in = function(t)
	return 1 - bounce_out(1 - t)
end

local easing_methods = {
	linear = function(t)
		return t
	end,
	quad_in = function(t)
		return t * t
	end,
	quad_out = function(t)
		return t * (2 - t)
	end,
	quad_in_out = function(t)
		return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
	end,
	cubic_in = function(t)
		return t * t * t
	end,
	cubic_out = function(t)
		t = t - 1
		return t * t * t + 1
	end,
	cubic_in_out = function(t)
		return t < 0.5 and 4 * t * t * t or (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
	end,
	quart_in = function(t)
		return t * t * t * t
	end,
	quart_out = function(t)
		t = t - 1
		return 1 - t * t * t * t
	end,
	quart_in_out = function(t)
		return t < 0.5 and 8 * t * t * t * t or 1 - 8 * (t - 1) * (t - 1) * (t - 1) * (t - 1)
	end,
	quint_in = function(t)
		return t * t * t * t * t
	end,
	quint_out = function(t)
		t = t - 1
		return t * t * t * t * t + 1
	end,
	quint_in_out = function(t)
		return t < 0.5 and 16 * t * t * t * t * t or 1 + 16 * (t - 1) * (t - 1) * (t - 1) * (t - 1) * (t - 1)
	end,
	sine_in = function(t)
		return 1 - math.cos(t * math.pi / 2)
	end,
	sine_out = function(t)
		return math.sin(t * math.pi / 2)
	end,
	sine_in_out = function(t)
		return -0.5 * (math.cos(math.pi * t) - 1)
	end,
	expo_in = function(t)
		return t == 0 and 0 or 2 ^ (10 * (t - 1))
	end,
	expo_out = function(t)
		return t == 1 and 1 or 1 - 2 ^ (-10 * t)
	end,
	expo_in_out = function(t)
		if t == 0 then return 0 end
		if t == 1 then return 1 end
		t = t * 2
		return t < 1 and 0.5 * 2 ^ (10 * (t - 1)) or 0.5 * (2 - 2 ^ (-10 * (t - 1)))
	end,
	circ_in = function(t)
		return 1 - math.sqrt(1 - t * t)
	end,
	circ_out = function(t)
		t = t - 1
		return math.sqrt(1 - t * t)
	end,
	circ_in_out = function(t)
		t = t * 2
		return t < 1 and -0.5 * (math.sqrt(1 - t * t) - 1) or 0.5 * (math.sqrt(1 - (t - 2) * (t - 2)) + 1)
	end,
	back_in = function(t)
		local s = 1.70158
		return t * t * ((s + 1) * t - s)
	end,
	back_out = function(t)
		t = t - 1
		local s = 1.70158
		return t * t * ((s + 1) * t + s) + 1
	end,
	back_in_out = function(t)
		t = t * 2
		local s = 1.70158 * 1.525
		return t < 1 and 0.5 * (t * t * ((s + 1) * t - s)) or 0.5 * ((t - 2) * (t - 2) * ((s + 1) * (t - 2) + s) + 2)
	end,
	elastic_in = function(t)
		return t == 0 and 0 or t == 1 and 1 or -2 ^ (10 * (t - 1)) * math.sin((t - 1.1) * 5 * math.pi)
	end,
	elastic_out = function(t)
		return t == 0 and 0 or t == 1 and 1 or 2 ^ (-10 * t) * math.sin((t - 0.1) * 5 * math.pi) + 1
	end,
	elastic_in_out = function(t)
		if t == 0 then return 0 end
		if t == 1 then return 1 end
		t = t * 2
		return t < 1 and -0.5 * 2 ^ (10 * (t - 1)) * math.sin((t - 1.1) * 5 * math.pi) or 0.5 * 2 ^ (-10 * (t - 1)) * math.sin((t - 1.1) * 5 * math.pi) + 1
	end,
	bounce_out = bounce_out,
	bounce_in = bounce_in,
	bounce_in_out = function( t)
		return t < 0.5 and bounce_in(t * 2) * 0.5 or bounce_out(t * 2 - 1) * 0.5 + 0.5 
	end,
}

local easing_types = {
	number = function(a, b, t) return a + (b - a) * t end,
	UDim2 = function(a, b, t)
		return UDim2.new(
			a.X.Scale + (b.X.Scale - a.X.Scale) * t,
			a.X.Offset + (b.X.Offset - a.X.Offset) * t,
			a.Y.Scale + (b.Y.Scale - a.Y.Scale) * t,
			a.Y.Offset + (b.Y.Offset - a.Y.Offset) * t
		)
	end,
	Color3 = function(a, b, t) return a:lerp(b, t) end,
	Vector3 = function(a, b, t) return a:Lerp(b, t) end,
	Vector2 = function(a, b, t) return a:Lerp(b, t) end,
	CFrame = function(a, b, t) return a:Lerp(b, t) end
}

function easing_lib.new(object)
	return setmetatable({Object = object, active_easings = {}}, easing_lib)
end

function easing_lib:animate(property, target, speed, easing, callback)
	local start_value = self.Object[property]
	local value_type = typeof(start_value)
	local interpolate = easing_types[value_type]

	if not interpolate then
		warn("Unsupported type: " .. value_type)
		if callback then callback() end
		return
	end
	
	local ease = easing_methods[easing] or easing_methods.linear
	local start_time = tick()
	local easing_id = #self.active_easings + 1

	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function()
		local progress = math.min((tick() - start_time) / speed, 1)
		local eased = ease(progress)

		self.Object[property] = interpolate(start_value, target, eased)

		if progress >= 1 then
			connection:Disconnect()
			self.active_easings[easing_id] = nil
			if callback then callback() end
		end
	end)

	self.active_easings[easing_id] = connection
	return easing_id
end


function easing_lib:cancel(easing_id)
	if self.active_easings[easing_id] then
		self.active_easings[easing_id]:Disconnect()
		self.active_easings[easing_id] = nil
	end
end

function easing_lib:cancel_all()
	for _, connection in pairs(self.active_easings) do
		connection:Disconnect()
	end
	self.active_easings = {}
end

return easing_lib
