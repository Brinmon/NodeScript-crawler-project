--DataEdit.lua   
--数据初始化模式！ 
-- 0：将TiktokAuthorInfo的信息读取出来并写入保存到程序中
-- 1：将程序中的信息存储起来到TiktokAuthorInfo
function DataInit(mod)
    if(mod == 0) then 
        AddTxtDataToProcessInfo("Tiktok")
        AddTxtDataToProcessInfo("YouTube")
    elseif(mod == 1) then 
        AddProcessInfoToTxtData("Tiktok")
        AddProcessInfoToTxtData("YouTube")
    end
end

--加载文本数据进入进程
function AddTxtDataToProcessInfo(app_name)
    local AuthorInfoPath = "" --存放name 和 id
    local AuthorPath = "" --只存放 name
    local IDText = ""
    if(app_name == "Tiktok") then 
        AuthorInfoPath =  getDir().."/TiktokAuthorInfo.txt";
        print(AuthorInfoPath)
        AuthorPath = getDir().."/TiktokAuthor.txt"
        IDText = "groupID"
    elseif(app_name == "YouTube") then 
        AuthorInfoPath =  getDir().."/YouTubeAuthorInfo.txt";
        print(AuthorInfoPath)
        AuthorPath = getDir().."/YouTubeAuthor.txt"
        IDText = "channelID"
    end

    --以写的模式打开只存放 name的文本，相当于覆盖写入
    local AuthorFile = io.open(AuthorPath, "w+")
    --先输出存放name 和 id的文件有啥数据
    ReadFileData(AuthorInfoPath)
    --读取出存放name 和 id的文本
    local AuthorInfoFile = io.open(AuthorInfoPath, "r+")
    if AuthorInfoFile then
        for line in AuthorInfoFile:lines() do
            if(line == "\n")then 
                print("dasd"..line)
                break
            end
            local firstString, secondString = line:match("(%S+)%s+(%S+)")
            -- print("First string: " .. firstString)
            -- print("Second string: " .. secondString)
            --将作者写入txt文本
            AuthorFile:write(firstString.."\n")
            save(firstString.."_"..IDText, secondString)
        end
        AuthorInfoFile:close()
        AuthorFile:close()
        PrintAndToast(app_name.."加载文本数据进入进程成功！")
        return
    else
        PrintAndToast(app_name.."加载文本数据进入进程失败！")
        return
    end
end

--将程序中的信息写入文本中
function AddProcessInfoToTxtData(app_name)
    local AuthorInfoPath = "" --存放name 和 id
    local AuthorPath = "" --只存放 name
    local IDText = ""
    if(app_name == "Tiktok") then 
        AuthorInfoPath =  getDir().."/TiktokAuthorInfo.txt";
        AuthorPath = getDir().."/TiktokAuthor.txt"
        IDText = "groupID"
    elseif(app_name == "YouTube") then 
        AuthorInfoPath =  getDir().."/YouTubeAuthorInfo.txt";
        AuthorPath = getDir().."/YouTubeAuthor.txt"
        IDText = "channelID"
    end

    local tableinfo = {} -- 存放name和id的键值对
    local AuthorFile = io.open(AuthorPath, "r+") --读取现在程序中记录的作者
    if AuthorFile then
        for line in AuthorFile:lines() do
            local AuthorId = line.. "_"..IDText
            local context = get(AuthorId,"没有获取到值"); --获取每个用户的id！
            tableinfo[line] = context
        end
        AuthorFile:close() --读取完成！！！
        PrintAndToast("成功取出所有"..app_name..IDText)
    else
        PrintAndToast("无法打开AuthorFile文件进行读取！")
        return
    end
    print(tableinfo)--输出获取的的信息

    local AuthorInfoFile = io.open(AuthorInfoPath, "w+")
    if AuthorInfoFile then
        for element, id in pairs(tableinfo) do
            AuthorInfoFile:write(element .. " "..id.."\n") --将作者的name和id写入文件中
        end
        AuthorInfoFile:close()
        PrintAndToast("将程序中的所有"..app_name.."数据全部写入文件！")
    else
        PrintAndToast("无法打开AuthorInfoFile文件进行写入！")
        return
    end
end

-- 将表保存到文本文件
function saveTableToFile(t, filename)
    local file = io.open(getDir().."/"..filename, "w+")
    if file then
        for element, _ in pairs(t) do
            file:write(element .. "\n")
        end
        file:close()
        PrintAndToast("表保存成功！")
    else
        PrintAndToast("无法打开文件进行写入！")
    end
end

-- 从文本文件中读取表数据
function loadTableFromFile(filename)
    local t = {}
    local file = io.open(getDir().."/"..filename, "r+")
    if file then
        for line in file:lines() do
            local temp = string.gsub(line, "[\r\n]", "")
            t[temp] = true
        end
        file:close()
        PrintAndToast("表加载成功！")
        return t
    else
        PrintAndToast("无法打开文件进行读取！")
        return nil
    end
end


--读取文本数据化为table
function ReadTextToTable(AuthorTable,IsAuthorTable,filename)
    local tempAuthorTable = {}
    local tempIsAuthorTable = {}
    local tablelen = 10
    local idx_1 = 0
    local idx_2 = 0
    TiktokAuthorfile = io.open(getDir().."/"..filename, "r+")
    if TiktokAuthorfile then
        for line in TiktokAuthorfile:lines() do
            tempAuthorTable[idx_2] = line
            tempIsAuthorTable[idx_2] = true
            if(idx_2 == tablelen-1) then 
                AuthorTable[idx_1] = tempAuthorTable
                IsAuthorTable[idx_1] = tempIsAuthorTable
                tempAuthorTable = {}
                tempIsAuthorTable = {}
                idx_1 = idx_1 + 1
            end
            idx_2 = (idx_2 + 1) % tablelen
        end
        if(idx_2 ~= tablelen-1)then 
            tempAuthorTable[idx_2] = "end"
            tempIsAuthorTable[idx_2] = true
            AuthorTable[idx_1] = tempAuthorTable
            IsAuthorTable[idx_1] = tempIsAuthorTable
        end
        PrintAndToast(filename.."文件加载成功！")
        TiktokAuthorfile:close()
        print(AuthorTable)
        return AuthorTable,IsAuthorTable
    else
        print("无法打开文件进行读取！")
    end
end



function ReadFileData(path)
    -- 打开文件以只读模式
    local file = io.open(path, "r")

    if file then
        -- 读取文件内容
        local content = file:read("*a")
        -- 关闭文件
        file:close()
        -- 打印文件内容
        print("文件内容:")
        print(content)
    else
        print("无法打开文件。")
    end

end 








--发现这些操作作用不大去除

--添加视频作者
-- function AddVideoAuthor(app_name)
--     local temp = {match='@.*';sim=0.7;line=false; }
--     sleep(1000)
--     local AuthorNamePos = 0
--     local tempAuthorName = ""


--     PrintAndToast("运行：AddVideoAuthor添加"..app_name.."作者")
--     if(app_name == "YouTube") then 
--         -- local morecolorpos = {652,72,698,119,"674,83,#000000|675,96,#000000|675,107,#000000|658,94,#FFFFFF|687,94,#FFFFFF|675,114,#FFFFFF",60}
--         -- AutoColorClick(morecolorpos,"点击主页的左上角！")
--         -- local sharepos = R():text("分享"):getParent():screen(1);
--         -- AutoClick(sharepos,"点击分享按钮！",false,true)
--         -- local copylinkpos = R():desc("复制链接"):screen(1);
--         -- AutoClick(copylinkpos,"点击复制链接",false,true)
--         -- sleep(1000)
--         -- local msg = getClipboard(); --获取剪贴板中的内容
--             -- PrintAndToast(msg)
--         local r = {match='@.*';sim=0.7;line=false; }
--         local res = ocrp(r);
--         print(res)
--         if #res ~= 0 then 
--             PrintAndToast("获取作者名成功！！")
--             print(res[1]["text"]:match("(%S+)"))
--             tempAuthorName = res[1]["text"]:match("(%S+)")
--         else
--             PrintAndToast("获取作者名失败！！")
--             return 0
--         end
--         -- local AuthorName = "@"..str["text"]:match()
--         -- AuthorName = msg:match("@([^%?]+)")
--         filename = "YouTubeAuthor.txt"
--     elseif(app_name == "TikTok")then 
--         AuthorNamePos =R():text(".*@.*"):screen(1);
--         filename = "TiktokAuthor.txt"
--         tempAuthorName = GetPosStatsInfo(AuthorNamePos,"获取"..app_name.."作者主页名","text",False)
--         print(tempAuthorName)
--         if(tempAuthorName == "跳过")then 
--             PrintAndToast("未搜索到作者名，跳过！")
--             return
--         end
--     end
    
--     local AuthorName = tempAuthorName:sub(2)
--     PrintAndToast("作者名："..AuthorName)
--     local AuthorTable = loadTableFromFile(filename)
--     print(AuthorTable)
--     if(AuthorTable[AuthorName] == true) then 
--         PrintAndToast("作者已存在,无需加入！")
--         print("目前存储的作者：")
--         print(AuthorTable)
--         return
--     end
--     AuthorTable[AuthorName] = true
--     PrintAndToast("作者不存在,现在加入！")
--     print("目前存储的作者：")
--     print(AuthorTable)
--     saveTableToFile(AuthorTable,filename)
-- end

-- -- #删除视频作者
-- function DeleteVideoAuthor(app_name)
--     PrintAndToast("运行：DeleteVideoAuthor删除"..app_name.."作者")
--     local AuthorNamePos = 0
--     if(app_name == "YouTube") then 
--         AuthorNamePos = R():text(".*@.*"):screen(1);
--         filename = "YouTubeAuthor.txt"
--     elseif(app_name == "Tiktok")then 
--         AuthorNamePos = R():text(".*@.*"):screen(1);
--         filename = "TiktokAuthor.txt"
--     end
    
--     local tempAuthorName = GetPosStatsInfo(AuthorNamePos,"获取"..app_name.."作者主页名","text",False)
--     if(tempAuthorName == "跳过")then 
--         PrintAndToast("未搜索到作者名，跳过！")
--         return
--     end

--     local AuthorName = string.sub(tempAuthorName, 2)
--     PrintAndToast("作者名："..AuthorName)
--     AuthorTable = loadTableFromFile(filename)
--     if(AuthorTable[AuthorName] == true) then 
--         PrintAndToast("作者存在，可以删除！")
--         AuthorTable[AuthorName] = nil
--         saveTableToFile(AuthorTable,filename)
--         print("目前存储的作者：")
--         print(AuthorTable)
--         return
--     end
--     PrintAndToast("该作者未加入列表中，跳过：")
--     print(AuthorTable)
-- end



-- --查找作者名字，-1就是展示所有作者
-- function ShowVideoAuthor(app_name,Authoridx)
--     local filename = 0
--     PrintAndToast("运行：ShowVideoAuthor展示"..app_name.."作者列表！")
--     if(app_name == "YouTube") then 
--         filename = "YouTubeAuthor.txt"
--     elseif(app_name == "Tiktok")then 
--         filename = "TiktokAuthor.txt"
--     end
--     local idx = 0
--     local Authorfile = io.open("/sdcard/DataEdit/"..filename, "r+")
--     if Authorfile then
--         print("存放的TiktokAuthor：")
--         for line in Authorfile:lines() do
--             if(idx == Authoridx) then 
--                 return string.gsub(line, "\n", "")
--             end
--             print(line)
--             idx = idx + 1
--         end
--         Authorfile:close()
--     else
--         print("无法打开文件进行读取！")
--     end
-- end

-- --查找作者名字，-1就是展示所有作者
-- function ShowTiktokAuthor(Authoridx)
--     toast("展示Tiktok作者")
--     local idx = 0
--     TiktokAuthorfile = io.open("/sdcard/DataEdit/TiktokAuthor.txt", "r+")
--     if TiktokAuthorfile then
--         print("存放的TiktokAuthor：")
--         for line in TiktokAuthorfile:lines() do
--             if(idx == Authoridx) then 
--                 return string.gsub(line, "\n", "")
--             end
--             print(line)
--             idx = idx + 1
--         end
--         TiktokAuthorfile:close()
--     else
--         print("无法打开文件进行读取！")
--     end
-- end

-- -- #添加tiktok作者
-- function AddTiktokAuthor()
--     PrintAndToast("运行：AddTiktokAuthor添加tiktok作者")
--     filename = "TiktokAuthor.txt"
--     AuthorNamePos = R():id("com.zhiliaoapp.musically:id/ilp"):screen(1);
--     tempAuthorName = GetPosStatsInfo(AuthorNamePos,"获取Tiktok作者主页名","text",False)
--     if(tempAuthorName == "跳过")then 
--         PrintAndToast("未搜索到作者名，跳过！")
--         return
--     end
--     local AuthorName = string.sub(tempAuthorName, 2)
--     PrintAndToast("作者名："..AuthorName)
--     local TiktokAuthorTable = loadTableFromFile(filename)
--     print(TiktokAuthorTable)
--     if(TiktokAuthorTable[AuthorName] == true) then 
--         PrintAndToast("作者已存在,无需加入！")
--         print("目前存储的作者：")
--         print(TiktokAuthorTable)
--         return
--     end
--     TiktokAuthorTable[AuthorName] = true
--     PrintAndToast("作者不存在,现在加入！")
--     print("目前存储的作者：")
--     print(TiktokAuthorTable)
--     saveTableToFile(TiktokAuthorTable,filename)
-- end

-- -- #删除tiktok作者
-- function DeleteTiktokAuthor()
--     PrintAndToast("运行：DeleteTiktokAuthor删除tiktok作者")
--     filename = "TiktokAuthor.txt"
--     AuthorNamePos = R():id("com.zhiliaoapp.musically:id/ilp"):screen(1);
--     tempAuthorName = GetPosStatsInfo(AuthorNamePos,"获取Tiktok作者主页名","text",False)
--     if(tempAuthorName == "跳过")then 
--         PrintAndToast("未搜索到作者名，跳过！")
--         return
--     end
--     local AuthorName = string.sub(tempAuthorName, 2)
--     PrintAndToast("作者名："..AuthorName)
--     TiktokAuthorTable = loadTableFromFile(filename)
--     if(TiktokAuthorTable[AuthorName] == true) then 
--         PrintAndToast("作者存在，可以删除！")
--         TiktokAuthorTable[AuthorName] = nil
--         saveTableToFile(TiktokAuthorTable,filename)
--         print("目前存储的作者：")
--         print(TiktokAuthorTable)
--         return
--     end
--     PrintAndToast("该作者未加入列表中，跳过：")
--     print(TiktokAuthorTable)
-- end
