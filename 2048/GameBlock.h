//
//  GameBlock.h
//  2048
//
//  Created by tarena on 16/4/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GameBlock : NSObject
@property(nonatomic,strong) NSMutableArray<NSNumber*> *blockArray;
-(NSArray*)gameBlockInStartWithLineCount:(int)lineCount numberCount:(int)numberCount;
-(NSArray *)addGameBlock;

-(NSDictionary*)afterMoveWithLeft;
-(NSDictionary*)afterMoveWithRight;
-(NSDictionary*)afterMoveWithUp;
-(NSDictionary*)afterMoveWithDown;

@property(nonatomic,strong) NSDictionary *moveDic;
@property(nonatomic,assign) int lineCount;
@property(nonatomic,assign) int numberCount;
@property(nonatomic,assign) NSInteger grades;
@property(nonatomic,assign) BOOL isGameOver;
@end
