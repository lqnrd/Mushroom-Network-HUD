if not aura_env.f then
  local width, height, scaleX = C_Map.GetMapWorldSize(1819)
  if (not height) or (height == 0) then
    scaleX = 1
  else
    scaleX = width / height
  end
  local f = CreateFrame("Frame","TheRingFrame",aura_env.region)
  aura_env.f = f
  f:SetPoint("CENTER")
  f:SetSize(10,10)
  local t = {
    [325620] = {0.5175, 0.3554, 1565, 6944}, -- The Elder Stand
    [325617] = {0.4669, 0.3543, 1565, 6945}, -- Eventide Grove
    [308436] = {0.4135, 0.4010, 1565, 6943}, -- The Stalks
    [325616] = {0.3875, 0.4850, 1565, 6942}, -- Banks of Life
    [325629] = {0.3887, 0.5562, 1819, 6965}, -- Great Unknown
    [325621] = {0.4177, 0.6124, 1565, 6948}, -- Forest's Edge
    [325607] = {0.4579, 0.6644, 1565, 6934}, -- Crumbled Ridge
    [325618] = {0.5287, 0.6800, 1565, 6946}, -- Gormhive
    [325602] = {0.5876, 0.6198, 1702, 6923}, -- Heart of the Forest
    [325660] = {0.6022, 0.5285, 1819, 6972}, -- Deep Unknown
    [325619] = {0.5895, 0.4336, 1565, 6947}, -- Tirna Scithe
    [325614] = {0.5635, 0.3744, 1565, 6941}, -- Stillglade
  }
  f.ids = {}
  for i, v in pairs(t) do
    local poiInfo, name = v[3] and v[4] and C_AreaPoiInfo.GetAreaPOIInfo(v[3], v[4])
    if poiInfo then
      f.ids[i] = f:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
      f.ids[i].dist = 0
      f.ids[i].name = ""
      f.ids[i]:SetTextColor(1, 1, 1, 1)
    end
  end
  function f:UpdatePortalNames()
    for i, v in pairs(t) do
      if f.ids[i] then
        local poiInfo, name = v[3] and v[4] and C_AreaPoiInfo.GetAreaPOIInfo(v[3], v[4])
        if aura_env.config[tostring(i)] and (aura_env.config[tostring(i)] ~= "") then
          name = aura_env.config[tostring(i)]
        elseif poiInfo then
          name = poiInfo.name
        else
          name = GetSpellInfo(i)
        end
        f.ids[i].name = name
        f.ids[i]:SetText(f.ids[i].name or "???")
      end

    end
  end
  f.p = f:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
  f.p:SetText("X")
  f.p:SetTextColor(1, 0, 0, 1)
  function f:UpdateSize()
    self.size = aura_env.config["size"] and tonumber(aura_env.config["size"]) or 1000
  end
  f:UpdateSize()
  function f:UpdatePositions(angle)
    local s = sin(-angle/(2*PI)*360)
    local c = cos(-angle/(2*PI)*360)
    local x, y
    local pos = C_Map.GetPlayerMapPosition(1819,"player")
    for i, v in pairs(t) do
      if f.ids[i] and pos then
        local tDist = ((v[1] - pos.x) ^ 2 + (v[2] - pos.y) ^ 2) ^ 0.5
        f.ids[i].dist = tDist
      end
    end
    local low = math.huge
    local sDI
    for i, v in pairs(t) do
      if f.ids[i] then
        local comp = f.ids[i].dist
        if comp < low then
          low = comp
          sDI = i
        end
      end
    end

    for i, v in pairs(t) do
      if f.ids[i] then
        local nameString = f.ids[i].name
        if i == sDI then
          nameString = "|cFF00FF00" .. nameString .. "|r"
          f.ids[i]:SetText(nameString)
        end
        f.ids[i]:SetText(nameString)
        x, y = scaleX*(v[1]*self.size-self.size/2), -(v[2]*self.size-self.size/2)
        self.ids[i]:SetPoint("CENTER", self, "CENTER", x*c-y*s, x*s+y*c)
      end
    end
    if pos then
      x, y = scaleX*(pos.x*self.size-self.size/2), -(pos.y*self.size-self.size/2)
      self.p:SetPoint("CENTER", self, "CENTER", x*c-y*s, x*s+y*c)
    end
  end
  f:UpdatePositions(GetPlayerFacing() or 0)
  f:SetScript("OnUpdate", function(self)
      self:UpdatePositions(GetPlayerFacing() or 0)
  end)
end
aura_env.f:UpdateSize()
aura_env.f:UpdatePortalNames()
aura_env.f:Hide()