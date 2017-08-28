require "/scripts/vec2.lua"
require "/scripts/util.lua"

function init()
  self.playerId = projectile.sourceEntity()
  self.controlForce = config.getParameter("controlForce")
  self.maxSpeed = config.getParameter("speed", 60)
  self.hitTimer = config.getParameter("hitTimer")
  self.cooldown = 0
  mcontroller.applyParameters(
  	{
  		collisionEnabled = false
  	}
  )
end

function update(dt)

  if self.cooldown > 0 then
  	self.cooldown = math.max(0, self.cooldown - dt)
  	return
  end

  local entityPos = nil
  local pos = mcontroller.position()
  local distance = -1
  local entities = world.entityQuery(pos, 20, {withoutEntityId = self.playerId})
  for _, e in ipairs(entities) do
  	if world.entityAggressive(e) then
  		epos = world.entityPosition(e)
  		local newDistance = world.magnitude(pos, epos)
  		if (newDistance < distance or distance < 0) then
  			distance = newDistance
  			entityPos = epos
  		end
  	end
  end

  if distance > 0 then
  	if distance < 1 then
  		self.cooldown = self.hitTimer
  		return
  	end
  	--sb.logInfo("tracking")
  	local toTarget = world.distance(entityPos, pos)
    toTarget = vec2.norm(toTarget)
    --local angle = math.atan(entityPos[2]-pos[2],entityPos[1]-pos[1])
    --mcontroller.approachVelocityAlongAngle(angle, self.maxSpeed, self.controlForce/2, false)
    mcontroller.approachVelocity(vec2.mul(toTarget, self.maxSpeed), self.controlForce)
    --mcontroller.approachVelocityAlongAngle(angle, self.maxSpeed, self.controlForce/2, false)
  end
  mcontroller.setRotation(math.atan(mcontroller.velocity()[2], mcontroller.velocity()[1]))
end