--PhoneControls.lua

-- print("Number of mp4 files: " .. count)
function CountPhoneVideoNum(filepath)
    -- DataInitfile = io.open("sdcard/snaptube/download/SnapTube Video/3.txt", "w+")
    -- local youtubevideonum = GetDirFile("sdcard/snaptube/download/") --youtubepath
    -- local tiktokvideonum = GetDirFile("sdcard/DCIM/Camera/") --tiktokpath
    local count = 0
    local filedir = GetDirFile(filepath)
    for i, v in ipairs(filedir) do
        if v:match("%.mp4$") then
            count = count + 1
        end
    end 
    return count
end


function CloseAllPross()
    home()
    sleep(600)
    jobs();
    sleep(1000) -- 需要等待不然关闭程序按钮未加载出来！
    
    
    local app_managerlist = R():desc("最近无运行应用");
    local IsExistOtherProcess,noneview = CheckPosIsExist(app_managerlist)
    if(IsExistOtherProcess) then 
        print("无程序需要清除！")
        back()
    else
        pos_prossclosebutton = R():id("com.hihonor.android.launcher:id/clear_all_recents_image_button");
        AutoClick(pos_prossclosebutton,"关闭按钮！",false,false,true)
        local closebutton = R():text("关闭应用");
        local IsExistOtherProcess,noneview = CheckPosIsExist(closebutton)
        if(IsExistOtherProcess) then 
            AutoClick(closebutton,"关闭报错按钮！",false,false,true)
        end
        slid(360,1560,360,1440,400);
        print("滑动界面处理界面卡死！")
        sleep(1000)
        print("关闭所有程序成功！")
    end
end

function OpenPhoneapp(app_name)
    --返回桌面寻找app_name
    home();--返回桌面
    --返回桌面寻找app_name
    local target_app = R():text(app_name);
    AutoClick(target_app,"找到"..app_name.."，并打开！")
end

function CheckNetIsConnect(app_name)
    local testurl = 0
    if(app_name == "Tiktok") then
        testurl = "http:/www.tiktok.com"
    elseif(app_name=="YouTube")then 
        testurl = "http:/www.youtube.com"
    else
        testurl = "http:/www.baidu.com"
    end
    --组装http 请求参数
    local p = {
    param={};
    header={};
    timeout = 5;
    }
    PrintAndToast("开始测试网路是否成功！")
    --1.【必填】请求的url 地址
    p.url = testurl ;
    res = httpGet(p);
    if res then
        PrintAndToast(app_name.."连接成功！！！")
        PrintAndToast(res.code);
        return true
    end
    PrintAndToast(app_name.."连接失败！！！")
    return false
end

function ClearPhoneNotice()
    print("打开通知框！")
    noti();
    sleep(500)
    local clearnoticebutton = R():id("com.android.systemui:id/delete");
    AutoClick(clearnoticebutton,"点击清理通知！",false,false,true)
    if(not CheckFunctionIsSucceed(clearnoticebutton,"如果按钮不存在则清除干净！")) then 
        print("通知清理完毕！")
        back()
    else
        print("通知清理失败！")
        back()
    end
end

function OpenWifi()
    CloseConnectVpn()
    while true do 
        local current_time = os.date("*t")
        local hour = current_time.hour
        local min = current_time.min
        if(hour >= 6 and hour <=23) then 
            noti();
            sleep(500)
            local wifipos = R():path("/FrameLayout/FrameLayout/ViewGroup"):getChild();
            AutoClick(wifipos,"打开wifi设置！",true)

            sleep(2000)
            local husestudentwifi = R():text("HUSE-Student"):getParent();
            AutoClick(husestudentwifi,"点击校园网并且连接！HUSE-Student",false,false,true)
    
            local connectpos = R():text("连接");
            AutoClick(connectpos,"点击连接按钮",false,false,true)
            sleep(10000)
            -- noti();
            -- local opennotifunction = R():desc("展开快捷设置");
            -- AutoClick(opennotifunction,"展开快捷设置!",false,false,true)
    
            -- local selfwifiopenhot = R():text("个人热点"):getParent():getParent();
            -- local wifihotinfo = GetPosStatsInfo(selfwifiopenhot,"获取热点的信息文本","desc",true)
            -- print("当前热点情况："..wifihotinfo)
            -- if(wifihotinfo ~= "个人热点,已开启") then 
            --     AutoClick(selfwifiopenhot,"点开个人热点！!",false,false,true)
            -- else
            --     print("热点已在开启状态！！")
            -- end
    
            -- local husestudentwifiposinfo = R():path("/FrameLayout/FrameLayout/ViewPager/ViewGroup/LinearLayout");
            -- local wifiinfo = GetPosStatsInfo(husestudentwifiposinfo,"获取WiFi连接信息","desc",true)
            -- print("当前wifi情况："..wifiinfo)
            -- if(string.sub(wifiinfo,19,27) ~= "已开启") then 
            --     print("重新连接！")
            --     AutoClick(wifipos,"打开wifi",false,false,true)
            --     print("试试！")
            -- end
    
            --组装http 请求参数
            p={};
            --1.【必填】请求的url 地址
            p.url ="http:/www.baidu.com";
            res = httpGet(p);
            if res then
                print("wifi连接成功！！！")
                print(res.code);
                return
            end
            print("wifi连接失败！！！")
    		
    		back()
    		sleep(500)
            local wifiswitchpos = R():id("com.android.settings:id/switch_widget");
            AutoClick(wifiswitchpos,"点击wifi开关!",false,false,true)
    
            sleep(1000)
            AutoClick(wifiswitchpos,"点击wifi开关!",false,false,true)
        else
            print("继续等待.........")
            sleep(3000)
        end
    end
end


function InitPhoneENV() 
    -- DeleteAllVideo()
    InitChooseBestNet() 
    CloseAllPross()
    ClearPhoneNotice()
end

function DeleteAllVideo()
    local time = 1
    CloseAllPross()
    --返回桌面寻找图库
    OpenPhoneapp("图库")

    --选中视频选项然后进入
    local albumvideopos = R():text("视频"):getParent();
    while time<=3 do 
        local IsExistVideo,noneview = CheckPosIsExist(albumvideopos)
        if(IsExistVideo) then 
            AutoClick(albumvideopos,"进入视频区块！")
    
            --选择一个视频并长按
            local onevideopos = R():id("com.hihonor.photos:id/iv_thumbnail");
            AutoClick(onevideopos,"长按选中视频",true,false)
    
            local allselectbutton = R():text("全选");
            AutoClick(allselectbutton,"点击全选按钮!",false,false,true)
    
            local deletebutton = R():text("删除");
            AutoClick(deletebutton,"点击删除按钮!")
    
            local againdeletebutton = R():id("android:id/button1");
            AutoClick(againdeletebutton,"点击确认删除按钮!")
            print("视频已经清除完毕！")
            break 
        end
        time = time + 1
        sleep(500)
        print("未检测到目标！")
    end
    CloseAllPross()
end

function GetCurrentVideoNum()
    local CurrentVideoNum = 0
    local time = 1
    CloseAllPross()
    --返回桌面寻找图库
    OpenPhoneapp("图库")
    --选中视频选项然后进入
    sleep(2000)
    while time<=3 do 
        local albumvideopos = R():text("视频");
        local IsExistVideo,noneview = CheckPosIsExist(albumvideopos)
        if(IsExistVideo) then 
            local videonumpos = R():text("视频"):getParent():getChild(2);
            CurrentVideoNum = GetPosStatsInfo(videonumpos,"获取视频数量","text")
            print("当前视频数量："..CurrentVideoNum)
            CloseAllPross()
            return CurrentVideoNum
        end
        time = time + 1
        sleep(500)
        print("未检测到目标！")
    end
    --视频数量为0
    print("无视频存在！")
    CurrentVideoNum = 0

    print("当前视频数量："..CurrentVideoNum)
    CloseAllPross()
    return CurrentVideoNum
end

function DeleteSomeVideo(somevideonum)
    print("删除指定数量的视频！")
    local time = 1
    local videoidx = 1
    CloseAllPross()
    while true do 
        if pcall(
            function()
                --返回桌面寻找图库
                OpenPhoneapp("图库")
                while time<=3 do 
                    --选中视频选项然后进入
                    local albumvideopos =R():text("视频"):getParent();
                    local IsExistVideo,noneview = CheckPosIsExist(albumvideopos)
                    if(IsExistVideo) then 
                        AutoClick(albumvideopos,"进入视频区块！")
                        local onevideopos = R():path("/FrameLayout/RecyclerView"):getChild(1);
                        --选择一个视频
                        AutoClick(onevideopos,"进入第一个视频！",false,true)
                            
                        while videoidx<=somevideonum do 
                            local deletebutton = R():text("删除");
                            AutoClick(deletebutton,"点击删除按钮!")
    
                            local againdeletebutton = R():id("android:id/button1");
                            AutoClick(againdeletebutton,"点击确认删除按钮!")
                            sleep(500)
                            videoidx = videoidx + 1
                        end
                        break
                    end
                    time = time + 1
                    sleep(500)
                    print("未检测到目标！")
                end
            end
        ) then
            print("成功"..somevideonum.."个删除完成！")
            home()
            break
        else
            print("视频清除错误！重新清除！")
            ErrorFix()
            CloseAllPross()
        end
    end
end
