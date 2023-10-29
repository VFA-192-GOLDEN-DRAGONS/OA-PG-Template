
function SetupNavygroup(carrierGroup)
  local navygroup = NAVYGROUP:New(carrierGroup)
  navygroup:Activate()
  navygroup:SetPatrolAdInfinitum()
  navygroup:Cruise(10)

  env.info("Activated NAVYGROUP: " .. carrierGroup:GetName())
  return navygroup
end

function SetupRecoveryTanker(carrierUnit, groupTemplateName, takeoffType)
  local tanker = RECOVERYTANKER:New(carrierUnit, groupTemplateName)
  tanker:SetUnlimitedFuel(true)
  tanker:SetTakeoff(takeoffType or SPAWN.Takeoff.Air)

  -- If we spawned in the air, let's respawn in the air
  if takeoffType == SPAWN.Takeoff.Air then tanker:SetRespawnInAir() end

  env.info("Starting RECOVERYTANKER: " .. groupTemplateName)
  tanker:__Start(5)
  return tanker
end

function SetupRescueHelo(carrierUnit, groupTemplateName, takeoffType)
  local helo = RESCUEHELO:New(carrierUnit, groupTemplateName)
  helo:SetTakeoff(takeoffType or SPAWN.Takeoff.Air)
  if takeoffType == SPAWN.Takeoff.Air then tanker:SetRespawnInAir() end

  env.info("Starting RESCUEHELO: " .. groupTemplateName)
  helo:Start()
 
  -- NOTE: it is very important to define the RESCUEHELO object as global variable.
  -- Otherwise, the lua garbage collector will kill the formation for unknown reasons!
  return helo
end


env.info("Configuring Carrier Groups")


local cvn72Unit = UNIT:FindByName("CVN-72")
local lha1Unit = UNIT:FindByName("LHA-1")

CVN72NavyGroup = SetupNavygroup(GROUP:FindByName("CVN-72 Group"))
LHA1NavyGroup = SetupNavygroup(GROUP:FindByName("LHA-1 Group"))

CVN72Tanker = SetupRecoveryTanker(cvn72Unit, "S-3B Recovery Tanker", SPAWN.Takeoff.Hot)
CVN72Tanker:SetCallsign(CALLSIGN.Tanker.Arco, 1)
CVN72Tanker:SetTACAN(117, "AO2", "X")
CVN72Tanker:SetRadio(317.525, "AM")


-- must store RESCUEHELO objects in a global (see RESCUEHELO documentation)
CVN72RescueHelo = SetupRescueHelo(cvn72Unit, "Navy Rescue Hawk", SPAWN.Takeoff.Hot) 
LHA1RescueHelo = SetupRescueHelo(lha1Unit, "Navy Rescue Hawk", SPAWN.Takeoff.Hot)