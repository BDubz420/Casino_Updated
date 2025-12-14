function CasinoKit.simpleTimer(delay, fn)
local randomId = "casinokit_simpletimer_" .. CurTime() .. "_" .. CasinoKit.rand.Int(0, 999999)
	timer.Create(randomId, delay, 1, fn)
	return {
		stop = function(_)
			timer.Remove(randomId)
		end,
		callNow = function(self)
			fn()
			self:stop()
		end,
	}
end
