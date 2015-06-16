function love.load()
	sprites = love.graphics.newImage("/sprites/chara1.png")

	player = {}
	player.x = 300
	player.y = 450
	player.width = 5
	player.height = 5
	player.speed = 150 
	player.shots = {}
	player.sprite = love.graphics.newQuad(7, 3, 18, 29, sprites:getWidth(), sprites:getHeight())
	player.moving = love.graphics.newQuad(132, 0, 24, 32, sprites:getWidth(), sprites:getHeight())
	player.go = false

	enemies = {}

	for i = 0,7 do
		enemy = {}
		enemy.width = 40
		enemy.height = 20
		enemy.x = i * (enemy.width + 60) + 100
		enemy.y = enemy.height + 100
		table.insert(enemies, enemy)
	end
end



function love.keyreleased(key)
	if (key == " ") then
		shoot()
	end
end

function love.update(dt)
	player.go = false
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
		v.y = v.y - dt * 100

		if v.y < 0 then
			table.insert(remShot, i)
		end

		for ii,vv in ipairs(enemies) do
			if CheckCollision(v.x, v.y, 2, 5, vv.x, vv.y, vv.width, vv.height) then
				table.insert(remEnemy, ii)
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
		v.y = v.y + dt

		if v.y > 465 then
		end
	end

end
 
function love.draw()
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.rectangle("fill", 0, 465, 800, 150)

	love.graphics.setColor(255, 255, 255, 255)
	-- love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
	
	if player.go == true then
		love.graphics.draw(sprites, player.moving, player.x, player.y)
	else
		love.graphics.draw(sprites, player.sprite, player.x, player.y)
	end
	love.graphics.setColor(255, 255, 255, 255)
	for i,v in ipairs(player.shots) do
		love.graphics.rectangle("fill", v.x, v.y, 2, 5)
	end

	love.graphics.setColor(0, 255, 255, 255)
	for i,v in ipairs(enemies) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
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