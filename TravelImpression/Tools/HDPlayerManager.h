//
//  HDPlayerManager.h
//  MobileInterconnect
//
//  Created by huadong on 2017/5/8.
//  Copyright © 2017年 cong_he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HDSongModel.h"
#import <AVFoundation/AVFoundation.h>
//循环模式
typedef NS_ENUM(NSInteger, HDPlayerCycle) {
    nextSong = 0,//列表默认
    theSong = 1,//单曲
    isRandom = 2//随机
};
typedef NS_ENUM(NSInteger, HDPlayStatus) {
    HDPlayStatusNon,           //未知状态
    HDPlayStatusLoadSongInfo,  //加载歌曲信息
    HDPlayStatusReadyToPlay,   //准备播放
    HDPlayStatusPlay,          //播放
    HDPlayStatusPause,         //暂停
    HDPlayStatusStop           //停止
};

@interface HDPlayerManager : NSObject

#pragma mark - 状态
/*
 * 循环模式
 */
@property (nonatomic) HDPlayerCycle  cycle;
/*
 * 播放状态
 */
@property (nonatomic, assign) HDPlayStatus status;

#pragma mark - 列表
/*
 * 歌曲列表
 */
@property (nonatomic, strong) NSMutableArray<HDSongModel *> * songList;

/*
 * 当前播放歌曲
 */
@property (nonatomic, strong) HDSongModel *currentSong;

/*
 * 当前播放歌曲索引
 */
@property (nonatomic, assign) NSInteger currentSongIndex;

/*
 * 当前播放歌曲图片
 */
@property (nonatomic, strong) UIImage *coverImg;


#pragma mark - 播放器
/*
 * 播放器
 */
@property (nonatomic, strong) AVPlayer *player;

/*
 * 播放器播放状态
 */
@property (nonatomic, assign) BOOL isPlaying;

/*
 * 播放进度
 */
@property (nonatomic, assign) float progress;

/*
 * 缓冲进度
 */
@property (nonatomic, assign) float bufferProgress;

/*
 * 当前播放时间(秒)
 */
@property (nonatomic, copy) NSString *playTime;

/*
 * 总时长(秒)
 */
@property (nonatomic, copy) NSString *playDuration;

/*
 * 当前播放时间(00:00)
 */
@property (nonatomic, copy) NSString *timeNow;

/*
 * 总时长(00:00)
 */
@property (nonatomic, copy) NSString *duration;

/*
 * 获取单例
 */
+ (instancetype)manager;

/*
 * 开始播放
 */
- (void)startPlay;

/*
 * 暂停播放
 */
- (void)pausePlay;

/*
 * 停止播放
 */
-(void)stopPlay;

/*
 * app启动完成的播放
 */
- (void)launchPlay;


/*
 * 切歌
 */
- (void)skipSongWithHandle:(void(^)(BOOL isSuccess))handle;

/*
 * ban歌
 */
- (void)banSongWithHandle:(void(^)(BOOL isSuccess))handle;

/*
 * 播放分享歌曲
 */
- (void)playSharedSong:(HDSongModel *)info;


/*
 * 是否播放离线音乐
 */
@property (nonatomic, assign) BOOL isOffLinePlay;
/*
 * 预加载播放音乐(isplayNow: 是否直接播放)
 */
- (void)loadPlayList:(NSArray *)songList index:(NSInteger)index isplayNow:(BOOL)isnow;

/*
 * 播放音乐(index: 开始的位置)
 */
- (void)playList:(NSArray *)songList index:(NSInteger)index;

/*
 * 上一首
 */
- (void)previousMusic;

/*
 * 下一首
 */
- (void)nextMusic;

/*
 * 改变循环模式
 */
- (void)updateCycle;

@end
