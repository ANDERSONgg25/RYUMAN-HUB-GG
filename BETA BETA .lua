repeat task.wait(0.25) until game:IsLoaded();

getgenv().Image = "rbxassetid://76665714186511";
getgenv().ToggleUI = "U";

task.spawn(function()
    if not getgenv().LoadedMobileUI then 
        getgenv().LoadedMobileUI = true

        local OpenUI = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")

        OpenUI.Name = "OpenUI"
        OpenUI.Parent = game:GetService("CoreGui")

        ImageButton.Parent = OpenUI
        ImageButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
        ImageButton.BackgroundTransparency = 1
        ImageButton.Position = UDim2.new(0.9, 0, 0.1, 0)
        ImageButton.Size = UDim2.new(0, 45, 0, 45)
        ImageButton.Image = getgenv().Image
        ImageButton.Draggable = true

        UICorner.CornerRadius = UDim.new(5, 5)
        UICorner.Parent = ImageButton

        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, getgenv().ToggleUI, false, game)
        end)
    end
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "RYUMAN HUB",
    SubTitle = "by FINO444",
    TabWidth = 160,
    Size = UDim2.fromOffset(380, 380),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.U
})

local autoClickEnabled = false

local AutoClickToggle = Window:AddToggle("Auto Click", {
    Title = "Activar Auto Click",
    Default = false,
    Callback = function(state)
        autoClickEnabled = state
    end
})

Fluent:Notify({
    Title = "GG",
    Content = "Script loaded successfully!",
    Duration = 8
})

local VirtualUser = game:GetService("VirtualUser")

while true do
    task.wait(0.05)

    if autoClickEnabled then
        VirtualUser:Button1Down(Vector2.new(1e4, 1e4))
        task.wait(0.05)
        VirtualUser:Button1Up(Vector2.new(1e4, 1e4))
    end
end
