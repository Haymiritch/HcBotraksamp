-- Огромное спасибо: exportaccountdata, quesada, чоко мами (разбаньте его пж)

require("addon")
local sampev = require("samp.events")
local inicfg = require('inicfg')
local cfg = inicfg.load(nil, "hcbot")

local hcbot_start = false
local packets = 0

function onRunCommand(cmd)
	if cmd:find("^!key %d+$") then -- команда для эмуляции нажатий кнопок
        sendKey(tonumber(cmd:match("%d+")))
        return false
    end
	if cmd == "!hcbot" then -- для запуска бота
        hcbot_start = not hcbot_start
		if hcbot_start then printm("HcBot начал свою работу.") else printm("HcBot закончил свою работу.") end
		return false
    end	
	if cmd:find("^!hcbot offatspawn") then -- выключать ли курд при спавне
        cfg.settings.coord_ofatspawn = not cfg.settings.coord_ofatspawn
		if cfg.settings.coord_ofatspawn then
			printm("Если заспавнят - коордмастер остановится.")
		else
			printm("Если заспавнят - коордмастер НЕ остановится.")
		end
		return false
    end
	if cmd:find("^!hcbot timestep_onfoot %d+$") then -- настройка задержки тп с ног
        cfg.settings.timestep_onfoot = tonumber(cmd:match("%d+"))
		printm("Задержка между телепортом: " .. cfg.settings.timestep_onfoot .. " мс.")
        return false
    end
	if cmd:find("^!hcbot step_onfoot %d+$") then -- настройка шага тп с ног
        cfg.settings.step_onfoot = tonumber(cmd:match("%d+"))
		printm("Шаг телепорта: " .. cfg.settings.step_onfoot .. " метров.")
        return false
    end
	if cmd:find("^!hcbot timestep_incar %d+$") then -- настройка задержки тп с кара
        cfg.settings.timestep_incar = tonumber(cmd:match("%d+"))
		printm("Задержка между телепортом: " .. cfg.settings.timestep_incar .. " мс.")
        return false
    end
	if cmd:find("^!hcbot step_incar %d+$") then -- настройка шага тп с кара
        cfg.settings.step_incar = tonumber(cmd:match("%d+"))
		printm("Шаг телепорта: " .. cfg.settings.step_incar .. " метров.")
        return false
    end
	if cmd:find("^!hcbot visota %d+$") then -- настройка шага тп с кара
        cfg.settings.visota = tonumber(cmd:match("%d+"))
		printm("На сколько метров тепатся ниже: " .. cfg.settings.visota .. " м.")
        return false
    end
	if cmd:find("^!hcbot info") then -- для вывода информации
		printm("================ Настройки с ног ===============")
		printm("Задержка между телепортом: " .. cfg.settings.timestep_onfoot .. " мс.")
		printm("Шаг телепорта: " .. cfg.settings.step_onfoot .. " метров.")
		printm("================ Настройки с машины ===============")
		printm("Задержка между телепортом: " .. cfg.settings.timestep_incar .. " мс.")
		printm("Шаг телепорта: " .. cfg.settings.step_incar .. " метров.")
		printm("================ Прочие настройки ==============")
		printm("На сколько метров тепатся ниже: " .. cfg.settings.visota .. " м.")
		printm("Бот в машине: " .. tostring(getBotVehicle()).." (если 0 - не в машине, остальное это ид машины)")
		printm("Бот включен: " .. tostring(hcbot_start))
		printm("!hcbot save - сохранить настройки")
		printm(" * https://www.blast.hk/members/421795/")
        return false
    end
	if cmd:find("^!hcbot save") then -- для сохранения настроек
		inicfg.save(cfg, 'hcbot.ini')
		printm("Настройки успешно сохранены!")
        return false
    end
	if cmd:find("^!hcbot repare_old") then -- для возвращения настроек в прежнее состояние
		cfg.settings.coord_ofatspawn = "true"
		cfg.settings.timestep_onfoot = "40"
		cfg.settings.step_onfoot = "2"
		cfg.settings.timestep_incar = "50"
		cfg.settings.step_incar = "7"
		cfg.settings.visota = "10"
		inicfg.save(cfg, 'hcbot.ini')
		printm("Настройки успешно восстановлены!")
        return false
    end
	if cmd:find("^!hcbot help") then -- для вывода команд
		printm("!hcbot - включить чекпоинт бота")
		printm("!key айди - емулировать нажатие кнопки")
		printm("!hcbot save - сохранить настройки")
		printm("!hcbot repare_old - восстановить настройки как были")
		printm("!hcbot offatspawn - выключать ли тп если во время тп спавнят")
		printm("!hcbot timestep_onfoot мс - настройка задержки перед тп с ног")
		printm("!hcbot step_onfoot метры - настройка шага тп с ног")
		printm("!hcbot timestep_incar мс - настройка задержки перед тп с машины")
		printm("!hcbot step_incar метры - настройка шага тп с машины")
		printm("!hcbot info - вывести информацию об настройках")
		printm("!getcars - вывести машины которые находятся в зоне стрима")
		printm("!sest idcar x_car y_car z_car - сесть в машину")
		printm(" * x_car, y_car, z_car - координаты машины, idcar - ид машины")
		printm("!musor - вкл/выкл отображения мусорных сообщений в чат")
		printm("!hcbot help - вывести данное сообщение")
		printm(" * https://www.blast.hk/members/421795/")
        return false
    end
	
	if cmd == "!getcars" then -- для вывода машин в зоне стрима
        cars = getAllVehicles()
		for k, v in pairs(cars) do
			x, y, z = getBotPosition() 
			distance = getDistanceBetweenCoords(x, y, z, v.position.x, v.position.y, v.position.z)
			print(v.name .. "["..k.."]" .. " | Coord: X: "..math.floor(v.position.x).." Y: "..math.floor(v.position.y).." Z: "..math.floor(v.position.z) .. " | Закрыт: "..tostring(v.locked).." | Дистанция: "..math.floor(distance).." м.")
		end
        return false
    end
	if cmd:find("^!sest (.*)") then -- чтобы сесть в машину (использование !sest айди_машины координата_машины_X координата_машины_Y координата_машины_Z)
		if getBotVehicle() == 0 then
			sesti(cmd:match("(.*)"))
		else
			printm("Бот находится в машине.")
		end       
        return false
    end
	if cmd == "!musor" then -- отображать ли мусор в чате
		cfg.settings.chat_musor = not cfg.settings.chat_musor
		if cfg.settings.chat_musor then printm("Отображение мусора в чате - включено.") else printm("Отображение мусора в чате - выключено.") end
        return false
    end
end

function onPrintLog(text) -- хук на текст
	if cfg.settings.chat_musor then
		if text:find("gtasounds") or text:find("COORD") then --or text:find("")
			return false
		end
	end
end

function sesti(param) -- команда чтобы прилитеть и сесть в мапашину на водительское
	local id, xs, ys, zs = string.match(param, '(%d+)%s(.*)%s(.*)%s(.*)')
	xs = tonumber(xs)
	ys = tonumber(ys)
	zs = tonumber(zs)
	idd = tonumber(id)
	mashinka = 1
	coordStart(xs, ys, zs, cfg.settings.timestep_onfoot, cfg.settings.step_onfoot, cfg.settings.coord_ofatspawn)
end

function onCoordStop() -- если курдмастер зкончил работу
	newTask(function()
		if mashinka == 1 then
			mashinka = 0
			sendVehicleEnter(idd, 0) -- сесть в машину
			wait(1000)
			setBotVehicle(idd, 0) -- сесть в машину чтоб точно
			print("Сели в машину: "..idd)
		end
		printm("Успешно прилетели.")
		if getBotVehicle() ~= 0 then
			wait(2500)
			x, y, z = getBotPosition() 
			setBotPosition(x, y, z-cfg.settings.visota+1)
		end
	end)
end

function sampev.onSendVehicleSync(data) -- если инкар отправит sync
	if hcbot_start then
		data.moveSpeed.x = 0.5
		data.moveSpeed.y = 0.5
		data.moveSpeed.z = 1.0
	end
end

function sampev.onSendPlayerSync(data) -- если онфут отправит sync
	if hcbot_start then
		data.moveSpeed.x = 0.5
		data.moveSpeed.y = 0.5
		data.moveSpeed.z = 1.0
	end
end

function getDistanceBetweenCoords(x, y, z, px, py, pz) -- для узнавания дистанции между тобой и коордианатой
    local distance = math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
    return distance
end

function onCoordStart() -- если курдмастер начал работу
	if getBotVehicle() ~= 0 then
		x, y, z = getBotPosition() 
		setBotPosition(x, y, z-cfg.settings.visota)
	end

	printm("Курдмастер начал свою работу.")
end

newTask(function()
	while true do wait(0)
	    if isCoordActive() then
			wait(100)
	        if getBotVehicle() == 0 then -- 0 - не в машине
			    packets = packets + 1
			
			    if packets >= 7 then
			        packets = 0
			        sleep(239)
			    end
		    else
			    packets = packets + 1
			
			    if packets >= 7 then
			        packets = 0
					sleep(400)
			    end
		    end
	    end
	end
end)

function sampev.onSetRaceCheckpoint(type, position, nextPosition, size) -- если отправили чекпоинт
	if hcbot_start then
		x, y, z = getBotPosition() 
		distance = getDistanceBetweenCoords(x, y, z, position.x, position.y, position.z)
		printm("Поймали чекпоинт: "..math.floor(position.x)..", "..math.floor(position.y)..", "..math.floor(position.z).." | Дистанция: "..math.floor(distance).." m.")
		if getBotVehicle() == 0 then -- 0 - не в машине
			coordStart(position.x, position.y, position.z, cfg.settings.timestep_onfoot, cfg.settings.step_onfoot, cfg.settings.coord_ofatspawn)
		else			
			coordStart(position.x, position.y, position.z, cfg.settings.timestep_incar, cfg.settings.step_incar, cfg.settings.coord_ofatspawn)
		end
	end
end

-- внизу всё что нужно для авторизации либо регистрации аккаунта
function sampev.onShowDialog(id, style, title, btn1, btn2, text)
    if title:find('Пароль') then
        sendDialogResponse(id, 1, 0, cfg.settings.password)
        return false
    end
    if title:find('Выберите ваш пол') then
		sendDialogResponse(id, 1, 0, "")
        return false
    end
	if title:find('Выберите цвет кожи') then
		sendDialogResponse(id, 1, 0, "")
        return false
    end
	if title:find('вы о нас узнали?') then
		sendDialogResponse(id, 1, 1, "")
        return false
	end
	if title:find('Введите ник пригласившего?') then
		sendDialogResponse(id, 1, 0, cfg.settings.referal)
        return false
	end
	if title:find('Дополнительная') then
		sendDialogResponse(id, 0, 0, "")
		return false
	end	
	if title:find('Авторизация') then
		sendDialogResponse(id, 1, 0, cfg.settings.password)
		return false
	end
end

function sampev.onShowTextDraw(id, data) -- что-бы выбрало скин нормально
	if id == 419 then
		newTask(function()
			wait(1000)
			sendClickTextdraw(id)
		end)
	end
end

function onSendRPC(id, bs)
	if id == 128 then -- чтобы принять реквест класс
		return true
	end
end

-- для эмуляции нажатий на кнопки и тд
function sampev.onSendPlayerSync(data)
    if key then
        data.keysData = key
        key = nil
    end
end

function sendKey(id)
	printm("Отправил кнопку: "..id)
    key = id
    updateSync()
end

-- внизу не нужное (для работы скрипта нужное)
function printm(text)
	print("[HcBOT]: "..text)
end

function onLoad()
	printm("Успешно загружен! By Haymiritch")
	printm(" * https://www.blast.hk/members/421795/")
	printm(" * Команды: !hcbot help")
end