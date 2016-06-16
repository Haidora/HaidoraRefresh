//
//  HDInfiniteToRefreshView.m
//  Pods
//
//  Created by Dailingchi on 15/4/15.
//
//

#import "HDInfiniteToRefreshView.h"
#import "UIScrollView+HDRefreshPrivate.h"

typedef NS_ENUM(NSUInteger, HDInfiniteToRefreshState) {
    HDInfiniteToRefreshStateNone = 0,
    HDInfiniteToRefreshStateTriggering,
    HDInfiniteToRefreshStateTriggered,
    HDInfiniteToRefreshStateLoading,
};

//旋转的支持
@interface HDInfiniteToRefreshView ()
{
    CGFloat _previousOffset;
    UIEdgeInsets _scrollViewInsetsDefaultValue;
    UIScrollView *_scrollView;
}

@property (nonatomic, assign) HDInfiniteToRefreshState state;

@end

@implementation HDInfiniteToRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = HDInfiniteToRefreshStateNone;
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
        _scrollView = (UIScrollView *)newSuperview;
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
                [scrollView removeObserver:self forKeyPath:HDRefreshViewContentSizeKeyPath];
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
    if (context == (__bridge void *_Nullable)(HDInfiniteToRefreshKVOContext))
    {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (object == scrollView)
        {
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
    if (superView && !superView.infiniteRefreshLoading && !superView.pullRefreshLoading)
    {
        if (superView.frame.size.height > superView.contentSize.height)
        {
            self.alpha = 0;
            return;
        }
        else
        {
            self.alpha = 1;
        }
        CGFloat offSetWithInsetY = superView.contentOffset.y + _scrollViewInsetsDefaultValue.top;
        CGFloat visibleOffSetY = [self heightForRefreshShow];
        if (offSetWithInsetY <= visibleOffSetY)
        {
            return;
        }
        CGFloat progress = ((offSetWithInsetY - visibleOffSetY) / CGRectGetHeight(self.frame));
        if (HDInfiniteToRefreshStateNone == _state)
        {
            if (superView.isDragging)
            {
                [self.animator changeProgress:progress];
                _state = HDInfiniteToRefreshStateTriggering;
            }
        }
        else if (HDInfiniteToRefreshStateTriggering == _state)
        {
            if (progress > 1.0f)
            {
                _state = HDInfiniteToRefreshStateTriggered;
            }
        }
        else if (HDInfiniteToRefreshStateTriggered == _state)
        {
            if ((offSetWithInsetY + 7) >= (CGRectGetHeight(self.bounds) + visibleOffSetY) &&
                !superView.isDragging)
            {
                [self startAnimating];
            }
            else
            {
                [self.animator changeProgress:progress];
            }
        }
    }
}

- (CGFloat)heightForRefreshShow
{
    CGFloat height = [self heightForContentViewInvisible];
    if (height < 0)
    {
        height = 0;
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
    self.state = HDInfiniteToRefreshStateLoading;
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
              self.state = HDInfiniteToRefreshStateNone;
              scrollView.infiniteRefreshLoading = NO;
          }
        }];
}

@end
