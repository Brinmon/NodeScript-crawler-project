--FunctionIntegration.lua 集成模块
function Crawlallvideo(CrawlMod)
    local start_time = os.time()
	local youtubefilename = ""
	local tiktokfilename  = "" 
	if(CrawlMod == 0) then 
		youtubefilename = "YouTubeAuthor.txt"
		tiktokfilename = "TiktokAuthor.txt"
	end

    PrintAndToast("开始执行爬取YouTube和Tiktok的视频！")
    InitPhoneENV() --选择最好的vpn
	-- ConnectVpn()
    GetYouTubeAllCreaterNewVideo(youtubefilename)
    GetTiktokAllCreaterNewVideo(tiktokfilename)
    CloseConnectVpn()
	-- 获取程序结束时间戳
	local end_time = os.time()
	OutPutOperationTime(start_time,end_time)
end


function CrawlAndUpallvideo(CrawlAndUPMod)
    local start_time1 = os.time()
	local videotype = "MC"
	local UpMod = 0
	if CrawlAndUPMod == 0 then
		UpMod = 0
	elseif CrawlAndUPMod == 1 then
		UpMod = 1
	elseif CrawlAndUPMod == 2 then
		UpMod = 2
	end
	

	local TiktokFileName = "TiktokAuthor.txt"
    local TiktokAuthorTable = {}
    local TiktokIsAuthorTable = {}
    TiktokAuthorTable,TiktokIsAuthorTable = ReadTextToTable(TiktokAuthorTable,TiktokIsAuthorTable,TiktokFileName)

	local YouTubeFileName = "YouTubeAuthor.txt"
    local YouTubeAuthorTable = {}
    local YouTubeIsAuthorTable = {}
	local YouTubeVideoType = "Shorts"
    YouTubeAuthorTable,YouTubeIsAuthorTable = ReadTextToTable(YouTubeAuthorTable,YouTubeIsAuthorTable,YouTubeFileName)

	local TiktokOtherFileName = "TiktokOtherAuthor.txt"
    local TiktokOtherAuthorTable = {}
    local TiktokOtherIsAuthorTable = {}
	local TiktokOtherVideoType = "Other"
    TiktokOtherAuthorTable,TiktokOtherIsAuthorTable = ReadTextToTable(TiktokOtherAuthorTable,TiktokOtherIsAuthorTable,TiktokOtherFileName)

	local checkidx = 0
	InitPhoneENV() --选择最好的vpn

	while true do 
		local Iserror,errorinfo = pcall(
			function()
				while true do 

					for i = 0, #TiktokAuthorTable do
						print("序号:"..tostring(i))
						TiktokAuthorTable[i],TiktokIsAuthorTable[i] = shuffle(TiktokAuthorTable[i],TiktokIsAuthorTable[i])
						GetTiktokTableCreaterNewVideo(TiktokFileName,TiktokAuthorTable[i],TiktokIsAuthorTable[i])
						sleep(1000)
						local v1 = Upallvideo(UpMod,videotype)
						if(v1 == 0)then
							ConnectVpn()
						end
					end

					for i = 0, #YouTubeAuthorTable do
						YouTubeAuthorTable[i],YouTubeIsAuthorTable[i] = shuffle(YouTubeAuthorTable[i],YouTubeIsAuthorTable[i])
						GetYouTubeTableCreaterNewVideo(YouTubeFileName,YouTubeAuthorTable[i],YouTubeIsAuthorTable[i],YouTubeVideoType)
						sleep(1000)
						local v1 = Upallvideo(UpMod,videotype)
						if(v1 == 0)then
							ConnectVpn()
						end
					end

					-- for i = 0, #TiktokOtherAuthorTable do
					-- 	GetTiktokTableCreaterNewVideo(YouTubeFileName,TiktokOtherAuthorTable[i],TiktokOtherIsAuthorTable[i])
					-- 	sleep(1000)
					-- 	local v1 = Upallvideo(UpMod,"Other")
					-- 	if(v1 == 0)then
					-- 		ConnectVpn()
					-- 	end
					-- end

					if checkidx == 3 then
						if CrawlAndUPMod == 0 then
							KuaishouCheckVideo()
						elseif CrawlAndUPMod == 1 then
							DouyinCheckVideo()
						elseif CrawlAndUPMod == 2 then
							KuaishouCheckVideo()
							DouyinCheckVideo()
						end
						ConnectVpn()
						checkidx = 0
					end
					checkidx = checkidx + 1
				end
			end
		)
		if Iserror then
			local end_time = os.time()
			PrintAndToast("CrawlAndUpallvideo")
			OutPutOperationTime(start_time1,end_time)
			break
		else
			PrintAndToast("CrawlAndUpallvideo失败！！"..errorinfo)
		end
	end
end

function Upallvideo(UpMod,videotype)
    local start_time1 = os.time()
	local appname = {"0","0"}
	if(UpMod == 0) then  --快手
		appname[0] = "快手"
	elseif(UpMod == 1) then --抖音
		appname[1] = "抖音"
	elseif(UpMod == 2) then --快抖
		appname[0] = "快手"
		appname[1] = "抖音"
	end

	local NewVideoNum  =  0
	local youtubevideonum = CountPhoneVideoNum("sdcard/snaptube/download/") --youtubepath
	local tiktokvideonum = CountPhoneVideoNum("sdcard/DCIM/Camera/") --tiktokpath
	NewVideoNum = youtubevideonum + tiktokvideonum
	PrintAndToast("视频数量："..tostring(NewVideoNum))
	if(NewVideoNum <= 0)then
		return 1
	end
	CloseConnectVpn()
	while true do 
		local Iserror,errorinfo = pcall(
			function()
				while NewVideoNum > 0 do 
					PrintAndToast("视频数量大于0！")
					if(NewVideoNum<=15) then 
						PrintAndToast("视频数量小于15！")
						if(appname[0] == "快手") then 
							UpVideoInKuaishou(NewVideoNum,videotype)
						end
						if(appname[1] == "抖音") then 
							UpVideoInDouyin(NewVideoNum,videotype)
						end
						PrintAndToast("开始删除视频！")
						DeleteSomeVideo(NewVideoNum)
						NewVideoNum = 0
					else
						PrintAndToast("视频数量大于15！")
						if(appname[0] == "快手") then 
							UpVideoInKuaishou(15,videotype)
						end
						if(appname[1] == "抖音") then 
							UpVideoInDouyin(15,videotype)
						end
						PrintAndToast("开始删除视频！")
						DeleteSomeVideo(15)
						NewVideoNum = NewVideoNum - 15
					end
				end
			end
		)
		if Iserror then
			local end_time = os.time()
			PrintAndToast("Upallvideo上传视频运行完毕！！！")
			OutPutOperationTime(start_time1,end_time)
			return 0
		else
			PrintAndToast("Upallvideo上传视频失败！！"..errorinfo)
			ErrorFix()
            CloseAllPross()
		end
	end
end


function ClearVideo()
    local info =  getPageInfo();
    if info.name == "抖音" then 
        PrintAndToast("应用:"..info.name);-- 当前应用名称
        while true do 
            DouyinDeleteVideo()
            sleep(500)
            -- local profile_view_pager = R():path("/FrameLayout/RecyclerView");--R():id("com.ss.android.ugc.aweme:id/g0+");
            -- AutoSild(profile_view_pager,"滑动视频view界面")
        end
    elseif(info.name == "快手") then
        PrintAndToast("应用:"..info.name);-- 当前应用名称
        while true do 
            KuaishouDeleteVideo()
            sleep(1000)
            click(239/2,(996+678)/2)
            sleep(1000)
            -- local profile_view_pager = R():id("com.smile.gifmaker:id/profile_view_pager"):getChild();
            -- AutoSild(profile_view_pager,"滑动视频view界面")
        end
    end
end

function testInternetAvailability(hour, minute, day)
    -- 检查校园网状态
    local hasInternet = true -- 默认有校园网

    -- 判断是否没有校园网
    if (day >= 2 and day <= 6 and hour >= 0 and hour < 6) or
       (day >= 2 and day <= 5 and hour == 23 and minute >= 40) or
       (day == 1 and hour == 23 and minute >= 40) then
        hasInternet = false
    end

	day = day - 1 == 0 and 7 or day -1
    -- 输出校园网状态
    if hasInternet then
		
        print(string.format("在星期%d的 %02d:%02d 有校园网", day, hour, minute))
    else
        print(string.format("在星期%d的 %02d:%02d 没有校园网", day, hour, minute))
    end
	return hasInternet
end

-- 定义Fisher-Yates洗牌算法
function shuffle(arr,arr1)
    local n = #arr
    for i = n, 2, -1 do
        local j = math.random(i)
        arr[i], arr[j] = arr[j], arr[i]
		arr1[i],arr1[j] = arr1[j],arr1[i]
    end
	return arr,arr1
end

function ErrorFix()
	PrintAndToast("欢迎来到Errorfix函数")
	local current_time = os.date("*t")
	local hour = current_time.hour
	local minute = current_time.min
	local day = current_time.wday
	local checkhasnet = testInternetAvailability(hour, minute, day)
	if(checkhasnet == false) then 
		CloseConnectVpn()
		while true do 
			local current_time = os.date("*t")
			local hour = current_time.hour
			local minute = current_time.min
			local day = current_time.wday
			local checkhasnet = testInternetAvailability(hour, minute, day)
			if(checkhasnet) then 
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
	else
		PrintAndToast("有校园网！！！")
	end
end