local discordia = require('discordia')
local json = require('json')
local client = discordia.Client()
local prefix = "!"
local curencyname = "Credits"

client:on('ready', function()
    client:setGame("blob arena!")
end)

local function embedfunc1(user,avurl,currency,col,addedcurrency,Title)
   local embed = {
        title = Title,
        author = {
            name = use,
            icon_url = avurl
        },
        fields = {
            {
            name = "Added ".. curencyname.. ":",
            value = addedcurrency,
            incline = false
            }
        },
        footer = {
            text = "BLOB-E"
        },
        color = col}
        return embed
end

client:on('messageCreate', function(message)
-- LEVELS
    local rand =  math.random(1,4)
    local file = io.open('./xp.json',"r")
    local parse = json.parse(file:read("*a"))
    
    local file2 = io.open('./levels.json',"r")
    local parse2 = json.parse(file2:read("*a"))

    local author = message.author

    local datakey = message.author.id
    file:close()

    if parse2[datakey] then
        if parse[datakey] == nil then
            parse[datakey] = 1
        end
        if parse[datakey] >= (100 * parse2[datakey]) then
            parse[datakey] = 0
            parse2[datakey] = parse2[datakey] + 1
        end
    else
        parse2[datakey] = 1
        parse[datakey] = 0
    end

    if rand == 1 then
        if parse[datakey] then
            parse[datakey] = parse[datakey] + 1
        else
            parse[datakey] = 1
        end
    end

    local file = io.open('./xp.json',"w")
    file:write(json.stringify(parse))
    file:close()

    file2 = io.open('./levels.json',"w")
    file2:write(json.stringify(parse2))
    file2:close()

----------------------------------------------------------

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

message:reply({embed = embedfunc1(message.author.username,message.avatarURL,addedcurrency,65280,addedcurrency,"Total Currency " .. parse[datakey])})

        local file = io.open('./currency.json',"w")
        file:write(json.stringify(parse))
        file:close()

    elseif message.content:sub(1,3) == prefix .. "mC" then -- File read for currency
        local file = io.open('./currency.json',"r")
        local parse = json.parse(file:read("*a"))
        local datakey = message.author.id
        file:close()

        if parse[datakey] then
        message:reply({embed = {
            title = "Total Credit:",
            author = {
                name = author.username,
                icon_url = author.avatarURL
            },
            fields = {
                {
                name = curencyname.. ":",
                value = parse[datakey],
                incline = false
                }
            },
            footer = {
                text = "BLOB-E"
            },
            color = 14678272}})
        
        else
            message:reply(
                {embed = {
                    title = "Credit Added",
                    author = {
                        name = author.username,
                        icon_url = author.avatarURL
                    },
                    fields = {
                        name = curencyname.. ":",
                        value = "0",
                        incline = false
                    },
                    footer = {
                        text = "BLOB-E"
                    },
                    color = 14678272
                }}
            )
        end

      --[[ elseif message.content:sub(1,11) == prefix .. "cDaily" then -- Daily rewards
        local file = io.open('./currency.json',"r")
        local parse = json.parse(file:read("*a"))
        local datakey = message.author.id
        file:close()
      --]]

    elseif message.content:sub(1,6) == prefix .. "uCAdd" then -- Give 
        
        local words = {}
        local words2 = {}
        local addedcurrency
        local file = io.open('./currency.json',"r")
        local parse = json.parse(file:read("*a"))
        local author = message.guild:getMember(message.author.id)
        local member = message.mentionedUsers.first
        for w in tostring(message.content):gmatch("%S+") do 
            table.insert(words,w)
        end

        for w in tostring(member):gmatch("%S+") do 
            table.insert(words2,w)
        end

        if words[3] ~= nil then
            
            if author.highestRole.position > message.guild:getMember(member).highestRole.position and member[1] ~= nil then
                --member = message.guild:getMember(user.id)
                member =  client:getUser(message.mentionedUsers[1])
                addedcurrency = tonumber(words[2])

                if parse[words2[2]] then
                    parse[words2[2]] = parse[words2[2]] + addedcurrency
                else
                    parse[words2[2]] = addedcurrency
                end
        
                --message:reply("Currency added: ".. addedcurrency .. "\nTotalCurrency: " .. parse[words2[2]])

                message:reply({embed = {
                    title = "Total Credit: " .. parse[datakey],
                    author = {
                        name = message.mentionedUsers.first.username,
                        icon_url = message.mentionedUsers.first.avatarURL
                    },
                    fields = {
                        {
                        name = "Added ".. curencyname.. ":",
                        value = addedcurrency,
                        incline = false
                        }
                    },
                    footer = {
                        text = "BLOB-E"
                    },
                    color = 65280}})
        
                local file = io.open('./currency.json',"w")
                file:write(json.stringify(parse))
                file:close()
            else
                message:reply("no perms 💀")
            end
        else
            message:reply("**Please add a 3rd parameter** *(Currency amount)*!")
        end
    elseif message.content:sub(1,4) == prefix .. "mxp" then -- XP stuff
        local file = io.open('./xp.json',"r")
        local parse = json.parse(file:read("*a"))
        local datakey = message.author.id
        file:close()

        if parse[datakey] then
            message:reply(
                {embed = {
                    title = "Total XP: ".. parse[datakey],
                    author = {
                        name = author.username,
                        icon_url = author.avatarURL
                    },
                    footer = {
                        text = "BLOB-E"
                    },
                    color = 12956415
                }}
            )
        
        else
            message:reply(
                {embed = {
                    title = "Total XP: ".. "0",
                    author = {
                        name = author.username,
                        icon_url = author.avatarURL
                    },
                    footer = {
                        text = "BLOB-E"
                    },
                    color = 12956415
                }}
            )
        end
        elseif message.content:sub(1,4) == prefix .. "uCC" then -- Subtract currency
        local words = {}
        local words2 = {}
        local subbedcurrency
        local file = io.open('./currency.json',"r")
        local parse = json.parse(file:read("*a"))
        local author = message.guild:getMember(message.author.id)
        local member = message.mentionedUsers.first
        local datakey = member.id
        for w in tostring(message.content):gmatch("%S+") do 
            table.insert(words,w)
        end

        for w in tostring(member):gmatch("%S+") do 
            table.insert(words2,w)
        end

        if words[3] ~= nil then
            
            if author.highestRole.position > message.guild:getMember(member).highestRole.position and member[1] ~= nil then
                --member = message.guild:getMember(user.id)
                member =  client:getUser(message.mentionedUsers[1])
                subbedcurrency = tonumber(words[2])

                if parse[datakey] then
                    parse[datakey] = parse[datakey] - subbedcurrency
                else
                    parse[datakey] = -subbedcurrency
                end
        
                --message:reply("Currency added: ".. addedcurrency .. "\nTotalCurrency: " .. parse[words2[2]])

                message:reply({embed = {
                    title = "Total Credit: " .. parse[datakey],
                    author = {
                        name = message.mentionedUsers.first.username,
                        icon_url = message.mentionedUsers.first.avatarURL
                    },
                    fields = {
                        {
                        name = "Subtracted ".. curencyname.. ":",
                        value = subbedcurrency,
                        incline = false
                        }
                    },
                    footer = {
                        text = "BLOB-E"
                    },
                    color = 65280}})
        
                local file = io.open('./currency.json',"w")
                file:write(json.stringify(parse))
                file:close()
            else
                message:reply("no perms 💀")
            end
        else
            message:reply("**Please add a 2nd parameter** *(user)* or 3rd parameter (currency amount)!") 
        end
    elseif message.content:sub(1,3) == prefix .. "mL" then -- Level
        local file = io.open('./levels.json',"r")
        local parse = json.parse(file:read("*a"))
        local datakey = message.author.id
        file:close()

        if parse[datakey] then
            message:reply(
                {embed = {
                    title = "Total Level: ".. parse[datakey],
                    author = {
                        name = author.username,
                        icon_url = author.avatarURL
                    },
                    footer = {
                        text = "BLOB-E"
                    },
                    color = 12910771
                }}
            )
        
        else
            message:reply(
                {embed = {
                    title = "Total Level: ".. "0",
                    author = {
                        name = author.username,
                        icon_url = author.avatarURL
                    },
                    footer = {
                        text = "BLOB-E"
                    },
                    color = 12910771
                }}
            )
        end
    end
end)

local file = io.open("./token.text")
local token = file:read("*a")
file:close()

client:run('Bot '.. token)
