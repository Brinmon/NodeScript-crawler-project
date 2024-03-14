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

	while true do 
		local Iserror,errorinfo = pcall(
			function()
				while NewVideoNum > 0 do 
					PrintAndToast("视频数量大于0！")
					if(NewVideoNum<=15) then 
						PrintAndToast("视频数量小于15！")
						if(appname[0] == "快手") then 
							UpVideoInKuaishou(NewVideoNum)
						elseif(appname[1] == "抖音") then 
							UpVideoInDouyin(NewVideoNum)
						end
						PrintAndToast("开始删除视频！")
						DeleteSomeVideo(NewVideoNum)
						NewVideoNum = 0
					else
						PrintAndToast("视频数量大于15！")
						if(appname[0] == "快手") then 
							UpVideoInKuaishou(15)
						elseif(appname[1] == "抖音") then 
							UpVideoInDouyin(15)
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
			OutPutOperationTime(start_time,end_time)
			break
		else
			PrintAndToast("Upallvideo上传视频失败！！"..errorinfo)
		end
	end
end

