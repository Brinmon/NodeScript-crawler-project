--Douyin.lua

-- save("DouyinTitle1","《当我打开抖音发现竟然是MC时》 #我的世界 #我的世界启动 #我的世界中国版 #我的游戏日常")
-- save("DouyinTitle2","不会吧！不会吧！mc没热度了！#我的世界 #我的世界启动 #我的世界中国版 #肝帝出发")
-- save("DouyinTitle3","方块扶我青云志，我还MC永不朽！ #我的世界 #我的世界启动 #我的世界中国版 #我的游戏日常")
-- save("DouyinTitle4","我的游戏貌似只有MC！#我的世界 #我的世界启动 #我的世界网易 #我的游戏日常")

-- save("DouyinTitle1Other","《当我打开抖音发现竟然是游戏时》 #游戏启动 #游戏的重要性 #好久没玩游戏了")
-- save("DouyinTitle2Other","不会吧！不会吧！游戏不会被忘了吧！#游戏启动 #游戏的重要性 #好久没玩游戏了")
-- save("DouyinTitle3Other","游戏扶我青云志，我还游戏永不朽！ #游戏启动 #游戏的重要性 #好久没玩游戏了")
-- save("DouyinTitle4Other","我的游戏貌似还有很多！ #游戏启动 #游戏的重要性 #好久没玩游戏了")

function UpVideoInDouyin(UpVideoNum,videotype)
    if(UpVideoNum<=0)then   
        PrintAndToast("无视频要上传跳过！")
        return 
    end
    local start_time = os.time()
    local titleset = {}
    if videotype == "MC" then
        titleset[0] = get("DouyinTitle1","#我的世界");
        titleset[1] = get("DouyinTitle2","#我的世界");
        titleset[2] = get("DouyinTitle3","#我的世界");
        titleset[3] = get("DouyinTitle4","#我的世界");  
    elseif videotype == "Other" then
        titleset[0] = get("DouyinTitle1Other","#游戏的正确打开方式");
        titleset[1] = get("DouyinTitle2Other","#游戏的正确打开方式");
        titleset[2] = get("DouyinTitle3Other","#游戏的正确打开方式");
        titleset[3] = get("DouyinTitle4Other","#游戏的正确打开方式");  
    end

    --启动抖音！
    runApp("com.ss.android.ugc.aweme")
    sleep(3000)
    --判断是否进入抖音页面
    local IsWatchTextPos = R():text("首页");
    local IsWatchText = GetPosStatsInfo(IsWatchTextPos,"等待成功进入抖音","text")
    PrintAndToast("成功进入抖音！")
    sleep(500)
    local idx = 1
    while true do 
        local Iserror,errorinfo = pcall(
            function()
                while( idx <= UpVideoNum ) do 
                    local DouyinUpVideoTitle = titleset[math.random(0, 3)]
                    UpVideoInDouyinPart(idx)
                    local title_input = R():type("EditText");
                    AutoClick(title_input,"点击一下输入框",false,true)
                    sleep(500)
                    AutoInput(title_input,DouyinUpVideoTitle)
                    sleep(500)
                    -- back()
                    -- sleep(500)
                    SelectDouyinVideoTask(videotype)
                    sleep(500)
                    local PushVideoPos = R():text("发布");
                    AutoClick(PushVideoPos,"点击上传视频！",false,true)
                    WaitForDouyinUpVideoFinishedInDouyin()
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
            print("UpVideoInDouyin视频上传失败！重新上传！")
            ErrorFix() 
            CloseAllPross()
            runApp("com.ss.android.ugc.aweme")
            --判断是否进入抖音页面
            local IsWatchTextPos = R():text("首页");
            local IsWatchText = GetPosStatsInfo(IsWatchTextPos,"等待成功进入抖音","text")
            PrintAndToast("成功进入抖音！")
        end
    end
end

function WaitForDouyinUpVideoFinishedInDouyin()
    local DouyinIsVoideFinished = R():text(".*成功.*"):screen(1);
    local DouyinIsVoideFinished1 = R():desc(".*发布中.*"):screen(1);
    local whiletime = 1
    while whiletime<=10 do 
        print("检测次数："..whiletime)
        local Xbutton = R():desc("取消");
        AutoClick(Xbutton,"点击取消！",false,true,true)
        local flag = CheckFunctionIsSucceed(DouyinIsVoideFinished,"检测是否发布完成",true,3)
        local flag1 = CheckFunctionIsSucceed(DouyinIsVoideFinished1,"检测是否发布完成",true,3)
        if (flag == true or flag1 == false ) then
            --AutoClick(DouyinIsVoideFinished,"进入新发布的视频！")
            local Xbutton = R():desc("取消");
            AutoClick(Xbutton,"点击取消！",false,true,true)
            print("视频发布成功！")
            return
        else
            print("WaitForDouyinUpVideoFinishedInDouyin，继续等待！")
        end
        sleep(1000)
        whiletime = whiletime + 1
    end
    print("无需等待，直接跳过！")
end

function SelectDouyinVideoTask(TaskType)
    if(TaskType == "MC") then
        local create_service = R():text("添加游戏");
        local IsHasTask = AutoClick(create_service,"添加游戏",false,true,true)
        sleep(100)
        IsHasTask = AutoClick(create_service,"添加游戏",false,true,true)
        sleep(500)
        if(IsHasTask == "跳过")then 
            return
        end

        local mc_task = {542,349,670,391,"551,360,#FE2C55|605,359,#FE2C55|654,359,#FE2C55|554,380,#FE2C55|605,380,#FE2C55|646,377,#FE2C55",95}
        local value = AutoColorClick(mc_task,"选择我的世界任务按钮",true,6)
        if(value =="跳过") then 
            back()
            sleep(500)
        end
        sleep(1000)
    elseif TaskType == "Other" then
        PrintAndToast("跳过任务选择")
        back()
        sleep(500)
    end
end


function UpVideoInDouyinPart(idx)
    --点击发布视频按钮
    local UpVideoButtonPos = R():desc("拍摄，按钮"):screen(1);
    AutoClick(UpVideoButtonPos,"点击发布按钮",false,true)
    sleep(500)
    local albumbuttonpos = R():desc("相册"):type("Button"):screen(1);
    AutoClick(albumbuttonpos,"点击相册按钮",false,true)
    sleep(500)
    local next_button = R():text("下一步");
    local PosIsExist
    local targetview
    local time = 1
    print("开始检查下一步按钮在不在！")
    while (true) do
        local choose_view_list = R():path("/FrameLayout/RelativeLayout/LinearLayout/ViewPager/RecyclerView"):getChild(idx):getChild(2);
        AutoClick(choose_view_list,"选择相册中的视频")
        sleep(500)
        local videoischoosed = R():path("/FrameLayout/RelativeLayout/LinearLayout/ViewPager/RecyclerView"):getChild(idx):getChild(2):getChild();
        local videoischoosedtext = GetPosStatsInfo(videoischoosed,"判断是否选中视频","text")
    
        PrintAndToast("循环检测中！"..videoischoosedtext)
        PosIsExist,targetview = CheckPosIsExist(next_button)
        if(PosIsExist) then 
            targetview:click()
            sleep(500)
            PrintAndToast("Douyin选中视频后点击下一步")
            break
        end
    
        sleep(1000)
        PrintAndToast("DouyinOneToOne控件点击循环:".. time)
        time = time+1
        if(time == 7) then
            PrintAndToast("DouyinOneToOne点击失败重新运行！")
            -- 说明视频异常,跳过这个作品直接下一个！
            PrintAndToast("跳过这个作品直接下一个！")
            return;
        end
    end

    local video_next1 = R():text("下一步");
    AutoClick(video_next1,"选择视频后下一步按钮再下一步",false,true)
    -- AutoClick(video_next1,"选择视频后下一步按钮再下一步",false,true)
    sleep(500)

end

