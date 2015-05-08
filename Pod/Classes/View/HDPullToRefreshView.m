//
//  HDPullToRefreshView.m
//  Pods
//
//  Created by Dailingchi on 15/4/15.
//
//

#import "HDPullToRefreshView.h"
#import "UIScrollView+HDRefreshView.h"

static char *HDPullTORefreshKVOContext;
//旋转的支持
@interface HDPullToRefreshView ()
{
    UIEdgeInsets _scrollViewInsetsDefaultValue;
}

@end

@implementation HDPullToRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.animator layoutSubviewsWith:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview __attribute__((objc_requires_super))
{
    [self.superview removeObserver:self
                        forKeyPath:HDRefreshViewContentOffSetKeyPath
                           context:&HDPullTORefreshKVOContext];
    if (newSuperview != nil && [newSuperview isKindOfClass:[UIScrollView class]])
    {
        [newSuperview addObserver:self
                       forKeyPath:HDRefreshViewContentOffSetKeyPath
                          options:NSKeyValueObservingOptionInitial
                          context:&HDPullTORefreshKVOContext];
        _scrollViewInsetsDefaultValue = ((UIScrollView *)newSuperview).contentInset;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context __attribute__((objc_requires_super))
{
    if (context == &HDPullTORefreshKVOContext)
    {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if ([keyPath isEqualToString:HDRefreshViewContentOffSetKeyPath] && object == scrollView)
        {
            scrollView = object;
            if (scrollView)
            {
                [self adjustWithContentOffSetWith:scrollView];
            }
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark
#pragma mark Public method

- (void)adjustWithContentOffSetWith:(UIScrollView *)scrollView
{
    CGFloat offSetWithInsets = scrollView.contentOffset.y + _scrollViewInsetsDefaultValue.top;
    if (offSetWithInsets >= _scrollViewInsetsDefaultValue.top)
    {
        return;
    }
    if (!scrollView.refreshLoading)
    {
        if (scrollView.isDragging)
        {
            [self.animator changeProgress:(-offSetWithInsets / CGRectGetHeight(self.bounds))];
        }
        else if (offSetWithInsets <= (-CGRectGetHeight(self.bounds) + 7))
        {
            [self startAnimating];
        }
    }
}

#pragma mark
#pragma mark Action

- (void)startAnimating
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    scrollView.refreshLoading = YES;
    UIEdgeInsets insets = scrollView.contentInset;
    insets.top += CGRectGetHeight(self.frame);
    [self.animator startLoadingAnimation];
    [UIView animateWithDuration:0.3
        animations:^{
          scrollView.contentInset = insets;
          scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -insets.top);
        }
        completion:^(BOOL finished) {
          if (self.action)
          {
              self.action();
          }
        }];
}

- (void)stopAnimating
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    scrollView.refreshLoading = NO;
    [UIView animateWithDuration:0.3
        animations:^{
          scrollView.contentInset = _scrollViewInsetsDefaultValue;
        }
        completion:^(BOOL finished) {
          if (finished)
          {
              [self.animator stopLoadingAnimation];
          }
        }];
}

@end
