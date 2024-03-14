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

function Upallvideo(UpMod)
    local start_time = os.time()
	local appname = ""
	if(UpMod == 0) then 
		appname = "快手"
	end

	local NewVideoNum  =  0
    local youtubevideonum = GetDirFile("sdcard/snaptube/download/") --youtubepath
    local tiktokvideonum = GetDirFile("sdcard/DCIM/Camera/") --tiktokpath
	NewVideoNum = youtubevideonum + tiktokvideonum

	if(appname == "快手") then 
		UpVideoInKuaishou(NewVideoNum)
	end

	local end_time = os.time()
	OutPutOperationTime(start_time,end_time)
end

