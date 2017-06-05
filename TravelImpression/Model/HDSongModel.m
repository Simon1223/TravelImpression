//
//  HDSongModel.m
//  MobileInterconnect
//
//  Created by huadong on 2017/5/8.
//  Copyright © 2017年 cong_he. All rights reserved.
//

#import "HDSongModel.h"

@implementation HDSongModel

@end


@implementation HDSongModel(Save)

/**
 *  从UserDefault获取播放列表
 */
+ (NSArray<HDSongModel*> *)getMusicListFromeUserDefault{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"MusicList"];
    
    //2.初始化解归档对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //3.解归档
    NSArray *persons = [unarchiver decodeObjectForKey:@"Musickey"];
    
    //4.完成解归档
    [unarchiver finishDecoding];
    
    return persons;
}


/**
 *  保存播放列表信息到UserDefault
 */
+ (void)saveMusicListToUserDefault:(NSArray<HDSongModel*> *)songs{
    NSArray *array = songs;
    
    //保存对象转化为二进制数据（一定是可变对象）
    NSMutableData *data = [NSMutableData data];
    
    //1.初始化
    NSKeyedArchiver *archivier = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //2.归档
    [archivier encodeObject:array forKey:@"Musickey"];
    
    //3.完成归档
    [archivier finishEncoding];
    
    //4.保存
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MusicList"];
    
    
}

/**
 *  播放index 当前时间存入UserDefault
 */
+ (void )saveMusicIndexToUserDefault:(NSInteger)index{
    
    [[NSUserDefaults standardUserDefaults] setObject:@(index) forKey:@"MusicCurrentIndex"];
}

/**
 *  从UserDefault获取播放index
 */
+ (NSInteger )getMusicIndexFromeUserDefault{
    
    NSInteger musicCurrentIndex = [[[NSUserDefaults standardUserDefaults]objectForKey:@"MusicCurrentIndex"] integerValue];
    ;
    return musicCurrentIndex;
}

@end
