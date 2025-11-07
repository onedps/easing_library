--!native
--!optimize 2

local run_service = game:GetService("RunService")

local easing_lib = {}
easing_lib.__index = easing_lib

local bounce_out = function(t: number): number
	if t < 1 / 2.75 then return 7.5625 * t * t
	elseif t < 2 / 2.75 then t = t - 1.5 / 2.75 return 7.5625 * t * t + 0.75
	elseif t < 2.5 / 2.75 then t = t - 2.25 / 2.75 return 7.5625 * t * t + 0.9375
	else t = t - 2.625 / 2.75 return 7.5625 * t * t + 0.984375 end
end

local bounce_in = function(t: number): number
	return 1 - bounce_out(1 - t)
end

local methods = {
	linear = function(t: number): number
		return t
	end,
	quad_in = function(t: number): number
		return t * t
	end,
	quad_out = function(t: number): number
		return t * (2 - t)
	end,
	quad_in_out = function(t: number): number
		return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
	end,
	cubic_in = function(t: number): number
		return t * t * t
	end,
	cubic_out = function(t: number): number
		t = t - 1
		return t * t * t + 1
	end,
	cubic_in_out = function(t: number): number
		return t < 0.5 and 4 * t ^3 or (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
	end,
	quart_in = function(t: number): number
		return t * t * t * t
	end,
	quart_out = function(t: number): number
		t = t - 1
		return 1 - t * t * t * t
	end,
	quart_in_out = function(t: number): number
		return t < 0.5 and 8 * t * t * t * t or 1 - 8 * (t - 1) * (t - 1) * (t - 1) * (t - 1)
	end,
	quint_in = function(t: number): number
		return t * t * t * t * t
	end,
	quint_out = function(t: number): number
		t = t - 1
		return t * t * t * t * t + 1
	end,
	quint_in_out = function(t: number): number
		return t < 0.5 and 16 * t * t * t * t * t or 1 + 16 * (t - 1) * (t - 1) * (t - 1) * (t - 1) * (t - 1)
	end,
	sine_in = function(t: number): number
		return 1 - math.cos(t * math.pi / 2)
	end,
	sine_out = function(t: number): number
		return math.sin(t * math.pi / 2)
	end,
	sine_in_out = function(t: number): number
		return -0.5 * (math.cos(math.pi * t) - 1)
	end,
	expo_in = function(t: number): number
		return t == 0 and 0 or 2 ^ (10 * (t - 1))
	end,
	expo_out = function(t: number): number
		return t == 1 and 1 or 1 - 2 ^ (-10 * t)
	end,
	expo_in_out = function(t: number): number
		if t == 0 then return 0 end
		if t == 1 then return 1 end
		t = t * 2
		return t < 1 and 0.5 * 2 ^ (10 * (t - 1)) or 0.5 * (2 - 2 ^ (-10 * (t - 1)))
	end,
	circ_in = function(t: number): number
		return 1 - math.sqrt(1 - t * t)
	end,
	circ_out = function(t: number): number
		t = t - 1
		return math.sqrt(1 - t * t)
	end,
	circ_in_out = function(t: number): number
		t = t * 2
		return t < 1 and -0.5 * (math.sqrt(1 - t * t) - 1) or 0.5 * (math.sqrt(1 - (t - 2) * (t - 2)) + 1)
	end,
	back_in = function(t: number): number
		local s = 1.70158
		return t * t * ((s + 1) * t - s)
	end,
	back_out = function(t: number): number
		t = t - 1
		local s = 1.70158
		return t * t * ((s + 1) * t + s) + 1
	end,
	back_in_out = function(t: number): number
		t = t * 2
		local s = 1.70158 * 1.525
		return t < 1 and 0.5 * (t * t * ((s + 1) * t - s)) or 0.5 * ((t - 2) * (t - 2) * ((s + 1) * (t - 2) + s) + 2)
	end,
	elastic_in = function(t: number): number
		return t == 0 and 0 or t == 1 and 1 or -2 ^ (10 * (t - 1)) * math.sin((t - 1.1) * 5 * math.pi)
	end,
	elastic_out = function(t: number): number
		return t == 0 and 0 or t == 1 and 1 or 2 ^ (-10 * t) * math.sin((t - 0.1) * 5 * math.pi) + 1
	end,
	elastic_in_out = function(t: number): number
		if t == 0 then return 0 end
		if t == 1 then return 1 end
		t = t * 2
		return t < 1 and -0.5 * 2 ^ (10 * (t - 1)) * math.sin((t - 1.1) * 5 * math.pi) or 0.5 * 2 ^ (-10 * (t - 1)) * math.sin((t - 1.1) * 5 * math.pi) + 1
	end,
	bounce_out = bounce_out,
	bounce_in = bounce_in,
	bounce_in_out = function(t: number): number
		return t < 0.5 and bounce_in(t * 2) * 0.5 or bounce_out(t * 2 - 1) * 0.5 + 0.5 
	end,
}

export type ease_method = "linear" | "quad_in" | "quad_out" | "quad_in_out" | "cubic_in" | "cubic_out" | "cubic_in_out" | "quart_in" | "quart_out" | "quart_in_out" | "quint_in" | "quint_out" | "quint_in_out" | "sine_in" | "sine_out" | "sine_in_out" | "expo_in" | "expo_out" | "expo_in_out" | "circ_in" | "circ_out" | "circ_in_out" | "back_in" | "back_out" | "back_in_out" | "elastic_in" | "elastic_out" | "elastic_in_out" | "bounce_in" | "bounce_out" | "bounce_in_out"
export type target_type = Vector3 | Color3 | ColorSequence | CFrame | UDim2 | number | Vector2

local types = {
	number = function(a: number, b: number, t: number): number return a + (b - a) * t end,
	UDim2 = function(a: UDim2, b: UDim2, t: number): UDim2 return a:Lerp(b, t) end,
	Color3 = function(a: Color3, b: Color3, t: number): Color3 return a:Lerp(b, t) end,
	Vector3 = function(a: Vector3, b: Vector3, t: number): Vector3 return a:Lerp(b, t) end,
	Vector2 = function(a: Vector2, b: Vector2, t: number): Vector2 return a:Lerp(b, t) end,
	CFrame = function(a: CFrame, b: CFrame, t: number): CFrame return a:Lerp(b, t) end,
	ColorSequence = function(a: ColorSequence, b: ColorSequence, t: number): ColorSequence
		if #a.Keypoints ~= #b.Keypoints then
			error("ColorSequence must have the same number of keypoints")
		end

		local keypoints = {}
		for i = 1, #a.Keypoints do
			local a_keypoint = a.Keypoints[i]
			local b_keypoint = b.Keypoints[i]
			local time = a_keypoint.Time + (b_keypoint.Time - a_keypoint.Time) * t
			local color = a_keypoint.Value:Lerp(b_keypoint.Value, t)

			table.insert(keypoints, ColorSequenceKeypoint.new(time, color))
		end

		return ColorSequence.new(keypoints)
	end,
}

local active_easings = {}

function easing_lib.animate(object: Object, property: string, target: target_type, duration: number, easing: ease_method, callback: any)
	local start_value = object[property]
	local value_type = typeof(start_value)
	local interpolate = types[value_type]

	if not interpolate then
		warn("Unsupported type: " .. value_type)
		if callback then callback() end
		return
	end

	local ease = methods[easing] or methods.linear
	local anim_id = #active_easings + 1
	local progress = 0
	
	local connection
	connection = run_service.Heartbeat:Connect(function(dt)
		progress += math.clamp(dt / duration, 0, 1)

		if progress >= 1 then
			connection:Disconnect()
			connection = nil
			object[property] = target
			active_easings[anim_id] = nil
			if callback then callback() end
			return
		end

		object[property] = interpolate(start_value, target, ease(progress))
	end)

	active_easings[anim_id] = connection
	
	return setmetatable({id = anim_id}, easing_lib)
end

function easing_lib:cancel()
	if active_easings[self.id] then
		active_easings[self.id]:Disconnect()
		active_easings[self.id] = nil
	end
end

function easing_lib.cancel_all()
	for _, connects in pairs(active_easings) do
		connects:Disconnect()
		connects = nil
	end
	
	active_easings = {}
end

return easing_lib
