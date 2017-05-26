一个项目的基类工程，使用此工程可以为您省去很多前期搭框架时间！

# 示例

HomeViewController

AddImageViewController

# 工程包含第三方

AFNetworking  //网络

Qiniu  //七牛存储
HappyDNS //七牛依赖

MJRefresh  //上下拉刷新

ReactiveCocoa //RAC 是一个 iOS 中的函数式响应式编程框架

SDWebImage  //图片显示

SVProgressHUD (2.0.4) //提示 请勿更新最新版，最新版颜色设置不起作用

# 说明

配置都在Config文件夹里面

基础类都在Base文件夹里面

常用的类和扩展都在Public文件夹里面

# Config

AppConfig //App的一些常用参数配置

RequestManager //网络请求在此添加

# Base

## 界面基类
BaseTabBarController

BaseNavigationController

BaseViewController

BaseTableViewController

BaseCollectionViewController

## Cell基类
BaseTableViewCell

BaseCollectionViewCell

## 模型基类

BaseModel

# Public

## 相机/相册

CutPhotoViewController //图片裁剪

PhotoPreviewViewController //图片预览

PhotosViewController //全自定义相机相册

## Define
PublicDefine //宏

## Extension
UIView+Helpers //UIView扩展

UIImage+Extension //UIImage扩展

NSString+Extension //字符串扩展

UITabBar+Badge //TabBar小红点扩展

## Asset
AssetHelper //相册

## UploadImages
UploadManager //数据上传

## DownloadImages
DownloadImageManager //图片下载

# Supporting Files

Info.plist

TabBarConfigure.plist

PrefixHeader.pch

InfoPlist.strings

# 使用说明

整体色调修改AppConfig.h,改变整体界面色调很简单，想怎么换就怎么换



标签控制器对应的界面请在TabBarConfigure.plist里面添加和更改



按照给出的样式所示格式，添加标签，有几个就添加几个，标签控制器的高度可以修改代码


其中50就是默认高度，你需要多高就更改多大

标签里面的图标和文字的相关属性见代码


//设置指定tabar 小红点的值


如果标签不需要显示数值，只需要显示一个小红点，可以通过下面2个方法控制

//显示小红点 没有数值


//隐藏小红点 没有数值


如何在其他界面获取BaseTabBarController，可以通过

BaseTabBarController *baseTabBar = ((AppDelegate *)[UIApplication sharedApplication].delegate).baseTabBar获取，然后调用设置小红点的方法

导航样式请在BaseNavigationController里面修改


push是否隐藏标签在方法

里做了处理，所以不需要push的时候再加显示或隐藏的处理了，如果需要自己单独处理可以屏蔽此代码

BaseTableViewController使用,记得添加头文件


数据模型继承自BaseModel就可以直接保存

//保存

- (void)saveData:(id)obj {

NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:obj];
NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
[userDefaults setObject:archiveCarPriceData forKey:@"someKey"];
[userDefaults synchronize];
}

//获取

NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
id obj = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"someKey"]] ;
