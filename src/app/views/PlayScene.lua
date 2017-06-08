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
    --[[
    local rootNode = self:getResourceNode()
    local scene = rootNode:getScene()

    local fruit = FruitItem:create(1,1)
    fruit:setPosition(display.cx, display.cy)
    rootNode:addChild(fruit)

    local fruit = FruitItem:create(1,1)
    fruit:setPosition(display.cx + FruitItem.getWidth(), display.cy + FruitItem.getWidth())
    rootNode:addChild(fruit)
    ]]

    self:init()

end

function PlayScene:init()

    self.xCount = 8
    self.yCount = 8
    self.gap = 3
    self.startX = (display.width - self.xCount * FruitItem.getWidth() - (self.xCount - 1) * self.gap)/2
    self.startY = (display.height - self.yCount * FruitItem.getWidth() - (self.yCount - 1) * self.gap)/2 - 30
    self.matrix = {}

    	-- 等待转场特效结束后再加载矩阵
	--[[ 3.10使用该函数报错
    self:getResourceNode():setonEnterTransitionDidFinishCallback(function()
		self:initMartix()
	end)
    ]]
    self:getResourceNode():registerScriptHandler(function(event)

        if event == "enterTransitionFinish" then
            self:initMatrix()            
        end
    end)
    
end

function PlayScene:initMatrix()
    
    for y = 1, self.yCount do
        for x = 1, self.xCount do
            self:createAndDropFruit(x,y)
        end
    end
end

function PlayScene:createAndDropFruit(x, y, fruitIndex)

    local tempP = self:getFruitPosition(x,y)
    local startPosition = cc.p(tempP.x, tempP.y + display.height/2)
    local endPosition = cc.p(tempP.x, tempP.y)

    local newFruit = FruitItem:create(x,y)
    self.matrix[ (y - 1) * self.xCount + x ] = newFruit 
    newFruit:setPosition(startPosition)

    local speed = startPosition.y / (2 * display.height)
    newFruit:runAction(cc.MoveTo:create(speed, endPosition))
    self:getResourceNode():addChild(newFruit)
    
    newFruit:setTouchEnabled(true)
    newFruit:addClickEventListener(function ()
        --printf("new fruit click")
        if newFruit.isActive then
            newFruit:setActive(false)
        else
            newFruit:setActive(true)
        end

    end)
    

end

function PlayScene:getFruitPosition(x, y)

    local px = self.startX + (x - 1)*(FruitItem.getWidth() + self.gap) + FruitItem.getWidth()/2     
    local py = self.startY + (y - 1)*(FruitItem.getWidth() + self.gap) + FruitItem.getWidth()/2
    return cc.p(px, py)
end

return PlayScene
