-- ==========================================
-- 1. CONFIGURACIÓN E INTERFAZ (Movida a la derecha)
-- ==========================================
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("PredictorBidBattles") then
    playerGui.PredictorBidBattles:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PredictorBidBattles"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 120)
-- Cambiamos la posición a la derecha de la pantalla
mainFrame.Position = UDim2.new(1, -230, 0.5, -60) 
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -20)
infoLabel.Position = UDim2.new(0, 10, 0, 10)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextSize = 15
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Text = "ESTADO: Esperando garaje..."
infoLabel.Parent = mainFrame

-- ==========================================
-- 2. BASE DE DATOS Y LÓGICA (Simplificada para prueba)
-- ==========================================
local precios = {
    ["CajaMadera"] = 100,
}

local function calcularYMostrar(carpeta)
    local objetosContados = 0
    for _, item in pairs(carpeta:GetChildren()) do
        objetosContados = objetosContados + 1
    end
    
    infoLabel.Text = "¡GARAJE DETECTADO!\nObjetos: " .. objetosContados
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 85, 0) 
end

-- ==========================================
-- 3. DETECTOR AUTOMÁTICO (MODO DEBUG)
-- ==========================================
workspace.ChildAdded:Connect(function(child)
    -- ESTO ES NUEVO: Imprimirá en la consola TODO lo que aparezca
    print("El juego generó: " .. child.Name)
    
    -- Seguimos buscando la carpeta (pronto cambiaremos este nombre)
    if child.Name == "GarageContent" then
        calcularYMostrar(child)
    end
end)

print("==== PREDICTOR V2 CARGADO ====")
