local artifact = Artifact.new("Darkness")
artifact.unlocked = true
artifact.loadoutSprite = Sprite.find("SelectArtifact2", vanilla) --Sprite.load("art_danger.png", 2, 18, 18)
artifact.loadoutText = "A darkness surrounds you"

--Thanks None!
local halo
do
    local DIAMETER = 128

    local d = DIAMETER
    local r = d/2
    local surface = Surface.new(d, d)
    if Surface.isValid(surface) then
        graphics.setTarget(surface)

        graphics.color(Color.BLACK)
        graphics.rectangle(0, 0, d - 1, d - 1)

        for i = 0, 3 do
            graphics.color(Color.WHITE)
            graphics.alpha(1/3)
            graphics.setBlendMode("subtract")
            graphics.circle(r - 1, r - 1, r - i*(r/4))
        end

        local dynamic = surface:createSprite(r, r)
        halo = dynamic:finalize("Halo")
    end
end

game = {}
game.timer = 0 

callback("onStep", function()
    game.timer = game.timer + 1
end)

callback.register("onDraw", function()
    if artifact.active then
        if halo then
            local player = net.localPlayer or misc.players[1]
            local playerAc = player:getAccessor()

            local SC = 1 + math.sin(game.timer / 25) / 10 
            local w, h = graphics.getHUDResolution()
            local sw, sh = halo.width * SC, halo.height * SC
            local x, y = player.x, player.y
            graphics.drawImage{
                image = halo,
                x = x,
                y = y,
                scale = SC,
            }
            
            graphics.color(Color.BLACK)
            graphics.rectangle(x + sw/2, y - h, x + w - 1, y + h - 1) -- E
            graphics.rectangle(x - w, y - h, x + w - 1, y - sh/2 - 1) -- N
            graphics.rectangle(x - w, y - h, x - sw/2 - 1, y + h - 1) -- W
            graphics.rectangle(x - w, y + sh/2, x + w - 1, y + h - 1) -- S
        end
    end
end)