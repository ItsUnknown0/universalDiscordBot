local discordia = require('discordia')
local json = require('json')
local client = discordia.Client()
local prefix = "!"

client:on('ready', function()
    client:setGame("Fortnite!")
end)

client:on('messageCreate', function(message)
    if message.content:sub(1,12) == prefix .. "aC" then -- Currency Commands!
        local addedcurrency = math.random(1,20)
        local file = io.open('./currency.json',"r")
        local parse = json.parse(file:read("*a"))
        local datakey = message.author.id
        file:close()

        if parse[datakey] then
            parse[datakey] = parse[datakey] + addedcurrency
        else
            parse[datakey] = addedcurrency
        end

        message:reply("Currency added: ".. addedcurrency .. "\nTotalCurrency: " .. parse[datakey])

        local file = io.open('./currency.json',"w")
        file:write(json.stringify(parse))
        file:close()

    elseif message.content:sub(1,11) == prefix .. "mC" then -- File read for currency
        local file = io.open('./currency.json',"r")
        local parse = json.parse(file:read("*a"))
        local datakey = message.author.id
        file:close()
        if parse[datakey] then
        message:reply("Total Currency: ".. parse[datakey])
        else
            message:reply("Total Currency: 0")
        end

      --[[ elseif message.content:sub(1,11) == prefix .. "cDaily" then -- Daily rewards
        local file = io.open('./currency.json',"r")
        local parse = json.parse(file:read("*a"))
        local datakey = message.author.id
        file:close()
      --]]

    elseif message.content:sub(1,6) == prefix .. "cuAdd" then
        local words = {}
        local words2 = {}
        local addedcurrency
        local file = io.open('./currency.json',"r")
        local parse = json.parse(file:read("*a"))
        local author = message.guild:getMember(message.author.id)
        local member = message.mentionedUsers.first
        print(member)
        for w in tostring(message.content):gmatch("%S+") do 
            table.insert(words,w)
        end

        for w in tostring(member):gmatch("%S+") do 
            table.insert(words2,w)
        end

        if words[3] ~= nil then
            
            if author.highestRole.position >= message.guild:getMember(member).highestRole.position and member[1] ~= nil then
                --member = message.guild:getMember(user.id)
                member =  client:getUser(message.mentionedUsers[1])
                print(member)
                addedcurrency = tonumber(words[2])

                if parse[words2[2]] then
                    parse[words2[2]] = parse[words2[2]] + addedcurrency
                else
                    parse[words2[2]] = addedcurrency
                end
        
                message:reply("Currency added: ".. addedcurrency .. "\nTotalCurrency: " .. parse[words2[2]])
        
                local file = io.open('./currency.json',"w")
                file:write(json.stringify(parse))
                file:close()
            else
                message:reply("no perms 💀")
            end
        else
            message:reply("**Please add a 3rd parameter** *(Currency amount)*!")
        end


    end
end)

local file = io.open("./token.text")
local token = file:read("*a")
file:close()

client:run('Bot '.. token)