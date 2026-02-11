local Seed = math.randomseed(54242572)
local Steepness = 3 -- value 1 to 10, 10 is highest
local MaxHeight = 60

local _LowestHeight = 0
local function GetSurroundingYValues(List:{}, x:number, z:number)
    local SurroundingYValues = {}
    for i = -1, 1 do
        for j = -1, 1 do
            if List[x + i] ~= nil then
                if List[x + i][z + j] ~= nil then
                    table.insert(SurroundingYValues, List[x + i][z + j])
                end
            end
        end
    end
    if #SurroundingYValues == 0 then -- FirstGeneratingHeight
        return {math.random(_LowestHeight, MaxHeight)}
    end
    return SurroundingYValues
end
local function GenerateGroundCoordinates():{"X" | "Y" | "Z"}
    local GroundCoordinates = {}
    -- for each x and z, get a y value
    for x = 0, 250 do
        GroundCoordinates[x] = {}
        for z = 0, 250 do
            local SurroundingYValues = GetSurroundingYValues(GroundCoordinates, x, z)
            local HighestNearYValue = math.max(unpack(SurroundingYValues))
            local LowestNearYValue = math.min(unpack(SurroundingYValues))
            
            local MinY = HighestNearYValue - (Steepness + 2) -- Y has to have at max 10 + Steepness heightDifference from its neighbors
            MinY = math.clamp(MinY, _LowestHeight, MaxHeight) -- Y shouldnt be lower than _LowestHeight or higher than MaxHeight
            
            local MaxY = LowestNearYValue + (Steepness + 2) -- Y has to have at max 10 + Steepness heightDifference from its neighbors
            MaxY = math.clamp(MaxY, _LowestHeight, MaxHeight) -- Y shouldnt be lower than _LowestHeight or higher than MaxHeight
            
            local y = math.random(MinY, MaxY)
            GroundCoordinates[x][z] = y
        end
    end
    return GroundCoordinates
end

local Map = GenerateGroundCoordinates()
for x = 0, #Map do
    for z = 0, #Map[x] do
        local Coordinates = Vector3.new(x, Map[x][z], z)
        local newPart = Instance.new("Part")
        newPart.Anchored = true
        newPart.Color = Color3.new(0, 1, 1)
        newPart.Position = Coordinates
        newPart.Parent = game.Workspace
        --newPart.Size = Vector3.new(1, 1, 1)
    end
end
