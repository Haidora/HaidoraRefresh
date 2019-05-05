//
//  HaidoraRefreshAnimator.m
//  Pods
//
//  Created by Dailingchi on 15/3/13.
//
//

#import "HDRefreshAnimator.h"

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
        _titleLable.text =
            NSLocalizedStringFromTable(@"Pull to Refresh...", HDRefreshBundleName, @"");
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
        _activityView.autoresizingMask = self.arrowImage.autoresizingMask;
    }
    return _activityView;
}

- (void)startLoadingAnimation
{
    self.titleLable.text = NSLocalizedStringFromTable(@"Loading...", HDRefreshBundleName, @"");
    self.arrowImage.hidden = YES;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

- (void)stopLoadingAnimation
{
    self.arrowImage.hidden = NO;
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
}

- (void)changeProgress:(CGFloat)progress
{
    CGAffineTransform transformPull = CGAffineTransformIdentity;
    CGAffineTransform transformRefresh = CGAffineTransformIdentity;
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (_position == HDRefreshViewPositionTop)
    {
        transformPull = CGAffineTransformIdentity;
        transformRefresh = CGAffineTransformMakeRotation(M_PI);
    }
    else if (_position == HDRefreshViewPositionBottom)
    {
        transformPull = CGAffineTransformMakeRotation(M_PI);
        transformRefresh = CGAffineTransformIdentity;
    }
    if (progress > 1)
    {
        NSString *loadingString = (_position == HDRefreshViewPositionTop) ? @"Release to refresh..." : @"Release to loading...";
        self.titleLable.text =
            NSLocalizedStringFromTable(loadingString, HDRefreshBundleName, @"");
        transform = transformRefresh;
    }
    else
    {
        NSString *loadingString =  (_position == HDRefreshViewPositionTop) ? @"Pull to refresh..." : @"Pull up loading...";
        self.titleLable.text =
            NSLocalizedStringFromTable(loadingString, HDRefreshBundleName, @"");
        transform = transformPull;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                       self.arrowImage.transform = transform;
                     }];
}

- (void)layoutSubviewsWith:(UIView *)superView
{
    CGFloat superHeight = CGRectGetHeight(superView.frame);
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
        if (_position == HDRefreshViewPositionTop)
        {
            self.arrowImage.transform = CGAffineTransformIdentity;
        }
        else if (_position == HDRefreshViewPositionBottom)
        {
            self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }
    if (self.activityView.superview == nil)
    {
        self.activityView.frame = self.arrowImage.frame;
        [superView addSubview:self.activityView];
    }
}

@end
