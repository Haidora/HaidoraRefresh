//
//  HaidoraRefreshAnimator.m
//  Pods
//
//  Created by Dailingchi on 15/3/13.
//
//

#import "HDRefreshAnimator.h"
#import <QuartzCore/QuartzCore.h>

#define kHDBeatAnimatorLayerLoaderHeight 4
#define kHDBeatAnimatorLayerSeparatorHeight 2

@interface HDBeatAnimator ()

@property (nonatomic, strong) CAShapeLayer *layerLoader;
@property (nonatomic, strong) CAShapeLayer *layerSeparator;

@end

@implementation HDBeatAnimator

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.layerLoader = [CAShapeLayer layer];
        self.layerLoader.lineWidth = kHDBeatAnimatorLayerLoaderHeight;
        self.layerLoader.lineCap = kCALineCapRound;
        self.layerLoader.strokeColor =
            [UIColor colorWithRed:0.165 green:0.264 blue:1.000 alpha:1.000].CGColor;
        self.layerLoader.strokeEnd = 0;

        self.layerSeparator = [CAShapeLayer layer];
        self.layerSeparator.lineWidth = kHDBeatAnimatorLayerSeparatorHeight;
        self.layerSeparator.lineCap = kCALineCapRound;
        self.layerSeparator.strokeColor = [UIColor colorWithWhite:0.500 alpha:0.300].CGColor;
        self.layerSeparator.strokeEnd = 1;
    }
    return self;
}

- (void)startLoadingAnimation
{
    CABasicAnimation *pathAnimationStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    pathAnimationStart.duration = 1;
    pathAnimationStart.repeatCount = HUGE_VALL;
    pathAnimationStart.autoreverses = YES;
    pathAnimationStart.fromValue = @(0);
    pathAnimationStart.toValue = @(0.5);
    [self.layerLoader addAnimation:pathAnimationStart forKey:@"pathAnimationStart"];

    CABasicAnimation *pathAnimationEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimationEnd.duration = 1;
    pathAnimationEnd.repeatCount = HUGE_VALL;
    pathAnimationEnd.autoreverses = YES;
    pathAnimationEnd.fromValue = @(1);
    pathAnimationEnd.toValue = @(0.5);
    [self.layerLoader addAnimation:pathAnimationEnd forKey:@"strokEndAnimation"];
}

- (void)stopLoadingAnimation
{
    [self.layerLoader removeAllAnimations];
}

- (void)changeProgress:(CGFloat)progress
{
    self.layerLoader.strokeStart = 1 - progress;
    self.layerLoader.strokeEnd = progress;
}

- (void)layoutSubviewsWith:(UIView *)superView
{
    // add layer
    if (self.layerSeparator.superlayer == nil)
    {
        [superView.layer addSublayer:self.layerSeparator];
    }
    if (self.layerLoader.superlayer == nil)
    {
        [superView.layer addSublayer:self.layerLoader];
    }
    UIBezierPath *bezierPathLoader = [UIBezierPath bezierPath];
    [bezierPathLoader moveToPoint:CGPointMake(0, CGRectGetHeight(superView.frame) -
                                                     kHDBeatAnimatorLayerLoaderHeight)];
    [bezierPathLoader addLineToPoint:CGPointMake(CGRectGetWidth(superView.frame),
                                                 CGRectGetHeight(superView.frame) -
                                                     kHDBeatAnimatorLayerLoaderHeight)];

    UIBezierPath *bezirePathSeparator = [UIBezierPath bezierPath];
    [bezirePathSeparator moveToPoint:CGPointMake(0, CGRectGetHeight(superView.frame) -
                                                        kHDBeatAnimatorLayerSeparatorHeight)];
    [bezirePathSeparator addLineToPoint:CGPointMake(CGRectGetWidth(superView.frame),
                                                    CGRectGetHeight(superView.frame) -
                                                        kHDBeatAnimatorLayerSeparatorHeight)];

    self.layerLoader.path = bezierPathLoader.CGPath;
    self.layerSeparator.path = bezirePathSeparator.CGPath;
}

@end

@interface HDClassicAnimator ()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation HDClassicAnimator

- (UILabel *)titleLable
{
    if (nil == _titleLable)
    {
        _titleLable = [[UILabel alloc] init];
        _titleLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _titleLable.font = [UIFont boldSystemFontOfSize:14.0f];
        _titleLable.textColor = [UIColor darkGrayColor];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UIImageView *)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage =
            [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HaidoraRefresh.bundle/arrow"]];
        _arrowImage.contentMode = UIViewContentModeCenter;
        _arrowImage.autoresizingMask =
            UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _arrowImage;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView)
    {
        _activityView = [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = self.arrowImage.frame;
        _activityView.autoresizingMask = self.arrowImage.autoresizingMask;
    }
    return _activityView;
}

- (void)startLoadingAnimation
{
    self.titleLable.text = @"Loading ...";
    [UIView animateWithDuration:0.3
        animations:^{
          self.arrowImage.hidden = YES;
          self.activityView.hidden = NO;
        }
        completion:^(BOOL finished) {
          if (finished)
          {
              [self.activityView startAnimating];
          }
        }];
}

- (void)stopLoadingAnimation
{
    [UIView animateWithDuration:0.3
        animations:^{
          self.arrowImage.hidden = NO;
          self.activityView.hidden = YES;
        }
        completion:^(BOOL finished) {
          if (finished)
          {
              [self.activityView startAnimating];
          }
        }];
}

- (void)changeProgress:(CGFloat)progress
{
//    NSLog(@"%@", @(progress));
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (progress > 1)
    {
        self.titleLable.text = @"Realse to Refresh....";
        transform = CGAffineTransformMakeRotation(M_PI);
    }
    else
    {
        self.titleLable.text = @"Pull to Refresh....";
        transform = CGAffineTransformIdentity;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                       self.arrowImage.transform = transform;
                     }];
}

- (void)layoutSubviewsWith:(UIView *)superView
{
    CGFloat superHeight = CGRectGetHeight(superView.frame);
    //    CGFloat superWidth = CGRectGetWidth(superView.frame);
    if (self.titleLable.superview == nil)
    {
        self.titleLable.frame = superView.bounds;
        [superView addSubview:self.titleLable];
    }
    if (self.arrowImage.superview == nil)
    {
        CGFloat height = 30;
        self.arrowImage.frame = CGRectMake(55, (superHeight - height) / 2, height, height);
        [superView addSubview:self.arrowImage];
    }
    if (self.activityView.superview == nil)
    {
        self.activityView.hidden = YES;
        [superView addSubview:self.activityView];
    }
}

@end
