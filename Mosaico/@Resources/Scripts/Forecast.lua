-- Previsao de 6 dias: le os vetores de maxima/minima do Open-Meteo e publica
-- F<i>Name, F<i>Max, F<i>Min e F<i>A/F<i>B (inicio/fim da barra, 0..1) para i = 1..6.

local DAYS = 6

function Initialize()
end

local function numbers(name)
	local list = {}
	local m = SKIN:GetMeasure(name)
	if not m then return list end
	for v in string.gmatch(m:GetStringValue(), '[-%d%.]+') do
		table.insert(list, tonumber(v))
	end
	return list
end

function Update()
	local maxs, mins = numbers('MeasureFMax'), numbers('MeasureFMin')
	if #maxs < DAYS or #mins < DAYS then return 0 end
	local lo, hi = math.huge, -math.huge
	for i = 1, DAYS do
		lo = math.min(lo, mins[i])
		hi = math.max(hi, maxs[i])
	end
	local span = math.max(hi - lo, 1)
	local t = os.date('*t')
	for i = 1, DAYS do
		local wd = (t.wday - 1 + i - 1) % 7
		local name = i == 1 and 'hoje' or SKIN:GetVariable('DN' .. wd)
		SKIN:Bang('!SetVariable', 'F' .. i .. 'Name', name)
		SKIN:Bang('!SetVariable', 'F' .. i .. 'Max', string.format('%d', math.floor(maxs[i] + 0.5)))
		SKIN:Bang('!SetVariable', 'F' .. i .. 'Min', string.format('%d', math.floor(mins[i] + 0.5)))
		SKIN:Bang('!SetVariable', 'F' .. i .. 'A', string.format('%.3f', (mins[i] - lo) / span))
		SKIN:Bang('!SetVariable', 'F' .. i .. 'B', string.format('%.3f', (maxs[i] - lo) / span))
	end
	return 1
end
