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
    self.actives = {}

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

--掉落水果
function PlayScene:createAndDropFruit(x, y, fruitIndex)

    local tempP = self:getFruitPosition(x,y)
    local startPosition = cc.p(tempP.x, tempP.y + display.height/2)
    local endPosition = cc.p(tempP.x, tempP.y)

    local newFruit = FruitItem:create(x,y)
    self.matrix[ self:getMatrixPosition(x,y)] = newFruit 
    newFruit:setPosition(startPosition)

    local speed = startPosition.y / (2 * display.height)
    newFruit:runAction(cc.MoveTo:create(speed, endPosition))
    self:getResourceNode():addChild(newFruit)
    
    newFruit:setTouchEnabled(true)
    newFruit:addClickEventListener(function ()
        --printf("new fruit click")
        --[[
        if newFruit.isActive then
            newFruit:setActive(false)
        else
            newFruit:setActive(true)
        end
        print("初始点击"..newFruit.fruitIndex)
        ]]
        if not newFruit.isActive then
            if self.actives.nums > 0 then
                self:retainActivies()
            end
            self:highLightFruits(newFruit)
        else
            self:removeActives()
        end

    end)
    

end

--高亮相同水果
function PlayScene:highLightFruits(fruitItem)
    
    fruitItem:setActive(true)
    table.insert(self.actives,fruitItem)
    local leftFruit =  self.matrix[ (fruitItem.y - 1) * self.xCount + fruitItem.x - 1 ]
    local rightFruit =  self.matrix[ (fruitItem.y - 1) * self.xCount + fruitItem.x + 1 ]
    local topFruit =  self.matrix[ (fruitItem.y - 1 + 1) * self.xCount + fruitItem.x ]
    local bottomFruit =  self.matrix[ (fruitItem.y - 1 -1) * self.xCount + fruitItem.x]
    local tempFruitTable = {leftFruit, rightFruit, topFruit, bottomFruit}
    --越界检查（重要）！！
    if fruitItem.x - 1 < 1 then 
        table.remove(tempFruitTable, 1)
    end
    if fruitItem.x + 1 > self.xCount then 
        table.remove(tempFruitTable, 2)
    end
    if fruitItem.y + 1 > self.yCount then 
        table.remove(tempFruitTable, 3)
    end
    if fruitItem.y - 1 < 1 then 
        table.remove(tempFruitTable, 4)
    end
    --递归搜索左右上下相同的水果
    for k,fruit in pairs(tempFruitTable) do
        if fruit ~= nil and fruit.fruitIndex == fruitItem.fruitIndex and not fruit.isActive then  
            print("找到一个"..fruit.fruitIndex)
            self:highLightFruits(fruit)
        end
    end
end

--消除高亮水果
function PlayScene:removeActives()
    for k,fruitItem in pairs(self.actives) do
        self:getResourceNode():removeChild(fruitItem)
    end
    self.actives = {}
end

--恢复高亮水果颜色
function PlayScene:retainActivies()
    for k,fruitItem in pairs(self.actives) do
        FruitItem:setActive(false)
    end
    self.actives = {}
end

--由矩阵坐标得到显示坐标
function PlayScene:getFruitPosition(x, y)

    local px = self.startX + (x - 1)*(FruitItem.getWidth() + self.gap) + FruitItem.getWidth()/2     
    local py = self.startY + (y - 1)*(FruitItem.getWidth() + self.gap) + FruitItem.getWidth()/2
    return cc.p(px, py)
end

--矩阵坐标转换tableindex
function PlayScene:getMatrixPosition(x, y)
    return (y - 1) * self.xCount + x 
end

return PlayScene
