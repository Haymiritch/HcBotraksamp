-- �������� �������: exportaccountdata, quesada, ���� ���� (��������� ��� ��)

require("addon")
local sampev = require("samp.events")
local inicfg = require('inicfg')
local cfg = inicfg.load(nil, "hcbot")

local hcbot_start = false
local packets = 0

function onRunCommand(cmd)
	if cmd:find("^!key %d+$") then -- ������� ��� �������� ������� ������
        sendKey(tonumber(cmd:match("%d+")))
        return false
    end
	if cmd == "!hcbot" then -- ��� ������� ����
        hcbot_start = not hcbot_start
		if hcbot_start then printm("HcBot ����� ���� ������.") else printm("HcBot �������� ���� ������.") end
		return false
    end	
	if cmd:find("^!hcbot offatspawn") then -- ��������� �� ���� ��� ������
        cfg.settings.coord_ofatspawn = not cfg.settings.coord_ofatspawn
		if cfg.settings.coord_ofatspawn then
			printm("���� ��������� - ����������� �����������.")
		else
			printm("���� ��������� - ����������� �� �����������.")
		end
		return false
    end
	if cmd:find("^!hcbot timestep_onfoot %d+$") then -- ��������� �������� �� � ���
        cfg.settings.timestep_onfoot = tonumber(cmd:match("%d+"))
		printm("�������� ����� ����������: " .. cfg.settings.timestep_onfoot .. " ��.")
        return false
    end
	if cmd:find("^!hcbot step_onfoot %d+$") then -- ��������� ���� �� � ���
        cfg.settings.step_onfoot = tonumber(cmd:match("%d+"))
		printm("��� ���������: " .. cfg.settings.step_onfoot .. " ������.")
        return false
    end
	if cmd:find("^!hcbot timestep_incar %d+$") then -- ��������� �������� �� � ����
        cfg.settings.timestep_incar = tonumber(cmd:match("%d+"))
		printm("�������� ����� ����������: " .. cfg.settings.timestep_incar .. " ��.")
        return false
    end
	if cmd:find("^!hcbot step_incar %d+$") then -- ��������� ���� �� � ����
        cfg.settings.step_incar = tonumber(cmd:match("%d+"))
		printm("��� ���������: " .. cfg.settings.step_incar .. " ������.")
        return false
    end
	if cmd:find("^!hcbot visota %d+$") then -- ��������� ���� �� � ����
        cfg.settings.visota = tonumber(cmd:match("%d+"))
		printm("�� ������� ������ ������� ����: " .. cfg.settings.visota .. " �.")
        return false
    end
	if cmd:find("^!hcbot info") then -- ��� ������ ����������
		printm("================ ��������� � ��� ===============")
		printm("�������� ����� ����������: " .. cfg.settings.timestep_onfoot .. " ��.")
		printm("��� ���������: " .. cfg.settings.step_onfoot .. " ������.")
		printm("================ ��������� � ������ ===============")
		printm("�������� ����� ����������: " .. cfg.settings.timestep_incar .. " ��.")
		printm("��� ���������: " .. cfg.settings.step_incar .. " ������.")
		printm("================ ������ ��������� ==============")
		printm("�� ������� ������ ������� ����: " .. cfg.settings.visota .. " �.")
		printm("��� � ������: " .. tostring(getBotVehicle()).." (���� 0 - �� � ������, ��������� ��� �� ������)")
		printm("��� �������: " .. tostring(hcbot_start))
		printm("!hcbot save - ��������� ���������")
		printm(" * https://www.blast.hk/members/421795/")
        return false
    end
	if cmd:find("^!hcbot save") then -- ��� ���������� ��������
		inicfg.save(cfg, 'hcbot.ini')
		printm("��������� ������� ���������!")
        return false
    end
	if cmd:find("^!hcbot repare_old") then -- ��� ����������� �������� � ������� ���������
		cfg.settings.coord_ofatspawn = "true"
		cfg.settings.timestep_onfoot = "40"
		cfg.settings.step_onfoot = "2"
		cfg.settings.timestep_incar = "50"
		cfg.settings.step_incar = "7"
		cfg.settings.visota = "10"
		inicfg.save(cfg, 'hcbot.ini')
		printm("��������� ������� �������������!")
        return false
    end
	if cmd:find("^!hcbot help") then -- ��� ������ ������
		printm("!hcbot - �������� �������� ����")
		printm("!key ���� - ����������� ������� ������")
		printm("!hcbot save - ��������� ���������")
		printm("!hcbot repare_old - ������������ ��������� ��� ����")
		printm("!hcbot offatspawn - ��������� �� �� ���� �� ����� �� �������")
		printm("!hcbot timestep_onfoot �� - ��������� �������� ����� �� � ���")
		printm("!hcbot step_onfoot ����� - ��������� ���� �� � ���")
		printm("!hcbot timestep_incar �� - ��������� �������� ����� �� � ������")
		printm("!hcbot step_incar ����� - ��������� ���� �� � ������")
		printm("!hcbot info - ������� ���������� �� ����������")
		printm("!getcars - ������� ������ ������� ��������� � ���� ������")
		printm("!sest idcar x_car y_car z_car - ����� � ������")
		printm(" * x_car, y_car, z_car - ���������� ������, idcar - �� ������")
		printm("!musor - ���/���� ����������� �������� ��������� � ���")
		printm("!hcbot help - ������� ������ ���������")
		printm(" * https://www.blast.hk/members/421795/")
        return false
    end
	
	if cmd == "!getcars" then -- ��� ������ ����� � ���� ������
        cars = getAllVehicles()
		for k, v in pairs(cars) do
			x, y, z = getBotPosition() 
			distance = getDistanceBetweenCoords(x, y, z, v.position.x, v.position.y, v.position.z)
			print(v.name .. "["..k.."]" .. " | Coord: X: "..math.floor(v.position.x).." Y: "..math.floor(v.position.y).." Z: "..math.floor(v.position.z) .. " | ������: "..tostring(v.locked).." | ���������: "..math.floor(distance).." �.")
		end
        return false
    end
	if cmd:find("^!sest (.*)") then -- ����� ����� � ������ (������������� !sest ����_������ ����������_������_X ����������_������_Y ����������_������_Z)
		if getBotVehicle() == 0 then
			sesti(cmd:match("(.*)"))
		else
			printm("��� ��������� � ������.")
		end       
        return false
    end
	if cmd == "!musor" then -- ���������� �� ����� � ����
		cfg.settings.chat_musor = not cfg.settings.chat_musor
		if cfg.settings.chat_musor then printm("����������� ������ � ���� - ��������.") else printm("����������� ������ � ���� - ���������.") end
        return false
    end
end

function onPrintLog(text) -- ��� �� �����
	if cfg.settings.chat_musor then
		if text:find("gtasounds") or text:find("COORD") then --or text:find("")
			return false
		end
	end
end

function sesti(param) -- ������� ����� ��������� � ����� � �������� �� ������������
	local id, xs, ys, zs = string.match(param, '(%d+)%s(.*)%s(.*)%s(.*)')
	xs = tonumber(xs)
	ys = tonumber(ys)
	zs = tonumber(zs)
	idd = tonumber(id)
	mashinka = 1
	coordStart(xs, ys, zs, cfg.settings.timestep_onfoot, cfg.settings.step_onfoot, cfg.settings.coord_ofatspawn)
end

function onCoordStop() -- ���� ���������� ������� ������
	newTask(function()
		if mashinka == 1 then
			mashinka = 0
			sendVehicleEnter(idd, 0) -- ����� � ������
			wait(1000)
			setBotVehicle(idd, 0) -- ����� � ������ ���� �����
			print("���� � ������: "..idd)
		end
		printm("������� ���������.")
		if getBotVehicle() ~= 0 then
			wait(2500)
			x, y, z = getBotPosition() 
			setBotPosition(x, y, z-cfg.settings.visota+1)
		end
	end)
end

function sampev.onSendVehicleSync(data) -- ���� ����� �������� sync
	if hcbot_start then
		data.moveSpeed.x = 0.5
		data.moveSpeed.y = 0.5
		data.moveSpeed.z = 1.0
	end
end

function sampev.onSendPlayerSync(data) -- ���� ����� �������� sync
	if hcbot_start then
		data.moveSpeed.x = 0.5
		data.moveSpeed.y = 0.5
		data.moveSpeed.z = 1.0
	end
end

function getDistanceBetweenCoords(x, y, z, px, py, pz) -- ��� ��������� ��������� ����� ����� � ������������
    local distance = math.sqrt((px - x)^2 + (py - y)^2 + (pz - z)^2)
    return distance
end

function onCoordStart() -- ���� ���������� ����� ������
	if getBotVehicle() ~= 0 then
		x, y, z = getBotPosition() 
		setBotPosition(x, y, z-cfg.settings.visota)
	end

	printm("���������� ����� ���� ������.")
end

newTask(function()
	while true do wait(0)
	    if isCoordActive() then
			wait(100)
	        if getBotVehicle() == 0 then -- 0 - �� � ������
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

function sampev.onSetRaceCheckpoint(type, position, nextPosition, size) -- ���� ��������� ��������
	if hcbot_start then
		x, y, z = getBotPosition() 
		distance = getDistanceBetweenCoords(x, y, z, position.x, position.y, position.z)
		printm("������� ��������: "..math.floor(position.x)..", "..math.floor(position.y)..", "..math.floor(position.z).." | ���������: "..math.floor(distance).." m.")
		if getBotVehicle() == 0 then -- 0 - �� � ������
			coordStart(position.x, position.y, position.z, cfg.settings.timestep_onfoot, cfg.settings.step_onfoot, cfg.settings.coord_ofatspawn)
		else			
			coordStart(position.x, position.y, position.z, cfg.settings.timestep_incar, cfg.settings.step_incar, cfg.settings.coord_ofatspawn)
		end
	end
end

-- ����� �� ��� ����� ��� ����������� ���� ����������� ��������
function sampev.onShowDialog(id, style, title, btn1, btn2, text)
    if title:find('������') then
        sendDialogResponse(id, 1, 0, cfg.settings.password)
        return false
    end
    if title:find('�������� ��� ���') then
		sendDialogResponse(id, 1, 0, "")
        return false
    end
	if title:find('�������� ���� ����') then
		sendDialogResponse(id, 1, 0, "")
        return false
    end
	if title:find('�� � ��� ������?') then
		sendDialogResponse(id, 1, 1, "")
        return false
	end
	if title:find('������� ��� �������������?') then
		sendDialogResponse(id, 1, 0, cfg.settings.referal)
        return false
	end
	if title:find('��������������') then
		sendDialogResponse(id, 0, 0, "")
		return false
	end	
	if title:find('�����������') then
		sendDialogResponse(id, 1, 0, cfg.settings.password)
		return false
	end
end

function sampev.onShowTextDraw(id, data) -- ���-�� ������� ���� ���������
	if id == 419 then
		newTask(function()
			wait(1000)
			sendClickTextdraw(id)
		end)
	end
end

function onSendRPC(id, bs)
	if id == 128 then -- ����� ������� ������� �����
		return true
	end
end

-- ��� �������� ������� �� ������ � ��
function sampev.onSendPlayerSync(data)
    if key then
        data.keysData = key
        key = nil
    end
end

function sendKey(id)
	printm("�������� ������: "..id)
    key = id
    updateSync()
end

-- ����� �� ������ (��� ������ ������� ������)
function printm(text)
	print("[HcBOT]: "..text)
end

function onLoad()
	printm("������� ��������! By Haymiritch")
	printm(" * https://www.blast.hk/members/421795/")
	printm(" * �������: !hcbot help")
end