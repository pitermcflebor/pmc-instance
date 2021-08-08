local GERB = assert(GetEntityRoutingBucket)
local GPRB = assert(GetPlayerRoutingBucket)
local SERB = assert(SetEntityRoutingBucket)
local SPRB = assert(SetPlayerRoutingBucket)

_G.Instances = {}

_G.U = {
	isDebugEnabled = (GetResourceMetadata(GetCurrentResourceName(), 'debug_log') == 'yes'),
	debugFormatted = GetResourceMetadata(GetCurrentResourceName(), 'debug_message') or '[INSTANCE] Player %s entered instance %s'
}
setmetatable(U, {
	__index = {
		DebugMessage = function(self, _s, _in)
			if self.isDebugEnabled then
				print(self.debugFormatted:format(_s, _in))
			end
		end,
		Ensure = function(self, o, t)
			assert(type(o) == t, 'invalid Lua type, expected '..t..', got '..type(o))
			return true
		end,
		EnsureInstance = function(self, _in)
			self:Ensure(_in, 'number')
			if Instances[_in] == nil then
				Instances[_in] = {
					players = {},
					entities = {}
				}
			elseif Instances[_in].players == nil then
				Instances[_in].players = {}
			elseif Instances[_in].entities == nil then
				Instances[_in].entities = {}
			end
			return true
		end,
		EnsureAddPlayer = function(self, _in, _s)
			if self:Ensure(_in, 'number') and self:Ensure(_s, 'number') then
				if self:EnsureInstance(_in) then
					if GPRB(_s) == 0 then
						table.insert(Instances[_in].players, _s)
						SPRB(_s, _in)
						self:DebugMessage(_s, _in)
					else
						self:EnsureChangePlayer(_in, _s, true)
					end
				end
			end
		end,
		EnsureRemovePlayer = function(self, _in, _s)
			if self:Ensure(_s, 'number') then
				self:EnsureChangePlayer(_in, _s)
			end
		end,
		EnsureChangePlayer = function(self, _in, _s, _shouldAdd)
			if self:Ensure(_in, 'number') and self:Ensure(_s, 'number') then
				local _c_in = GPRB(_s)

				if self:EnsureInstance(_in) and self:EnsureInstance(_c_in) then
					if _c_in ~= 0 then
						if _shouldAdd then
							Instances[_in].players[#Instances[_in].players + 1] =_s
						else
							for _i, _v in ipairs(Instances[_in].players) do
								if _v == _s then
									Instances[_in].players[_i] = nil
									break
								end
							end
						end

						_in = _shouldAdd and _in or 0
						
						SPRB(_s, _in)
						self:DebugMessage(_s, _in)
					end
				end
			end
		end,
	}
})

AddEventHandler('__instance_internal:instance:player:add', function(...) U:EnsureAddPlayer(...) end)
AddEventHandler('__instance_internal:instance:player:remove', function(...) U:EnsureRemovePlayer(...) end)
AddEventHandler('__instance_internal:instance:players:get', function(inIndex, cb)
	if U:Ensure(inIndex, 'number') then
		if U:EnsureInstance(inIndex) then
			cb(Instances[inIndex].players)
		end
	end
end)
