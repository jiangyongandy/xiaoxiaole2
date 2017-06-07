
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

-- 获取UI控件
MainScene.RESOURCE_BINDING = {
    ["Button_1"]   = {["varname"] = "btn",},
    ["mainBG_1"]   = {["varname"] = "bgSprite",},
}

function MainScene:onCreate()
    
    printf("resource node = %s", tostring(self:getResourceNode()))

    -- 1.加载精灵帧
    display.loadSpriteFrames("fruit.plist", "fruit.png")

    self.btn:addClickEventListener(function()
        printf("btn click")
        -- 无转场动画
        --self:getApp():enterScene("PlayScene")
        -- 有转场动画
        self:getApp():enterScene("PlayScene", "FADE", 1)
    end)

    

end

return MainScene
