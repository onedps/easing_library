--!native
--!optimize 2

local run_service = game:GetService("RunService")

local cos = math.cos
local pi = math.pi
local sin = math.sin
local sqrt = math.sqrt

local easing_lib = {}
easing_lib.__index = easing_lib

local bounce_out = function(t: number): number
	if t < 1 / 2.75 then return 7.5625 * t * t
	elseif t < 2 / 2.75 then t = t - 1.5 / 2.75 return 7.5625 * t * t + .75
	elseif t < 2.5 / 2.75 then t = t - 2.25 / 2.75 return 7.5625 * t * t + .9375
	else t = t - 2.625 / 2.75 return 7.5625 * t * t + .984375 end
end

local bounce_in = function(t: number): number
	return 1 - bounce_out(1 - t)
end

local methods = {
	Linear = {
		In = function(t: number): number
			return t
		end,
		Out = function(t: number): number
			return t
		end,
		Inout = function(t: number): number
			return t
		end,
	},
	
	Quad = {
		In = function(t: number): number
			return t * t
		end,
		Out = function(t: number): number
			return t * (2 - t)
		end,
		Inout = function(t: number): number
			return t < .5 and 2 * t * t or -1 + (4 - 2 * t) * t
		end,
	},
	
	Cubic = {
		In = function(t: number): number
			return t * t * t
		end,
		Out = function(t: number): number
			t = t - 1
			return t * t * t + 1
		end,
		Inout = function(t: number): number
			return t < .5 and 4 * t ^3 or (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
		end,
	},
	
	Quart = {
		In = function(t: number): number
			return t * t * t * t
		end,
		Out = function(t: number): number
			t = t - 1
			return 1 - t * t * t * t
		end,
		Inout = function(t: number): number
			return t < .5 and 8 * t * t * t * t or 1 - 8 * (t - 1) * (t - 1) * (t - 1) * (t - 1)
		end,	
	},
	
	Quint = {
		In = function(t: number): number
			return t * t * t * t * t
		end,
		Out = function(t: number): number
			t = t - 1
			return t * t * t * t * t + 1
		end,
		Inout = function(t: number): number
			return t < .5 and 16 * t * t * t * t * t or 1 + 16 * (t - 1) * (t - 1) * (t - 1) * (t - 1) * (t - 1)
		end,	
	},
	
	Sine = {
		In = function(t: number): number
			return 1 - cos(t * pi / 2)
		end,
		Out = function(t: number): number
			return sin(t * pi / 2)
		end,
		Inout = function(t: number): number
			return -.5 * (cos(pi * t) - 1)
		end,	
	},
	
	Expo = {
		In = function(t: number): number
			return t == 0 and 0 or 2 ^ (10 * (t - 1))
		end,
		Out = function(t: number): number
			return t == 1 and 1 or 1 - 2 ^ (-10 * t)
		end,
		Inout = function(t: number): number
			if t == 0 then return 0 end
			if t == 1 then return 1 end
			t = t * 2
			return t < 1 and .5 * 2 ^ (10 * (t - 1)) or .5 * (2 - 2 ^ (-10 * (t - 1)))
		end,	
	},
	
	Circ = {
		In = function(t: number): number
			return 1 - sqrt(1 - t * t)
		end,
		Out = function(t: number): number
			t = t - 1
			return sqrt(1 - t * t)
		end,
		Inout = function(t: number): number
			t = t * 2
			return t < 1 and -.5 * (sqrt(1 - t * t) - 1) or .5 * (sqrt(1 - (t - 2) * (t - 2)) + 1)
		end,	
	},
	
	Back = {
		In = function(t: number): number
			local s = 1.70158
			return t * t * ((s + 1) * t - s)
		end,
		Out = function(t: number): number
			t = t - 1
			local s = 1.70158
			return t * t * ((s + 1) * t + s) + 1
		end,
		Inout = function(t: number): number
			t = t * 2
			local s = 1.70158 * 1.525
			return t < 1 and .5 * (t * t * ((s + 1) * t - s)) or .5 * ((t - 2) * (t - 2) * ((s + 1) * (t - 2) + s) + 2)
		end,
	},
	
	Elastic = {
		In = function(t: number): number
			return t == 0 and 0 or t == 1 and 1 or -2 ^ (10 * (t - 1)) * sin((t - 1.1) * 5 * pi)
		end,
		Out = function(t: number): number
			return t == 0 and 0 or t == 1 and 1 or 2 ^ (-10 * t) * sin((t - .1) * 5 * pi) + 1
		end,
		Inout = function(t: number): number
			if t == 0 then return 0 end
			if t == 1 then return 1 end
			t = t * 2
			return t < 1 and -.5 * 2 ^ (10 * (t - 1)) * sin((t - 1.1) * 5 * pi) or .5 * 2 ^ (-10 * (t - 1)) * sin((t - 1.1) * 5 * pi) + 1
		end,	
	},
	
	Bounce = {
		In = bounce_in,
		Out = bounce_out,
		Inout = function(t: number): number
			return t < .5 and bounce_in(t * 2) * .5 or bounce_out(t * 2 - 1) * .5 + .5 
		end,
	},
}

export type method = "Linear" | "Quad" | "Cubic" | "Quart" | "Quint" | "Sine" | "Expo" | "Circ" | "Back" | "Elastic" | "Bounce"
export type direction = "In" | "Out" | "In out"
export type target_type = Vector3 | Color3 | ColorSequence | CFrame | UDim2 | number | Vector2

local types
types = {
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
		for k,v in a.Keypoints do
			local a_key = v
			local b_key = b.Keypoints[k]
			
			local time = types.number(a_key.Time, b_key.Time, t)
			local color = a_key.Value:Lerp(b_key.Value, t)

			table.insert(keypoints, ColorSequenceKeypoint.new(time, color))
		end

		return ColorSequence.new(keypoints)
	end,
}

local active_easings = {}

easing_lib.animate = function(object: Object, target: {target_type}, time: number, easing: {method: method, direction: direction}, callback: () -> ()?)
	local direction = easing.direction:gsub(" ", "") or "In"
	local ease = methods[easing.method][direction] or methods.Linear.In
	local anim_id = #active_easings + 1
	local progress = 0

	local connection
	connection = run_service.PreSimulation:Connect(function(dt)
		if progress >= 1 then
			connection:Disconnect()
			connection = nil
			if active_easings[anim_id] then active_easings[anim_id] = nil end
			if callback then callback() end
			return
		end
		
		progress += math.clamp(dt / time, 0, 1)
	
		for k,v in target do
			if object[k] then
				local prop_type = type(object[k])
				object[k] = types[prop_type](object[k], v, ease(progress))
			end
		end
	end)

	active_easings[anim_id] = connection

	return setmetatable({id = anim_id}, easing_lib)
end

easing_lib.cancel = function(self)
	if active_easings[self.id] then
		active_easings[self.id]:Disconnect()
		active_easings[self.id] = nil
	end
end

easing_lib.cancel_all = function()
	for _, connects in active_easings do
		connects:Disconnect()
		connects = nil
	end

	active_easings = {}
end

return easing_lib
