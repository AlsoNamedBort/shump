function love.load()
	love.window.setMode(240, 320)
	timer = 0
	sprites = {}
	sprites = love.graphics.newImage("/sprites/chara1.png")
	shotSprites = love.graphics.newImage("/sprites/icon0.png")

	player = {}
	player.x = 120
	player.y = 280
	player.width = 5
	player.height = 5
	player.speed = 200
	player.shots = {}
	player.shotStrength = 1
	player.shots.shotSprite = love.graphics.newQuad(
		6, 47, 3, 16, shotSprites:getWidth(), shotSprites:getHeight())
	player.sprite = love.graphics.newQuad(
		7, 3, 18, 29, sprites:getWidth(), sprites:getHeight())
	player.moving = love.graphics.newQuad(
		132, 0, 24, 32, sprites:getWidth(), sprites:getHeight())
	player.go = false
	player.isShooting = 0

	enemies = {}

	enemy = {}
	enemy.__index = enemy
	function enemy.create()
		local e = {}
		setmetatable(e, enemy)
		e.width = 14
		e.height = 29
		e.health = 3
		e.speed = 1
		e.sprite = love.graphics.newQuad(
			7, 35, 18, 29, sprites:getWidth(), sprites:getHeight())
		e.x = 0
		e.y = 0
		e.curve = love.math.newBezierCurve(0, 0, 0, 250, 245, 325)
		e.j = 0
		e.speed = .01
		return e
	end
	spawnTable = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
end

function love.keypressed(key)
	if key == "return" and startTimer ~= true then
		startTimer = true
		timer = 0
	end
end

function love.update(dt)
	player.go = false
	-- if startTimer then
	-- 	baseTimer = baseTimer + dt
	-- end
	-- if baseTimer > 1 then
	-- 	baseTimer = baseTimer - 1
	-- 	timer = timer + 1
	-- end
	if love.keyboard.isDown(" ") then
		if player.isShooting > .05 then
			shoot()
			player.isShooting = 0
		end
		player.isShooting = player.isShooting + dt
	end
	if love.keyboard.isDown("left") then
		player.x = player.x - player.speed * dt
		player.go = true
	end
	if love.keyboard.isDown("right") then
		player.x = player.x + player.speed * dt
		player.go = true
	end
	if love.keyboard.isDown("up") then
		player.y = player.y - player.speed * dt
		player.go = true
	end
	if love.keyboard.isDown("down") then
		player.y = player.y + player.speed * dt
		player.go = true
	end
	
	local remEnemy = {}
	local remShot = {}

	for i,v in ipairs(player.shots) do
		v.y = v.y - dt * 500

		if v.y < 0 then
			table.insert(remShot, i)
		end

		for ii,vv in ipairs(enemies) do
			if CheckCollision(v.x, v.y, 2, 5, vv.x, vv.y, vv.width, vv.height) then
				vv.health = vv.health - player.shotStrength
				if vv.health == 0 then
					table.insert(remEnemy, ii)
				end
				table.insert(remShot, i)
			end
		end
	end

	for i,v in ipairs(remEnemy) do
		table.remove(enemies, v)
	end

	for i,v in ipairs(remShot) do
		table.remove(player.shots, v)
	end

	for i,v in ipairs(spawnTable) do
		if startTimer and timer == v then
			enemies[#enemies + 1] = enemy.create()
			z = v
		else
			timer = timer + dt
		end
	end


	if startTimer then
		for i,v in ipairs(enemies) do
			v.j = v.j +  v.speed
			if v.j >= 1 then
				v.j = .99
			end
			v.x, v.y = v.curve:evaluate(v.j)
		end
	end
end
 
function love.draw()
	love.graphics.setColor(0, 255, 0, 255)
	if z ~= nil then
		love.graphics.print(z, 120, 120)
	end
	for i,v in ipairs(enemies) do
		love.graphics.draw(sprites, v.sprite, v.x, v.y)
	end
	if player.go == true then
		love.graphics.draw(sprites, player.moving, player.x, player.y)
	else
		love.graphics.draw(sprites, player.sprite, player.x, player.y)
	end
	for i,v in ipairs(player.shots) do
		love.graphics.draw(shotSprites, player.shots.shotSprite, (v.x + player.width), v.y)
	end
end

function shoot()
	local shot = {}
	shot.x = player.x + player.width/2
	shot.y = player.y

	table.insert(player.shots, shot)
end

function CheckCollision(ax1, ay1, aw, ah, bx1, by1, bw, bh)
	local ax2, ay2, bx2, by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end