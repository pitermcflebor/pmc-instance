
# PMC-INSTANCE

## Installation [EN]
- Download the latest release
- Unzip the file and add the `pmc-instance` to your resources folder
- Add `ensure pmc-instance` to your .cfg file

## Usage [EN]
**This is a server-side only script**
- Add to your fxmanifest `server_script '@pmc-instance/instance.lua'`
- Optional: add `dependency 'pmc-instance'` to your script (*probably client-side will crash because there isn't any dependency client-side for `pmc-instance`*)

## Instalación [ES]
- Descarga la última versión
- Descomprime el archivo y añade `pmc-instance` a tu carpeta resources
- Añade `ensure pmc-instance` a tu archivo .cfg

## Uso [ES]
- Añade a tu fxmanifest `server_script '@pmc-instance/instance.lua'`
- Opcional: añade `dependency 'pmc-instance'` a tu script (*probablemente no funciona en cliente porque la dependencia no existe*)

---
### Methods / Métodos
| function     | parameter           | return          |
|--------------|---------------------|-----------------|
| instance.new | index `number` 0-63 | `nil`           |
| :addPlayer   | source `number`     | `nil`           |
| :removePlayer| source `number`     | `nil`           |
| :getPlayers  | none                | `table` sources |

### Example / Ejemplo
#### client-side
```lua
RegisterCommand('enter_race', function()
	TriggerServerEvent('race:enter')
end)

RegisterCommand('leave_race', function()
	TriggerServerEvent('race:leave')
end)
```
#### server-side
```lua
local raceInstance = instance.new(1)
RegisterNetEvent('race:enter')
AddEventHandler('race:enter', function()
	local source = tonumber(source)
	raceInstance:addPlayer(source)
end)

RegisterNetEvent('race:leave')
AddEventHandler('race:leave', function()
	local source = tonumber(source)
	raceInstance:removePlayer(source)
end)

RegisterCommand('race_players', function()
	print(raceInstance:getPlayers())
	-- output: [1,23,12,45...]
	-- source array
end)
```