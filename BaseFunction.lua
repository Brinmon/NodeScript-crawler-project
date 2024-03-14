--BaseFunction.lua文件
--1.检查是否存在目标节点
--a.判断节点是否存在于屏幕之中 :screen(1)
--b.判断节点是否存在于节点之中
local globaltime = 14

function PrintAndToast(strs)
    if(strs ~= nil)then 
        print(strs)
        toast(strs,1000)
    end
end


function CheckPosIsExist(rule)
    local view = find(rule);  -- 查找节点
    if view then            -- 判断节点是否存在
        return true,view
    else 
        return false,view
    end
end

--c.查找图色节点是否存在
function CheckColorPosIsExist(rule)
    local view = findColor(rule);   -- 查找节点
    if view then            -- 判断节点是否存在
        return true,view
    else 
        return false,view
    end
end

--智能点击按钮
--rule:路径规则  str：调试信息 longflag：是否长按 posflag：是否使用坐标点击
--坐标点击时要确保目标上层无遮挡
function AutoClick(rule,str,longflag,posflag,iswait)
    local PosIsExist
    local targetview
    local time = 1
    local islongclick = 0
    local isposclick = 0
    if longflag then 
        islongclick = 1
    end
    if posflag then 
        isposclick = 1
    end

    while(true)
    do
        PosIsExist,targetview = CheckPosIsExist(rule)
        if(PosIsExist) then 
            PrintAndToast(str.." 节点：存在！！！")
            if(targetview.isClick == true) then
                if(islongclick == 0) then 
                    PrintAndToast(str.." 节点：可点击！")
                    if(isposclick == 0) then 
                        targetview:click()
                        PrintAndToast(str.." 节点：点击成功！")
                        sleep(500)
                        return 1;
                    end
                end
            else
                PrintAndToast(str.." 不可点击！")
                -- error("按钮不可点击！",0)
            end
            if(isposclick == 1) then 
                click((targetview.rect.left + targetview.rect.right)/2 , (targetview.rect.top + targetview.rect.bottom)/2)
                PrintAndToast(str.." 节点：坐标点击成功！")
                sleep(500)
                return 1;
            elseif(islongclick == 1) then
                PrintAndToast(str.." 节点：可点击！")
                click((targetview.rect.left + targetview.rect.right)/2 , (targetview.rect.top + targetview.rect.bottom)/2,800)
                PrintAndToast(str.." 节点：长按成功！")
                sleep(500)
                return 1;
            end
        end
    
        if(iswait and time == 4) then 
            PrintAndToast("无需等待直接跳过！")
            return "跳过"
        end
        
        if(time == globaltime) then
            PrintAndToast("AutoClick控件点击失败重新运行！")
            PrintAndToast(str.." 不存在！")
            error("按钮不存在！",0) 
        else
            sleep(1000)
            PrintAndToast("AutoClick控件点击循环:".. time)
            time = time+1
        end
    end
end

-- 按照图色坐标查找
function AutoColorClick(rule,str,iswait,num)
    local PosIsExist
    local targetview
    local tempnum = 0
    local time = 1
    if(iswait)then
        tempnum = num
    end
    while(true)
    do
        PosIsExist,targetview = CheckColorPosIsExist(rule)
        if(PosIsExist) then 
            PrintAndToast(str.." 图色节点：存在！")
            click(targetview.x,targetview.y)
            PrintAndToast(str.." 图色节点：点击成功！")
            return;
        end

        if(iswait and time == tempnum) then 
            PrintAndToast("无需等待直接跳过！")
            return "跳过"
        end
    
        if(time == globaltime) then
            PrintAndToast("AutoColorClick图色点击失败重新运行！")
            PrintAndToast(str.." 不存在！")
            error("图色按钮不存在！",0) 
        else
            sleep(1000)
            PrintAndToast("AutoColorClick图色点击循环:".. time)
            time = time+1
        end
    end
end

-- 6.只存在一条路径下获取节点信息
function GetPosStatsInfo(rule,str,target,iswait,num)
    local PosIsExist
    local targetview
    local time = 1

    while(true)
    do
        PosIsExist,targetview = CheckPosIsExist(rule)
        if(PosIsExist) then 
            PrintAndToast(str.." 节点：存在!")
            if(target == "text") then
                PrintAndToast(str.." 获取文本信息text！成功！")
                return targetview.text
            elseif(target == "type") then
                PrintAndToast(str.." 获取控件类型type！成功！")
                return targetview.type
            elseif(target == "desc") then
                PrintAndToast(str.." 获取控件类型desc！成功！")
                return targetview.desc
            elseif(target == "childnum") then
                PrintAndToast(str.." 获取控件类型type！成功！")
                return targetview.childCount
            end
        end
    
        if(iswait and time == num) then 
            PrintAndToast("无需等待直接跳过！")
            return "跳过"
        end


        if(time == globaltime) then
            PrintAndToast("GetPosStatsInfo获取失败重新运行！")
            PrintAndToast(str.." 不存在！")
            error("获取信息失败！",0) 
        else
            sleep(1000)
            PrintAndToast("GetPosStatsInfo获取循环:".. time)
            time = time+1
        end
    end
end

-- 向输入框输入文本
-- rule:路径规则 ，str：要输入的内容 ， pasteflag：是否使用剪切板输入
function AutoInput(rule,str,pasteflag)
    local PosIsExist
    local targetview
    local time = 1
    local ispaste = 0
    if pasteflag then 
        ispaste = 1
    end

    while(true)
    do
        PosIsExist,targetview = CheckPosIsExist(rule)
        if(PosIsExist) then 
            if(ispaste == 0) then 
                PrintAndToast("输入框存在！")
                targetview:input(str)
                PrintAndToast("输入成功："..str)
                return;
            elseif(ispaste == 1) then 
                PrintAndToast("输入框存在！将内容放置于剪切板："..str)
                putClipboard(str)
                sleep(500)
                AutoClick(rule,"文本输入框",true) -- 长按输入框，直到出现粘贴
                local pastepos =R():path("/FrameLayout/RelativeLayout/LinearLayout"):screen(1);
                AutoClick(pastepos,"粘贴按钮") -- 点击出现粘贴的坐标 
                return;
            end
        end
    
        if(time == globaltime) then
            PrintAndToast("AutoInput输入失败重新运行！")
            PrintAndToast(str.." 不存在！")
            error("图色按钮不存在！",0) 
        else
            sleep(1000)
            PrintAndToast("AutoInput输入循环:".. time)
            time = time+1
        end
    end
end

--等待成功信号
function CheckFunctionIsSucceed(succeedrule,outputstr,iswait,time1)
    local time = 3
    if iswait == true then 
        time = time1
    end

    local whiletime = 1
    while whiletime<=time do 
        local IsSucceed,noneview = CheckPosIsExist(succeedrule)
        PrintAndToast("检测次数："..whiletime)
        if (IsSucceed) then
            PrintAndToast("《调试信息》："..outputstr)
            PrintAndToast("功能成功实现！")
            return true
        else
            sleep(1000)
            PrintAndToast("CheckFunctionIsSucceed！继续等待")
        end
        whiletime = whiletime + 1
    end
    PrintAndToast("《调试信息》："..outputstr)
    PrintAndToast("功能实现失败！")
    return false
end

--等待Color成功信号
function CheckColorIsSucceed(succeedrule,outputstr,iswait,time1)
    local time = 3
    if iswait == true then 
        time = time1
    end
    local whiletime = 1
    while whiletime<=time do 
        local IsSucceed,noneview = CheckColorPosIsExist(succeedrule)
        PrintAndToast("检测次数："..whiletime)
        if (IsSucceed) then
            PrintAndToast("《调试信息》："..outputstr)
            PrintAndToast("功能成功实现！")
            return true
        else
            sleep(1000)
            PrintAndToast("CheckFunctionIsSucceed！继续等待")
        end
        whiletime = whiletime + 1
    end
    PrintAndToast("《调试信息》："..outputstr)
    PrintAndToast("功能实现失败！")
    return false
end

--1.一条路径下滑动
function AutoSild(rule,str)
    local PosIsExist
    local targetview
    local time = 1
    while (true) do
        PosIsExist,targetview = CheckPosIsExist(rule)
        if(PosIsExist) then 
            targetview:slid(1)
            sleep(200)
            PrintAndToast(str)
            break
        end
        sleep(3000)
        PrintAndToast("AutoSild控件滑动循环:".. time)
        time = time+1
        if(time == globaltime) then
            PrintAndToast("AutoSild控件滑动失败重新运行！")
            error("发生错误了！") 
        end
    end
end


--判断当前是否处于正确的页面
function CheckIsTargetPage(targetpage)
    PrintAndToast("CheckIsTargetPage判断是否在目标页面！")
    local CurrentPage
    local info =  getPageInfo();
    CurrentPage = info.activity
    if CurrentPage == targetpage then 
        PrintAndToast("成功前往目标页面："..targetpage)
        return true
    else
        PrintAndToast("不在目标页面,当前在："..CurrentPage)
        return false
    end
end
    
--前往目标页面
function EnterTargetPage(startpage,targetpage,operate)
    if(CheckIsTargetPage(startpage)) then 
        operate()
        if(CheckIsTargetPage(targetpage)) then 
            PrintAndToast("成功！")
        end
    else
        PrintAndToast("起始页面错误！")
    end
end

function GetPageinfo()
    local info =  getPageInfo();
    if info then 
        PrintAndToast(info.name);-- 当前应用名称
        PrintAndToast(info.packageName);-- 当前应用的id
        PrintAndToast(info.activity);--当前页面的名称
    end
end

function OutPutOperationTime(start_time,end_time) 
    local run_time = end_time - start_time

    -- 将秒数转换为小时、分钟、秒
    local hours = math.floor(run_time / 3600)
    local minutes = math.floor((run_time % 3600) / 60)
    local seconds = run_time % 60
    
    -- 输出运行时间
    PrintAndToast("程序运行时间：" .. hours .. "小时 " .. minutes .. "分钟 " .. seconds .. "秒")
end

function WriteFileData(str)
    local current_time = os.date("%Y%m%d")
    local file_name = "DownloadLog.txt"
    local path = getDir().."/"..file_name
    local line_count = 0
    local file = io.open(path, "r+")
    if file then
        for _ in file:lines() do
            line_count = line_count + 1
        end
        file:close()
        print("文本文件的行数为：" .. line_count)
    else
        print("无法打开文件。")
    end
    local current_time = os.date("*t")
    local year = current_time.year
    local month = current_time.month
    local day = current_time.day
    local hour = current_time.hour
    local min = current_time.min
    local sec = current_time.sec

    local info = tostring(math.floor(line_count/2)).."个："..year .. "年" .. month .. "月" .. day .. "日 " .. hour .. ":" .. min .. ":" .. sec .. "->"..str.data
    info = info.."\n"..str.name.."\n"
    -- 打开文件以追加模式
    local file = io.open(path, "a+")
    if file then
        -- 追加内容
        file:write(info)
        -- 关闭文件
        file:close()
        print("内容已追加到文件末尾。")
    else
        print("无法打开文件。")
    end
end 

