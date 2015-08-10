//
//  HDPullToRefreshView.m
//  Pods
//
//  Created by Dailingchi on 15/4/15.
//
//

#import "HDPullToRefreshView.h"
#import "UIScrollView+HDRefreshPrivate.h"

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
    [super willMoveToSuperview:newSuperview];
    if (newSuperview != nil && [newSuperview isKindOfClass:[UIScrollView class]])
    {
        _scrollViewInsetsDefaultValue = ((UIScrollView *)newSuperview).contentInset;
    }
    else if (newSuperview == nil && [self.superview isKindOfClass:[UIScrollView class]])
    {
        // https://github.com/samvermette/SVPullToRefresh/blob/master/SVPullToRefresh/UIScrollView%2BSVPullToRefresh.m#L196
        // use self.superview, not self.scrollView. Why self.scrollView == nil here?
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (YES)
        {
            if (self.isObserving)
            {
                [scrollView removeObserver:self forKeyPath:HDRefreshViewContentOffSetKeyPath];
                self.isObserving = NO;
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context __attribute__((objc_requires_super))
{
    if (context == HDPullTORefreshKVOContext)
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
    if (!scrollView.pullRefreshLoading && !scrollView.infiniteRefreshLoading)
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
    scrollView.pullRefreshLoading = YES;
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
    scrollView.pullRefreshLoading = NO;
    [self.animator stopLoadingAnimation];
    [UIView animateWithDuration:0.3
        animations:^{
          scrollView.contentInset = _scrollViewInsetsDefaultValue;
        }
        completion:^(BOOL finished) {
          if (finished)
          {
              [self.animator changeProgress:0];
          }
        }];
}

@end
