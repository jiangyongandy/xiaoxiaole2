-- jiang 17/6/7

FruitItem = require("app.views.FruitItem")

local PlayScene = class("PlayScene", cc.load("mvc").ViewBase)

PlayScene.RESOURCE_FILENAME = "PlayScene.csb"

-- 获取UI控件
PlayScene.RESOURCE_BINDING = {
    ["Button_1"]   = {["varname"] = "btn",},
    ["mainBG_1"]   = {["varname"] = "bgSprite",},
}

function PlayScene:onCreate()
    
    printf("resource node = %s", tostring(self:getResourceNode()))
    local rootNode = self:getResourceNode()
    local scene = rootNode:getScene()

    local fruit = FruitItem:create(1,1)
    fruit:setPosition(display.cx, display.cy)
    rootNode:addChild(fruit)

    local fruit = FruitItem:create(1,1)
    fruit:setPosition(display.cx + FruitItem.getWidth(), display.cy + FruitItem.getWidth())
    rootNode:addChild(fruit)


end

return PlayScene
