//
//  ViewController.m
//  DropIt
//
//  Created by Ｋ on 2015/2/16.
//  Copyright (c) 2015年 Ｋ. All rights reserved.
//

#import "DropItViewController.h"
#import "DropItBehavior.h"
@interface DropItViewController ()<UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) DropItBehavior *dropItBehavior;
@property (strong, nonatomic) UIDynamicAnimator *animator;
//@property (strong, nonatomic) UIGravityBehavior *gravity;
//@property (strong, nonatomic) UICollisionBehavior *collision;
@end
static const CGSize DROP_SIZE = { 25, 40};
@implementation DropItViewController

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (DropItBehavior *) dropItBehavior {
    if (!_dropItBehavior) {
        _dropItBehavior = [[DropItBehavior alloc] init];
        [self.animator addBehavior:_dropItBehavior];
    }
    
    return _dropItBehavior;
}
//- (UICollisionBehavior *)collision {
//    if (!_collision) {
//        _collision = [[UICollisionBehavior alloc]init];
//        _collision.translatesReferenceBoundsIntoBoundary = YES;
//        [self.animator addBehavior:_collision];
//    }
//    
//    return _collision;
//}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    
    return  _animator;
}

//- (UIGravityBehavior *)gravity {
//    if (!_gravity) {
//        _gravity = [[UIGravityBehavior alloc]init];
//        _gravity.magnitude = 0.9;
//        [self.animator addBehavior:_gravity];
//    }
//    
//    return _gravity;
//}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self removeCompleteRows];
}

- (BOOL)removeCompleteRows {
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    for (CGFloat y = self.gameView.bounds.size.height - DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height) {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width/2; x<=self.gameView.bounds.size.width - DROP_SIZE.width/2; x += DROP_SIZE.width) {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
                
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) {
            break;
        }
        
        if (rowIsComplete) {
            [dropsToRemove addObjectsFromArray:dropsFound];
        }
    }
    
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropItBehavior removeItem:drop];
        }
        
        [self animateRemovingDrops:dropsToRemove];
    }
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove {
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView  *drop in dropsToRemove) {
            int x = (arc4random() % (int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
            int y = self.gameView.bounds.size.height;
            drop.center = CGPointMake(x, y);
        }
    } completion:^(BOOL finished) {
        [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
    
}

- (void)drop {
    CGRect frame ;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random() % (int)self.gameView.frame.size.width)/ DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc]initWithFrame:frame];
    dropView.backgroundColor = [ self randomColor];
    [self.gameView addSubview:dropView];
    [self.dropItBehavior addItem:dropView];
//    [self.gravity addItem:dropView];
//     [self.collision addItem:dropView];
}

- (UIColor *)randomColor {
    switch (arc4random()%5) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor orangeColor];
        case 2:
            return [UIColor greenColor];
        case 3:
            return [UIColor yellowColor];
        case 4:
            return [UIColor purpleColor];
    }
    
    return [UIColor blackColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end