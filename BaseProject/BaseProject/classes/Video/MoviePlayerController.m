
//
//  MoviePlayerController.h
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import "MoviePlayerController.h"
#import <ZFDownloadManager.h>

@interface MoviePlayerController () <ZFPlayerDelegate>
/** 播放器View的父视图*/
@property (strong, nonatomic)  UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MoviePlayerController
{
    UIView *player_view;
}
- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ UIColor whiteColor];
    if (player_view == nil) {
        player_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        player_view.backgroundColor = [UIColor whiteColor];
    }
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@"播放新视频" forState:UIControlStateNormal];
    next.frame = CGRectMake(0, 300, self.view.width, 50);
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    next.backgroundColor = [UIColor grayColor];
    [next addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    /*
    self.playerFatherView = [[UIView alloc] init];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    */
    
    // 自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
     [self.view addSubview:player_view];
    [self.view addSubview:next];
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
    
}

#pragma mark - Getter


- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        
//        ZFPlayerControlView *view = [ZFPlayerControlView new];
        _model.fatherView = player_view;

        [_playerView playerControlView:nil playerModel:self.model];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = YES;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;

    }
    return _playerView;
}

#pragma mark - Action

- (void)nextBtnClick{
    _model.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"];
    _model.title = @"这是播放的新视频";
    [self.playerView resetToPlayNewVideo:self.model];
}

@end
