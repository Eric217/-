//
//  ViewController.m
//  SortReveal
//
//  Created by Eric on 2018/4/10.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Common.h"
#import "UIView+funcs.h"
#import "SortMainController.h"
#import <Masonry/Masonry.h>
#import "UIView+frameProperty.h"
#import "SortingViewController.h"
#import "ConfigSortController.h"
#import "UIViewController+SplitController.h"
#import "UIButton+init.h"
#import "CommonCollectionCell.h"


@interface SortMainController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *appTitle;
@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, copy) NSMutableArray *titleArr;

@property (nonatomic, assign) CGFloat itemSize;
@property (nonatomic, assign) CGFloat edgeDistance; //20
@property (nonatomic, assign) CGFloat verticalSpacing; //36

@end

@implementation SortMainController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //data arr
    NSArray *arr = [Config getArrayFromFile:SortNameFile];
    if (!arr) {
        arr = @[@"冒泡排序", @"选择排序", @"插入排序", @"堆排序", @"快速排序"];
        [Config writeToPlistName:SortNameFile data:arr];
    }
    _titleArr = arr.mutableCopy;
    self.view.backgroundColor = UIColor.whiteColor;
    
    //collection view
    _edgeDistance = [Config v_pad:46 plus:36 p:33 min:20];
    _verticalSpacing = [Config v_pad:52 plus:33 p:24 min:20];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_collection setBackgroundColor:UIColor.whiteColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.alwaysBounceVertical = 1;
    _collection.contentInset = UIEdgeInsetsMake(15, _edgeDistance, 15, _edgeDistance);
    [_collection registerClass:CommonCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(CommonCollectionCell.class)];
    [self.view addSubview:_collection];
    
    //title label
    _appTitle = [[UILabel alloc] init];
    [_appTitle setText:@"排序"];
    [_appTitle setTextAlignment:NSTextAlignmentCenter];
    [_appTitle setFont:[UIFont boldSystemFontOfSize:40]];
    [self.view addSubview:_appTitle];
    
    //layout
    [_appTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.top.mas_equalTo(16);
        make.height.mas_equalTo(0);
    }];
    
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appTitle.mas_bottom);
        make.width.left.bottom.equalTo(self.view);
    }];
    
    UIButton *butt = [UIButton customBackBarButtonItemWithTitle:@"返回" target:self action:@selector(back)];
    [self.view addSubview:butt];
    [butt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(32);
        make.left.equalTo(self.view).offset(26);
        make.size.mas_equalTo(CGSizeMake(78, 30));
    }];
}

- (void)back {
    self.view.window.rootViewController = self.presentingViewController;
    [self dismissViewControllerAnimated:1 completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CommonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(CommonCollectionCell.class) forIndexPath:indexPath];
    NSString *content = _titleArr[indexPath.item];
    
    [cell fillContents:content];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(_itemSize, _itemSize);
}

///行间距。列间距 item spacing不论怎么设置，最后系统都会自己调整，按照cell对称、不能显示一半等等得到最后spacing。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _verticalSpacing;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    ConfigSortController *conf = [[ConfigSortController alloc] initWithSort:indexPath.item title:_titleArr[indexPath.item] root:self.view.window.rootViewController];

    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:conf];
    
    [self showSplitWithMaster:masterNav detail:SortingViewController.class delegate:conf];
  
}

//比collection view的代理方法先执行
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    const CGSize s = self.view.frame.size;
    
    CGFloat w = s.width > s.height ? s.height : s.width;
    
    if (IPAD) {
        
        if ([self isFloatingOrThirth]) {
            _itemSize = (s.width - 2.64*_edgeDistance);
        } else if ([self isFullScreen]) {
            _itemSize = (w-2*_edgeDistance-2*68)/3;
        } else if ([self isHalfIpad] || [self isPortrait]) { //!!!!
            _itemSize = (s.width - 2.9*_edgeDistance)/2;
        } else {
            _itemSize = (w-3.6*_edgeDistance)/3;
        }
    } else {
        _itemSize = (w-3*_edgeDistance)/2;
    }
    
    [_appTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat h;
        if (IPAD)
            h = [self isPortrait] ? 190 : 170;
        else {
            CGFloat ph = IPhoneX ?  130 : 94;
            h = [self isPortrait] ? ph : 70;
        }
        make.height.mas_equalTo(h);
    }];
}

@end
