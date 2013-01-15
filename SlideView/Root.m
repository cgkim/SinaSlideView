//
//  Root.m
//  SlideView
//
//  Created by kim on 13-1-8.
//  Copyright (c) 2013年 ed3g. All rights reserved.
//

#import "Root.h"
#import <QuartzCore/QuartzCore.h>

@interface Root ()

@property (strong, nonatomic) CALayer *arrowImage;
@property (strong, nonatomic) UIView *categoryView;
@property (strong, nonatomic) NSMutableArray *category;
@property (strong, nonatomic) UILabel *titleLabel;

@property int selectIndex;

@end

@implementation Root

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 200.0, 40.0)];
    lbl.font = [UIFont systemFontOfSize:18];
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = @"我是内容。";
    [self.view addSubview:lbl];
    
    UIView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
    titleView.contentMode = UIViewContentModeRight;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCategory:)];
    [titleView addGestureRecognizer:singleRecognizer];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(90.0f, 17.0f, 13.0f, 9.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed:@"arrowhead.png"].CGImage;
    [titleView.layer addSublayer:layer];
    self.arrowImage = layer;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, titleView.bounds.size.width - 14, 21.0)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = 1;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [titleView addSubview:self.titleLabel];
    self.navigationItem.titleView = titleView;
    
    self.categoryView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.categoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.hidden = YES;
    UIView *categoryBackground = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    categoryBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    categoryBackground.backgroundColor = [UIColor blackColor];
    categoryBackground.alpha = 0.5;
    [self.categoryView addSubview:categoryBackground];
    [self.view addSubview:self.categoryView];
    
    self.category = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsChannels" ofType:@"plist"]];
    [self.category enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        static int marginTop = -1;
        if (idx % 4 == 0) {
            marginTop++;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((idx % 4) * 80, marginTop * 80, 80.0, 80.0);
        [btn setBackgroundImage:[UIImage imageNamed:obj[@"image"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:obj[@"highlightedImage"]] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:obj[@"highlightedImage"]] forState:UIControlStateSelected];
        btn.tag = idx + 100;
        if (idx == 0) {
            btn.selected = YES;
            self.selectIndex = idx;
            self.titleLabel.text = obj[@"title"];
        }
        [btn addTarget:self action:@selector(showCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.categoryView addSubview:btn];
    }];
}

- (void)showCategory:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)[self.categoryView viewWithTag:self.selectIndex + 100];
        btn.selected = NO;
        UIButton *currentBtn = (UIButton *)sender;
        NSDictionary *obj = self.category[currentBtn.tag - 100];
        self.selectIndex = currentBtn.tag - 100;
        currentBtn.selected = YES;
        self.titleLabel.text = obj[@"title"];
        NSLog(@"switch to : %d", [obj[@"cid"] intValue]);
    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    if (self.categoryView.hidden == YES) {
        animation.subtype = kCATransitionFromBottom;
        self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        self.categoryView.hidden = NO;
    } else {
        animation.subtype = kCATransitionFromTop;
        self.arrowImage.transform = CATransform3DMakeRotation(0, 0.0f, 0.0f, 1.0f);
        self.categoryView.hidden = YES;
    }
    [[self.categoryView layer] addAnimation:animation forKey:@"animation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
