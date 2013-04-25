//
//  ViewController.m
//  RadioStation
//
//  Created by marujun on 13-4-25.
//  Copyright (c) 2013年 马汝军. All rights reserved.
//

#import "ViewController.h"
#import "LoadFullView.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [play_button addTarget:self action:@selector(startPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self initMoviePlayer];
 
//    隐藏自定义的音量view，使用默认的音量控制view
    volumeSlider.alpha=0;
    MPVolumeView *volumeView = [ [MPVolumeView alloc] init];
    volumeView.frame=CGRectMake(47, 349, 227, 23);
    [volumeView setShowsVolumeSlider:YES];
    [volumeView setShowsRouteButton:YES];
    [volumeView sizeToFit];
    [self.view addSubview:volumeView];
    
}


- (void)initMoviePlayer{
    NSString *urlStr = @"http://phonewmgj.wanmei.com.ccgslb.net/wmgj/wmgj.m3u8";
    NSURL *movieURL = [NSURL URLWithString:urlStr];
    self.moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:movieURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preparePlayMovie:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:[self.moviePlayerViewController moviePlayer]]; //设置视频开始播放的回调处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMovieFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:[self.moviePlayerViewController moviePlayer]];  //设置视频播放完毕时的回调处理
}

- (void)addLoadingView
{
    LoadFullView *loadFullView=[[[NSBundle mainBundle] loadNibNamed:@"LoadFullView" owner:self options:nil] objectAtIndex:0];
    loadFullView.frame=CGRectMake(0, 0, 320, 300);
    if( IS_IPHONE_5 ){
        loadFullView.frame=CGRectMake(0, 40, 320, 388);
    }
    [self.view addSubview:loadFullView];
}
- (void)removeLoadingView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remove.load.view" object:nil];
}

- (void)startPlay:(id)sender{
//    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController]; //加载系统原生播放界面

    [play_button setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [self addLoadingView];
    [[self.moviePlayerViewController moviePlayer] play];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]; //后台播放
    
    [play_button removeTarget:self action:@selector(startPlay:) forControlEvents:UIControlEventTouchUpInside];
    [play_button addTarget:self action:@selector(stopPlay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)stopPlay:(id)sender{
    [self removeLoadingView];
    [[self.moviePlayerViewController moviePlayer] stop];

    [play_button setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [play_button removeTarget:self action:@selector(stopPlay:) forControlEvents:UIControlEventTouchUpInside];
    [play_button addTarget:self action:@selector(startPlay:) forControlEvents:UIControlEventTouchUpInside];
}

//自定义音量控制
- (IBAction)changeVolume:(id)sender {
    float volume=[[NSString stringWithFormat:@"%.1f",volumeSlider.value] floatValue] ;
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:volume];
}

#pragma mark - MPMoviePlayerPlaybackDidFinishNotification
- (void)playMovieFinished:(NSNotification *)notification //当点击Done按键或者播放完毕时调用此函数
{
    MPMoviePlayerController *player = [notification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
//    [player stop];
//    [self.moviePlayerViewController dismissMoviePlayerViewControllerAnimated]; //移除系统原生播放界面
//    ALog(@"已退出播放界面！");
}
#pragma mark - MPMediaPlaybackIsPreparedToPlayDidChangeNotification
- (void)preparePlayMovie:(NSNotification *)notification //视频开始播放
{
    ALog(@"加载完成，开始播放视频！");
    [self removeLoadingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
