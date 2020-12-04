-- This is my old soft shutdown system, I've scripted another one that I will keep private.

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
 
------------------------------------------------------------

local MessageToClone = script:FindFirstChild("Message")
 
local function newMessage(player, message)
    local tempMessage = MessageToClone:Clone()
    tempMessage.Parent = player:WaitForChild("PlayerGui")
    tempMessage:FindFirstChild("Frame"):FindFirstChild("TextLabel").Text = message
end

------------------------------------------------------------
if game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0 then
    local waitTime = 5
   
    Players.PlayerAdded:Connect(function(player)
        newMessage(player, "")
       	wait(waitTime)
        waitTime = waitTime / 15
        TeleportService:Teleport(game.PlaceId, player)
    end)
   
    for i, player in pairs(Players:GetPlayers()) do
        newMessage(player, "We're currently restarting our servers, The Wherry Lines will restart and teleport you to the main game when the update has finished.")
       
        TeleportService:Teleport(game.PlaceId, player)
        wait(waitTime)
        waitTime = waitTime / 15
	end
------------------------------------------------------------
elseif RunService:IsStudio() == false then
    game:BindToClose(function()
        spawn(function()
            local reservedServerCode = TeleportService:ReserveServer(game.PlaceId)
            for _, player in pairs(Players:GetPlayers()) do
                newMessage(player, "We're restarting our servers for a update, The Wherry Lines will be back online shortly.")
               
                TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, {player})
            end
            Players.PlayerAdded:Connect(function(player)
                newMessage(player, "We're restarting our servers for an update, The Wherry Lines will back online shortly.")
               
                TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, {player})
            end)
        end)
        while #Players:GetPlayers() > 0 do
            wait(1)
        end
    end)   
end
