local playersProcessingMeth = {}

RegisterServerEvent('esxbalkan_droge:pickedUpHydrochloricAcid')
AddEventHandler('esxbalkan_droge:pickedUpHydrochloricAcid', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('hydrochloric_acid', 1) then
		xPlayer.addInventoryItem('hydrochloric_acid', 1)
	else
		xPlayer.showNotification(_U('hydrochloric_acid_inventoryfull'))
	end
end)

RegisterServerEvent('esxbalkan_droge:pickedUpSodiumHydroxide')
AddEventHandler('esxbalkan_droge:pickedUpSodiumHydroxide', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('sodium_hydroxide', 1) then
		xPlayer.addInventoryItem('sodium_hydroxide', 1)
	else
		xPlayer.showNotification(_U('sodium_hydroxide_inventoryfull'))
	end
end)

RegisterServerEvent('esxbalkan_droge:pickedUpSulfuricAcid')
AddEventHandler('esxbalkan_droge:pickedUpSulfuricAcid', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('sulfuric_acid', 1) then
		xPlayer.addInventoryItem('sulfuric_acid', 1)
	else
		xPlayer.showNotification(_U('sulfuric_acid_inventoryfull'))
	end
end)

RegisterServerEvent('esxbalkan_droge:processMeth')
AddEventHandler('esxbalkan_droge:processMeth', function()
	if not playersProcessingMeth[source] then
		local _source = source

		playersProcessingMeth[_source] = ESX.SetTimeout(Config.Delays.MethProcessing, function()
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xhydrochloric_acid,xsulfuric_acid,xsodium_hydroxide,xmeth = xPlayer.getInventoryItem('hydrochloric_acid'),xPlayer.getInventoryItem('sulfuric_acid'),xPlayer.getInventoryItem('sodium_hydroxide'), xPlayer.getInventoryItem('meth')

			if xhydrochloric_acid.count > 0 and xsulfuric_acid.count > 0 and xsodium_hydroxide.count > 0 then
				if xPlayer.canSwapItem('hydrochloric_acid', 1, 'meth', 1) and xPlayer.canSwapItem('sulfuric_acid', 1, 'meth', 1) and xPlayer.canSwapItem('sodium_hydroxide', 1, 'meth', 1) then
					xPlayer.removeInventoryItem('hydrochloric_acid', 1)
					xPlayer.removeInventoryItem('sulfuric_acid', 1)
					xPlayer.removeInventoryItem('sodium_hydroxide', 1)
					xPlayer.addInventoryItem('meth', 1)

					xPlayer.showNotification(_U('meth_processed'))
				else
					xPlayer.showNotification(_U('meth_processingfull'))
				end
			else
				xPlayer.showNotification(_U('meth_processingenough'))
			end

			playersProcessingMeth[_source] = nil
		end)
	else
		print(('esxbalkan_droge: %s attempted to exploit meth processing!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessingMeth[playerID] then
		ESX.ClearTimeout(playersProcessingMeth[playerID])
		playersProcessingMeth[playerID] = nil
	end
end

RegisterServerEvent('esxbalkan_droge:cancelProcessing')
AddEventHandler('esxbalkan_droge:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
