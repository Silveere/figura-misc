for key, value in pairs(vanilla_model) do
	value.setEnabled(false)
end
for key, value in pairs(armor_model) do
	value.setEnabled(false)
end
for k, v in pairs(held_item_model) do
	v.setEnabled(false)
end


function skinModel()

	if player.getAnimation() == "CROUCHING" then
		model.Player.legs.setPos({0,-2,5})
	else
		model.Player.legs.setPos({0,0,0})
	end
end

function explode_dud()
	sound.playSound('entity.generic.explode', player.getPos(), vectors.of{1, 0.75})
	particle.addParticle('minecraft:explosion_emitter', player.getPos())
end

action_wheel.SLOT_1.setItem("minecraft:gunpowder")
action_wheel.SLOT_1.setTitle("sssss...")
action_wheel.SLOT_1.setFunction(function() explode() end)

explode_tick=0
last_explode_tick=0
is_exploding=false
function lerp(a, b, t) return a+((b-a)*t) end
function cubic(x, a, b) return ((x*(1/a))^3)*b end
function explode()
	is_exploding=true
	sound.playSound('entity.creeper.primed', player.getPos(), vectors.of{1, 0.5})
end
function renderExplode(val)
	local x=val/20

	local scale=vectors.of{0.35, 0.1, 0.35}

	local jitter=(val%2 >= 1) and 0.005 or 0
	local flash=(val%6 >= 3)
	local flash_intensity=math.ceil(math.min(15, cubic(x, 1.5, 1)*8+6))

	if flash then
		model.Player.setOverlay(vectors.of{flash_intensity, 15})
	else
		model.Player.setOverlay(vectors.of{0, 15})
	end

	model.Player.setScale{cubic(x, 1.5, scale.x)+1, cubic(x, 1.5, scale.y)+jitter+1, cubic(x, 1.5, scale.z)+1}
end
function animTick()
	if explode_tick >= 30 then
		explode_tick=0
		last_explode_tick=0
		is_exploding=false
		explode_dud()
	end
	if is_exploding then
		last_explode_tick=explode_tick
		explode_tick = explode_tick + 1
	end
end

function tick()
	animTick()
end

function render(delta)
	skinModel()
	renderExplode(lerp(last_explode_tick, explode_tick, delta))
end
