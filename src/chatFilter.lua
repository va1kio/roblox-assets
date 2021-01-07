-- Scam messages filter
-- license: MIT
-- author: @nana_kon

local module = {}
local Players = game:GetService("Players")
local sensitiveWords = {
	"robux reward",
	"earn robux",
	"want lots of robux",
	"in your browser",
	"made tons of robux"
}

function module.process(client, object, channel)
	local message = string.lower(string.gsub(object.Message, "‍", ""))
	local sensitiveWordsFound = false
	client = Players:FindFirstChild(client)
	
	for i,v in pairs(sensitiveWords) do
		if message:find(v) then
			sensitiveWordsFound = true
		end
	end
	
	if sensitiveWordsFound then
		-- just finding the sensitive words are not enough
		-- in this section, we'll figure out whether the message contains the link or not
		-- this isn't very accurate considering we are using taking a bold guess
		-- thinking all the links must be suspicious when sensitiveWordsFound are true, rather than actually reading the domain name
		-- but the chance of inaccurate filter result are pretty low with this design -- @nana_kon
		
		if string.match(message, "%S+%.%S+") then
			-- for those who do not understand string patterns,
			-- %S means any characters without that/those character, and s is whitespace/space
			-- + %. is basically "."
			
			object.Message = "[Content Deleted]" -- too lazy to do the hashtag lolol
		end
	end
end

return function(ChatService)
	if not ChatService then
		return module
	end

	ChatService:RegisterFilterMessageFunction("scam-filter", module.process)
end
