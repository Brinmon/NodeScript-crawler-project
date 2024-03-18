--main.lua
require 'DataEdit'
require 'BaseFunction'
require 'Tiktok'
require 'PhoneControls'
require 'YouTube'
require 'v2rayNG'
require 'FunctionIntegration'
require 'Kuaishou'
require 'Douyin'
compile("myhappymylife:1.96")

-- DataInit(0) 文本加载进程序！
-- DataInit(1)  程序加载进文本！

local IsTest = true  --false表示测试模式，true表示正常模式

PrintAndToast("开启测试模式！！")


PrintAndToast("关闭测试模式！！")


-- 背景可用 Shape 填充
shape={
	windowShape={
		colors={"#d788b5","#ac77af","#61519c","#3b3c8e"},
		angle=225;
	};
	btn={
		radius=270;
		angle=135;
		colors={"#000000","#000000"};
	};
	headbg={
		colors={"#000000"};
		conner=20;
		border=2;
		borderColor="#FFFFFF"
	};
}

css={
	window={tabfColor="#000000",tbgColor="#282746",width=-1,height=140,textSize=15,textColor="#FFFFFF",bgShape=shape.windowShape};
	text={textSize=15,textColor="#FFFFFF",width=-2,bgColor="#FF0000",align="center",margin={0,30,0,30}},
	text2={textSize=15,textColor="#000000",align="left",margin={30,30,0,0}},
	text3={textSize=20,textColor="#000000",align="left",margin={30,0,0,0}},
	right={textSize=20,gravity="right",margin={0,0,50,0}},
	head={textColor="#EE7373",margin={20,20,20,0},grivity="center",bgShape=shape.headbg,padding={10,10,10,10},width=-1};
	btn={bgShape=shape.btn,textColor="#EE7373"};
	image={width=100,height=100};
	bgimage = {bgImage ="1.png",width=-1,height=400};

};

while IsTest do 
	local CarwlMod = 0
	local UpMod = 0
	ui={
		width=600;height=900;
		time = -1;
		page={
			主线任务={
				{type="div", -- ore = 横向布局和纵向布局
					views={
						{type="edit",hint="请输入内容",id="EditContext",}
					};
				},

				{type="div",ore=1, -- ore = 横向布局和纵向布局
					views={
						{type="text",value="工作模式:\n请你选择!",style=css.text2},
						{type="spinner",value="抖快全自动|快手全自动|抖音全自动|抖快检查视频|抖音检查视频|快手检查视频|上传视频|爬取视频|抖音上传视频|快手上传视频|清理垃圾视频",id="MainWorkMod"}
					};
				},    
		
				{type="div",ore=1, -- ore = 横向布局和纵向布局
					views={
						{type="text",value="编辑模式:\n请你选择!",style=css.text2},
						{type="spinner",value="添加作者|删除作者|展示作者|修改标题",id="EditWorkMod"}
					};
				},
				{type="div",ore=1,
					views={
						{type="text",value="类型选择：",style=css.text2},
						{type="radio",value="*youtube|tiktok",ore=1,id="VideoType"},
					};
				};

				{type="div",ore=1,
					views={
						{type="text",value="作者类型：",style=css.text2},
						{type="radio",value="*MC|Other",ore=1,id="AuthorType"},
					};
				};

				{type="div",ore=1,
					views={
						{type="text",value="编辑模式开关：",style=css.text2},
						{type="radio",value="开|*关",ore=1,id="ModOff"},
					};
				};
			};
		};

		style=css.window;
		submit={type="text",value="运行",style=css.btn};
		cancle={type="text",value="取消",style=css.btn};
	};
	ret=show(ui)

	if ret then 
		if ModOff == "开" then
			if(EditWorkMod ==     "添加作者") then 
				if VideoType == "youtube" then
					GetYouTubeAuthorId(EditContext)
				elseif VideoType == "tiktok" then
					GetTiktokAuthorId(EditContext)
				end
			elseif(EditWorkMod == "修改标题") then 
				PrintAndToast("后续实现")
			end
		elseif  ModOff == "关"  then
			if(MainWorkMod ==     "抖快全自动") then 
				CrawlAndUpallvideo(2)
			elseif(MainWorkMod == "快手全自动") then 
				CrawlAndUpallvideo(0)
			elseif(MainWorkMod == "抖音全自动") then 
				CrawlAndUpallvideo(1)
			elseif(MainWorkMod == "爬取视频") then
				Crawlallvideo(CarwlMod)
			elseif(MainWorkMod == "抖快检查视频") then 
				KuaishouCheckVideo()
				DouyinCheckVideo()
			elseif(MainWorkMod == "抖音检查视频") then
				DouyinCheckVideo()
			elseif(MainWorkMod == "快手检查视频") then
				KuaishouCheckVideo()
			elseif(MainWorkMod == "上传视频") then 
				Upallvideo(2,AuthorType)
			elseif(MainWorkMod == "抖音上传视频") then
				Upallvideo(1,AuthorType)
			elseif(MainWorkMod == "快手上传视频") then
				Upallvideo(0,AuthorType)
			elseif(MainWorkMod == "清理垃圾视频") then
				ClearVideo()
			end
		end
	else
		print('用户选择了取消')
		print("成功退出程序！")
		break
	end
end
