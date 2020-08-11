--[[
	Retry.lua
	Copyright 2020 va1kio
	
	==============================================================================================================
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
	and associated documentation files (the "Software"), to deal in the Software without restriction, 
	including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
	and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
	subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions
	of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
	LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
	OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	==============================================================================================================
	
	About Retry
	
	Retry is an utility for running scripts that requires network connections (such as, HTTPs, API, etc), when using Retry
	Retry itself will attempt to try running the function which is wrapped in a pcall, and if it failed, it will keep retrying
	until it has reached the RetryLimit (Default is 3)
	
	To avoid issue like too much requests, Retry will wait for an interval per retry.
	
	So, why Retry?
	DataStoreService has a property called AutomaticRetry, which will automatically retry when failed. However,
	DataStores do not respect this property  because automatic retry has been disabled due to technical reasons. 
	Therefore, you must implement systems for retrying operations yourself.
	
	I've created this module for beginners, since they might not know about this, for developers, you can implement
	a system for retrying operation, rather than using this one, but it's all up to you.
	
	
	REFERENCE:
	
	function Retry:Try(function Callback)
	// Start trying a function, and will retry if failed.
--]]

local module = {}
module.RetryLimit = 3 -- Retry limit, setting to math.huge will yield the script, and is not recommended, the maximum should be 10.
module.IntervalPerRetry = 5 -- Cooldown per retry, I highly don't recommend setting this to 0, this can potentially crash your instance, as the while loop below

function module:Try(Callback)
	local Tries = 1
	local Success, Result = pcall(Callback)
	while not Success and Tries <= module.RetryLimit do
		Success, Result = pcall(Callback)
		Tries += 1
		wait(module.IntervalPerRetry)
	end
	if not Success then
		error("An error occured when attempting to try : " .. tostring(Result))
	else
		return Success, Result
	end
end

return module