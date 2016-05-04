//
//  ViewController.m
//  2048
//
//  Created by tarena on 16/4/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ViewController.h"
#import <math.h>
#import "NSArray+NSXY.h"
#import "GameBlock.h"
#import "GameBlockView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIStepper *levelSteper;
@property(nonatomic,strong) NSArray *datas;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property(nonatomic,assign) int lineCount;
@property(nonatomic,assign) BOOL isGameViewDidLoad;
@property(nonatomic,strong) GameBlock *game;
@property(nonatomic,strong) GameBlockView *gameView;
@end

@implementation ViewController

-(void)setLevelValue:(int)level{
    self.levelLabel.text = [NSString stringWithFormat:@"level:%d",level];
}
- (IBAction)levelValueChanged:(UIStepper*)sender {
    [self setLevelValue:sender.value];
}
- (IBAction)levelChangedButtonClicked:(id)sender {
    if (self.gameView.isAnimating) {
        return;
    }
    self.lineCount =self.levelSteper.value;
    self.game = [[GameBlock alloc]init];
    self.datas = [self.game gameBlockInStartWithLineCount:self.lineCount numberCount:self.lineCount];
    [self.gameView removeFromSuperview];
    self.gameView = [[GameBlockView alloc]initWithFrame:self.ContainerView.bounds data:self.datas lineCount:self.lineCount];
    [self.ContainerView addSubview:self.gameView];
}

- (void)viewDidLayoutSubviews{
    if (self.isGameViewDidLoad == NO) {
        self.gameView = [[GameBlockView alloc]initWithFrame:self.ContainerView.bounds data:self.datas lineCount:self.lineCount];
        self.isGameViewDidLoad = YES;
        
        [self.ContainerView addSubview:self.gameView];
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@",NSStringFromCGRect(self.ContainerView.bounds));
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.label.text = [NSString stringWithFormat:@"scoles:%ld",(long)self.game.grades];
    [self setupSwipeGesture];
    
    self.lineCount = 4;
    self.isGameViewDidLoad = NO;
    self.game = [[GameBlock alloc]init];
    self.datas = [self.game gameBlockInStartWithLineCount:self.lineCount numberCount:self.lineCount];
    
    [self setLevelValue:4];
//     [self.game afterMoveWithLeft];
//    [self.gameView refreshBlocksWithData:self.game.blockArray];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)speedSliderValueChanged:(UISlider *)sender {
    if (self.gameView.isAnimating == YES) {
        return;
    }
    self.gameView.animateDuration = sender.value;
}

-(void)setupSwipeGesture{
    //左划
    
    UISwipeGestureRecognizer *swipeToLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swipeToLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    //右划
    UISwipeGestureRecognizer *swipeToRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swipeToRight.direction = UISwipeGestureRecognizerDirectionRight;
    //上划
    UISwipeGestureRecognizer *swipeToUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swipeToUp.direction = UISwipeGestureRecognizerDirectionUp;
    //下划
    UISwipeGestureRecognizer *swipeToDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swipeToDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeToLeft];
    
    [self.view addGestureRecognizer:swipeToRight];
    
    [self.view addGestureRecognizer:swipeToUp];
    
    [self.view addGestureRecognizer:swipeToDown];
}

-(void)setCouldSwipe{
    self.gameView.isAnimating = NO;
}
-(void)swipe:(UISwipeGestureRecognizer*)sender{
    if (self.gameView.isAnimating == YES) {
        
        return;
    }
    self.gameView.isAnimating = YES;
    [self performSelector:@selector(setCouldSwipe) withObject:nil afterDelay:self.gameView.animateDuration+self.gameView.delay];
    
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            //向左
            
            [self moveAnimationInDirection:LEFT];
        
        
            break;
        case UISwipeGestureRecognizerDirectionRight:
            //向右
            [self moveAnimationInDirection:RIGHT];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            //向上
            [self moveAnimationInDirection:UP];
            break;
        default:
            //向下
            [self moveAnimationInDirection:DOWN];
            break;
    }
    
}
-(void)moveAnimationInDirection:(DIRECTION)direction{
    [self.gameView sendDatas:self.game.blockArray];
    NSDictionary *moveDic = [[NSDictionary alloc]init];
    switch (direction) {
        case LEFT:{
            moveDic = [self.game afterMoveWithLeft];
            
        }
            break;
        case RIGHT:{
            moveDic = [self.game afterMoveWithRight];
           
        }
            break;
        case UP:{
            moveDic = [self.game afterMoveWithUp];
            
        }
            break;
        case DOWN:{
            moveDic = [self.game afterMoveWithDown];
            
        }
            break;
       
    }
    
    [self.gameView blockViewAnimationWithMove:moveDic direction:direction];
//    [self.game addGameBlock];
    [self.gameView addGameBlockViewWithDatas:[self.game addGameBlock]];
    if(self.game.isGameOver){
        
        [self showAlertViewToRestart];
        
    }
    self.label.text = [NSString stringWithFormat:@"score:%ld",(long)self.game.grades];
//    [self.gameView refreshBlocksWithData:self.game.blockArray];
    
}

-(void)showAlertViewToRestart{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Over" message:[NSString stringWithFormat:@"You got a score %ld",(long)self.game.grades] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.game gameBlockInStartWithLineCount:self.game.lineCount numberCount:self.game.numberCount];
        [self.gameView refreshBlocksWithData:self.game.blockArray];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.game.isGameOver) {
        [self showAlertViewToRestart];
        
    }
}
/**
 计算
 */
//-(void)doCompute:(NSArray*)arr direction:(DIRECTION)direction{
//    NSInteger arrCount = arr.count;
//    arrCount=16;
//    int lineCount = (int)sqrt(arrCount);
//    for (int i=0; i<lineCount;i++ ) {
//        for (int j= 0; j<lineCount; j++) {
//            switch (direction) {
//                case LEFT:
//                    if (j<lineCount-1 &&([arr arrayNumberInX:j inY:i lineLength:lineCount].intValue == [arr arrayNumberInX:j+1 inY:i lineLength:lineCount].intValue)) {
//                        [UIView animateWithDuration:0.2 animations:^{
//                            
//                        } completion:^(BOOL finished) {
//                            
//                        }];
//                        
//                    }
//                    break;
//                case RIGHT:
//                    
//                    break;
//                case UP:
//                    
//                    break;
//                case DOWN:
//                    
//                    break;
//            }
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
