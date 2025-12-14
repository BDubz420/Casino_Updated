--
-- Legacy binary RNG modules (cryptrandom) were removed to avoid optional native dependencies.
-- This module now provides a util.SharedRandom-based source with optional per-player seeding.
--

CasinoKit.rand = {}

local baseSeed = tonumber(util.CRC(tostring(os.time()) .. tostring(SysTime()) .. tostring({})))
local globalSequence = 0

local function nextSeed(offset)
        globalSequence = globalSequence + 1
        return baseSeed + globalSequence + (offset or 0)
end

local function normalizeBounds(min, max)
        min = math.floor(min or 0)
        max = math.floor(max ~= nil and max or min)

        if max < min then
                min, max = max, min
        end

        return min, max
end

function CasinoKit.rand.random()
        return util.SharedRandom("CasinoKit.GlobalRNG", 0, 1, nextSeed())
end

function CasinoKit.rand.Int(min, max)
        min, max = normalizeBounds(min, max)
        return math.floor(util.SharedRandom("CasinoKit.GlobalRNGInt", min, max + 1 - 1e-6, nextSeed()))
end

function CasinoKit.rand.Float(min, max)
        min, max = min or 0, max or 1

        if max < min then
                min, max = max, min
        end

        return util.SharedRandom("CasinoKit.GlobalRNGFloat", min, max, nextSeed())
end

function CasinoKit.rand.PlayerGenerator(ply)
        local steamSeed = 0
        if IsValid(ply) and ply.SteamID64 then
                steamSeed = tonumber(util.CRC(ply:SteamID64())) or 0
        end

        local sequence = 0

        return function(min, max)
                sequence = sequence + 1

                min, max = min or 0, max or 1
                if max < min then
                        min, max = max, min
                end

                local seed = nextSeed(steamSeed + sequence)
                return util.SharedRandom("CasinoKit.PlayerRNG", min, max, seed)
        end
end

MsgN("[CasinoKit] Using util.SharedRandom-based RNG; cryptrandom support removed.")
