## MHDevelopExample_Objective_C

### 下载
- 若`pod install`很漫长或有问题，请戳百度网盘链接:https://pan.baidu.com/s/1xbyYfD6Zy9jRPgoAsdcGSA  密码:luxc <PS：不定期更新！！！>

### 概述
- 本工程主要是利用`iOS` 的`Objective-C`开发的技术要点汇总；
- 涵盖了开发中踩坑的原因，以及填坑的技术分享；
- 抛砖引玉，取长补短，希望能够提供一点思路，避免少走一些弯路。

### 使用
- **特别说明：** 使用前可以全局搜索 `CMHDEBUG` 字段，找到该字段的宏定义。可以修改其值，来获取自己想看的业务场景。具体场景说明如下：

	```
	/// 1 -- 进入基于MVC设计模式的基类设计
	/// 0 -- 进入常用的开发Demo
	#define CMHDEBUG 1
	```
- [Cocoapods安装教程](https://www.cnblogs.com/chuancheng/p/8443677.html) 
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


### 博文
- [iOS 玩转UISlider](https://www.jianshu.com/p/9dc78695302b)
- [iOS 利用AFNetworking实现大文件分片上传](https://www.jianshu.com/p/7919c620967e)
- [iOS 基于MVC设计模式的基类设计](https://www.jianshu.com/p/1078a8d5d415)
- [iOS 基于MVVM设计模式的微信朋友圈开发](https://www.jianshu.com/p/2f161f6a310f)
- [iOS 基于MVVM + RAC + ViewModel-Based Navigation的微信开发（二）](https://www.jianshu.com/p/8c35fc02f47b)
- [iOS 基于MVVM + RAC + ViewModel-Based Navigation的微信开发（一）](https://www.jianshu.com/p/fd407a4ecb8e)
- [iOS 关于MVVM With ReactiveCocoa设计模式的那些事](https://www.jianshu.com/p/a0c22492a620)
- [iOS 关于MVVM Without ReactiveCocoa设计模式的那些事](https://www.jianshu.com/p/db8400e1d40e)
- [iOS 关于MVC和MVVM设计模式的那些事](https://www.jianshu.com/p/caaa173071f3)
- [iOS UITableView 表头、表尾、段头、段尾 的坑（二）
](https://www.jianshu.com/p/127bc31e1519)
- [iOS 实现优酷视频的评论回复功能](https://www.jianshu.com/p/feb14f4eee1c)
- [iOS 如何完全抓取出ipa包内的所有图片资源](https://www.jianshu.com/p/e6d7e1170ae6)
- [iOS 实现微信朋友圈评论回复功能（二）](https://www.jianshu.com/p/733733fd042d)
- [iOS UITableView 多选删除功能](https://www.jianshu.com/p/1d82befe9988)
- [iOS 实现微信朋友圈评论回复功能（一）](https://www.jianshu.com/p/395bac3648a7)
- [iOS UITableView左滑删除功能](https://www.jianshu.com/p/4c53901062eb)
- [iOS 父子控制器的使用](https://www.jianshu.com/p/ef48ddb4d7e3)
- [iOS UITableView 表头、表尾、段头、段尾 的坑（一）](https://www.jianshu.com/p/f1001599de49)


