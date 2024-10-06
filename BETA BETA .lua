-- Esperar hasta que el juego esté completamente cargado
repeat task.wait(0.25) until game:IsLoaded();

-- Configuración del botón: imagen y tecla para alternar la UI Fluent
getgenv().Image = "rbxassetid://76665714186511"; -- ID de la imagen que aparecerá en el botón
getgenv().ToggleUI = "U"; -- Tecla que alternará la visibilidad de la interfaz Fluent UI

-- Crear el botón y añadir funcionalidad
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

-- Cargar la librería Fluent UI desde la URL proporcionada
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Crear la ventana principal de la UI con Fluent
local Window = Fluent:CreateWindow({
    Title = "RYUMAN HUB BETA",
    SubTitle = "by FINO444",
    TabWidth = 160,
    Size = UDim2.fromOffset(360, 320),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.U
})

-- Crear pestañas en la UI Fluent
local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Settings = Window:AddTab({ Title = "Settings" })
}

-- Variables para el loop del auto click, hitbox y para almacenar la posición del clic
local autoClickEnabled = false
local hitboxEnabled = false
local lastClickPosition = nil -- Variable para guardar la posición del último clic

-- Usar RunService.Heartbeat para ejecutar el código en loop
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

-- Toggle para el auto clicker
Tabs.Main:AddToggle("AutoClicker", {
    Title = "Auto Click",
    Default = false,
    Callback = function(Value)
        autoClickEnabled = Value
        task.spawn(function()
            while autoClickEnabled do
                if lastClickPosition then
                    -- Simular clic en la última posición guardada
                    VirtualUser:Button1Down(lastClickPosition)
                end
                RunService.Heartbeat:Wait() -- Ejecutar en cada frame
            end
        end)
    end
})

-- Toggle para cambiar el tamaño de la hitbox de los jugadores
Tabs.Main:AddToggle("HitboxToggle", {
    Title = "Hitbox All players",
    Default = false,
    Callback = function(Value)
        hitboxEnabled = Value
        task.spawn(function()
            while hitboxEnabled do
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local rootPart = player.Character.HumanoidRootPart
                        rootPart.Size = Vector3.new(9, 9, 9) -- Cambiar el tamaño de la hitbox a 7
                        rootPart.Transparency = 0.5 -- Hacer la hitbox semitransparente (opcional)
                        rootPart.CanCollide = false -- Asegurarse de que no cause colisiones extrañas
                    end
                end
                task.wait(1) -- Esperar un segundo antes de revisar nuevamente
            end
            
            -- Si se desactiva el toggle, restaurar la hitbox al tamaño original
            if not hitboxEnabled then
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local rootPart = player.Character.HumanoidRootPart
                        rootPart.Size = Vector3.new(2, 2, 1) -- Restaurar el tamaño predeterminado de la hitbox
                        rootPart.Transparency = 1 -- Restaurar la transparencia predeterminada
                        rootPart.CanCollide = true
                    end
                end
            end
        end)
    end
})

-- Guardar la posición del clic cuando el jugador hace clic en la pantalla
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        lastClickPosition = Vector2.new(input.Position.X, input.Position.Y) -- Asegúrate de que es un Vector2
    end
end)

-- Mostrar una notificación cuando el script se haya cargado correctamente
Fluent:Notify({
    Title = "GG",
    Content = "Auto Clicker and Hitbox script loaded successfully!",
    Duration = 8
})
