function love.load()
	sprites = {}
	sprites = love.graphics.newImage("/sprites/chara1.png")
	shotSprites = love.graphics.newImage("/sprites/icon0.png")

	player = {}
	player.x = 300
	player.y = 450
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

	for i = 0,17 do
		enemy = {}
		enemy.width = 14
		enemy.height = 29
		enemy.health = 5
		enemy.speed = 1
		enemy.sprite = love.graphics.newQuad(
			7, 35, 18, 29, sprites:getWidth(), sprites:getHeight())
		enemy.x = i * (enemy.width + 30) + 10
		enemy.y = 0
		table.insert(enemies, enemy)
	end
end

function love.update(dt)
	player.go = false
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
	remEnemy.health = 0
	local remShot = {}

	for i,v in ipairs(player.shots) do
		v.y = v.y - dt * 500

		if v.y < 0 then
			table.insert(remShot, i)
		end

		for ii,vv in ipairs(enemies) do
			if CheckCollision(v.x, v.y, 2, 5, vv.x, vv.y, vv.width, vv.height) then
				enemies[ii].health = enemies[ii].health - player.shotStrength
				if enemies[ii].health == 0 then
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

	for i,v in ipairs(enemies) do
		v.y = v.y + v.speed
	end

end
 
function love.draw()
	if player.go == true then
		love.graphics.draw(sprites, player.moving, player.x, player.y)
	else
		love.graphics.draw(sprites, player.sprite, player.x, player.y)
	end
	for i,v in ipairs(player.shots) do
		love.graphics.draw(shotSprites, player.shots.shotSprite, (v.x + player.width), v.y)
	end
	for i,v in ipairs(enemies) do
		love.graphics.draw(sprites, enemies[i].sprite, enemies[i].x, enemies[i].y)
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