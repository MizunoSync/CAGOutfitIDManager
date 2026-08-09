local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local FILE_NAME = "saved_outfit_data.json"
local MAP_LINK = "https://www.roblox.com/games/12104187655/Untitled-Catalog-Avatar-Creator"

-- Determine where to put the GUI
local guiParent = (gethui and gethui()) or (pcall(function() return CoreGui.Name end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

if guiParent:FindFirstChild("AvatarItemsHUD") then
    guiParent.AvatarItemsHUD:Destroy()
end

-- Create Main UI Elements
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AvatarItemsHUD"
ScreenGui.Parent = guiParent

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 560)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Saved Outfit Viewer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

-- Search Bar Frame
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -20, 0, 32)
SearchFrame.Position = UDim2.new(0, 10, 0, 45)
SearchFrame.BackgroundTransparency = 1
SearchFrame.Parent = MainFrame

local PlayerInput = Instance.new("TextBox")
PlayerInput.Size = UDim2.new(0.7, -5, 1, 0)
PlayerInput.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
PlayerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerInput.PlaceholderText = "Enter Player Name..."
PlayerInput.Text = ""
PlayerInput.Font = Enum.Font.Gotham
PlayerInput.TextSize = 14
PlayerInput.Parent = SearchFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = PlayerInput

local SearchBtn = Instance.new("TextButton")
SearchBtn.Size = UDim2.new(0.3, 0, 1, 0)
SearchBtn.Position = UDim2.new(0.7, 5, 0, 0)
SearchBtn.BackgroundColor3 = Color3.fromRGB(130, 50, 200)
SearchBtn.Text = "Fetch"
SearchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBtn.Font = Enum.Font.GothamBold
SearchBtn.TextSize = 14
SearchBtn.Parent = SearchFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBtn

-- Scrolling List
local ScrollingList = Instance.new("ScrollingFrame")
ScrollingList.Size = UDim2.new(1, -20, 1, -250)
ScrollingList.Position = UDim2.new(0, 10, 0, 85)
ScrollingList.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ScrollingList.BorderSizePixel = 0
ScrollingList.ScrollBarThickness = 4
ScrollingList.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = ScrollingList

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 5)
ListPadding.PaddingBottom = UDim.new(0, 5)
ListPadding.PaddingLeft = UDim.new(0, 5)
ListPadding.PaddingRight = UDim.new(0, 5)
ListPadding.Parent = ScrollingList

-- Bottom Buttons
local BottomFrame = Instance.new("Frame")
BottomFrame.Size = UDim2.new(1, -20, 0, 150)
BottomFrame.Position = UDim2.new(0, 10, 1, -155)
BottomFrame.BackgroundTransparency = 1
BottomFrame.Parent = MainFrame

local BottomLayout = Instance.new("UIListLayout")
BottomLayout.SortOrder = Enum.SortOrder.LayoutOrder
BottomLayout.Padding = UDim.new(0, 8)
BottomLayout.Parent = BottomFrame

local TotalLabel = Instance.new("TextLabel")
TotalLabel.Size = UDim2.new(1, 0, 0, 20)
TotalLabel.BackgroundTransparency = 1
TotalLabel.Text = "Calculating Total Value..."
TotalLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
TotalLabel.TextSize = 15
TotalLabel.Font = Enum.Font.GothamSemibold
TotalLabel.TextXAlignment = Enum.TextXAlignment.Center
TotalLabel.Parent = BottomFrame

local function createButton(text, color, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local CopyBtn = createButton("Copy IDs (Each on new line)", Color3.fromRGB(50, 100, 200), BottomFrame)
local UpdateBtn = createButton("Save Viewed Outfit to JSON", Color3.fromRGB(200, 150, 50), BottomFrame)
local CopyMapBtn = createButton("Copy Map Link", Color3.fromRGB(50, 200, 100), BottomFrame)

-- Core Logic
local currentRenderedIDs = {}

-- Extract IDs from a HumanoidDescription
local function extractIDs(description)
    local ids = {}
    local properties = {
        "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", 
        "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
        "Shirt", "Pants", "GraphicTShirt", "Face", "Head", "Torso", "LeftArm", 
        "RightArm", "LeftLeg", "RightLeg", "RunAnimation", "WalkAnimation", 
        "FallAnimation", "JumpAnimation", "IdleAnimation", "SwimAnimation", "ClimbAnimation"
    }

    for _, prop in ipairs(properties) do
        local success, val = pcall(function() return description[prop] end)
        if success then
            if type(val) == "string" and val ~= "" and val ~= "0" then
                for id in string.gmatch(val, "%d+") do
                    table.insert(ids, tonumber(id))
                end
            elseif type(val) == "number" and val > 0 then
                table.insert(ids, val)
            end
        end
    end
    return ids
end

local function getAvatarIDsFromPlayer(player)
    if not player or not player.Character then return {} end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return {} end
    return extractIDs(humanoid:GetAppliedDescription())
end

local function getPlayerFromString(str)
    if not str or str == "" then return nil end
    str = string.lower(str)
    for _, p in ipairs(Players:GetPlayers()) do
        if string.lower(string.sub(p.Name, 1, #str)) == str or string.lower(string.sub(p.DisplayName, 1, #str)) == str then
            return p
        end
    end
    return nil
end

local function getSavedIDs()
    if isfile and isfile(FILE_NAME) then
        local success, content = pcall(readfile, FILE_NAME)
        if success then
            local s2, decoded = pcall(HttpService.JSONDecode, HttpService, content)
            if s2 and type(decoded) == "table" then return decoded end
        end
    end
    return nil
end

local function saveIDs(ids)
    if writefile then
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, ids)
        if success then pcall(writefile, FILE_NAME, encoded) end
    end
end

-- Render the list to the UI
local function renderItems(itemIDs)
    currentRenderedIDs = itemIDs
    
    for _, child in ipairs(ScrollingList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    TotalLabel.Text = "Calculating Total Value..."
    TotalLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    local totalValue = 0
    
    task.spawn(function()
        for _, id in ipairs(itemIDs) do
            local success, info = pcall(function()
                return MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset)
            end)
            
            local price = (success and info.PriceInRobux) or 0
            local name = (success and info.Name) or "Unknown Item"
            totalValue = totalValue + price
            
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 40)
            card.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            card.BorderSizePixel = 0
            card.Parent = ScrollingList
            
            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 4)
            cCorner.Parent = card
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.7, -10, 0.5, 0)
            nameLabel.Position = UDim2.new(0, 5, 0, 2)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = card
            
            local idLabel = Instance.new("TextLabel")
            idLabel.Size = UDim2.new(0.7, -10, 0.5, 0)
            idLabel.Position = UDim2.new(0, 5, 0.5, -2)
            idLabel.BackgroundTransparency = 1
            idLabel.Text = "ID: " .. tostring(id)
            idLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            idLabel.TextSize = 12
            idLabel.Font = Enum.Font.Gotham
            idLabel.TextXAlignment = Enum.TextXAlignment.Left
            idLabel.Parent = card
            
            local priceLabel = Instance.new("TextLabel")
            priceLabel.Size = UDim2.new(0.3, -5, 1, 0)
            priceLabel.Position = UDim2.new(0.7, 0, 0, 0)
            priceLabel.BackgroundTransparency = 1
            priceLabel.Text = price > 0 and ("R$ " .. tostring(price)) or "Off-sale"
            priceLabel.TextColor3 = price > 0 and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 200)
            priceLabel.TextSize = 14
            priceLabel.Font = Enum.Font.GothamBold
            priceLabel.TextXAlignment = Enum.TextXAlignment.Right
            priceLabel.Parent = card
            
            ScrollingList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
            TotalLabel.Text = "Total Value: R$ " .. tostring(totalValue)
            
            task.wait(0.05)
        end
        
        if #itemIDs == 0 then
            TotalLabel.Text = "No items found."
            TotalLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
        end
    end)
end

-- Button Connections
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CopyMapBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(MAP_LINK)
        CopyMapBtn.Text = "Link Copied!"
        CopyMapBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        task.wait(1.5)
        CopyMapBtn.Text = "Copy Map Link"
        CopyMapBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    end
end)

SearchBtn.MouseButton1Click:Connect(function()
    local query = PlayerInput.Text
    if query == "" then
        Title.Text = "Viewing: Your Avatar"
        renderItems(getAvatarIDsFromPlayer(LocalPlayer) or {})
        return
    end

    local target = getPlayerFromString(query)
    if target then
        Title.Text = "Viewing: " .. target.DisplayName
        local ids = getAvatarIDsFromPlayer(target)
        if #ids > 0 then
            renderItems(ids)
        else
            TotalLabel.Text = "Character not loaded for " .. target.Name
            TotalLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
            renderItems({})
        end
    else
        TotalLabel.Text = "Player not found!"
        TotalLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        local stringList = table.concat(currentRenderedIDs, "\n")
        setclipboard(stringList)
        CopyBtn.Text = "Copied to Clipboard!"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        task.wait(1.5)
        CopyBtn.Text = "Copy IDs (Each on new line)"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    end
end)

UpdateBtn.MouseButton1Click:Connect(function()
    UpdateBtn.Text = "Updating Save File..."
    saveIDs(currentRenderedIDs)
    Title.Text = "Viewing: JSON Saved Outfit"
    task.wait(0.5)
    UpdateBtn.Text = "Save Viewed Outfit to JSON"
end)

-- Initialize
local function init()
    local ids = getSavedIDs()
    if ids then
        Title.Text = "Viewing: JSON Saved Outfit"
        renderItems(ids)
    else
        Title.Text = "No Save Found - Grabbing Yours"
        local current = getAvatarIDsFromPlayer(LocalPlayer) or {}
        saveIDs(current)
        renderItems(current)
    end
end

init()
