//
//  ViewController.m
//  Lesson 19 HW 2
//
//  Created by Alex on 04.01.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "ViewController.h"
typedef enum {
    SubViewTagCell,
    SubViewTagCheckers,
    SubViewTagBoard,
    
} SubViewTag; //tags made for choosing views later

@interface ViewController ()
@property (weak, nonatomic) UIView* board;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor grayColor];
    CGSize boardSize = CGSizeMake(MIN(self.view.bounds.size.width, self.view.bounds.size.height), MIN(self.view.bounds.size.width, self.view.bounds.size.height));
    CGRect boardRect;
    boardRect.origin = CGPointMake(0, 20);
    //boardRect.origin = CGPointMake((self.view.bounds.size.width - boardSize.width/2), (self.view.bounds.size.height - boardSize.height/2));
    boardRect.size = boardSize;
    
    self.board = [self viewWithCGRect:boardRect color:[UIColor blueColor] parentView:self.view tag:SubViewTagBoard];
    
    self.board.autoresizingMask =   UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    for (int x=0; x<8; x++) {
        for (int y=0; y<8; y++) {
            CGRect cellRect;
            cellRect.size = CGSizeMake(boardSize.width/8, boardSize.height/8);
            cellRect.origin = CGPointMake(x*cellRect.size.width, y*(cellRect.size.height));
            UIColor* color;
            color = ((x+y)%2 == 0) ? [UIColor whiteColor]:[UIColor blackColor];
            UIView* cellView = [self viewWithCGRect:cellRect color:color parentView:self.board tag:SubViewTagCell];
            if ((x+y)%2 !=0 && ((y>=0 && y<3) | (y>=5 && y<8))) {
                CGRect checkersRect;
                checkersRect.size = CGSizeMake(.65*cellView.frame.size.width, .65*cellView.frame.size.height);
                checkersRect.origin = CGPointMake((cellView.frame.size.width-checkersRect.size.width)/2, (cellView.frame.size.height - checkersRect.size.height)/2);
                checkersRect.origin = [self.board convertPoint:checkersRect.origin fromView:cellView];
                color = (y>=0 && y<3) ? [UIColor redColor] : [UIColor greenColor];
                UIView* checkersView = [self viewWithCGRect:checkersRect color:color parentView:self.board tag:SubViewTagCheckers];
                //checkersView.layer.cornerRadius = checkersView.bounds.size.height/2 ;
                checkersView.layer.cornerRadius = checkersRect.size.width/2 ;
            }
        }
    }
    
    
    
}

- (UIView*) viewWithCGRect:(CGRect) rect color:(UIColor*) color parentView:(UIView*) parent tag:(SubViewTag)tag {
    UIView* view = [[UIView alloc] initWithFrame:rect];
    view.tag = tag;
    // view.layer.cornerRadius = view.bounds.size.height/2; // this is for circles
    view.backgroundColor = color;
    [parent addSubview:view];
    return view;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    UIColor* randomColor = [UIColor colorWithRed:(float)(arc4random()%256)/255 green:(float)(arc4random()%256)/255 blue:(float)(arc4random()%256)/255 alpha:1.f ];
    for (int i=0; i<[self.board.subviews count]; i++) {
        UIView* subView = [self.board.subviews objectAtIndex:i];
        if (subView.tag == SubViewTagCheckers) {
            while (YES) {
                NSUInteger randomIndex = arc4random()%[self.board.subviews count];
                UIView* subView2 = [self.board.subviews objectAtIndex:randomIndex];
                if (subView2.tag == SubViewTagCheckers && ![subView isEqual:subView2]) {
                    CGRect frame = subView.frame;
                    subView.frame = CGRectMake(subView2.frame.origin.x, subView2.frame.origin.y, subView2.frame.size.width, subView2.frame.size.height);
                    subView2.frame = CGRectMake(frame.origin.x, frame.origin.y, subView2.frame.size.width, subView2.frame.size.height);
                    [self.board exchangeSubviewAtIndex:i withSubviewAtIndex:randomIndex];
                    break;
                }
            }
        } else if (subView.tag == SubViewTagCell && ![subView.backgroundColor isEqual:[UIColor whiteColor]]) {
            
            subView.backgroundColor = randomColor;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
