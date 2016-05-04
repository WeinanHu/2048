//
//  GameBlockView.h
//  2048
//
//  Created by tarena on 16/4/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LEFT,
    RIGHT,
    UP,
    DOWN
}DIRECTION;
@interface GameBlockView : UIView

-(instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data lineCount:(int)lineCount;
-(void)refreshBlocksWithData:(NSArray*)datas;
-(void)blockViewAnimationWithMove:(NSDictionary*)move direction:(DIRECTION)direction;
-(void)sendDatas:(NSArray*)datas;
-(void)addGameBlockViewWithDatas:(NSArray*)datas;
@property(nonatomic,assign) BOOL isAnimating;
@property(nonatomic,assign) CGFloat animateDuration;
@property(nonatomic,assign) CGFloat delay;
@end
