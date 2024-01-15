
local clockImage = TimeOfDayIndicatorFrame:CreateTexture(nil,'BACKGROUND')
clockImage:SetTexture('Interface\\AddOns\\TimeOfDayIndicator\\W3UI_Resources\\TimeIndicator')
clockImage:SetPoint('TOP', TimeOfDayIndicatorFrame, 'TOP', 0, -19)
clockImage:SetWidth(56)
clockImage:SetHeight(52)
clockImage:Show()

local frameArt = TimeOfDayIndicatorFrame:CreateTexture(nil,'BORDER')
frameArt:SetAllPoints(TimeOfDayIndicatorFrame)
frameArt:Show()

local glow = TimeOfDayIndicatorFrame:CreateTexture(nil, 'OVERLAY')
glow:SetTexture('Interface\\AddOns\\TimeOfDayIndicator\\W3UI_Resources\\genericglowfaded')
glow:SetPoint('CENTER', TimeOfDayIndicatorFrame, 'CENTER', 0, 5)
glow:SetWidth(110)
glow:SetHeight(110)
glow:SetBlendMode('ADD')
glow:Show()

local magicGlow = TimeOfDayIndicatorFrame:CreateTexture(nil, 'OVERLAY')
magicGlow:SetTexture('Interface\\AddOns\\TimeOfDayIndicator\\W3UI_Resources\\star3')
magicGlow:SetPoint('CENTER', TimeOfDayIndicatorFrame, 'CENTER', 0, 0)
magicGlow:SetWidth(110)
magicGlow:SetHeight(110)
magicGlow:SetBlendMode('ADD')
magicGlow:Hide()

local sizeFrameArt = function(race)
    frameArt:SetTexture('Interface\\AddOns\\TimeOfDayIndicator\\W3UI_Resources\\'..race..'uitile-timeindicatorframe')
    if race == 'human' then
        frameArt:SetTexCoord(28 / 256, 226 / 256, 0, 94 / 128)
        TimeOfDayIndicatorFrame:SetWidth(198)
        TimeOfDayIndicatorFrame:SetHeight(94)
    elseif race == 'nightelf' then
        frameArt:SetTexCoord(10 / 256, 246 / 256, 0, 95 / 128)
        TimeOfDayIndicatorFrame:SetWidth(236)
        TimeOfDayIndicatorFrame:SetHeight(95)
    elseif race == 'orc' then
        frameArt:SetTexCoord(40 / 256, 212 / 256, 0, 89 / 128)
        TimeOfDayIndicatorFrame:SetWidth(172)
        TimeOfDayIndicatorFrame:SetHeight(89)
    else
        frameArt:SetTexCoord(17 / 256, 234 / 256, 0, 94 / 128)
        TimeOfDayIndicatorFrame:SetWidth(217)
        TimeOfDayIndicatorFrame:SetHeight(94)
    end
end

local player = UnitName('player')
if type(TimeOfDayIndicator_Variables) ~= 'table' then
	TimeOfDayIndicator_Variables = {}
    TimeOfDayIndicator_Variables['GameTimeFrame'] = 'disabled'
    TimeOfDayIndicator_Variables['Game Tooltip'] = 'WoWlike'
    GameTimeFrame:Hide()
    TimeOfDayIndicator_Variables[player] = 'human'
    sizeFrameArt('human')
end

TimeOfDayIndicatorFrame_Config = function(msg)
    local msg = strlower(msg)
	if strfind(msg, 'tooltip') or strfind(msg, 'gametooltip') then
        if TimeOfDayIndicator_Variables['Game Tooltip'] == 'WoWlike' then
            TimeOfDayIndicator_Variables['Game Tooltip'] = 'WC3'

        else
            TimeOfDayIndicator_Variables['Game Tooltip'] = 'WoWlike'
        end
        DEFAULT_CHAT_FRAME:AddMessage('TimeOfDayIndicator: Tooltip style changed')
        return
    elseif strfind(msg, 'human') or strfind(msg, 'alliance') then
        TimeOfDayIndicator_Variables[player] = 'human'
        sizeFrameArt(TimeOfDayIndicator_Variables[player])
        DEFAULT_CHAT_FRAME:AddMessage('TimeOfDayIndicator: HumanUI')
        return
    elseif strfind(msg, 'orc') or strfind(msg, 'horde') then
        TimeOfDayIndicator_Variables[player] = 'orc'
        sizeFrameArt(TimeOfDayIndicator_Variables[player])
        DEFAULT_CHAT_FRAME:AddMessage('TimeOfDayIndicator: OrcUI')
        return
    elseif strfind(msg, 'undead') or strfind(msg, 'ud') then
        TimeOfDayIndicator_Variables[player] = 'undead'
        sizeFrameArt(TimeOfDayIndicator_Variables[player])
        DEFAULT_CHAT_FRAME:AddMessage('TimeOfDayIndicator: UndeadUI')
        return
    elseif strfind(msg, 'night') or strfind(msg, 'nelf') then
        TimeOfDayIndicator_Variables[player] = 'nightelf'
        sizeFrameArt(TimeOfDayIndicator_Variables[player])
        DEFAULT_CHAT_FRAME:AddMessage('TimeOfDayIndicator: NightElfUI')
        return
    elseif strfind(msg, 'gametime') or strfind(msg, 'minimap') then
        if TimeOfDayIndicator_Variables['GameTimeFrame'] == 'disabled' then
            TimeOfDayIndicator_Variables['GameTimeFrame'] = 'enabled'
            GameTimeFrame:Show()

        else
            TimeOfDayIndicator_Variables['GameTimeFrame'] = 'disabled'
            GameTimeFrame:Hide()
        end
        DEFAULT_CHAT_FRAME:AddMessage('TimeOfDayIndicator: GameTimeFrame '..TimeOfDayIndicator_Variables['GameTimeFrame'])
        return
	end
	DEFAULT_CHAT_FRAME:AddMessage('TimeOfDayIndicator.v1')
	DEFAULT_CHAT_FRAME:AddMessage('Subcommands: human, orc, undead, nightelf, gametime, tooltip')
end

SlashCmdList['TODINDICATOR'] = TimeOfDayIndicatorFrame_Config
SLASH_TODINDICATOR1 = '/timeofday'
SLASH_TODINDICATOR2 = '/todindicator'

local GAMETIME_DAWN = (( 5 * 60) + 30) * 60
local GAMETIME_DUSK = ((21 * 60) +  0) * 60

local timeToSeconds = function(hr, min, sec)
    --message('debug: time to seconds')
    return (((hr * 60) + min) * 60) + sec
end

local formatTime = function(hr, min, sec)
    --message('debug: time formatted')
    if TwentyFourHourTime then return format('%02d:%02d:%02d', hr, min, sec)

    elseif hr > 12 or hr == 0 then
        if not hr == 0 then
            return format('%02d:%02d:%02d PM', 12, min, sec)
        else
            return format('%02d:%02d:%02d PM', (hr - 12), min, sec)
        end
        
    else
        return format('%02d:%02d:%02d AM', hr, min, sec)
    end
end


local KALIMDOR = {}
local timezone = function(hr, zone)
    --message('debug: timezone '..zone)
    local match
    if not IsInInstance() then
        for k, v in pairs(KALIMDOR) do
            if zone == v then
                return GetGameTime()
            end
        end
    end
    return hr
end

local color = {
    ['Day']     = { r = 1.00, g = 0.85, b = 0.15 }, --100%, 93%, 15%
    ['Night']   = { r = 0.20, g = 0.60, b = 1.00 }  --4%, 25%, 64%
}

local tooltipUpdate = function(hours, minutes, seconds)
    --message('debug: tooltip update')
    local localHour = timezone(hours, GetZoneText())
    local onHemisphere, offHemisphere, offHour
    
    if TimeOfDayIndicator_Variables['Game Tooltip'] == 'WoWlike' then
        if localHour ~= hours then
            onHemisphere = 'Kalimdor'
            offHemisphere = 'Eastern Kingdoms'
            offHour = hours
        else
            onHemisphere = 'Eastern Kingdoms'
            offHemisphere = 'Kalimdor'
            if hours > 12 then
                offHour = hours - 12
            else
                offHour = hours + 12
            end
        end
        local time = timeToSeconds(localHour, minutes, seconds)

        local timeName, cycleOfDay
        if time >= GAMETIME_DUSK or time < GAMETIME_DAWN then
            timeName = 'Nighttime'
            cycleOfDay = 'Night'
        else
            cycleOfDay = 'Day'
            if time >= ((17 * 60) * 60) then --5:00 PM
                timeName = 'Evening'
            elseif time >= ((12 * 60) * 60) then --12:00 PM
                timeName = 'Afternoon'
            else
                timeName = 'Morning'
            end
        end
        GameTooltip:SetPoint("TOP", TimeOfDayIndicatorFrame, "BOTTOM")
        GameTooltip:SetText('Time of Day: '..timeName, color[cycleOfDay].r, color[cycleOfDay].g, color[cycleOfDay].b)
        GameTooltip:AddLine(onHemisphere..' '..formatTime(localHour, minutes, seconds))
        GameTooltip:AddLine(offHemisphere..' '..formatTime(offHour, minutes, seconds))
    else
        GameTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y)
        GameTooltip:SetText('Time of Day ( \124cffffd200'..formatTime(localHour, minutes, seconds)..'\124r )', 1.0, 1.0, 1.0)
        GameTooltip:AddLine('This is the current time of day.', 1.0, 1.0, 1.0)
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine('The time of day can affect visibility of units and the use of some abilities.', 1.0, 1.0, 1.0)
    end
    GameTooltip:Show()
end

local timeToChange
local setUpCycle = function(hours, minutes, seconds)
    --message('debug: set up cycle')

    local time = timeToSeconds(hours, minutes, seconds)

    local timeOfDay, pixel, left, right, interval

    if time >= GAMETIME_DUSK then
        timeOfDay = 'Night'
        pixel = ((time - 75599) / 239.0625) / 512
        left = 8 / 512
        right = 120 / 512
        interval = floor((time - 75599) / 3825)

    elseif time >= GAMETIME_DAWN then
        timeOfDay = 'Day'
        pixel = ((time - 19799) / 435.9375) / 512
        left = 136 / 512
        right = 248 / 512
        interval = floor((time - 19799) / 6975)

        if (GAMETIME_DUSK - time) < 60 then timeToChange = true end

    else
        timeOfDay = 'Night'
        pixel = ((time + 10800) / 239.0625) / 512
        left = 8 / 512
        right = 120 / 512
        interval = floor((time + 10800) / 3825)

        if (GAMETIME_DAWN - time) < 60 then timeToChange = true end
    end

    glow:SetVertexColor(color[timeOfDay].r, color[timeOfDay].g, color[timeOfDay].b)
    magicGlow:SetVertexColor(color[timeOfDay].r, color[timeOfDay].g, color[timeOfDay].b)

    if pixel > 0 then
        left =  left + pixel
        right = right + pixel
    end
    clockImage:SetTexCoord(left, right, 8 / 128, 110 / 128)

    --message('debug: ringTime')
    for i = 0, 7 do
        local glowRing = getglobal('TimeOfDayIndicator_GlowRingNumber' .. (i + 1))
        if not glowRing then
            glowRing = TimeOfDayIndicatorFrame:CreateTexture('TimeOfDayIndicator_GlowRingNumber' .. i, 'ARTWORK')
            glowRing:SetTexture('Interface\\AddOns\\TimeOfDayIndicator\\W3UI_Resources\\genericglow2_32')
            glowRing:SetTexCoord(2 / 32, 30 / 32, 2 / 32, 30 / 32)
            glowRing:SetWidth(8)
            glowRing:SetHeight(8)
            glowRing:SetBlendMode('ADD')
        end
        local x, y, r = -1, 3, 35
        local a
        if i == 0 or i == 4 then
            a = 45
        elseif i == 1 or i == 5 then
            a = 45
        elseif i == 2 or i == 6 then
            a = 45
        else
            a = 45
        end


        --radius is 35?
        --x = 19 + half of the clock
        --[[
        if TimeOfDayIndicator_Variables[player] == 'human' then x, y, r = -1, 2, 35
        elseif TimeOfDayIndicator_Variables[player] == 'nightelf' then
        elseif TimeOfDayIndicator_Variables[player] == 'orc' then x, y, r = 1, 0, 34
        else x, y, r = -1, 47 - (20 + 49/2), 34
        end
        ]]

        local angle = (i * a) * math.pi / 180 + (1.5 * math.pi)
        if angle > (2 * math.pi) then angle = angle - (2 * math.pi) end
        x, y = x + r * math.cos(angle), y + r * math.sin(angle)
        glowRing:SetPoint('CENTER', TimeOfDayIndicatorFrame, 'CENTER', x, y)

        --if i <= interval then
            glowRing:SetVertexColor(color[timeOfDay].r, color[timeOfDay].g, color[timeOfDay].b)
            glowRing:Show()
        --else
        --    glowRing:Hide()
        --end
    end
end

local hour, minute, second, lapse, notLapse, glowUp
local OnUpdate = function()
    if (GetTime() - notLapse) >= 0.25 then --each one quarter of second
        local size = glow:GetWidth()
        if glowUp then
            glow:SetWidth(size + 1.0)
            glow:SetHeight(size + 1.0)
            if size >= 120 then glowUp = nil end
        else
            glow:SetWidth(size - 1.0)
            glow:SetHeight(size - 1.0)
            if size <= 110 then glowUp = true end
        end

        notLapse = GetTime()
    end

    if (GetTime() - lapse) >= 1 then --each 1 second
        --message('debug: 1 second')
        second = second + 1

        if second >= 60 then --each 1 minute
            --message('debug: lastminute')
            local playerHour = timezone(hour, GetZoneText())
            setUpCycle(playerHour, minute, second) --45265

            minute = minute + 1
            second = 0
            if minute >= 60 then
                minute = 0
                hour = hour + 1
                if hour >= 24 then
                    hour = 0
                end
            end
        end
        
        if GameTooltip:IsOwned(TimeOfDayIndicatorFrame) then
            --message('debug: tooltip owned')
            tooltipUpdate(hour, minute, second)
        end
        
        if timeToChange then
            --message('debug: timeToChange')
            local time = timeToSeconds(hour, minute, second)
            
            if magicGlow:IsShown() and time - timeToChange > 1 then
                if time - timeToChange >= 5 or magicGlow:GetAlpha() == 0 then
                    magicGlow:Hide()
                    timeToChange = nil
                else
                    UIFrameFadeOut(magicGlow, 2.0, 0.75, 0.0)
                end

            elseif time == GAMETIME_DUSK or time == GAMETIME_DAWN then
                magicGlow:Show()
                UIFrameFadeIn(magicGlow, 1.25, 0.0, 0.75)
                timeToChange = time
                
                if time == GAMETIME_DUSK then PlaySoundFile('Interface\\AddOns\\TimeOfDayIndicator\\W3UI_Resources\\duskwolf.wav')
                else PlaySoundFile('Interface\\AddOns\\TimeOfDayIndicator\\W3UI_Resources\\daybreakrooster.wav') end
            end
        end
        
        lapse = GetTime()
    end
end

TimeOfDayIndicatorFrame:SetScript('OnEvent', function()
    if event == 'CHAT_MSG_SYSTEM' and strfind(arg1, 'Server Time:', 1) then
        local time = strsub(arg1, 30, -1)
        --local time = strsub(strfind(arg1, '%02d:%02d:%02d'))
        --Server Time: Tue, 15.08.2023 16:11:13
        local sysH = tonumber(strsub(time, 1, 2))
        local sysM = tonumber(strsub(time, 4, -4))
        local sysS = tonumber(strsub(time, -2, -1))
        
        if not hour or hour and hour ~= sysH then hour = sysH end
        if not minute or minute and minute ~= sysM then minute = sysM end
        if not second or second and second ~= sysS then second = sysS end



        notLapse = GetTime()
        lapse = notLapse
        setUpCycle(GetGameTime(), minute, second)
        if not TimeOfDayIndicatorFrame:IsShown() then
            TimeOfDayIndicatorFrame:Show()
            TimeOfDayIndicatorFrame:SetScript('OnUpdate', OnUpdate)
        end
        --message('debug: '..hour..'?'..minute..'?'..second)
        

    elseif event == 'PLAYER_ENTERING_WORLD' then
        TimeOfDayIndicatorFrame:UnregisterEvent('PLAYER_ENTERING_WORLD')
        if TimeOfDayIndicator_Variables[player] then
            sizeFrameArt(TimeOfDayIndicator_Variables[player])
        else
            TimeOfDayIndicator_Variables[player] = 'human'
            sizeFrameArt(TimeOfDayIndicator_Variables[player])
        end
    end
end)

KALIMDOR = {
    'Amani\'alor',
    'Ashenvale',
    'Azshara',
    'Darkshore',
    'Darnassus',
    'Desolace',
    'Durotar',
    'Dustwallow Marsh',
    'Felwood',
    'Feralas',
    'Gates of Ahn\'Quiraj',
    'Hyjal',
    'Maraudon',
    'Moonglade',
    'Mulgore',
    'Orgrimmar',
    'Silithus',
    'Stonetalon Mountains',
    'Tanaris',
    'Tel\'Abim',
    'Teldrassil',
    'The Barrens',
    'Thousand Needles',
    'Thunder Bluff',
    'Un\'Goro Crater',
    'Wailing Caverns',
    'Winterspring',
    'The Veiled Sea',
    'The Great Sea',
    'Icepoint Rock'
}