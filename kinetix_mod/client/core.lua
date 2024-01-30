local menuShortcut = 'F5'

TriggerServerEvent("requestAvailableEmotes")

RegisterCommand('kinetix_anim', function(source, params)
	local dictName = params[1] .. '@animation'
    local animName = 'clip'

	
	if not HasAnimDictLoaded(dictName) then
		RequestAnimDict(dictName)
    end
    local retry = 0
    while not HasAnimDictLoaded(dictName) and retry < 50 do
        Wait(0)
		retry = retry + 1
    end
	retry = 0

	TaskPlayAnim(PlayerPedId(), dictName, animName, 8.0, -8.0, -1, 0, 0.0, false, false, false)
end)

local keybindControls = {
	["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["Backspace"] = 177, ["Tab"] = 37, ["q"] = 44, ["w"] = 32, ["e"] = 38, ["r"] = 45, ["t"] = 245, ["y"] = 246, ["u"] = 303, ["p"] = 199, ["["] = 39, ["]"] = 40, ["Enter"] = 18, ["CapsLock"] = 137, ["a"] = 34, ["s"] = 8, ["d"] = 9, ["f"] = 23, ["g"] = 47, ["h"] = 74, ["k"] = 311, ["l"] = 182, ["Shift"] = 21, ["z"] = 20, ["x"] = 73, ["c"] = 26, ["v"] = 0, ["b"] = 29, ["n"] = 249, ["m"] = 244, [","] = 82, ["."] = 81, ["Home"] = 213, ["PageUp"] = 10, ["PageDown"] = 11, ["Delete"] = 178
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local creationMenuKey = keybindControls[menuShortcut]
        if IsControlPressed(0, creationMenuKey) then
            lib.showContext('create_anim_root')
            TriggerServerEvent("requestInit")
        end
    end
end)

CreateRootMenu()

RegisterNetEvent("user_creation_response")
AddEventHandler("user_creation_response", function(processes)
    CreateMainMenu(processes)
end)

RegisterNetEvent("qr_code_response")
AddEventHandler("qr_code_response", function(url)
    CreateQRCodeMenu(url)
end)

RegisterNetEvent("qr_code_response")
AddEventHandler("qr_code_response", function(url)
    CreateQRCodeMenu(url)
end)

RegisterNetEvent("process_update")
AddEventHandler("process_update", function(data)
    NotifyProcessUpdate(data)
end)

RegisterNetEvent("emote_ready")
AddEventHandler("emote_ready", function(data)
    TriggerServerEvent("requestAvailableEmotes")
    ExecuteCommand('refresh')
    RequestAnimDict(data.uuid .. "@animation")
end)

RegisterNetEvent("emote_ready_notify")
AddEventHandler("emote_ready_notify", function(data)
    NotifyEmoteReady(data)
end)

RegisterNetEvent("emotes_response")
AddEventHandler("emotes_response", function(data)
    CreateEmoteWheel(data)
end)