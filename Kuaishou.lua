--Kuaishou.lua

-- save("KuaishouTitle1", "这么精彩的视频确定不点个收藏 #我的世界 #我的世界周年庆 #我的游戏日常 ")
-- save("KuaishouTitle2", "有趣的mc视频可没有多少啊！#我的世界 #我的世界周年庆 #我的游戏日常")
-- save("KuaishouTitle3", "这确定不点个关注！#我的世界 #我的世界周年庆 #我的游戏日常")
-- save("KuaishouTitle4", "我为 #我的世界（联运） 拍摄了精彩游戏视频！跟我一起玩吧  #mc节奏大师  #无缝剪辑")

function UpVideoInKuaishou(UpVideoNum,videotype)
    if(UpVideoNum<=0)then   
        PrintAndToast("无视频要上传跳过！")
        return 
    end
    local start_time = os.time()
    local titleset = {}
    if(videotype == "MC")then
        PrintAndToast("MC")
        titleset[0] = get("KuaishouTitle1","#我的世界");
        titleset[1] = get("KuaishouTitle2","#我的世界");
        titleset[2] = get("KuaishouTitle3","#我的世界");
        titleset[3] = get("KuaishouTitle4","#我的世界");
    elseif videotype == "Other" then
        titleset[0] = get("DouyinTitle1Other","#游戏的正确打开方式");
        titleset[1] = get("DouyinTitle2Other","#游戏的正确打开方式");
        titleset[2] = get("DouyinTitle3Other","#游戏的正确打开方式");
        titleset[3] = get("DouyinTitle4Other","#游戏的正确打开方式");  
    end

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
                    local KuaishouUpVideoTitle = titleset[math.random(0, 3)]
                    print(KuaishouUpVideoTitle)
                    UpVideoInKuaishouPart(idx)
                    local title_input = R():id("com.smile.gifmaker:id/editor");
                    AutoClick(title_input,"点击一下输入框",false,true)
                    sleep(500)
                    AutoInput(title_input,KuaishouUpVideoTitle)
                    sleep(1000)
                    SelectKuaishouVideoTask(videotype)
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
            ErrorFix()
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
        local Xbutton = R():text("取消");
        AutoClick(Xbutton,"点击取消！",false,true,true)
        if (CheckFunctionIsSucceed(KuaishouIsVoideFinished,"检测是否发布完成",true,3)) then
            --AutoClick(KuaishouIsVoideFinished,"进入新发布的视频！")
            print("视频发布成功！")
            local Xbutton = R():text("取消");
            AutoClick(Xbutton,"点击取消！",false,true,true)
            return
        else
            print("WaitForKuaishouUpVideoFinished，继续等待！")
        end
        sleep(1000)
        whiletime = whiletime + 1
    end
    print("无需等待，直接跳过！")
end

function SelectKuaishouVideoTask(TaskType)
    if(TaskType == "MC") then
        local create_service = R():id("com.smile.gifmaker:id/share_producer_wrap");
        AutoClick(create_service,"选择创作者服务",false,true)
        AutoClick(create_service,"选择创作者服务",false,true)

        local sidetask = R():id("com.smile.gifmaker.tuna_plc_post:id/share_business_link_list_view");
        AutoSild(sidetask,"滑动快手作者服务任务栏！！")

        local game_task = R():text("游戏合伙人"):getParent();
        local PosIsExist,noneview = CheckPosIsExist(game_task)
        if(PosIsExist) then 
            AutoClick(game_task,"选择游戏合伙人按钮",false,false,true)
            sleep(3000)
            local mc_task = {525,348,669,407,"541,358,#FE82A0|651,359,#FE3666|592,375,#FFFFFF|540,393,#FE3666|648,392,#FFFFFF",95}
            local value = AutoColorClick(mc_task,"选择我的世界任务按钮",true,6)
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
    elseif TaskType == "Other" then
        PrintAndToast("跳过任务选择")
        back()
        sleep(500)
    end
end

function UpVideoInKuaishouPart(idx)
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
end

function KuaishouCheckVideo()
    print("检查快手是否存在问题视频！")
    CloseConnectVpn()
    --启动快手！
    runApp("com.smile.gifmaker")
    while true do 
        if pcall(KuaishouCheckVideoPart) then
            break
        else
            -- body3
            print("检查视频错误！重新检查！")
            CloseAllPross()
            --启动快手！
            runApp("com.smile.gifmaker")
        end
    end
    print("快手检查完毕！")
    home()
end

function KuaishouCheckVideoPart()

    -- sleep(5000)
    --判断是否进入快手页面
    local IsWatchKuaishouTextPos = R():text("首页");
    AutoClick(IsWatchKuaishouTextPos,"点击首页",false,true)

    local mainpage_more = {26,66,75,107,"39,75,#232323|63,75,#232323|53,87,#222222|41,99,#262626|63,100,#222222",95}
    AutoColorClick(mainpage_more,"点击主页的更多选项")

    --选择创作者中心
    local Kuaishou_CreaterCenter = R():text("创作者中心"):screen(1);
    AutoClick(Kuaishou_CreaterCenter,"选择创作者中心",false,true)
    -- AutoClick(Kuaishou_CreaterCenter,"选择创作者中心",false,true,true)
    local morefuwu = R():text("全部服务"):getParent();
    AutoClick(morefuwu,"选择创作者中心",false,true)

    --点击账号检测
    local Kuaishou_CheckButton = R():text("账号检测"):getParent();
    AutoClick(Kuaishou_CheckButton,"点击账号检测",false,true)

    --点击检查按钮！
    local Kuaishou_CheckButton = R():path("/FrameLayout/WebView/WebView/View/View/Button");
    AutoClick(Kuaishou_CheckButton,"点击检查按钮！")
    sleep(3000)

    while true do
        local checkvideostatus = R():text("正在诊断中");
        local checkvideostatusIsExist,noneview = CheckPosIsExist(checkvideostatus)
        if(checkvideostatusIsExist) then 
            print("正在检测视频中！")
            sleep(1000)
        else
            print("检查完毕！")
            sleep(4000)
            local checkvideoresult = R():text("账号近期各项正常，请继续保持");
            local checkvideoresultIsExist,noneview = CheckPosIsExist(checkvideoresult)

            local checkvideoresult1 = R():text("账号部分功能被限制");
            local checkvideoresultIsExist1,noneview1 = CheckPosIsExist(checkvideoresult1)
            print(checkvideoresultIsExist)
            print(checkvideoresultIsExist1)
            if(checkvideoresultIsExist or checkvideoresultIsExist1) then 
                print("成功检查完毕！不存在问题视频！")
                CloseAllPross()
                return
            end
            print("账号存在问题！！")
            local checkvideoresult = R():text("查看作品诊断结果"):getParent();
            AutoClick(checkvideoresult,"存在异常视频点击进入！")
            sleep(3000)
            local errorvideoidx = 1
            local errorvideonum = 0
            local errorvideonumpos = R():text("作品标题");
            local views = finds(errorvideonumpos);
            for k,view in pairs(views) do
                errorvideonum = k
            end
			print("节点包含的子控件个数"..errorvideonum)-- 节点包含的子控件个数 number

            while errorvideoidx <= errorvideonum do 
                local errorinfovideo = R():path("/FrameLayout/WebView/WebView/View/View/View"):getChild(2):getChild(1):getChild(errorvideoidx+2):getChild(1):getChild(1);
                AutoClick(errorinfovideo,"进入错误视频信息页！",false,true)
                sleep(1000)
                print('1')
                local errorvideo = R():path("/FrameLayout/WebView/WebView/View/View/View/View");
                AutoClick(errorvideo,"进入错误视频！",false,true)
                print('1')
                --删除视频!
                KuaishouDeleteVideo()
                back()
                sleep(1000)
                back()
                errorvideoidx = errorvideoidx + 1
            end
            print("删除所有的错误视频")
            CloseAllPross()
            break;
        end
    end
end


function KuaishouDeleteVideo()
    local settingsbutton = R():id("com.smile.gifmaker:id/forward_button");
    AutoClick(settingsbutton,"点击分享按钮！",false,true)

    local morefunctionsilde = R():path("/FrameLayout/FrameLayout/FrameLayout/RecyclerView"):getChild(3):getChild();
    local flag,view =    CheckPosIsExist(morefunctionsilde)
    if(flag) then 
        AutoSild(morefunctionsilde,"滑动功能条！")
        AutoSild(morefunctionsilde,"滑动功能条！")
        AutoSild(morefunctionsilde,"滑动功能条！")
    end
    sleep(1000)
    slid(650,1495,91,1495,500);
    sleep(500)
    slid(650,1495,91,1495,500);
    
    local deletebutton = R():text("删除作品"):getParent();
    AutoClick(deletebutton,"点击删除按钮！",false,true)
    sleep(500)
    local againdeletebutton = R():text("确认删除"):getParent();
    local IsExist,noneview = CheckPosIsExist(againdeletebutton)
    if(IsExist) then 
        AutoClick(againdeletebutton,"确定点击删除按钮！",false,true)
    else
        local againdeletebutton = R():text("残忍删除"):getParent();
        AutoClick(againdeletebutton,"确定点击删除按钮！",false,true)
    end

end