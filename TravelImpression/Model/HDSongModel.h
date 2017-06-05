//
//  HDSongModel.h
//  MobileInterconnect
//
//  Created by huadong on 2017/5/8.
//  Copyright © 2017年 cong_he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoderObject.h"
@interface HDSongModel : BaseCoderObject

/**歌曲名**/
@property (nonatomic, copy) NSString *name;

/**演唱者**/
@property (nonatomic, copy) NSString *singer;

/**专辑名**/
@property (nonatomic, copy) NSString *album;

/**专辑封面(网络音乐图片)**/
@property (nonatomic, copy) NSString *albumPicture;

/**歌词**/
@property (nonatomic, copy) NSString *lyric;

/**歌曲路径**/
@property (nonatomic, copy) NSString *url;

/**是否是本地文件**/
@property (nonatomic, assign) BOOL offLine;

/**专辑封面图片（本地音乐）**/
@property (nonatomic, copy) UIImage * coverImage;


@end

@interface HDSongModel(Save)

/**
 *  从UserDefault获取播放列表
 */
+ (NSArray<HDSongModel*> *)getMusicListFromeUserDefault;


/**
 *  保存播放列表信息到UserDefault
 */
+ (void)saveMusicListToUserDefault:(NSArray<HDSongModel*> *)songs;


/**
 *  从UserDefault获取播放index 
 */
+ (NSInteger )getMusicIndexFromeUserDefault;

/**
 *  播放index 当前时间存入UserDefault
 */
+ (void )saveMusicIndexToUserDefault:(NSInteger)index;

@end

