
netherY = 30

baseDelay = 0.1
-- menuDelay = 0.2
menuDelay = 0.12
dimensionLoad = 3.0
menuTime = 2.0
worldGenTime = 16.0

trialsRanSoFar = 0
trialsToRun = 1000
trialLength = 40
strongholdPoint = nil

returnString = "return"
locateString = "/locate stronghold"
makeFirstPortalString = "/setblock ~ 2 ~ minecraft:nether_portal"
tpIntoFirstPortalString = "/tp @p ~ 2 ~"
tpToBaseString = "/tp @p 300 200 300"

setBlockSimpleString = "/setblock "
spaceString = " "
netherPortalString = " minecraft:nether_portal"
simpleTpString = "/tp @p "
aboveCeilingNetherYString = " 128 "

netherStronghold = nil

netherStrongholdX = nil
netherStrongholdZ = nil
netherStrongholdFloorX = nil
netherStrongholdFloorZ = nil
netherStrongholdXString = nil
netherStrongholdZString = nil
typeBufferString = nil

ref0 = nil
ref1 = nil
ref2 = nil
ref3 = nil
ref4 = nil
ref5 = nil
ref6 = nil
ref7 = nil
ref8 = nil
ref9 = nil

function pressEnter()
    hs.eventtap.keyStroke(nil, returnString)
end

function typeLocateCommand()
    hs.eventtap.keyStrokes(locateString)
end

function typeMakeFirstPortal()
    hs.eventtap.keyStrokes(makeFirstPortalString)
end

function tpIntoFirstPortal()
    hs.eventtap.keyStrokes(tpIntoFirstPortalString)
end

function typeMakeNetherSidePortal()
    hs.eventtap.keyStrokes(setBlockSimpleString)
    netherStrongholdFloorX = math.floor(netherStronghold.x)
    typeBufferString = tostring(netherStrongholdFloorX)
    hs.eventtap.keyStrokes(typeBufferString)
    hs.eventtap.keyStrokes(spaceString)
    typeBufferString = tostring(netherY)
    hs.eventtap.keyStrokes(typeBufferString)
    hs.eventtap.keyStrokes(spaceString)
    netherStrongholdFloorZ = math.floor(netherStronghold.y)
    typeBufferString = tostring(netherStrongholdFloorZ)
    hs.eventtap.keyStrokes(typeBufferString)
    hs.eventtap.keyStrokes(netherPortalString)
end

function tpNearNetherSidePortal()
    hs.eventtap.keyStrokes(simpleTpString)
    typeBufferString = tostring(netherStronghold.x)
    hs.eventtap.keyStrokes(typeBufferString)
    hs.eventtap.keyStrokes(aboveCeilingNetherYString)
    typeBufferString = tostring(netherStronghold.y)
    hs.eventtap.keyStrokes(typeBufferString)
end

function tpIntoNetherSidePortal()
    hs.eventtap.keyStrokes(simpleTpString)
    typeBufferString = tostring(netherStronghold.x)
    hs.eventtap.keyStrokes(typeBufferString)
    hs.eventtap.keyStrokes(spaceString)
    typeBufferString = tostring(netherY)
    hs.eventtap.keyStrokes(typeBufferString)
    hs.eventtap.keyStrokes(spaceString)
    typeBufferString = tostring(netherStronghold.y)
    hs.eventtap.keyStrokes(typeBufferString)
end

function typeTpToBase()
    hs.eventtap.keyStrokes(tpToBaseString)
end


function file_exists(file)
    f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

function getPointFromLine(line)
    ind = 0
    xStr = 'blank'
    zStr = 'blank'
    for token in string.gmatch(line, "[^%s]+") do
        if ind == 9 then
            xStr = token
        end
        if ind == 11 then
            zStr = token
        end
        ind = ind + 1
    end
    xStr = string.sub(xStr, 2, -2)
    zStr = string.sub(zStr, 1, -2)
    print('coords are ' .. xStr .. ' and ' .. zStr)
    return hs.geometry(tonumber(xStr), tonumber(zStr))
end
  

function lines_from(file)
    if not file_exists(file) then return {} end
    print('file exists')
    lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end



function getStrongholdLocationFromWorldFile()
    my_lines = lines_from('/Applications/MultiMC.app/Contents/MacOS/instances/1.16.1-1/.minecraft/logs/latest.log')
    max_k = 0
    correct_line = nil
    for k,v in pairs(my_lines) do
        -- if string.find({subject="The nearest stronghold", pattern=v, plain=true}) then
        if string.find(v, "%f[%a]".."stronghold".."%f[%A]") then
            -- print('yes sh line rules ' .. k)
            if k > max_k then
                -- print('yes best line ' .. k)
                max_k = k
                correct_line = v
            end
        end
    end
    strongholdPoint = getPointFromLine(correct_line)
    ref0 = hs.timer.doAfter(baseDelay*10, tpIntoNether)
end

function getEyeSpyLineNumber()
    my_lines = lines_from('/Applications/MultiMC.app/Contents/MacOS/instances/1.16.1-1/.minecraft/logs/latest.log')
    eye_spy_max_k = 0
    correct_line = nil
    for k,v in pairs(my_lines) do
        -- if string.find({subject="The nearest stronghold", pattern=v, plain=true}) then
        if string.find(v, "%f[%a]".."Spy".."%f[%A]") then
            -- print('yes sh line rules ' .. k)
            if k > eye_spy_max_k then
                -- print('yes best line ' .. k)
                eye_spy_max_k = k
            end
        end
    end
    return eye_spy_max_k
end

-- function clickShLocationInner(ind)
--     modifiedDelay = 0.015
--     baseY = 323.0
--     baseX = 136.0
--     yDiv = 4.0
--     randMult = 3.0
--     randTimeMod = 0.012
--     if ind == 0 then
--         hs.mouse.absolutePosition(hs.geometry(baseX, baseY))
--         hs.eventtap.leftClick(hs.geometry(baseX, baseY))
--         hs.timer.doAfter(modifiedDelay*10, function() clickShLocationInner(ind+1) end)
--     elseif ind == 1 then
--         hs.eventtap.leftClick(hs.geometry(baseX, baseY))
--         hs.timer.doAfter(modifiedDelay+randTimeMod*math.random(), function() clickShLocationInner(ind+1) end)
--     elseif ind == 25 then
--         targetX = baseX+ind-2.0
--         targetY = baseY+(ind/yDiv)
--         hs.mouse.absolutePosition(hs.geometry(targetX, targetY))
--         hs.eventtap.leftClick(hs.geometry(targetX, targetY))
--     else
--         moveToX = baseX+ind+randMult*math.random()
--         moveToY = baseY-randMult+(ind/yDiv)+2.0*math.random()
--         hs.mouse.absolutePosition(hs.geometry(moveToX,moveToY ))
--         -- hs.eventtap.leftClick(hs.geometry(moveToX, moveToY))
--         hs.timer.doAfter(modifiedDelay+randTimeMod*math.random(), function() clickShLocationInner(ind+1) end)
--     end
-- end

-- function clickStrongholdLocation()
--     hs.mouse.absolutePosition(hs.geometry(150.0, 328.0))
--     hs.timer.doAfter(0.01, function() clickShLocationInner(0) end)
-- end

function copyText()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, true):post()
    hs.eventtap.event.newKeyEvent('c', true):post()
    hs.eventtap.event.newKeyEvent('c', false):post()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, false):post()
end

function selectText()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, true):post()
    hs.eventtap.event.newKeyEvent('a', true):post()
    hs.eventtap.event.newKeyEvent('a', false):post()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, false):post()
end



function tpToBase()
    ref0 = hs.timer.doAfter(baseDelay, pressEnter)
    ref1 = hs.timer.doAfter(baseDelay*2, typeTpToBase)
    ref2 = hs.timer.doAfter(baseDelay*3, pressEnter)
end

function runLocateCommand()
    ref0 = hs.timer.doAfter(baseDelay, pressEnter)
    ref1 = hs.timer.doAfter(baseDelay*2, typeLocateCommand)
    ref2 = hs.timer.doAfter(baseDelay*3, pressEnter)
end

function tpIntoStronghold()
    ref0 = hs.timer.doAfter(baseDelay, pressEnter)
    ref1 = hs.timer.doAfter(baseDelay*2, tpIntoNetherSidePortal)
    ref2 = hs.timer.doAfter(baseDelay*3, pressEnter)
    ref3 = hs.timer.doAfter(baseDelay*4+dimensionLoad, checkTrialResult)
end

function setUpNetherSidePortal()
    hs.eventtap.leftClick(hs.geometry(100, 100))
    ref0 = hs.timer.doAfter(baseDelay*2, pressEnter)
    ref1 = hs.timer.doAfter(baseDelay*4, tpNearNetherSidePortal)
    ref2 = hs.timer.doAfter(baseDelay*6, pressEnter)
    ref3 = hs.timer.doAfter(baseDelay*8, pressEnter)
    ref4 = hs.timer.doAfter(baseDelay*12, typeMakeNetherSidePortal)
    ref5 = hs.timer.doAfter(baseDelay*14, pressEnter)
    ref6 = hs.timer.doAfter(baseDelay*19, tpIntoStronghold)
end

function tpIntoNether()
    ref0 = hs.timer.doAfter(baseDelay, pressEnter)
    ref1 = hs.timer.doAfter(baseDelay*3, typeMakeFirstPortal)
    ref2 = hs.timer.doAfter(baseDelay*5, pressEnter)
    ref3 = hs.timer.doAfter(baseDelay*7, pressEnter)
    ref4 = hs.timer.doAfter(baseDelay*9, tpIntoFirstPortal)
    ref5 = hs.timer.doAfter(baseDelay*11, pressEnter)
    netherStronghold = hs.geometry((strongholdPoint.x-4.0)/8.0, (strongholdPoint.y-4.0)/8.0)
    ref6 = hs.timer.doAfter(baseDelay*11+dimensionLoad, setUpNetherSidePortal)
end

function pressEsc()
    hs.eventtap.keyStroke(nil, "escape")
end

function pressTab()
    hs.eventtap.keyStroke(nil, "tab")
end

function pressShiftTab()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.shift, true):post()
    hs.eventtap.event.newKeyEvent('tab', true):post()
    hs.eventtap.event.newKeyEvent('tab', false):post()
    hs.eventtap.event.newKeyEvent(hs.keycodes.map.shift, false):post()
end


function saveTrialResult()
    results_fil = io.open("~/Documents/Games/Minecraft/Speedrunning/stronghold_trials.txt", "a")
    results_fil:write("" .. netherY .. " " .. tostring(did_eye_spy), "\n")
    results_fil:close()
end


function checkTrialResult()
    if getEyeSpyLineNumber() > max_k then
        did_eye_spy = true
    else
        did_eye_spy = false
    end
    saveTrialResult()
    ref0 = hs.timer.doAfter(1.0, exitWorld)
end

function enterSinglePlayer()
    ref0 = hs.timer.doAfter(menuDelay, pressTab)
    ref1 = hs.timer.doAfter(menuDelay*2, pressEnter)
    ref2 = hs.timer.doAfter(menuDelay*3, enterCreateWorld)
end

function enterCreateWorld()
    ref0 = hs.timer.doAfter(menuDelay, pressShiftTab)
    ref1 = hs.timer.doAfter(menuDelay*2, pressShiftTab)
    ref2 = hs.timer.doAfter(menuDelay*3, pressEnter)
    ref3 = hs.timer.doAfter(menuDelay*4, doWorldCreation)
end

function doWorldCreation()
    ref0 = hs.timer.doAfter(menuDelay, pressTab)
    ref1 = hs.timer.doAfter(menuDelay*2, pressEnter)
    ref2 = hs.timer.doAfter(menuDelay*3, pressEnter)
    ref3 = hs.timer.doAfter(menuDelay*4, pressTab)
    ref4 = hs.timer.doAfter(menuDelay*5, pressTab)
    ref5 = hs.timer.doAfter(menuDelay*6, pressTab)
    ref6 = hs.timer.doAfter(menuDelay*7, pressTab)
    ref7 = hs.timer.doAfter(menuDelay*8, pressTab)
    ref8 = hs.timer.doAfter(menuDelay*9, pressTab)
    ref9 = hs.timer.doAfter(menuDelay*10, pressEnter)
    ref10 = hs.timer.doAfter(menuDelay*10+worldGenTime, doTrial)
end


function exitWorld()
    ref0 = hs.timer.doAfter(menuDelay, pressEsc)
    ref1 = hs.timer.doAfter(menuDelay*2, pressTab)
    ref2 = hs.timer.doAfter(menuDelay*3, pressTab)
    ref3 = hs.timer.doAfter(menuDelay*4, pressTab)
    ref4 = hs.timer.doAfter(menuDelay*5, pressTab)
    ref5 = hs.timer.doAfter(menuDelay*6, pressTab)
    ref6 = hs.timer.doAfter(menuDelay*7, pressTab)
    ref7 = hs.timer.doAfter(menuDelay*8, pressTab)
    ref8 = hs.timer.doAfter(menuDelay*9, pressTab)
    ref9 = hs.timer.doAfter(menuDelay*10, pressEnter)
    ref10 = hs.timer.doAfter(menuDelay*10+menuTime, syncThenStart)
    -- hs.timer.doAfter(baseDelay*150, tpIntoNether)
end

function syncThenStart()
    curTime = os.time()
    waitLength = trialLength - (curTime % trialLength)
    print('starting trial at ' .. tostring(curTime) .. ' waiting ' .. tostring(waitLength) .. ' seconds')
    ref0 = hs.timer.doAfter(waitLength, enterSinglePlayer)
end

function doTrial()
    -- hs.timer.doAfter(baseDelay, pressEsc)
    if trialsRanSoFar == trialsToRun then
        return
    end
    trialsRanSoFar = trialsRanSoFar + 1
    netherY = 10 + math.random(0, 70)
    ref0 = hs.timer.doAfter(baseDelay*5, tpToBase)
    ref1 = hs.timer.doAfter(baseDelay*15, runLocateCommand)
    ref2 = hs.timer.doAfter(baseDelay*25, getStrongholdLocationFromWorldFile)
    -- hs.timer.doAfter(baseDelay*150, tpIntoNether)
end


hs.hotkey.bind({"cmd", "shift"}, "T", function()
    win = hs.window.find("Minecraft")
    
    print('yo')
    win:move({0, 0, 350, 350})
    win:focus()
    math.randomseed(os.time())
    ref0 = hs.timer.doAfter(1.0, enterSinglePlayer)
  end)
