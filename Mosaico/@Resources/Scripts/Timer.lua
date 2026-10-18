-- Cronometro regressivo: publica TimerText (hh:mm:ss) e TimerFrac (0..1 restante)

function Initialize()
	total = (tonumber(SKIN:GetVariable('TimerMinutes')) or 3) * 60
	left = total
	running = false
	publish()
end

function publish()
	local h = math.floor(left / 3600)
	local m = math.floor(left % 3600 / 60)
	local s = left % 60
	SKIN:Bang('!SetVariable', 'TimerText', string.format('%02d:%02d:%02d', h, m, s))
	SKIN:Bang('!SetVariable', 'TimerFrac', string.format('%.4f', total > 0 and left / total or 0))
	SKIN:Bang('!SetVariable', 'TimerRunning', running and '1' or '0')
end

function Update()
	if running and left > 0 then
		left = left - 1
		if left == 0 then
			running = false
			SKIN:Bang('!Play', (os.getenv('WINDIR') or 'C:\\Windows') .. '\\Media\\Alarm01.wav')
		end
		publish()
	end
	return left
end

function Toggle()
	if left == 0 then left = total end
	running = not running
	publish()
end

function Reset()
	running = false
	left = total
	publish()
end

function Add(seconds)
	if running then return end
	total = math.max(60, total + seconds)
	left = total
	publish()
end
