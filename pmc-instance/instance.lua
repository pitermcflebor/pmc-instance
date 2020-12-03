
_G._INSTANCE_INTERNAL = {
	SourceExists = function(source)
		assert(source > 0, 'invalid source')
		local ping = GetPlayerPing(source)
		if ping ~= nil and type(ping) == 'number' and ping > 1 then
			return true
		end
	end,
	InstanceExists = function(index)
		if index > 0 and index < 64 then
			return true
		end
		return false
	end,
}
_G.instance = {}
_G.instanceMeta = {}

instanceMeta.__call = function(self) error'instance object is not callable!' end
instanceMeta.__newindex = function(self) error'cannot create new index on instance!' end
instanceMeta.__index = {
	new = function(instanceIndex)
		if _INSTANCE_INTERNAL.InstanceExists(instanceIndex) then
			return setmetatable({instanceIndex = instanceIndex}, {
				__call = function(self) error'instance object is not callable' end,
				__newindex = function(self) error'cannot create new index on instance object' end,
				__index = function(self, index)
					if index == 'addPlayer' then
						return function(self, source)
							assert(type(source) == 'number', 'invalid Lua type in argument #1, got '..type(source))
							if _INSTANCE_INTERNAL.SourceExists(source) then
								TriggerEvent('__instance_internal:instance:player:add', self.instanceIndex, source)
							end
						end
					elseif index == 'removePlayer' then
						return function(self, source)
							assert(type(source) == 'number', 'invalid Lua type in argument #1, got '..type(source))
							if _INSTANCE_INTERNAL.SourceExists(source) then
								TriggerEvent('__instance_internal:instance:player:remove', source)
							end
						end
					elseif index == 'getPlayers' then
						return function(self)
							local p = promise:new()
							TriggerEvent('__instance_internal:instance:players:get', self.instanceIndex, function(players) p:resolve(players) end)
							return Citizen.Await(p)
						end
					end
				end
			})
		else
			print('[tl-instance] Tried to set an invalid instance (0-63)')
		end
	end,
}

setmetatable(instance, instanceMeta)
