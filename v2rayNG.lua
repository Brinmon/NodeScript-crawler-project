--v2rayNG.lua
function CheckConnetStatus() 
    -- 获取是否连接vpn
    local vpnconnect_info = R():id("com.v2ray.ang:id/tv_test_state");
    isvpnconnect_txt = GetPosStatsInfo(vpnconnect_info,"连接是否已经连接vpn","text")
    print("连接状态："..isvpnconnect_txt)

    local connectresult = string.sub(isvpnconnect_txt,1,9)
    print("连接结果："..connectresult) -->hello..up.down.4
    if (connectresult == "已连接" or connectresult == "连接成") then
        print("连接成功！")
        return true
    elseif(connectresult == "未连接") then
        print("未连接！")
        return false
    end
end

function InitChooseBestNet() 
    local time = 0

    CloseAllPross()
    OpenPhoneapp("v2rayNG")
    
    local moreoperatepos = R():desc("更多选项");
    AutoClick(moreoperatepos,"点击更多按钮！")
    sleep(500)
    
    local Testallnetpos = R():text("测试全部配置真连接"):getParent();
    AutoClick(Testallnetpos,"点击测试全部配置真连接！")
    
    while(time < 18) do 
        sleep(1000)
        time = time + 1
        if(time%3 == 0) then 
            print("等待节点测试："..time)
        end
    end
    
    local moreoperatepos = R():desc("更多选项");
    AutoClick(moreoperatepos,"点击更多按钮！")
    sleep(500)
    
    local orderallnetpos = R():text("按测试结果排序"):getParent();
    AutoClick(orderallnetpos,"点击按测试结果排序！")
    sleep(1000)
    
    local BestNetPos = R():id("com.v2ray.ang:id/recycler_view"):getChild(1):getChild(1);
    AutoClick(BestNetPos,"点击按测试结果排序！")
    sleep(1000)
    
    while(true) do
        if(CheckConnetStatus()) then 
            home();--返回桌面
            sleep(1000)
            print("成功连接vpn！")
            return;
        else 
            local vpnbutton = R():id("com.v2ray.ang:id/fab");
            AutoClick(vpnbutton,"未连接，点击链接vpn")
            sleep(500)
        end
    end


end

function ConnectVpn()
    --找到桌面上的vpn
    home();--返回桌面
    OpenPhoneapp("v2rayNG")

    while(true) do
        if(CheckConnetStatus()) then 
            home();--返回桌面
            sleep(1000)
            print("成功连接vpn！")
            return;
        else 
            local vpnbutton = R():id("com.v2ray.ang:id/fab");
            AutoClick(vpnbutton,"未连接，点击链接vpn")
            sleep(500)
        end
    end
end

function CloseConnectVpn()
    --找到桌面上的vpn
    home();--返回桌面
    OpenPhoneapp("v2rayNG")

    while(true) do
        if(CheckConnetStatus()) then 
            local vpnbutton = R():id("com.v2ray.ang:id/fab");
            AutoClick(vpnbutton,"未连接，点击链接vpn")
            sleep(500)
        else 
            home();--返回桌面
            sleep(1000)
            print("成功断开vpn连接！")
            return;
        end
    end
end
