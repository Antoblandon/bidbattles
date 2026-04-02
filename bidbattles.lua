-- ==========================================
-- 1. CONFIGURACIÓN E INTERFAZ
-- ==========================================
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Borrar interfaz anterior si existe (para evitar duplicados al re-ejecutar)
if playerGui:FindFirstChild("PredictorBidBattles") then
    playerGui.PredictorBidBattles:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PredictorBidBattles"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 120)
mainFrame.Position = UDim2.new(0, 10, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas para que se vea más pro
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
-- 2. BASE DE DATOS Y LÓGICA DE CÁLCULO
-- ==========================================
local precios = {
    ["CajaMadera"] = 100,
    ["TelevisorViejo"] = 450,
    ["CajaFuerte"] = 2000,
    ["LaptopGamer"] = 1800,
    ["Sofa"] = 700,
    ["CajaMisteriosa"] = 500
}

local function calcularYMostrar(carpeta)
    local valorTotal = 0
    local objetosContados = 0

    for _, item in pairs(carpeta:GetChildren()) do
        -- Buscamos el precio o asignamos uno base si es desconocido
        local valor = precios[item.Name] or 75 
        valorTotal = valorTotal + valor
        objetosContados = objetosContados + 1
    end

    -- RECOMENDACIÓN DE GASTO:
    -- Si quieres ganar dinero, no puedes gastar más del 70-80% del valor total.
    local gastoRecomendado = valorTotal * 0.70 

    infoLabel.Text = string.format(
        "📦 OBJETOS: %d\n\n" ..
        "💰 VALOR TOTAL: $%d\n" ..
        "🔥 NO GASTAR MÁS DE: $%d\n\n" ..
        "ESTADO: ¡Garaje Calculado!",
        objetosContados, valorTotal, math.floor(gastoRecomendado)
    )
    
    -- Cambio de color visual para alertar
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 85, 0) -- Verde cuando calcula
    task.wait(5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Vuelve a gris
end

-- ==========================================
-- 3. DETECTOR AUTOMÁTICO (EVENTOS)
-- ==========================================

-- Esta función "escucha" cada vez que algo nuevo aparece en el Workspace
workspace.ChildAdded:Connect(function(child)
    -- En Bid Battles, cuando aparece un garaje, suele tener un nombre específico
    -- Cambia "GarageContent" por el nombre real que veas en el explorador
    if child.Name == "GarageContent" or child:FindFirstChild("ItemHolder") then
        infoLabel.Text = "Detectando nuevo garaje..."
        task.wait(0.5) -- Breve espera para que carguen todos los items
        calcularYMostrar(child)
    end
end)

print("Predictor de Subastas cargado y esperando eventos...")
