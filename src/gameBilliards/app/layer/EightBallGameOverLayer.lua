--
local LayerWidgetBase = require("hallcenter.controllers.LayerWidgetBase")
local EightBallGameOverLayer = class("EightBallGameOverLayer", LayerWidgetBase)

function EightBallGameOverLayer:ctor(event)
    self:registerTouchHandler()
    self:initView(event)
end

function EightBallGameOverLayer:initView(event)
    event = { }
    event.WinUserID = 2486410
    event.WinScore = 3000

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    if layer then
        self:addChild(layer)
    end
    self.node = cc.CSLoader:createNode("gameBilliards/csb/EightBallGameOverLayer.csb")
    if self.node then
        tool.playLayerAni(self.node)
        self:addChild(self.node)

        local function btnCallback(sender, eventType)
            self:btnCallback(sender, eventType)
        end

        self.player1 = self.node:getChildByName("Panel_Player_1")
        self.player2 = self.node:getChildByName("Panel_Player_2")

        self.btn_BackHall = self.node:getChildByName("Button_BackHall")
        self.btn_Again = self.node:getChildByName("Button_Again")
        self.btn_BackHall:addTouchEventListener(btnCallback)
        self.btn_Again:addTouchEventListener(btnCallback)
    end
    self:initGameInfo(event)
    self:initGameOverAni()
end

function EightBallGameOverLayer:initGameInfo(event)
    local deskPlayerList = dmgr:getDeskPlayerInfoList()
    local opponent = { head = 0, nickName = "default" }
    if #deskPlayerList > 1 then
        for i = 1, 2 do
            if deskPlayerList[i].User.UserInfo.UserID ~= player:getPlayerUserID() then
                opponent.head = deskPlayerList[i].User.UserInfo.Head
                opponent.nickName = deskPlayerList[i].User.UserInfo.NickName
            end
        end
    end
    if event then
        local index = event.WinUserID == player:getPlayerUserID() and 1 or 2
        local playerWin = self.node:getChildByName("Panel_Player_" .. index)
        local playerLose = self.node:getChildByName("Panel_Player_" ..(index == 1 and 2 or 1))
        self.player1:getChildByName("Head"):loadTexture(tool.getHeadImgById(player:getPlayerHead(), true), UI_TEX_TYPE_LOCAL)
        self.player2:getChildByName("Head"):loadTexture(tool.getHeadImgById(opponent.head, true), UI_TEX_TYPE_LOCAL)
        self.player1:getChildByName("NickName"):setString(tostring(player:getPlayerNickName()))
        self.player2:getChildByName("NickName"):setString(tostring(opponent.nickName))
        local index = event.WinUserID == player:getPlayerUserID() and 1 or 2
        playerWin:getChildByName("Winner"):setVisible(true)
        playerLose:getChildByName("Winner"):setVisible(false)
        playerWin:getChildByName("WinScore"):setString("+" .. event.WinScore)
        playerLose:getChildByName("WinScore"):setString("-" .. event.WinScore)
        if index == 1 then
            
        elseif index == 2 then
            
        end
    end
end

function EightBallGameOverLayer:initGameOverAni()
    
end

-- 返回大厅
function EightBallGameOverLayer:goBackHall()
    EBGameControl:setGameState(g_EightBallData.gameState.none)
    EBGameControl:leaveGame()
end

-- 再来一局
function EightBallGameOverLayer:playAgain()
    EBGameControl:setGameState(g_EightBallData.gameState.practise)
    local _key = G_PlayerInfoList:keyFind(player:getPlayerUserID())
    local requestData = {
        tableID = G_PlayerInfoList[_key].TableID,
        seatID = G_PlayerInfoList[_key].SeatID,
    }
    ClientNetManager.getInstance():requestCmd(g_Room_REQ_GAMEREADY, requestData, G_ProtocolType.Room)
    tool.closeLayerAni(self.node,self)
end

function EightBallGameOverLayer:btnCallback(sender, eventType)
    local nTag = sender:getTag()
    if eventType == TOUCH_EVENT_BEGAN then
        sender:setScale(1.05)
    elseif eventType == TOUCH_EVENT_ENDED then
        sender:setScale(1.0)
        amgr.playEffect("hall_res/button.mp3")
        if nTag == 196 then
            self:goBackHall()
        elseif nTag == 197 then
            self:playAgain()
        end
    elseif eventType == TOUCH_EVENT_MOVED then

    elseif eventType == TOUCH_EVENT_CANCELED then
        sender:setScale(1.0)
    end
end

function EightBallGameOverLayer:onEnter()
    self:set3DCamera()
end

function EightBallGameOverLayer:onExit()

end

return EightBallGameOverLayer