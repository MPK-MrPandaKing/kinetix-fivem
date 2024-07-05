local webhookRouter = Router.new()

function GetServerIdFromIdentifier(identifier)
    local wanted_id = nil

    for k, v in pairs(GetPlayers()) do
        local userId = GetUserId(v)

        local id = tonumber(v)
        if userId == identifier then
                wanted_id = id
        end
     end

     return wanted_id;
end

webhookRouter:Post("/:param", function(req, res)
    local body = req._Body
    local playerId = GetServerIdFromIdentifier(body.user)
	local hmac = hmac_sha256(apiKey, json.encode(req._Body, { sort_keys = true }))
	local hmacHeader = req._Raw.headers['x-signature']

	if checkWebhookHMAC and hmac ~= hmacHeader then
		print("Webhook : Invalid hmac signature")
		return 403, { error = "Invalid hmac signature" }
	end
    if body.status == "gta_done" then
		local configuration = exports.kinetix_mod:getConfiguration()
		if configuration.ugcValidation ~= nil and configuration.ugcValidation ~= false then
			DownloadYCD(body, playerId, true, true)
		end
    else
        if playerId ~= nil then
            if (body.status == 'baking') then
                PaywallAfter(playerId, body)
                TriggerClientEvent("process_creation", playerId, body)
            end
            TriggerClientEvent("process_update", playerId, body)
        end
    end
    return 200, {}
end)

Server.use("/webhook", webhookRouter)
Server.listen()