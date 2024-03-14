--Kuaishou.lua

function UpVideoInKuaishou(UpVideoNum)
    local start_time = os.time()
    --启动快手！
    runApp("com.smile.gifmaker")
    sleep(5000)
    --判断是否进入快手页面
    local IsWatchKuaishouTextPos = R():text("首页");
    local IsWatchKuaishouText = GetPosStatsInfo(IsWatchKuaishouTextPos,"等待成功进入快手","text")
    PrintAndToast("成功进入快手！")

    local idx = 1

    while true do 
        local Iserror,errorinfo = pcall(
            function()
                while( idx <= UpVideoNum ) do 
                    UpVideoInKuaishouPart(idx)
                    sleep(1000)
                    SelectVideoTask("MC")
                    sleep(1000)
                    local PushVideoPos = R():id("com.smile.gifmaker:id/publish_button"):text("发布");
                    AutoClick(PushVideoPos,"点击上传视频！")
                    WaitForKuaishouUpVideoFinishedInKuaishou()
                    click(360,794)
                    sleep(500)
                    click(360,794)
                    idx = idx + 1
                end
            end
        )
        if Iserror then
            print("UpVideoInKuaishou视频上传完成："..UpVideoNum)
            home()
            -- 获取程序结束时间戳
            local end_time = os.time()
            -- 计算运行时间（以秒为单位）
            OutPutOperationTime(start_time,end_time)
            break
        else
            print("UpVideoInKuaishou视频上传失败！重新上传！")
            CloseAllPross()
            runApp("com.smile.gifmaker")
            --判断是否进入快手页面
            local IsWatchKuaishouTextPos = R():text("首页");
            local IsWatchKuaishouText = GetPosStatsInfo(IsWatchKuaishouTextPos,"等待成功进入快手","text")
            PrintAndToast("成功进入快手！")
        end
    end
end

function WaitForKuaishouUpVideoFinishedInKuaishou()
    local KuaishouIsVoideFinished = R():text(".*发布成功.*"):screen(1);
    local whiletime = 1
    while whiletime<=10 do 
        print("检测次数："..whiletime)
        if (CheckFunctionIsSucceed(KuaishouIsVoideFinished,"检测是否发布完成",true,6)) then
            --AutoClick(KuaishouIsVoideFinished,"进入新发布的视频！")
            print("视频发布成功！")
            return
        else
            print("WaitForKuaishouUpVideoFinished，继续等待！")
        end
        sleep(1000)
        whiletime = whiletime + 1
    end
    print("无需等待，直接跳过！")
end

function SelectVideoTask(TaskType)
    if(TaskType == "MC") then
        local create_service = R():id("com.smile.gifmaker:id/share_producer_wrap");
        AutoClick(create_service,"选择创作者服务",false,true)

        local sidetask = R():id("com.smile.gifmaker.tuna_plc_post:id/share_business_link_list_view");
        AutoSild(sidetask,"滑动快手作者服务任务栏！！")

        local game_task = R():text("游戏合伙人"):getParent();
        local PosIsExist,noneview = CheckPosIsExist(game_task)
        if(PosIsExist) then 
            AutoClick(game_task,"选择游戏合伙人按钮",false,false,true)
            sleep(3000)
            local mc_task = {525,348,669,407,"541,358,#FE82A0|651,359,#FE3666|592,375,#FFFFFF|540,393,#FE3666|648,392,#FFFFFF",95}
            local value = AutoColorClick(mc_task,"选择我的世界任务按钮",true)
            if(value =="跳过") then 
                back()
                sleep(500)
                back()
            end
            sleep(1000)
            back()
        end

        local IsAddTaskpos = R():text("账号提示");
        local PosIsExist,noneview = CheckPosIsExist(IsAddTaskpos)
        if(PosIsExist) then 
            PrintAndToast("存在账号提示，无法加入任务！")
            back()
            sleep(1000)
            back()
        else
            PrintAndToast("不存在！账号提示")
        end
    end
end

-- save("KuaishouTitle1", "这么精彩的视频确定不点个收藏 #我的世界 #我的世界周年庆 #我的游戏日常 ")
-- save("KuaishouTitle2", "有趣的mc视频可没有多少啊！#我的世界 #我的世界周年庆 #我的游戏日常")
-- save("KuaishouTitle3", "这确定不点个关注！#我的世界 #我的世界周年庆 #我的游戏日常")
-- save("KuaishouTitle4", "我为 #我的世界（联运） 拍摄了精彩游戏视频！跟我一起玩吧  #mc节奏大师  #无缝剪辑")
function UpVideoInKuaishouPart(idx)
    local titleset = {}
    -- print("1")
    titleset[0] = get("KuaishouTitle1","#我的世界");
    titleset[1] = get("KuaishouTitle2","#我的世界");
    titleset[2] = get("KuaishouTitle3","#我的世界");
    titleset[3] = get("KuaishouTitle4","#我的世界");
    
    local KuaishouUpVideoTitle = titleset[math.random(0, 3)]

    --点击发布视频按钮
    local UpVideoButtonPos = R():id("com.smile.gifmaker:id/shoot_container"):screen(1);
    AutoClick(UpVideoButtonPos,"点击发布按钮",false,true)
    sleep(500)
    local albumbuttonpos = R():id("com.smile.gifmaker:id/album_layout");
    AutoClick(albumbuttonpos,"点击相册按钮",false,true)
    sleep(500)
    local video_div = R():id("com.smile.gifmaker:id/album_view_list"):getChild(idx):getChild(2);
    AutoClick(video_div,"选择视频按钮",false,true)
    sleep(500)
    local video_next = R():id("com.smile.gifmaker:id/next_step");
    AutoClick(video_next,"选择视频后下一步按钮",false,true)
    sleep(500)
    local video_next1 = R():id("com.smile.gifmaker:id/next_step_button");
    AutoClick(video_next1,"选择视频后下一步按钮再下一步",false,true)
    sleep(500)
    local title_input = R():id("com.smile.gifmaker:id/editor");
    AutoClick(title_input,"点击一下输入框",false,true)
    AutoInput(title_input,KuaishouUpVideoTitle)
    back()
end

