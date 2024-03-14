--Tiktok.lua

--爬取Tiktok的id
function GetTiktokAuthorId()
    --https://www.highsocial.com/zh/find-tiktok-user-id/
    local AuthorNamepos = R():text(".*@.*"):screen(1);
    local AuthorName = GetPosStatsInfo(AuthorNamepos, "获取Tiktok作者主页名", "text", false)
    PrintAndToast("作者名："..AuthorName)
    local p = {
        param={};
        header={};
    }
    -- 请求地址
    p.url ="https://www.highsocial.com/wp-admin/admin-ajax.php";
    p.param ["action"] ='get_user_account_id';
    p.param ["username"] = AuthorName:sub(2);
    local AuthorId = AuthorName:sub(2) .. "_groupID"
    local id = get(AuthorId,"没有获取到值");
    if(id ~= "没有获取到值") then 
        PrintAndToast("该id已经被存储无需再存储！")
        return
    end
    res = httpPost(p);
    if res then
         --打印服务器的返回值
        local groupID = res.body:match('"groupID":"(.-)"')
        if(groupID == nil) then 
            PrintAndToast("获取groupID失败！！");
            return
        end
        PrintAndToast("成功获取groupID！");
        print("groupID: "..groupID)
        local id = get(AuthorId,"没有获取到值");
        if(id == groupID) then 
            PrintAndToast("该id已经被存储无需再存储！")
            return
        end
        -- 存储string类型
        save(AuthorId, groupID)
        PrintAndToast("成功存储groupID：" .. AuthorId .. " " .. tostring(groupID))
    else 
        PrintAndToast("网络爬虫爬取失败！！！")
    end
end

--Tiktok作者主页跳转！
function TiktokUrlSchemeJmup(roomid)
    i ={};
    -- android 配置的action 选项， 通常和uri 配合使用
    i['action'] = "android.intent.action.VIEW";
    -- uri 通常用作协议跳转
    i['uri'] = "snssdk1180://user/profile/"..roomid;
    runIntent(i);
    sleep(1000)
    local AuthorNamepos = R():text(".*@.*"):screen(1);
    local AuthorName = GetPosStatsInfo(AuthorNamepos, "获取Tiktok作者主页名", "text", false)
    PrintAndToast("作者名："..AuthorName)
end

function IsvedioPinned(video_idx)
    print("判断作者的主页视频是否被置顶")
    local vediopagelist = R():id("com.zhiliaoapp.musically:id/c9t"):getChild(video_idx):getChild(1):getBrother(-2):screen(1);
    local vedio_statustext = GetPosStatsInfo(vediopagelist,"主页视频置顶信息","text")
    
    if(vedio_statustext == "Pinned") then
        print("视频被置顶")
        print("视频的状态："..vedio_statustext)
        return true,vedio_statustext
    else
        print("视频未被置顶")
        return false,vedio_statustext
    end

end

--选择最新视频
function SelectCreaterNewVedio()
    PrintAndToast("判断视频是否是被置顶并进入")
    local reallyvideoidx = 1
    local video_idx = 1
    local pos_set = R():id("com.zhiliaoapp.musically:id/c9t"):getChild(1):screen(1);
    local set_type = GetPosStatsInfo(pos_set,"获取作者页面是否存在集合","type")
    if(set_type == "ViewGroup") then
        PrintAndToast("该作者存在视频集合")
        video_idx = video_idx + 1
    end

    while(video_idx<=8)
    do
        sleep(500)
        PrintAndToast(">>查询第"..reallyvideoidx.."号视频<<")
        local IsPinned,statustext = IsvedioPinned(video_idx)
        if(IsPinned == false) then
            -- if(statustext == "Story (1)") then 
            -- elseif(statustext == "Stories (2)") then 
            local isstory = false
            if(statustext == nil) then 
                local pos_video =  R():id("com.zhiliaoapp.musically:id/c9t"):getChild(video_idx):getChild(1):screen(1);
                local watch_num = R():id("com.zhiliaoapp.musically:id/c9t"):getChild(video_idx):getChild(1):getBrother(-1):screen(1);
                -- AutoClick(pos_video,"进入作者的最新视频")
                return pos_video,watch_num
            elseif(statustext == "Just watched") then 
                local pos_video =  R():id("com.zhiliaoapp.musically:id/c9t"):getChild(video_idx):getChild(1):screen(1);
                local watch_num = R():id("com.zhiliaoapp.musically:id/c9t"):getChild(video_idx):getChild(1):getBrother(-1):screen(1);
                return pos_video,watch_num
            else
                local pos_video =  R():id("com.zhiliaoapp.musically:id/c9t"):getChild(video_idx):screen(1);
                local watch_num = R():id("com.zhiliaoapp.musically:id/c9t"):getChild(video_idx):getChild(1):getBrother(-1):screen(1);
                return pos_video,watch_num
            end
        end
        video_idx = video_idx + 1
        reallyvideoidx = reallyvideoidx +1
    end
end

--下载视频
function DownloadVedioInTiktok()
    PrintAndToast("开始下载视频！")
    local isdownloadfinsh
    local pos_sharebutton = R():id("com.zhiliaoapp.musically:id/hiw"):screen(1);
    AutoClick(pos_sharebutton,"点击分享按钮")

    local pos_savevideobutton = R():text("Save video"):getParent():screen(1)
    CheckFunctionIsSucceed(pos_savevideobutton,"等待下载视频按钮出现")
    local pos_savevideobuttonview 
    local isexistsavevideobutton
    isexistsavevideobutton,pos_savevideobuttonview = CheckPosIsExist(pos_savevideobutton)
    if(isexistsavevideobutton) then
        PrintAndToast("该作品是视频格式！")
        AutoClick(pos_savevideobutton,"点击下载按钮！")
        local timepos = R():id("com.zhiliaoapp.musically:id/jla"):screen(1);
        local namepos = R():id("com.zhiliaoapp.musically:id/title"):screen(1);
        local downloadtime = GetPosStatsInfo(timepos,"获取发布时间","text",true,2)
        local name = GetPosStatsInfo(namepos,"获取发布时间","text",true,2)
        local info = {
            data = downloadtime,
            name = name
        }
        WriteFileData(info)
        if(WaitVideoDownloadFinish()) then
            local pos_savefinish = find(R():text("Video saved"):screen(1));
            if pos_finish or pos_photofinish or pos_savefinish then
                back()
            end
            sleep(500)
        end
    else
        PrintAndToast("该作品是图片格式！")
        back()
        sleep(1000)
    end
end

function WaitVideoDownloadFinish()
    print("等待视频下载！")
    time=1
    while(true)
    do
        local pos_finish = find(R():text("Share to"):screen(1));
        local pos_photofinish = find(R():text("Select photos to save"):screen(1));
        local pos_savefinish = find(R():text("Video saved"):screen(1));
        if pos_finish or pos_photofinish or pos_savefinish then
            print("视频下载成功！")
            return true
        end
        sleep(1000)
        print("视频下载等待:".. time)
        time = time+1
        if(time == 60) then
            print("下载失败！")
            error("下载出错！")
        end
    end
end

--通过收藏和点赞来标记是否是最新视频！
function GetOneTiktokCreaterNewVideo(TiktokAuthorName)
    local VideoIsRedZanColor = {638,890,678,911,"644,898,#FE2C55|656,894,#FE2C55|667,896,#FE2C55|646,902,#FE2C55|658,902,#FE2C55|671,903,#FE2C55",50}
    local VideoIsWhiteZanColor = {641,888,679,916,"646,895,#F9F3EC|658,894,#F9F1EA|666,896,#F8F1EA|645,903,#F6F0EA|657,903,#F9F1EB|669,905,#F8F1EA",50}
    local VideoIsRedShouColor = {640,1139,677,1166,"644,1149,#FACE15|656,1148,#FACE15|670,1147,#FACE15|644,1157,#FACE15|661,1157,#FACE15|669,1156,#FACE15",50}
    local VideoIsWhiteShouColor = {642,1139,679,1168,"645,1147,#FDFCF9|657,1147,#FDFCF9|668,1147,#FDFCF9|644,1162,#FEFCF9|661,1161,#FDFCF9|669,1160,#FDFCF9",50}
    local temp = TiktokAuthorName.."_groupID"
    temp = string.gsub(temp, "[\r\n]", "")
    local roomid = get(temp,"没有获取到值");
    if (roomid == "没有获取到值") then 
        PrintAndToast("未存储该作者的groupID！")
        return -1
    end
    TiktokUrlSchemeJmup(roomid)
    -- sleep(2000)
    local pos_video = 0
    local watch_numpos = 0
    local VideoWatchedNum = 0
    local pos_video,watch_numpos = SelectCreaterNewVedio() -- 选中最新视频并进入
    print(watch_numpos)
    local VideoWatchedNumText = GetPosStatsInfo(watch_numpos,"获取Tiktok视频的播放数量！","text")
    -- print(VideoWatchedNumText)
    if VideoWatchedNumText then
        if VideoWatchedNumText:sub(-1) == "M" then
            local idx = string.find(VideoWatchedNumText,"M")
            VideoWatchedNum = tonumber(VideoWatchedNumText:sub(0,idx-1)) * 1000000
            PrintAndToast("该视频的播放量是" .. VideoWatchedNum)
        elseif VideoWatchedNumText:sub(-1) == "K" then
            local idx = string.find(VideoWatchedNumText,"K")
            VideoWatchedNum = tonumber(VideoWatchedNumText:sub(0,idx-1)) * 1000
            PrintAndToast("该视频的播放量是" .. VideoWatchedNum)
        else
            VideoWatchedNum = tonumber(VideoWatchedNumText)
            PrintAndToast("该视频的播放量是" .. VideoWatchedNum)
        end
        local AuthorId = TiktokAuthorName.."_TiktokWatchNum"
        print(AuthorId)
        local context = get(AuthorId,"没有获取到值");
        if(context == "没有获取到值")then 
            PrintAndToast("继续下面的步骤！")
            save(AuthorId,tostring(VideoWatchedNum))
        elseif(tonumber(context) <= VideoWatchedNum )then
            PrintAndToast("存储的播放量："..context)
            PrintAndToast("播放量增加或者未变！")
            PrintAndToast(TiktokAuthorName.."--->未更新！")
            save(AuthorId,tostring(VideoWatchedNum))
            return 0
        elseif(tonumber(context) > VideoWatchedNum ) then
            PrintAndToast("存储的播放量："..context)
            PrintAndToast("播放量减少可能更新视频！")
            save(AuthorId,tostring(VideoWatchedNum))
        end

        sleep(1000)
    else
        PrintAndToast("没有数据返回直接进入视频")
    end
    AutoClick(pos_video,"进入作者的最新视频",false,true)
    local IsZan = CheckColorIsSucceed(VideoIsWhiteZanColor,"检查该视频是否被点赞标记！",2)
    local IsShou = CheckColorIsSucceed(VideoIsWhiteShouColor,"检查该视频是否被收藏标记！",2)
    if(IsZan and IsShou) then
        PrintAndToast("该视频未被标记存在最新视频！")
        PrintAndToast(TiktokAuthorName.."--->存在最新视频！")
        PrintAndToast("开始下载视频！")
        DownloadVedioInTiktok()
        sleep(1000)
        AutoColorClick(VideoIsWhiteZanColor,"视频下载完毕，点赞标记一下！")
        sleep(200)
        AutoColorClick(VideoIsWhiteShouColor,"视频下载完毕，点赞标记一下！")
        sleep(500)
        local IsRedZan = CheckColorPosIsExist(VideoIsRedZanColor)
        local IsYelShou = CheckColorPosIsExist(VideoIsWhiteShouColor)
        if(IsRedZan or IsYelShou) then 
            PrintAndToast("标记成功！")
        else
            PrintAndToast("标记失败！")
        end
        return 1
    else
        PrintAndToast("该视频被标记无最新视频！")
        PrintAndToast(TiktokAuthorName.."--->未更新！")
        return 0
    end
end




--获取Tiktok所有作者的的
function GetTiktokAllCreaterNewVideo(filename)
    -- 获取程序开始时间戳
    local start_time = os.time()
    local AuthorTable = {}
    local IsAuthorTable = {}
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
                        local value = GetOneTiktokCreaterNewVideo(AuthorTable[i][j])
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
            home()
            return
        else
            PrintAndToast("Tiktok爬取视频错误")
            CloseAllPross()
            local Ishasnet = CheckNetIsConnect("Tiktok")
            if(Ishasnet == false)then 
                InitChooseBestNet() 
            end
        end
    end
end

