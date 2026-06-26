if getgenv().texturepack then getgenv().texturepack:Disconnect() end

-- BrickColor name → boosted flat color
local PALETTE = {
    -- Team wool / placed blocks
    ['Bright red']           = Color3.fromRGB(255,  42,  42),
    ['Bright blue']          = Color3.fromRGB( 35, 100, 255),
    ['Lime green']           = Color3.fromRGB( 40, 215,  55),
    ['Bright yellow']        = Color3.fromRGB(255, 210,   0),
    ['Hot pink']             = Color3.fromRGB(255,  55, 170),
    ['Cyan']                 = Color3.fromRGB(  0, 195, 215),
    ['White']                = Color3.fromRGB(245, 245, 250),
    ['Bright orange']        = Color3.fromRGB(255, 125,  15),
    ['Dark orange']          = Color3.fromRGB(235, 105,   5),
    ['Medium orange']        = Color3.fromRGB(255, 140,  20),
    ['Bright violet']        = Color3.fromRGB(135,  45, 210),
    ['Lavender']             = Color3.fromRGB(160, 100, 220),
    -- Ground / neutral map blocks
    ['Medium stone grey']    = Color3.fromRGB(122, 127, 138),
    ['Dark stone grey']      = Color3.fromRGB( 68,  72,  80),
    ['Light stone grey']     = Color3.fromRGB(185, 190, 197),
    ['Smoky grey']           = Color3.fromRGB( 98, 102, 112),
    ['Mid gray']             = Color3.fromRGB(155, 158, 165),
    ['Sand yellow']          = Color3.fromRGB(210, 188, 112),
    ['Brick yellow']         = Color3.fromRGB(215, 192, 120),
    ['Pale yellow']          = Color3.fromRGB(222, 200, 130),
    -- Wood
    ['Reddish brown']        = Color3.fromRGB(148,  80,  34),
    ['Nougat']               = Color3.fromRGB(170, 112,  48),
    ['Dark orange']          = Color3.fromRGB(180,  90,  20),
    -- Obsidian / blast-proof
    ['Really black']         = Color3.fromRGB( 20,  16,  28),
    ['Black']                = Color3.fromRGB( 27,  22,  36),
    -- Resource blocks
    ['Gold']                 = Color3.fromRGB(255, 182,  12),
    ['Bright green']         = Color3.fromRGB(  0, 188,  82),
    ['Dark green']           = Color3.fromRGB( 22, 115,  40),
    ['Sand green']           = Color3.fromRGB( 82, 160, 110),
    ['Electric blue']        = Color3.fromRGB( 62, 205, 222),
    ['Teal']                 = Color3.fromRGB( 18, 175, 165),
    -- Glass / translucent
    ['Ghost grey']           = Color3.fromRGB(175, 195, 215),
    ['Pastel blue']          = Color3.fromRGB( 85, 138, 208),
    ['Light blue']           = Color3.fromRGB( 70, 150, 225),
    ['Sand blue']            = Color3.fromRGB( 72, 118, 175),
}

local SKIP_NAMES = {
    HumanoidRootPart = true, Head = true, Torso = true,
    UpperTorso = true, LowerTorso = true,
    ['Left Arm'] = true, ['Right Arm'] = true,
    ['Left Leg'] = true, ['Right Leg'] = true,
    LeftUpperArm = true, RightUpperArm = true,
    LeftLowerArm = true, RightLowerArm = true,
    LeftHand = true, RightHand = true,
    LeftUpperLeg = true, RightUpperLeg = true,
    LeftLowerLeg = true, RightLowerLeg = true,
    LeftFoot = true, RightFoot = true,
}

local function boostColor(c)
    local h, s, v = Color3.toHSV(c)
    s = math.min(1, s * 1.4)
    v = math.min(1, v * 1.08)
    return Color3.fromHSV(h, s, v)
end

local function apply(part)
    if not (part:IsA('BasePart') or part:IsA('UnionOperation')) then return end
    if SKIP_NAMES[part.Name] then return end
    pcall(function()
        part.Material    = Enum.Material.SmoothPlastic
        part.TopSurface  = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        part.Color = PALETTE[part.BrickColor.Name] or boostColor(part.Color)
        for _, child in part:GetChildren() do
            if child:IsA('Texture') or child:IsA('Decal') then
                child:Destroy()
            end
        end
    end)
end

for _, v in workspace:GetDescendants() do
    task.defer(apply, v)
end

getgenv().texturepack = workspace.DescendantAdded:Connect(function(v)
    task.defer(apply, v)
end)
