//
//  GameBlockView.m
//  2048
//
//  Created by tarena on 16/4/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "GameBlockView.h"
@interface GameBlockView()
@property(nonatomic,assign) int lineCount;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,strong) NSArray *datas;
@property(nonatomic,strong) NSMutableArray *blocks;
@property(nonatomic,assign) BOOL isInit;
@property(nonatomic,strong) NSArray *gameDatas;

@end
@implementation GameBlockView
-(NSMutableArray *)blocks{
    if (!_blocks) {
        _blocks = [[NSMutableArray alloc]init];
    }
    return _blocks;
}

-(instancetype)initWithFrame:(CGRect)frame data:(NSArray*)data lineCount:(int)lineCount{
    if (self = [super initWithFrame:frame]) {
        self.isInit = YES;
        self.isAnimating = NO;
        self.lineCount = lineCount;
        self.animateDuration = 0.3;
        self.width = frame.size.width;
        self.height = frame.size.height;
        self.datas = data;
        
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{
    CGFloat blockWidth = self.width/self.lineCount;
    CGFloat blockHeight = self.height/self.lineCount;
    
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0; j<self.lineCount; j++) {
            NSNumber *data = self.datas[j+i*self.lineCount];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(blockWidth*j-1, blockHeight*i-1, blockWidth-1, blockHeight-1)];
//            view.backgroundColor = [self setUpColor:data];
            [self setUpLabel:data inView:view];
            
//            view.tag = 100+j+i*self.lineCount;
            
            [self.blocks addObject:view];
        }
    }
    for (int i = 0;i<self.blocks.count;i++) {
        [self addSubview:self.blocks[i]];
    }
    
}
-(void)refreshBlockWithDataAtIndex:(int)i{
    
    UIView *view = self.blocks[i];
    NSNumber *num = self.gameDatas[i];
    [self refreshLabelInView:view withData:num];
    
    
    
}
-(void)sendDatas:(NSArray*)datas{
    self.datas = datas;
}
-(void)refreshBlocksWithData:(NSArray*)datas{
    if (!self.isInit) {
        NSLog(@"gameView is not inited");
        return;
    }
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0; j<self.lineCount; j++) {
            UIView *view = self.blocks[j+i*self.lineCount];
            NSNumber *num = datas[j+i*self.lineCount];
            [self refreshLabelInView:view withData:num];
            
        }
    }
}
-(void)addGameBlockViewWithDatas:(NSArray*)datas{
    if (datas==nil) {
        return;
    }
    if (datas.count == 0) {
        return;
    }
    for (int i = 0; i<datas.count; i++) {
        int index = [[datas[i] valueForKey:@"index"]intValue];
        NSNumber *num = [datas[i] valueForKey:@"blockNum"];
        UIView *temp = self.blocks[index];
        UIView *viewtemp = [[UIView alloc]initWithFrame:temp.frame];
        [self refreshLabelInView:temp withData:[NSNumber numberWithInt:0]];
        [self setUpLabel:num inView:viewtemp];
        viewtemp.tag = 20000+index;
        [self insertSubview:viewtemp aboveSubview:temp];
        
        UIView *view = [self viewWithTag:20000+index];
        view.transform = CGAffineTransformScale(view.transform, 0.01, 0.01);
        view.alpha = 0;
        self.delay = self.animateDuration/2;
        [UIView animateWithDuration:self.animateDuration delay:self.delay options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.transform = CGAffineTransformScale(view.transform, 100, 100);
            view.alpha = 1;

            
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            
            
            if (i == datas.count-1) {
                 //end add animation
                if (self.isAnimating == YES) {
                    self.isAnimating =NO;
                }
//                [self refreshBlocksWithData:self.datas];
//                [self removeRemain];
//                [self refreshBlocksWithData:self.datas];

            }
        }];

    }
}
-(void)blockViewAnimationWithMove:(NSDictionary*)moveDic direction:(DIRECTION)direction{
    if (self.isAnimating == NO) {
        self.isAnimating = YES;
    }
    NSArray* move = moveDic[@"move"];
//    NSArray* destination = moveDic[@"destination"];
    CGFloat blockWidth = self.width/self.lineCount;
    CGFloat blockHeight = self.height/self.lineCount;
    int moveCount = 0;
    for (int i = 0; i<move.count; i++) {
        if ([move[i] intValue]>0) {
            moveCount++;
        }
    }
    
    
    NSLog(@"%@",move);
    
    __block int movehaveFinished=0;
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0; j<self.lineCount; j++) {
            if ([move[j+i*self.lineCount] intValue]>0) {
                UIView *temp = self.blocks[j+i*self.lineCount];
                UIView *viewtemp = [[UIView alloc]initWithFrame:temp.frame];
                UILabel *templabel = temp.subviews.lastObject;
                NSNumber *tempnum = [NSNumber numberWithInt:[templabel.text intValue]];
                [self refreshLabelInView:temp withData:[NSNumber numberWithInt:0]];
                [self setUpLabel:tempnum inView:viewtemp];
                viewtemp.tag = 100+j+i*self.lineCount;
                [self addSubview:viewtemp];
                
                int moveValue = [move[j+i*self.lineCount] intValue]*blockWidth;
                int moveValueV = [move[j+i*self.lineCount] intValue]*blockHeight;
               
                
                UIView *view = [self viewWithTag:100+j+i*self.lineCount];
//                CGFloat duration = self.animateDuration*[move[j+i*self.lineCount] intValue]/(self.lineCount-1);
                CGFloat duration = self.animateDuration;
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                   
                    if (direction ==LEFT) {
                        
                        view.transform = CGAffineTransformTranslate(view.transform, -moveValue, 0);
                    }
                    else if(direction == RIGHT){
                        
                        view.transform = CGAffineTransformTranslate(view.transform, moveValue, 0);
                    }else if (direction == UP){
                        
                        view.transform = CGAffineTransformTranslate(view.transform,0, -moveValueV);
                    }else if(direction == DOWN){
                        
                        view.transform = CGAffineTransformTranslate(view.transform,0, moveValueV);
                    }
//                    view.alpha = 0.5;
                }completion:^(BOOL finished) {
                    movehaveFinished++;
                    [view removeFromSuperview];
                    
//                    if (self.isAnimating == YES) {
//                        self.isAnimating =NO;
//                    }
                    
                    if (movehaveFinished == moveCount) {
                        //                        [self performSelector:@selector(refreshBlocksWithData:) withObject:self.datas afterDelay:0];
                        [self removeRemain];
                        [self refreshBlocksWithData:self.datas];
                    }
                }];
                
                //animation combine
//                if ([destination[j+i*self.lineCount]intValue]>=0) {
//                
//                    UIView *tempIn = self.blocks[[destination[j+i*self.lineCount]intValue]];
//                    UIView *viewtempIn = [[UIView alloc]initWithFrame:tempIn.frame];
//                    UILabel *templabelIn = tempIn.subviews.lastObject;
//                    NSNumber *tempnumIn = [NSNumber numberWithInt:[templabelIn.text intValue]];
//                    NSLog(@"%@",destination);
//                    [self setUpLabel:tempnumIn inView:viewtempIn];
//                    viewtempIn.tag = 10000+j+i*self.lineCount;
//                    [self addSubview:viewtempIn];
//                    UIView *viewIn = [self viewWithTag:10000+j+i*self.lineCount];
//                    
//                    [UIView animateWithDuration:(self.animateDuration+0.1)*0.15 delay:self.animateDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        viewIn.transform = CGAffineTransformScale(viewIn.transform, 1.2, 1.2);
//                    } completion:^(BOOL finished) {
//                        [UIView animateWithDuration:(self.animateDuration+0.1)*0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                            viewIn.transform = CGAffineTransformScale(viewIn.transform, 0.8, 0.8);}completion:^(BOOL finished) {
//                                [viewIn removeFromSuperview];
//                                [self removeRemain];
//                            }];
//                    }];
//
//                }

                
                
            }else {
//                self.isAnimating =NO;
            }
        }
    }

    
}
-(void)removeRemain{
    for (UIView *viewRemain in [self subviews]) {
        if (viewRemain.tag>=100) {
            [viewRemain removeFromSuperview];
        }
    }
}
-(void)refreshLabelInView:(UIView*)view withData:(NSNumber*)num{
    UILabel *label = view.subviews.lastObject;
    if ([num intValue]!=0) {
        label.text =[NSString stringWithFormat:@"%@",num];
    }else{
        label.text = @"";
    }
    view.backgroundColor = [self setUpColor:num];
}
-(void)setUpLabel:(NSNumber*)data inView:(UIView*)view{
//    CGRect rect = CGRectMake(view.bounds.size.width*0.15, view.bounds.size.height*0.15, view.bounds.size.width*0.7, view.bounds.size.height*0.7);
    UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
    if ([data intValue] ==0) {
        label.text = @"";
        
    }else{
        label.text = [NSString stringWithFormat:@"%@",data];
    }
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:view.bounds.size.height*0.8];
    
    label.adjustsFontSizeToFitWidth = YES;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.textAlignment = NSTextAlignmentCenter;
    view.backgroundColor = [self setUpColor:data];
    [view addSubview:label];
 

}
-(UIColor*)setUpColor:(NSNumber*)number{
    int num = number.intValue;
    
    if (num == 0) {
        return [UIColor colorWithRed:0.856 green:0.710 blue:0.572 alpha:1.000];
    }
    else if(num == 2)
        return [UIColor colorWithRed:0.715 green:0.617 blue:0.367 alpha:1.000];
    else if(num == 4)
        return [UIColor colorWithRed:0.734 green:0.511 blue:0.206 alpha:1.000];
    else if(num == 8)
        return [UIColor colorWithRed:1.000 green:0.663 blue:0.096 alpha:1.000];
    else if(num == 16)
        return [UIColor colorWithRed:1.000 green:0.573 blue:0.239 alpha:1.000];
    else if(num == 32)
        return [UIColor colorWithRed:1.000 green:0.437 blue:0.396 alpha:1.000];
    else if(num == 64)
        return [UIColor colorWithRed:1.000 green:0.183 blue:0.116 alpha:1.000];
    else if(num == 128)
        return [UIColor colorWithRed:0.587 green:0.058 blue:0.211 alpha:1.000];
    else if(num == 256)
        return [UIColor colorWithRed:1.000 green:0.355 blue:0.911 alpha:1.000];
    else if(num == 512)
        return [UIColor colorWithRed:0.771 green:0.236 blue:1.000 alpha:1.000];
    else if(num == 1024)
        return [UIColor colorWithRed:0.215 green:0.279 blue:1.000 alpha:1.000];
    else if(num == 2048)
        return [UIColor colorWithRed:0.202 green:0.803 blue:1.000 alpha:1.000];
    else if(num == 4096)
        return [UIColor colorWithRed:0.101 green:0.740 blue:0.594 alpha:1.000];
    else if(num == 8192)
        return [UIColor colorWithRed:0.106 green:0.728 blue:0.004 alpha:1.000];
    else if(num == 16384)
        return [UIColor colorWithRed:0.199 green:0.201 blue:0.204 alpha:1.000];
    return [UIColor colorWithRed:0.912 green:1.000 blue:0.739 alpha:1.000];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
