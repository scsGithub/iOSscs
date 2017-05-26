//
//  FirstViewController.m
//  Video
//
//  Created by 吾爷科技 on 2017/3/3.
//  Copyright © 2017年 吾爷科技. All rights reserved.
//

#import "FirstViewController.h"
#import "MoviePlayerController.h"

@interface FirstViewController ()
@end


@implementation FirstViewController

-(NSArray *)dataSource{
    NSArray *array = @[
@"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
@"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
@"http://baobab.wdjcdn.com/14525705791193.mp4",
@"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
@"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
@"http://baobab.wdjcdn.com/1455782903700jy.mp4",
@"http://baobab.wdjcdn.com/14564977406580.mp4",
@"http://baobab.wdjcdn.com/1456316686552The.mp4",
@"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
@"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
@"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
@"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
@"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
@"http://baobab.wdjcdn.com/1456653443902B.mp4",
@"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    return array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}


-(void)back{
    [self dismissUsePushEffectViewControllerWithAnimated:NO completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"网络视频%ld",(long)indexPath.section + 1];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoviePlayerController *movie = [MoviePlayerController new];
    NSURL *URL = [NSURL URLWithString:self.dataSource[indexPath.section]];
    
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.videoURL = URL;
    model.title = [NSString stringWithFormat:@"网络视频%ld",(long)indexPath.section + 1];
    movie.model = model;
    movie.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:movie animated:YES];
}

@end
