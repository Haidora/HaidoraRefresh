# HaidoraRefresh
通用的下拉刷新。

## Usage

    #import <HaidoraRefresh.h>
    
    //下拉刷新
    //添加下拉刷新回调
    [self.scrollView addPullToRefreshWithActionHandler:nil];
    //添加下拉刷新并设置自定义动画
    [self.scrollView addPullToRefreshWithActionHandler:nil animator:nil];
    //适用于collectionView,添加代码
     self.collectionView.alwaysBounceVertical = YES;

    
## Animator

更多自定义Animator[HaidoraRefreshExtension](https://github.com/Haidora/HaidoraRefreshExtension)

## Installation

HaidoraRefresh is available through [HaidoraPods](https://github.com/Haidora/HaidoraPods). To install
it, simply add the following line to your Podfile:

    pod "HaidoraRefresh"

## Author

mrdaios, mrdaios@gmail.com

## License

HaidoraRefresh is available under the MIT license. See the LICENSE file for more info.

