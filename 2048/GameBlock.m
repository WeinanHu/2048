//
//  GameBlock.m
//  2048
//
//  Created by tarena on 16/4/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "GameBlock.h"
#import "NSArray+NSXY.h"
@interface GameBlock()


@property(nonatomic,assign) NSInteger defaultgrades;
@property(nonatomic,assign) BOOL couldAddBlock;
@end
@implementation GameBlock
-(NSMutableArray<NSNumber *> *)blockArray{
    if (!_blockArray) {
        _blockArray = [NSMutableArray array];
    }
    return _blockArray;
}

-(NSArray*)gameBlockInStartWithLineCount:(int)lineCount numberCount:(int)numberCount{
    self.lineCount = lineCount;
    self.defaultgrades = 0;
    self.grades = 0;
    self.isGameOver = NO;
    self.couldAddBlock = NO;
    self.numberCount = numberCount;
    [self.blockArray removeAllObjects];
    NSMutableArray *arrDefaultNumber = [NSMutableArray array];
    for (int i = 0; i<lineCount*lineCount; i++) {
        [arrDefaultNumber addObject:[NSNumber numberWithInt:i]];
        [self.blockArray addObject:[NSNumber numberWithInt:0]];
    }
    
    for (int i = 0; i<numberCount; i++) {
        
        int index = arc4random()%arrDefaultNumber.count;
        int indexNumber = [arrDefaultNumber[index] intValue];
        [arrDefaultNumber removeObjectAtIndex:index];
        if (arc4random()%5<1) {
            self.blockArray[indexNumber] = [NSNumber numberWithInt:4];
        }else{
            self.blockArray[indexNumber] = [NSNumber numberWithInt:2];
        }
    }
    //add defaultGrades
    for (int i = 0; i<self.blockArray.count; i++) {
        self.defaultgrades += [self.blockArray[i] intValue];
    }
//    NSLog(@"%ld",self.defaultgrades);
    return self.blockArray;
}
-(NSArray *)addGameBlock{
    
    NSMutableArray *arrDefaultNumber = [NSMutableArray array];
    NSMutableArray *addBlock = [NSMutableArray array];
    

    for (int i = 0; i<self.lineCount*self.lineCount; i++) {
        if ([self.blockArray[i] intValue]==0) {
            
            [arrDefaultNumber addObject:[NSNumber numberWithInt:i]];
        }
       
    }
    //judging if gameover
    if (arrDefaultNumber.count==0 && [self judgeGameOver]) {
        [self gameOver];
        return nil;
    }
    //after gameOver judgement,judging if the block could be added
    if (self.couldAddBlock == NO) {
        return addBlock;
    }
    self.couldAddBlock = NO;
    for (int i = 0; i<self.lineCount-3; i++) {
        if (arrDefaultNumber.count == 0) {
            break;
        }
        
        int index = arc4random()%arrDefaultNumber.count;
        int indexNumber = [arrDefaultNumber[index] intValue];
        [arrDefaultNumber removeObjectAtIndex:index];
        if (arc4random()%5<1) {
            self.blockArray[indexNumber] = [NSNumber numberWithInt:4];
        }else{
            self.blockArray[indexNumber] = [NSNumber numberWithInt:2];
        }
        NSDictionary *dic = @{@"index":[NSNumber numberWithInt:indexNumber],@"blockNum":self.blockArray[indexNumber]};
        [addBlock addObject:dic];
    }
    //add grades
    self.grades = 0;
    for (int i = 0; i<self.blockArray.count; i++) {
        self.grades += [self.blockArray[i] intValue];
    }
    self.grades -=self.defaultgrades;
    return addBlock;
}
-(BOOL)judgeGameOver{
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0 ; j<self.lineCount-1 ; j++) {
            
            for (int k = j+1; k<self.lineCount; k++) {
                if ([self arrInX:k inY:i]!=0) {
                    if ([self arrInX:j inY:i]==[self arrInX:k inY:i]) {
                        return NO;
                    }
                    break;
                }
            }
        }
    }
    
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0 ; j< self.lineCount-1; j++) {
            
            for (int k = j+1; k<self.lineCount; k++) {
                if([self intValueInX:i inY:k]!=0){
                    if ([self intValueInX:i inY:j] == [self intValueInX:i inY:k]) {
                        return NO;
                    }
                    break;
                }
            }
        }
    }
    
    return YES;
}
-(void)gameOver{
    self.isGameOver = YES;
//    [self gameBlockInStartWithLineCount:self.lineCount numberCount:self.numberCount];
    
}
-(NSDictionary*)afterMoveWithLeft{
    NSMutableArray *arrMove = [NSMutableArray array];
    NSMutableArray *destination = [NSMutableArray array];
    for (int i = 0; i<self.lineCount*self.lineCount; i++) {
        
        [arrMove addObject:[NSNumber numberWithInt:0]];
        [destination addObject:[NSNumber numberWithInt:-1]];
    }
    //move&add&remove
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0 ; j<self.lineCount-1 ; j++) {
            int moveCounts = 0;
            for (int k = j+1; k<self.lineCount; k++) {
                if([self intValueInX:k inY:i]!=0){
                    if ([self intValueInX:j inY:i] == [self intValueInX:k inY:i]) {
                        self.couldAddBlock = YES;
                        self.blockArray[j+i*self.lineCount] = [NSNumber numberWithInt:[self intValueInX:j inY:i]*2];
                        
                        self.blockArray[k+i*self.lineCount] = [NSNumber numberWithInt:0];
                        int zeroCount = 0;
                        for (int l =0; l<j; l++) {
                            if ([self.blockArray[l+i*self.lineCount] intValue]==0) {
                                zeroCount++;
                            }
                        }
                        arrMove[k+i*self.lineCount] = [NSNumber numberWithInt:[arrMove[k+i*self.lineCount]intValue]+1+moveCounts+zeroCount];
                        destination[k+i*self.lineCount] = [NSNumber numberWithInt:k-zeroCount+i*self.lineCount];
                        
                    }
                    break;
                }
                moveCounts++;
                
                
            }
            //moveCount
        }
    }
    NSLog(@"%@",self.blockArray);
    //move
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0 ; j<self.lineCount-1 ; j++) {
            int moveCounts = 0;
            
            for (int k = j+1; k<self.lineCount; k++) {
                if ([self intValueInX:j inY:i] == 0) {
                    
                    if ([self intValueInX:k inY:i] != 0) {
                        self.couldAddBlock = YES;
                        self.blockArray[j+i*self.lineCount] = [NSNumber numberWithInt:[self intValueInX:k inY:i]];
                        self.blockArray[k+i*self.lineCount] = [NSNumber numberWithInt:0];
                        arrMove[k+i*self.lineCount] = [NSNumber numberWithInt:[arrMove[k+i*self.lineCount]intValue]+1+moveCounts];
//                        destination[k+i*self.lineCount] = [NSNumber numberWithInt:j+i*self.lineCount];
                        
                    }
                    moveCounts++;
                }
                
                
            }
        }
    }
    
    
    //write the moveCount to dictionary
    NSDictionary *moveDic = @{@"move":arrMove,@"destination":destination};
    self.moveDic = moveDic;
    return moveDic;
}
-(NSDictionary*)afterMoveWithRight{
    NSMutableArray *arrMove = [NSMutableArray array];
    NSMutableArray *destination = [NSMutableArray array];
    for (int i = 0; i<self.lineCount*self.lineCount; i++) {
        
        [arrMove addObject:[NSNumber numberWithInt:0]];
        [destination addObject:[NSNumber numberWithInt:-1]];

    }
    //move&add&remove
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = self.lineCount-1 ; j>0 ; j--) {
            int moveCounts = 0;
            for (int k = j-1; k>=0; k--) {
                if([self intValueInX:k inY:i]!=0){
                    if ([self intValueInX:j inY:i] == [self intValueInX:k inY:i]) {
                        self.couldAddBlock = YES;
                        self.blockArray[j+i*self.lineCount] = [NSNumber numberWithInt:[self intValueInX:j inY:i]*2];
                        
                        self.blockArray[k+i*self.lineCount] = [NSNumber numberWithInt:0];
                        int zeroCount = 0;
                        for (int l = self.lineCount-1; l>j; l--) {
                            if ([self.blockArray[l+i*self.lineCount] intValue]==0) {
                                zeroCount++;
                            }
                        }
                        arrMove[k+i*self.lineCount] = [NSNumber numberWithInt:[arrMove[k+i*self.lineCount]intValue]+1+moveCounts+zeroCount];
                        destination[k+i*self.lineCount] = [NSNumber numberWithInt:k+zeroCount+i*self.lineCount];
                    }
                    break;
                }
                moveCounts++;
                
                
            }
            //moveCount
        }
    }
    //move
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = self.lineCount-1 ; j>0 ; j--) {
            int moveCounts = 0;
            
            for (int k = j-1; k>=0; k--) {
                if ([self intValueInX:j inY:i] == 0) {
                    
                    if ([self intValueInX:k inY:i] != 0) {
                        self.couldAddBlock = YES;
                        self.blockArray[j+i*self.lineCount] = [NSNumber numberWithInt:[self intValueInX:k inY:i]];
                        self.blockArray[k+i*self.lineCount] = [NSNumber numberWithInt:0];
                        arrMove[k+i*self.lineCount] = [NSNumber numberWithInt:[arrMove[k+i*self.lineCount]intValue]+1+moveCounts];
//                        destination[k+i*self.lineCount] = [NSNumber numberWithInt:j+i*self.lineCount];
                    }
                    moveCounts++;
                }
                
            }
        }
    }
    
    
    //write the moveCount to dictionary
    NSDictionary *moveDic = @{@"move":arrMove,@"destination":destination};
    self.moveDic = moveDic;
    return moveDic;
}
-(NSDictionary*)afterMoveWithUp{
    NSMutableArray *arrMove = [NSMutableArray array];
    NSMutableArray *destination = [NSMutableArray array];
    for (int i = 0; i<self.lineCount*self.lineCount; i++) {
        
        [arrMove addObject:[NSNumber numberWithInt:0]];
        [destination addObject:[NSNumber numberWithInt:-1]];

    }
    //move&add&remove
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0 ; j< self.lineCount-1; j++) {
            int moveCounts = 0;
            for (int k = j+1; k<self.lineCount; k++) {
                if([self intValueInX:i inY:k]!=0){
                    if ([self intValueInX:i inY:j] == [self intValueInX:i inY:k]) {
                        self.couldAddBlock = YES;

                        self.blockArray[i+j*self.lineCount] = [NSNumber numberWithInt:[self intValueInX:i inY:j]*2];
                        
                        self.blockArray[i+k*self.lineCount] = [NSNumber numberWithInt:0];
                        int zeroCount = 0;
                        for (int l =0; l<j; l++) {
                            if ([self.blockArray[i+l*self.lineCount] intValue]==0) {
                                zeroCount++;
                            }
                        }
                        arrMove[i+k*self.lineCount] = [NSNumber numberWithInt:[arrMove[i+k*self.lineCount]intValue]+1+moveCounts+zeroCount];
                        destination[i+k*self.lineCount] = [NSNumber numberWithInt:i+(k-zeroCount)*self.lineCount];
                    }
                    break;
                }
                moveCounts++;
                
                
            }
            //moveCount
        }
    }
    //move
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = 0 ; j<self.lineCount - 1 ; j++) {
            int moveCounts = 0;
            
            for (int k = j+1; k<self.lineCount; k++) {
                if ([self intValueInX:i inY:j] == 0) {
                    
                    if ([self intValueInX:i inY:k] != 0) {
                        self.couldAddBlock = YES;
                        self.blockArray[i+j*self.lineCount] = [NSNumber numberWithInt:[self intValueInX:i inY:k]];
                        self.blockArray[i+k*self.lineCount] = [NSNumber numberWithInt:0];
                        arrMove[i+k*self.lineCount] = [NSNumber numberWithInt:[arrMove[i+k*self.lineCount]intValue]+1+moveCounts];
//                        destination[i+k*self.lineCount] = [NSNumber numberWithInt:i+j*self.lineCount];
                    }
                    moveCounts++;
                }
                
            }
        }
    }
    
    
    //write the moveCount to dictionary
    NSDictionary *moveDic = @{@"move":arrMove,@"destination":destination};
    self.moveDic = moveDic;
    return moveDic;
}
-(NSDictionary*)afterMoveWithDown{
    NSMutableArray *arrMove = [NSMutableArray array];
    NSMutableArray *destination = [NSMutableArray array];
    for (int i = 0; i<self.lineCount*self.lineCount; i++) {
        
        [arrMove addObject:[NSNumber numberWithInt:0]];
        [destination addObject:[NSNumber numberWithInt:-1]];

    }
    //move&add&remove
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = self.lineCount-1 ; j>0 ; j--) {
            int moveCounts = 0;
            for (int k = j-1; k>=0; k--) {
                if([self intValueInX:i inY:k]!=0){
                    if ([self intValueInX:i inY:j] == [self intValueInX:i inY:k]) {
                        self.couldAddBlock = YES;

                        self.blockArray[i+j*self.lineCount] = [NSNumber numberWithInt:[self intValueInX:i inY:j]*2];
                        
                        self.blockArray[i+k*self.lineCount] = [NSNumber numberWithInt:0];
                        int zeroCount = 0;
                        for (int l = (self.lineCount-1); l>j; l--) {
                            if ([self.blockArray[i+l*self.lineCount] intValue]==0) {
                                
                                zeroCount++;
                            }
                        }
                        arrMove[i+k*self.lineCount] = [NSNumber numberWithInt:[arrMove[i+k*self.lineCount]intValue]+1+moveCounts+zeroCount];
                        destination[i+k*self.lineCount] = [NSNumber numberWithInt:i+(k+zeroCount)*self.lineCount];
                    }
                    break;
                }
                moveCounts++;
                
                
            }
            //moveCount
        }
    }
    //move
    for (int i = 0; i<self.lineCount; i++) {
        for (int j = self.lineCount-1 ; j>0 ; j--) {
            int moveCounts = 0;
            
            for (int k = j-1; k>=0; k--) {
                if ([self intValueInX:i inY:j] == 0) {
                    
                    if ([self intValueInX:i inY:k] != 0) {
                        self.couldAddBlock = YES;
                        self.blockArray[i+j*self.lineCount] = [NSNumber numberWithInt:[self intValueInX:i inY:k]];
                        self.blockArray[i+k*self.lineCount] = [NSNumber numberWithInt:0];
                        
                        
                        arrMove[i+k*self.lineCount] = [NSNumber numberWithInt:[arrMove[i+k*self.lineCount]intValue]+1+moveCounts];
//                        destination[i+k*self.lineCount] = [NSNumber numberWithInt:i+j*self.lineCount];

                    }
                    moveCounts++;
                }
                
            }
        }
    }

    
    //write the moveCount to dictionary
    NSDictionary *moveDic = @{@"move":arrMove,@"destination":destination};
    self.moveDic = moveDic;
    return moveDic;
}

-(NSNumber*)arrInX:(int)x inY:(int)y{
    return [self.blockArray arrayNumberInX:x inY:y lineLength:self.lineCount] ;
}

-(int)intValueInX:(int)x inY:(int)y{
    return [[self arrInX:x inY:y] intValue];
}
@end
