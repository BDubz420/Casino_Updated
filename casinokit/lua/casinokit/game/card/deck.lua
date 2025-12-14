local Deck = CasinoKit.class("Deck")

function Deck:initialize()
	Deck.super.initialize(self)

	self.cardStack = {}

	self:addCards()
end

-- Add all cards
function Deck:addCards()
	for _,suit in pairs(CasinoKit.classes.Suit.valueList) do
		for _,rank in pairs(CasinoKit.classes.Rank.valueList) do
			local card = CasinoKit.classes.Card(suit, rank)
			table.insert(self.cardStack, card)
		end
	end
end

-- https://coronalabs.com/blog/2014/09/30/tutorial-how-to-shuffle-table-items/
function Deck:shuffle()
	local t = self.cardStack

    local iterations = #t

    for i = iterations, 2, -1 do
            -- Use deterministic integer selection to avoid invalid 0-index swaps that could drop cards.
            local j = CasinoKit.rand.Int(1, i)

            t[i], t[j] = t[j], t[i]
    end
end

function Deck:pop()
	return table.remove(self.cardStack, #self.cardStack)
end

function Deck:getCardCount()
	return #self.cardStack
end
