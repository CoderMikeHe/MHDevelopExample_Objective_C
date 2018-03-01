## MHDevelopExample_Objective_C
### 求职
笔者目前正在求职iOS移动应用开发工程师一职，坐标深圳南山区或福田区；若小伙伴有合适的iOS职位推荐，还请发送邮件到 **491273090@qq.com** 邮箱与笔者取得联系。么么哒。


### 概述
- 本工程主要是利用`iOS` 的`Objective-C`开发的技术要点汇总；
- 涵盖了开发中踩坑的原因，以及填坑的技术分享；
- 抛砖引玉，取长补短，希望能够提供一点思路，避免少走一些弯路。


### 使用
- 本`Demo`利用`Cocoapods`管理第三方框架，若第一次使用本项目，请使用终端`cd`到如下图所示的文件夹，执行`pod install`命令即可。

	![Usage.png](https://github.com/CoderMikeHe/MHDevelopExample_Objective_C/blob/master/MHDevelopExample/SnapShot/Usage.png)
	
	```
	1. pod repo update : 更新本地仓库
	2. pod install : 下载新的库
	```
- 如果你升级了Mac的系统时，并且当你的Mac系统升级为` high sierra `的时候，别忘记更新`cocoapods`。执行命令为：

	```
	$ sudo gem update --system
	$ sudo gem install cocoapods -n/usr/local/bin
	```

### 期待
- 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的代码看看BUG修复没有）。
- 如果在使用过程中发现有更好或更巧妙的实用技术，希望你能Issues我，我非常为该项目扩充更多好用的技术，谢谢。
- 如果通过该工程的使用和说明文档的阅读，对您在开发中有一点帮助，码字不易，还请点击右上角`star`按钮，谢谢；
- 简书地址：<http://www.jianshu.com/u/126498da7523>


### 功能模块
1. **父子控制器的使用**
    * 仿百思不得姐的架构实现
    
    	- 效果图
    		
    		![BaiSiBuDeJie.gif](https://github.com/CoderMikeHe/MHDevelopExample_Objective_C/blob/master/MHDevelopExample/SnapShot/BaiSiBuDeJie.gif)
    		
    	- 说明文档：（TOOD...）
    	
    * 仿网易新闻的架构实现（TODO...）
    
    	- 效果图
    	
    		![NetEaseNews.gif](https://github.com/CoderMikeHe/MHDevelopExample_Objective_C/blob/master/MHDevelopExample/SnapShot/NetEaseNews.gif)
    	
    	- 说明文档：（TOOD...）
  
2. **仿微信朋友圈的评论回复功能**
	* 利用UITableView的段头+Cell+段尾实现
		
		- 效果图
		
			![comment.gif](https://github.com/CoderMikeHe/MHDevelopExample_Objective_C/blob/master/MHDevelopExample/SnapShot/comment.gif)
			
		- 说明文档：[iOS实现微信朋友圈评论回复功能（一）](http://www.jianshu.com/p/395bac3648a7)
		
		
	* 利用UITableViewCell嵌套UITableView实现
		- 效果图
		
			![comment.gif](https://github.com/CoderMikeHe/MHDevelopExample_Objective_C/blob/master/MHDevelopExample/SnapShot/comment.gif)
			
		- 说明文档：[iOS实现微信朋友圈评论回复功能（二）](http://www.jianshu.com/p/733733fd042d)
	
	* 利用UITableView的段头+Cell+段尾实现优酷的视频的评论回复功能
		- 效果图
	
			![youkuComment.gif](https://github.com/CoderMikeHe/MHDevelopExample_Objective_C/blob/master/MHDevelopExample/SnapShot/youkuComment.gif)
			
		- 说明文档：[iOS 实现优酷视频的评论回复功能](http://www.jianshu.com/p/feb14f4eee1c)
		
	
3. **UITableView的使用**
	* UITableView的侧滑删除功能
		- 效果图
		
			![tableView_del.gif](https://github.com/CoderMikeHe/MHDevelopExample_Objective_C/blob/master/MHDevelopExample/SnapShot/tableView_del.gif)
		
		- 说明文档：[iOS UITableView删除功能](http://www.jianshu.com/p/4c53901062eb)
		
	* UITableView的的多选、删除功能
		- 效果图
			
			![tableView_sel.gif](https://github.com/CoderMikeHe/MHDevelopExample_Objective_C/blob/master/MHDevelopExample/SnapShot/tableView_sel.gif)
			
		- 说明文档：[iOS UITableView 多选删除功能](http://www.jianshu.com/p/1d82befe9988)

