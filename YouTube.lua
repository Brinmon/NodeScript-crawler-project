--YouTube.lua

--爬取YouTube的id
function GetYouTubeAuthorId()
    PrintAndToast("爬取YouTube的id")
    -- local AuthorNamepos = R():text(".*@.*"):screen(1);
    -- local AuthorName = GetPosStatsInfo(AuthorNamepos, "获取YouTube作者主页名", "text", false)
    -- local morecolorpos = {652,72,698,119,"674,83,#000000|675,96,#000000|675,107,#000000|658,94,#FFFFFF|687,94,#FFFFFF|675,114,#FFFFFF",60}
    -- AutoColorClick(morecolorpos,"点击主页的左上角！")
    -- local sharepos = R():text("分享"):getParent():screen(1);
    -- AutoClick(sharepos,"点击分享按钮！",false,true)
    -- local copylinkpos = R():desc("复制链接"):screen(1);
    -- AutoClick(copylinkpos,"点击复制链接",false,true)
    -- sleep(500)
    -- local msg = getClipboard(); --获取剪贴板中的内容
    local r = {match='@.*';sim=0.7;line=false; }
    local res = ocrp(r);
    local tempAuthorName = ""
    print(res)
    if #res ~= 0 then 
        PrintAndToast("获取作者名成功！！")
        print(res[1]["text"]:match("(%S+)"))
        tempAuthorName = res[1]["text"]:match("(%S+)")
    else
        PrintAndToast("获取作者名失败！！")
        return 0
    end

    local AuthorName = tempAuthorName
    PrintAndToast("作者名："..AuthorName)
    local p = {
        param={};
        header={};
    }
    -- 请求地址
    p.url ="https://www.youtube.com/"..AuthorName;
    local AuthorId = AuthorName:sub(2) .. "_channelID"
    local id = get(AuthorId,"没有获取到值");
    print(id)
    if(id ~= "没有获取到值") then 
        PrintAndToast("该id已经被存储无需再存储！")
        return
    end
    res = httpGet(p);
    if res then
         --打印服务器的返回值
        local channelID = res.body:match('youtube.com/channel/(.-)"')
        if(channelID == nil) then 
            PrintAndToast("获取channelID失败！！");
            return
        end
        print(channelID)
        PrintAndToast("成功获取channelID！");
        print("channelID: "..channelID)
        local id = get(AuthorId,"没有获取到值");
        if(id == channelID) then 
            PrintAndToast("该id已经被存储无需再存储！")
            return
        end
        -- 存储string类型
        save(AuthorId, channelID)
        PrintAndToast("成功存储channelID：" .. AuthorId .. " " .. channelID)
    else 
        PrintAndToast("网络爬虫爬取失败！！！")
    end
end

--Tiktok作者主页跳转！
function YouTubeUrlSchemeJmup(roomid)
    i ={};
    -- android 配置的action 选项， 通常和uri 配合使用
    i['action'] = "android.intent.action.VIEW";
    -- uri 通常用作协议跳转
    i['uri'] = "vnd.youtube://www.youtube.com/channel/"..roomid;
    runIntent(i);
    sleep(1000)
    local AuthorNamepos = R():text("首页"):screen(1);
    local AuthorName = GetPosStatsInfo(AuthorNamepos, "判断是否跳转成功！", "text", false)
    PrintAndToast("检查到的文本："..AuthorName)
end



--选择最新视频
function SelectYouTubeCreaterNewVedio(videotype)
    local VideoTypePos = 0
    if(videotype == "视频")then
        VideoTypePos = R():id("app.revanced.android.youtube:id/text"):text("视频"):type("Button");
    elseif(videotype == "Shorts") then 
        VideoTypePos = R():id("app.revanced.android.youtube:id/text"):text("SHORTS"):type("Button");
    end
    AutoClick(VideoTypePos,"点击"..videotype.."页面",false,true)
    sleep(500)
    local VideoInfoPos = R():desc(".*次观看.*"):screen(1);
    -- local VideoInfo = GetPosStatsInfo(VideoInfoPos, "获取YouTube视频信息！", "text", false)
    local pos_video = VideoInfoPos
    local watch_num  = VideoInfoPos
    return pos_video,watch_num
end

--下载视频
function DownloadVedioInYouTube(videotype)
    local currentvideonum = CountPhoneVideoNum("sdcard/snaptube/download/")
    PrintAndToast("当前视频数量："..tostring(currentvideonum))
    PrintAndToast("YouTube开始下载视频！")
    sleep(1000)
    local idx = 0
    while idx < 2 do 
        sleep(1000)
        if(videotype == "Shorts")then 
            local pos_sharebutton = R():text("分享"):screen(1);
            AutoClick(pos_sharebutton,"点击分享按钮",false,true)
            sleep(1000)
        elseif(videotype == "视频")then
            local pos_sharebutton =  R():desc("操作菜单"):screen(1);
            AutoClick(pos_sharebutton,"点击分享按钮",false,true)
            sleep(1000)
            local morepos = R():text("分享"):screen(1);
            AutoClick(morepos,"点击更多按钮！",false,true)
        end
        local morepos = R():desc("展开"):screen(1);
        AutoClick(morepos,"点击更多按钮！",false,true)
        sleep(1000)
        local downloadpos = R():text("Download"):screen(1);
        AutoClick(downloadpos,"点击更多按钮！",false,true)
        sleep(1000)
        if(idx == 0)then 
            back()
        end
        idx = idx + 1
    end
    sleep(1000)
    local IsSuccessClick = false
    local videoqualitytype = {"1080P 60FPS","720P 60FPS","1080P HD","720P HD","480P"} 
    local videoqualityidx = 1
    while (videoqualityidx <= #videoqualitytype) do 
        local videoqualitypos = R():text(videoqualitytype[videoqualityidx]):getParent();
        local IsExist,downloadview = CheckPosIsExist(videoqualitypos)
        PrintAndToast("检查节点："..videoqualitytype[videoqualityidx])
        print(downloadview)
        print("节点结果是否可点击：")
        print(IsExist)
        if IsExist then
            if downloadview then 
                if downloadview.isClick then 
                    PrintAndToast("存在"..videoqualitytype[videoqualityidx].."品质的视频！")
                    PrintAndToast("点击下载视频！")
                    click((downloadview.rect.left + downloadview.rect.right)/2 , (downloadview.rect.top + downloadview.rect.bottom)/2)
                    -- sleep(500)
                    IsSuccessClick = true
                    break
                else
                    PrintAndToast("无法点击！")
                end
            end
        end

        videoqualityidx = videoqualityidx + 1
    end

    if(IsSuccessClick == false) then 
        
        click(360,1378)
        sleep(500)
        click(360,1518)
        
    end

    local IsDownLoad = true
    local waittime = 0
    while IsDownLoad do 
        local videonum = CountPhoneVideoNum("sdcard/snaptube/download/")
        if(videonum > currentvideonum)then 
            IsDownLoad = false
            PrintAndToast("当前视频下载完毕！！")

            return 1
        end
        sleep(1000)
        if(waittime == 60)then 
            PrintAndToast("下载失败！.............跳过")
            return 0
        end
        PrintAndToast("下载中"..tostring(waittime))
        waittime = waittime + 1
    end
    -- if(not SnaptubeWaitVideoDownloadFinish())then 
    --     save(creater_name,CurrentVideoTitle); --存储最新视频与作者的键值对
    --     print("下载失败！.............跳过")
    --     return 0
    -- end
end


-- str1 = "#shorts Best Minecraft Tree House, 735次观看 - 播放 Shorts 短视频"
-- str2 = "#shorts automatic door 1, 1,942次观看 - 播放 Shorts 短视频"
-- str3 = "Minecraft Starter House, 1.3万次观看 - 播放 Shorts 短视频"
-- str4 = "Mystery Chest / Minecraft RTX #minecraft #shorts, 30万次观看 - 播放 Shorts 短视频"
-- str5 = "Realistic Enderman Slime / Minecraft RTX #minecraft #shorts, 114万次观看 - 播放 Shorts 短视频"
-- str6 = "TNT vs Water Realistic Physics / Minecraft RTX #shorts #minecraft, 1亿次观看 - 播放 Shorts 短视频"
-- str7 = "Herobrine Trapped Inside The Pool Filled With Realistic Water / Minecraft RTX #shorts #minecraft, 9454万次观看 - 播放 Shorts 短视2str23str7"
-- local pattern1 = "(%d+)次观看"
-- local pattern2 = "((%d+),(%d+))次观看"
-- local pattern3 = "(%d+)万次观看"
-- local pattern4 = "(%d+%.?%d)万次观看"
-- local pattern5 = "(%d+)亿次观看"
-- local pattern6 = "(%d+%.?%d)亿次观看"
function MacthWatchNum(VideoWatchedNumText)
    local pattern1 = "(%d+)次观看"
    local pattern2 = "((%d+),(%d+))次观看"
    local pattern3 = "(%d+)万次观看"
    local pattern4 = "((%d+).(%d+))万次观看"
    local pattern5 = "(%d+)亿次观看"
    local pattern6 = "((%d+).(%d+))亿次观看"
    local success, VideoWatchedNumText1 = pcall(
        function()
            print("开始匹配.亿字:"..VideoWatchedNumText)
            return VideoWatchedNumText:match(pattern6)
        end
    )
    if success and VideoWatchedNumText1 ~= nil then
        VideoWatchedNum = tonumber(VideoWatchedNumText1) * 100000000
        PrintAndToast("该视频的播放量是:" .. tostring(VideoWatchedNum))
        return VideoWatchedNum
    else
        local success, VideoWatchedNumText1 = pcall(
            function()
                print("开始匹配亿字:"..VideoWatchedNumText)
                return VideoWatchedNumText:match(pattern5)
            end
        )
        if success and VideoWatchedNumText1 ~= nil then
            VideoWatchedNum = tonumber(VideoWatchedNumText1) * 100000000
            PrintAndToast("该视频的播放量是:" .. tostring(VideoWatchedNum))
            return VideoWatchedNum
        end
    end
    local success, VideoWatchedNumText1 = pcall(
        function()
            print("开始匹配.万字:"..VideoWatchedNumText)
            return VideoWatchedNumText:match(pattern4)
        end
    )
    if success and VideoWatchedNumText1 ~= nil  then
        VideoWatchedNum = tonumber(VideoWatchedNumText1) * 10000
        PrintAndToast("该视频的播放量是:" .. tostring(VideoWatchedNum))
        return VideoWatchedNum
    else
        local success, VideoWatchedNumText1 = pcall(
            function()
                print("开始匹配万字:"..VideoWatchedNumText)
                return VideoWatchedNumText:match(pattern3)
            end
        )
        if success and VideoWatchedNumText1 ~= nil  then
            VideoWatchedNum = tonumber(VideoWatchedNumText1) * 10000
            PrintAndToast("该视频的播放量是:" .. tostring(VideoWatchedNum))
            return VideoWatchedNum
        end
    end

    local success, VideoWatchedNumText1 = pcall(
        function()
            print("开始匹配,整数:"..VideoWatchedNumText)
            return VideoWatchedNumText:match(pattern2)
        end
    )
    if success and VideoWatchedNumText1 ~= nil  then
        local temp = string.gsub(VideoWatchedNumText1, ",", "")
        VideoWatchedNum = tonumber(temp)
        PrintAndToast("该视频的播放量是:" .. tostring(VideoWatchedNum))
        return VideoWatchedNum
    else
        print("开始匹配整数:"..VideoWatchedNumText)
        local VideoWatchedNumText1 = VideoWatchedNumText:match(pattern1)
        VideoWatchedNum = tonumber(VideoWatchedNumText1)
        PrintAndToast("该视频的播放量是:" .. tostring(VideoWatchedNum)) 
        return VideoWatchedNum
    end
end

--通过收藏和点赞来标记是否是最新视频！
function GetOneYouTubeCreaterNewVideo(YouTubeAuthorName,videotype)
    local VideoIsRedZanColor    = 0
    local VideoIsWhiteZanColor  = 0
    local videonumstr = ""
    local videotyprpos = ""
    if(videotype == "视频") then
        VideoIsRedZanColor    = 0
        VideoIsWhiteZanColor  = 0
        videonumstr = "Long"
        videotyprpos = R():text("视频");
    elseif(videotype == "Shorts") then 
        VideoIsRedZanColor    = {646,813,674,834,"649,817,#3EA6FF|661,817,#3EA6FF|668,818,#3EA6FF|652,830,#3EA6FF|663,827,#3EA6FF|668,827,#3EA6FF",50}
        VideoIsWhiteZanColor  = {644,810,675,836,"645,816,#F6F8F4|659,814,#F6F8F4|667,816,#F6F7F4|646,828,#F6F8F4|656,828,#F5F7F4|669,830,#F6F8F4",50}
        videonumstr = "Short"
        videotyprpos = R():text("Shorts");
    end
    local temp = YouTubeAuthorName.."_channelID"
    temp = string.gsub(temp, "[\r\n]", "")
    local roomid = get(temp,"没有获取到值");
    PrintAndToast(YouTubeAuthorName.."_channelID")
    sleep(500)
    if (roomid == "没有获取到值") then 
        PrintAndToast("未存储该作者的channelID！")
        local context = get("blockical_channelID","没有获取到值");
        print(#temp)
        print(type(temp))
        print(#"blockical_channelID")
        print(type("blockical_channelID"))
        for i = 1,#temp ,1 do
            local char = temp:sub(i)
            local asciiValue = string.byte(char)
            print(">>"..asciiValue.."<<")
        end

        print("end")
        if(temp == "blockical_channelID") then
            PrintAndToast("成功")
            return
        end
        sleep(1000)
        PrintAndToast(context)
        sleep(1000)
        PrintAndToast(YouTubeAuthorName.."_channelID")
        sleep(1000)
        return -1
    end
    sleep(1000)
    YouTubeUrlSchemeJmup(roomid)
    sleep(1000)
    local pos_video = 0
    local watch_numpos = 0
    local VideoWatchedNum = 0
    local pos_video,watch_numpos = SelectYouTubeCreaterNewVedio(videotype) -- 选中最新视频并进入
    local VideoWatchedNumText = GetPosStatsInfo(watch_numpos,"获取Youtube视频的播放数量！","desc",true,7)
    -- print(VideoWatchedNumText)
    if(VideoWatchedNumText == "跳过")then 
        pos_video = R():desc("其他操作"):getParent():getParent():screen(1);
        goto enter
    end

    if VideoWatchedNumText then
        VideoWatchedNum = MacthWatchNum(VideoWatchedNumText)
        PrintAndToast("播放量:"..tostring(VideoWatchedNum))
        sleep(500)
        local AuthorId = YouTubeAuthorName.."_YouTube"..videonumstr.."WatchNum"
        print(AuthorId)
        local context = get(AuthorId,"没有获取到值");
        if(context == "没有获取到值")then 
            PrintAndToast("继续下面的步骤！")
            save(AuthorId,tostring(VideoWatchedNum))
        elseif(tonumber(context) <= VideoWatchedNum )then
            PrintAndToast("播放量增加或者未变！")
            PrintAndToast(YouTubeAuthorName.."--->未更新！")
            save(AuthorId,tostring(VideoWatchedNum))
            return 0
        elseif(tonumber(context) > VideoWatchedNum ) then
            PrintAndToast("播放量减少可能更新视频！")
            save(AuthorId,tostring(VideoWatchedNum))
        end
        sleep(1500)
    else
        PrintAndToast("没有数据返回直接进入视频")
    end
    ::enter::
    AutoClick(pos_video,"进入作者的最新视频",false,true)
    sleep(1000)
    
    if videotype == "Shorts" then
        local IsZan = CheckColorIsSucceed(VideoIsWhiteZanColor,"检查该视频是否被点赞标记！",2)
        if(IsZan) then
            sleep(1000)
            PrintAndToast("该视频未被标记存在最新视频！")
            PrintAndToast(YouTubeAuthorName.."--->存在最新视频！")
            PrintAndToast("开始下载视频！")
            DownloadVedioInYouTube("Shorts")
            
            sleep(500)
            back()
            AutoColorClick(VideoIsWhiteZanColor,"视频下载完毕，点赞标记一下！")
            sleep(500)
            
            local IsRedZan = CheckColorPosIsExist(VideoIsRedZanColor)
            if(IsRedZan) then 
                sleep(1000)
                PrintAndToast("标记成功！")
            else
                PrintAndToast("标记失败！")
            end
            local info = {
                data = "Youtube",
                name = YouTubeAuthorName
            }
            WriteFileData(info)
            return 1
        else
            PrintAndToast("该视频被标记无最新视频！")
            PrintAndToast(YouTubeAuthorName.."--->未更新！")
            return 0
        end
    elseif videotype == "视频" then 
        --获取视频标题判断是否存在新视频
        local LongVideoTitlePos = R():text(".*次观看.*"):screen(1):getParent():getParent():getParent();
        local LongVideoTitleText = GetPosStatsInfo(LongVideoTitlePos,"获取Youtube长视频的标题！","desc")
        if(LongVideoTitleText == nil) then 
            PrintAndToast("该视频标题获取失败！！")
            return 0
        end
        local result = ""
        local index = string.find(LongVideoTitleText,"-")
        if index then
            result = string.sub(LongVideoTitleText, 1, index - 1)
            print("获取到的标题:"..result) -- 输出: Hello
        else
            print("字符串中不存在 '-' 字符")
            return 0
        end
        local AuthorId = YouTubeAuthorName.."_YouTubeLongTitle"
        local context = get(AuthorId,"没有获取到值");
        if(context ~= result) then 
            DownloadVedioInYouTube("视频")
            save(AuthorId,tostring(VideoWatchedNum))
            back()
            save(AuthorId,result)
            PrintAndToast("视频下载完毕")
            return 1
        else
            PrintAndToast("该作者无最新视频！")
            PrintAndToast(YouTubeAuthorName.."--->未更新！")
            back()
            return 0
        end
    end
end


--获取Tiktok所有作者的的
function GetYouTubeAllCreaterNewVideo(filename)
    -- 获取程序开始时间戳
    local start_time = os.time()
    local AuthorTable = {}
    local IsAuthorTable = {}
    local videotype = "Shorts"
    AuthorTable,IsAuthorTable = ReadTextToTable(AuthorTable,IsAuthorTable,filename)
    local idx1len = #AuthorTable
    local tablelen = 10
    print(idx1len)
    local i = 0
    local j = 0
    -- print(AuthorTable)
    while true do 
        local Iserror,errorinfo = pcall(
            function()
                print("a")
                while i<=idx1len do 
                    print("b")
                    j = 0
                    
                    while j<=tablelen-1 do 
                        print("c")
                        if(AuthorTable[i][j] == "end")then 
                            PrintAndToast("全部爬取一遍！")
                            break
                        end
                        print("d")
                        if(IsAuthorTable[i][j] == false)then 
                            j = j+1
                            goto continue
                        end
                        print("e")
                        -- print(AuthorTable[i][j])
                        -- print(i)
                        -- print(j)
                        -- print(AuthorTable[i][j-1])
                        -- print(AuthorTable)
                        PrintAndToast("当前要爬取的目标："..AuthorTable[i][j])
                        local value = GetOneYouTubeCreaterNewVideo(AuthorTable[i][j],videotype)
                        if(value == 1)then 
                            IsAuthorTable[i][j] = false
                        end
                        print("f")
                        j = j+1
                        ::continue::
                    end
                    CloseAllPross()
                    i = i+1
                end
            end
        )
        if Iserror then
            -- 获取程序结束时间戳
            local end_time = os.time()
            -- 计算运行时间（以秒为单位）
            local run_time = end_time - start_time
    
            -- 将秒数转换为小时、分钟、秒
            local hours = math.floor(run_time / 3600)
            local minutes = math.floor((run_time % 3600) / 60)
            local seconds = run_time % 60
    
            -- 输出运行时间
            PrintAndToast("程序运行时间：" .. hours .. "小时 " .. minutes .. "分钟 " .. seconds .. "秒")
            ClearPhoneNotice()
            home()
            return
        else
            PrintAndToast("YouTube爬取视频错误")
            ErrorFix()
            CloseAllPross()
            local Ishasnet = CheckNetIsConnect("YouTube")
            if(Ishasnet == false)then 
                ClearPhoneNotice()
                InitChooseBestNet() 
            end
        end
    end
end
