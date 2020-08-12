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
	
	function Retry:Try(function Callback, int RetryLimit, number Interval)
	// Start trying a function, and will retry if failed.
	
	function Retry:Create(function Callback, int RetryLimit, number Interval)
	// Creates a RetryObject
	
	function RetryObject:Run()
	// Runs the callback given, and will retry if failed, state will set to Running, Retrying, Aborted, Success depending on the siutation.
	
	function RetryObject:Stop()
	// Stops operation and set State to Stopped.
	
	number RetryObject.Tries
	// Tries
	
	string RetryObject.State
	// The current state of RetryObject, can be Stopped, Running, Retrying, Aborted or Success.
	
	number RetryObject.RetryLimit
	// Maximum retry limit, default is 3 if not given.
	
	int RetryObject.Interval
	// Cooldown per retry, default is 5 if not given.
	
	function RetryObject.Callback
	// Callback used for RetryObject:Run()
--]]

local module = {}
module.RetryLimit = 3 -- Retry limit, setting to math.huge will yield the script, and is not recommended, the maximum should be 10.
module.IntervalPerRetry = 5 -- Cooldown per retry, I highly don't recommend setting this to 0, this can potentially crash your instance, as the while loop below

function module:Try(Callback, RetryLimit, Interval)
	local Tries = 1
	local Success, Result = pcall(Callback)
	while not Success and Tries <= (RetryLimit or module.RetryLimit) do
		Success, Result = pcall(Callback)
		Tries += 1
		wait(Interval or module.IntervalPerRetry)
	end
	if not Success then
		error("An error occured when attempting to try : " .. tostring(Result))
	else
		return Success, Result
	end
end

function module:Create(Callback, RetryLimit, Interval)
	local Table = {}
	Table.Tries = 1
	Table.State = "Stopped"
	Table.RetryLimit = RetryLimit or module.RetryLimit
	Table.Interval = Interval or module.IntervalPerRetry
	Table.Callback = Callback
	
	function Table:Run()
		Table.State = "Running"
		local Status, Result = pcall(Table.Callback)
		while not Status and Table.Tries <= Table.RetryLimit and Table.State == "Running" do
			Table.State = "Retrying"
			Status, Result = pcall(Table.Callback)
			Table.Tries += 1
			wait(Table.Interval)
		end
		
		if not Status then
			Table.State = "Aborted"
		else
			Table.State = "Success"
			Table.Result = {Result}
		end
	end
	
	function Table:Stop()
		Table.State = "Stopped"
	end
	
	return Table
end

return module