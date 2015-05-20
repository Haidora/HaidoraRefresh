//
//  HDInfiniteToRefreshView.m
//  Pods
//
//  Created by Dailingchi on 15/4/15.
//
//

#import "HDInfiniteToRefreshView.h"
#import "UIScrollView+HDRefreshView.h"

static char *HDInfiniteToRefreshKVOContext;
//旋转的支持
@interface HDInfiniteToRefreshView ()
{
    CGFloat _previousOffset;
    UIEdgeInsets _scrollViewInsetsDefaultValue;
    UIScrollView *_scrollView;
}

@end

@implementation HDInfiniteToRefreshView

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
                           context:&HDInfiniteToRefreshKVOContext];
    [self.superview removeObserver:self
                        forKeyPath:HDRefreshViewContentSizeKeyPath
                           context:&HDInfiniteToRefreshKVOContext];

    if (newSuperview != nil && [newSuperview isKindOfClass:[UIScrollView class]])
    {
        [newSuperview addObserver:self
                       forKeyPath:HDRefreshViewContentOffSetKeyPath
                          options:NSKeyValueObservingOptionInitial
                          context:&HDInfiniteToRefreshKVOContext];
        [newSuperview addObserver:self
                       forKeyPath:HDRefreshViewContentSizeKeyPath
                          options:NSKeyValueObservingOptionInitial
                          context:&HDInfiniteToRefreshKVOContext];
        _scrollViewInsetsDefaultValue = ((UIScrollView *)newSuperview).contentInset;
        _scrollView = (UIScrollView *)newSuperview;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context __attribute__((objc_requires_super))
{
    if (context == &HDInfiniteToRefreshKVOContext)
    {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (object == scrollView)
        {
            scrollView = object;
            if ([keyPath isEqualToString:HDRefreshViewContentOffSetKeyPath])
            {
                [self adjustStateWithContentOffset];
            }
            if ([keyPath isEqualToString:HDRefreshViewContentSizeKeyPath])
            {
                [self adjustFrameWithContentSize];
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

- (void)adjustFrameWithContentSize
{
    UIScrollView *superView = (UIScrollView *)self.superview;
    if (superView)
    {
        CGFloat contentHeight = superView.contentSize.height;
        CGFloat scrollHeight = CGRectGetHeight(superView.bounds) -
                               _scrollViewInsetsDefaultValue.top -
                               _scrollViewInsetsDefaultValue.bottom;
        CGRect frame = self.frame;
        frame.origin.y = MAX(contentHeight, scrollHeight);
        self.frame = frame;
    }
}

- (void)adjustStateWithContentOffset
{
    UIScrollView *superView = (UIScrollView *)self.superview;
    if (superView && !superView.infiniteRefreshLoading)
    {
        CGFloat offSetWithInsetY = superView.contentOffset.y + _scrollViewInsetsDefaultValue.top;
        CGFloat visibleOffSetY = [self heightForRefreshShow];
        if (offSetWithInsetY < visibleOffSetY)
        {
            return;
        }
        if (superView.isDragging)
        {
            [self.animator
                changeProgress:((offSetWithInsetY - visibleOffSetY) / CGRectGetHeight(self.frame))];
        }
        else if ((offSetWithInsetY + 7) >= (CGRectGetHeight(self.bounds) + visibleOffSetY))
        {
            [self startAnimating];
        }
    }
}

- (CGFloat)heightForRefreshShow
{
    CGFloat height = [self heightForContentViewInvisible];
    if (height > 0)
    {
        height = height - _scrollViewInsetsDefaultValue.top;
    }
    else
    {
        height = _scrollViewInsetsDefaultValue.top;
    }
    return height;
}

- (CGFloat)heightForContentViewInvisible
{
    CGFloat height = 0;
    height = CGRectGetHeight(_scrollView.frame) - _scrollViewInsetsDefaultValue.top -
             _scrollViewInsetsDefaultValue.bottom;
    height = _scrollView.contentSize.height - height;
    return height;
}

#pragma mark
#pragma mark Action

- (void)startAnimating
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    scrollView.infiniteRefreshLoading = YES;
    CGFloat bottom = CGRectGetHeight(self.bounds) + _scrollViewInsetsDefaultValue.bottom;
    CGFloat deltaH = [self heightForContentViewInvisible];
    if (deltaH < 0)
    {
        bottom -= deltaH;
    }
    UIEdgeInsets insets = scrollView.contentInset;
    insets.bottom = bottom;
    [self.animator startLoadingAnimation];
    [UIView animateWithDuration:0.3
        animations:^{
          scrollView.contentInset = insets;
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
    scrollView.infiniteRefreshLoading = NO;
    UIEdgeInsets insets = scrollView.contentInset;
    insets.bottom = _scrollViewInsetsDefaultValue.bottom;
    [self.animator stopLoadingAnimation];
    [UIView animateWithDuration:0.3
        animations:^{
          scrollView.contentInset = insets;
        }
        completion:^(BOOL finished) {
          if (finished)
          {
              [self.animator changeProgress:0];
          }
        }];
}

@end
