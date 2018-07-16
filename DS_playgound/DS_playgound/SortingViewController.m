//
//  SortingViewController.m
//  SortReveal
//
//  Created by Eric on 2018/4/11.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "SortingViewController.h"
#import "UIView+funcs.h"
#import "UIView+frameProperty.h"
#import "UIViewController+funcs.h"
#import "UIImage+operations.h"
#import "SettingViewController2.h"
#import "UIButton+init.h"
#import "Sorters.h"
#import "SortCell.h"

#define emptyDisplayString @"配置排序\n以开始"

@interface SortingViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

//Collection and empty view
@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) UILabel *collectionEmptyView;

//Right 2
@property (strong, nonatomic) UIBarButtonItem *settings;
@property (strong, nonatomic) UIBarButtonItem *restartButton;
//Bottom 4
@property (strong, nonatomic) UIBarButtonItem *nextStepButton;
@property (strong, nonatomic) UIBarButtonItem *nextRowButton;
@property (strong, nonatomic) UIBarButtonItem *flowRunButton;
@property (strong, nonatomic) UIBarButtonItem *lastStepButton;

//To do -- full screen
@property (strong, nonatomic) UIBarButtonItem *fullScreenItem;
@property (strong, nonatomic) UIButton *fullScreenButton;

//Data
@property (nonatomic, copy) NSMutableArray<NSString *> *originDataArr;
@property (nonatomic, copy) NSMutableArray<NSDictionary *> *viewDataDictArr;

@property (weak, nonatomic) NSTimer *timer;

@property (nonatomic, strong) id <Sorter> sorter;

@property (assign) SortOrder sortOrder;
@property (assign) SortType sortType;

@property (assign) CGFloat edgeDistance;
@property (assign) CGSize itemSize;

@end

@implementation SortingViewController

//MARK: - 构造 - WARNING: - restart need init
- (instancetype)initWithArr:(NSMutableArray *)arr sortType:(SortType)type sortOrder:(SortOrder)order {
    //MARK: - 执行顺序1
    self = [super init];
    if (self) {
        //除了视图的部分：
        _sortType = type;
        _sortOrder = order;
        _originDataArr = arr;
        if (arr.count) {
            [self initializeSorter];
            _viewDataDictArr = [NSMutableArray new];
        }
    }
    return self;
}
- (void)dealloc {
    [Config removeObserver:self];
}

//MARK: - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    //MARK: - 执行顺序2
    //buttons
    _fullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 6, 92, 32)];
    [_fullScreenButton setTitle:@"配置排序" forState:UIControlStateNormal];
    [_fullScreenButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_fullScreenButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_fullScreenButton setImage:[UIImage backImage] forState:UIControlStateNormal];
    [_fullScreenButton addTarget:self action:@selector(setFullScreenDisplay:) forControlEvents:UIControlEventTouchUpInside];
    _fullScreenButton = [UIButton customBackBarButtonItemWithTitle:@"全屏演示" target:self action:@selector(setFullScreenDisplay:)];
    _fullScreenItem = [[UIBarButtonItem alloc] initWithCustomView:_fullScreenButton];
    
    //if (IPAD)
    //   self.navigationItem.leftBarButtonItems = @[self.splitViewController.displayModeButtonItem];
    
    _restartButton = [[UIBarButtonItem alloc] initWithTitle:@"重新开始" style:UIBarButtonItemStylePlain target:self action:@selector(restart:)];
    [_restartButton setTintColor:UIColor.blackColor];
    _settings = [[UIBarButtonItem alloc] initWithTitle:@" 设置" style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
    [_settings setTintColor:UIColor.blackColor];
    self.navigationItem.rightBarButtonItems = @[_settings, _restartButton];
    
    _lastStepButton = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(lastStep:)];
    _flowRunButton = [[UIBarButtonItem alloc] initWithTitle:@"自动执行" style:UIBarButtonItemStylePlain target:self action:@selector(play:)];
    _nextRowButton = [[UIBarButtonItem alloc] initWithTitle:@"单组跳过" style:UIBarButtonItemStylePlain target:self action:@selector(nextRow:)];
    
    _nextStepButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:0 action:0];
    [fixedSpace setWidth:42];
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:0 action:0], _lastStepButton, fixedSpace, _flowRunButton, _nextRowButton, _nextStepButton];
    [_lastStepButton setEnabled:0];
    
    
    //collection view
    _edgeDistance = [Config v_pad:10 plus:5 p:5 min:3];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_collection setBackgroundColor:UIColor.whiteColor];
    [_collection setAllowsSelection:0];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.alwaysBounceVertical = 1;
    _collection.contentInset = UIEdgeInsetsMake(38.5, _edgeDistance, 24, _edgeDistance);
    [_collection registerClass:ELTreeUnitCell.class forCellWithReuseIdentifier:NSStringFromClass(ELTreeUnitCell.class)];
    [_collection registerClass:ELCommonLinearCell.class forCellWithReuseIdentifier:NSStringFromClass(ELCommonLinearCell.class)];
    [_collection registerClass:ELRepeatLinearCell.class forCellWithReuseIdentifier:NSStringFromClass(ELRepeatLinearCell.class)];
    [_collection registerClass:ELGroupedUnitCell.class forCellWithReuseIdentifier:NSStringFromClass(ELGroupedUnitCell.class)];
    [_collection registerClass:ELInsertionSortCell.class forCellWithReuseIdentifier:NSStringFromClass(ELInsertionSortCell.class)];
    
    
    [self.view addSubview:_collection];
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    _collectionEmptyView = [[UILabel alloc] init];
    [_collection insertSubview:_collectionEmptyView atIndex:0];
    UIColor *tc = [UIColor.grayColor colorWithAlphaComponent:0.78];
    [_collectionEmptyView setTextColor:tc];
    _collectionEmptyView.text = emptyDisplayString;
    _collectionEmptyView.numberOfLines = 2;
    _collectionEmptyView.font = [UIFont systemFontOfSize:28];
    _collectionEmptyView.textAlignment = NSTextAlignmentCenter;
    [_collectionEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collection).mas_offset(-13);
        make.centerY.equalTo(self.collection.mas_centerY).mas_offset(-126);
        make.size.mas_equalTo(CGSizeMake(300, 200));
    }];
    
    //user defaults
    if ([UserDefault doubleForKey:kTimeInterval] <= 0) {
        [Config saveDouble:0.8 forKey:kTimeInterval];
    }
    
    [self setTitle:@"动态演示"];
    [self initializeDisplay];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //MARK: - 执行顺序4
    //只是几个button的title、位置，无任何意义
    if ([self isFloatingOrThirth]) {
        [_settings setTitle:@"设置"];
        [_nextStepButton setTitle:@"单步 "];
        [_fullScreenButton setContentEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 0)];
    } else {
        [_settings setTitle:@" 设置"];
        [_nextStepButton setTitle:@"单步执行"];
        [_fullScreenButton setContentEdgeInsets:UIEdgeInsetsMake(0, -14, 0, 0)];
    }
    
    CGFloat w = self.view.width;
    //CGFloat h = self.view.height;
    
    if (_sortType == SortTypeHeap) {
        [Config updateUnitSizeAndFontFor:[self screenMode] withTreeSize:_originDataArr.count];
        _itemSize = [Config estimatedSizeThatFitsTree:_originDataArr.count bottom:UnderTreeH];
    } else
        _itemSize = CGSizeMake(w - 2*_edgeDistance, 100);
    
    if (IPAD) {
        
        if ([self canPullHideLeft]) {
            self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
            [self.navigationItem.leftBarButtonItem setTintColor:UIColor.blackColor];
            
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }
        
    }
    
    if (IPHONE) {
        if ([self isDevicePortait]) {
            [self updateBackEmptyPositionCX:-13 CY:-126];
        } else
            [self updateBackEmptyPositionCX:-13 CY:-80];
    } else {
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer:0];
}

//MARK: - 点击各个控件事件或其他触发事件
//由非转屏、改变iPad分屏时导致的layoutSubview里 不能reloadData，需要靠下面这个函数。
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    CGSize lastItemSize = _itemSize;
    CGFloat w = size.width;
    if (_sortType == SortTypeHeap) {

        [Config updateUnitSizeAndFontFor:[self screenMode] withTreeSize:_originDataArr.count];
        _itemSize = [Config estimatedSizeThatFitsTree:_originDataArr.count bottom:UnderTreeH];
    } else
        _itemSize = CGSizeMake(w - 2*_edgeDistance, 100);
    
    if (!(_itemSize.width == lastItemSize.width && _itemSize.height == lastItemSize.height)) {
        [_collection reloadData];
    }
}
///点击展示界面上的fullscreen按钮
- (void)setFullScreenDisplay:(id)sender {
    
//    if ([_fullScreenButton.titleLabel.text isEqualToString:@"全屏显示"]) {
//        _fullScreenSpecified = 1;
//        [self hidePrimarySplitStyle];
//    } else if ([self isFullScreen]) {
//        if ([self isDevicePortait]) {
//            [self overlaySplitStyle];
//        } else {
//            [self automaticSplitStyle];
//            _fullScreenSpecified = 0;
//        }
//    } else if (1) {
//
//    }
    
}

- (void)lastStep:(id)sender {
    if (_timer.isValid) {
        [self stopTimer:0];
    }
    int len = (int)(_viewDataDictArr.count);
    if (len < 2) {
        [_lastStepButton setEnabled:0];
        return;
    }
    [_sorter lastStep];
    [_viewDataDictArr removeLastObject];
    NSIndexPath *idx = IndexPath_Sec0(len-1);
    [_collection deleteItemsAtIndexPaths:@[idx]];
    [self setEnabled:1];
    if (len < 3) {
        [_lastStepButton setEnabled:0];
    }
}

- (void)nextStep:(id)sender {
    if (![sender isKindOfClass:NSTimer.class]) {
        [_timer invalidate];
    }
    if (!(_viewDataDictArr.count)) {
        return;
    }
    
    BOOL finished = false;
    [self nextSlide:[_sorter nextTurn:&finished] finished:finished];
}

- (void)nextRow:(id)sender {
   
    if (!(_viewDataDictArr.count))
        return;
    BOOL finished = 0;
    [self nextSlide:[_sorter nextRow:&finished] finished:finished];
}

- (void)play:(id)sender {
    if (!(_viewDataDictArr.count))
        return;
    if (_timer.isValid) {
        [self stopTimer:sender];
    } else {
        [_flowRunButton setTitle:@"暂停演示"];
        NSInteger exec = [UserDefault integerForKey:kFlowExecWay];
        SEL func;
        if (exec == ExecuteWayStep) {
            func = @selector(nextStep:);
        } else {
            func = @selector(nextRow:);
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:[NSUserDefaults.standardUserDefaults doubleForKey:kTimeInterval]  target:self selector:func userInfo:0 repeats:1];
        [_timer fire];

    }
}

///实现时，所有initializer都要调一遍
- (void)restart:(id)sender {
    [self stopTimer:0];
    if (_originDataArr.count <= 1) {
        return;
    }
    [self initializeSorter];
    [self initializeDisplay];
}

- (void)openSettings:(id)sender {
    
    if ([self.splitViewController isFullScreen] || [self.splitViewController canPullHideLeft]) {
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[SettingViewController2 new]];
        nav.preferredContentSize = CGSizeMake(340, 576);
        nav.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popvc = nav.popoverPresentationController;
        popvc.barButtonItem = self.settings;
        popvc.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popvc.backgroundColor = nav.topViewController.view.backgroundColor;
        [self presentViewController:nav animated:1 completion:nil] ;
    } else
        [self pushWithoutBottomBar:[SettingViewController2 new]];
}

//MARK: - 业务衍生函数
- (void)initButtonState:(BOOL)state {
    [_lastStepButton setEnabled:0];
    [self stopTimer:0];
    [self setEnabled:state];
}

- (void)setEnabled:(bool)b {
    [_nextRowButton setEnabled:b];
    [_nextStepButton setEnabled:b];
    [_flowRunButton setEnabled:b];
}
- (void)stopTimer:(id)sender {
    [_timer invalidate];
    [_flowRunButton setTitle:@"自动执行"];
}


/// 展示开始的唯一入口，注意！！！也会被restart调用！！！(此函数调用之前必须调用过initializeSorter！)
- (void)initializeDisplay {
    //MARK: - 执行顺序3
    _viewDataDictArr = [[NSMutableArray alloc] init];
    int arrSize = ((int)(_originDataArr.count));
    
    [self initButtonState:arrSize != 1];
    
    if (arrSize != 0) {
        [_viewDataDictArr addObject:[_sorter initialSortData]];
        _collectionEmptyView.text = @"";
    } else {
        _collectionEmptyView.text = emptyDisplayString;
    }
    [_collection reloadData];
}


///由initializeWithArr调用，对sorter配置
- (void)initializeSorter {
    //MARK: - 执行顺序1.1
    if (_sortType == SortTypeBubble) {
        _sorter = [BubbleSorter new];
    } else if (_sortType == SortTypeInsertion) {
        _sorter = [InsertionSorter new];
    } else if (_sortType == SortTypeSelection) {
        _sorter = [SelectionSorter new];
    } else if (_sortType == SortTypeHeap) {
        _sorter = [HeapSorter new];
    } else if (_sortType == SortTypeFast)
        _sorter = [QuickSorter new];
    
    [_sorter initializeWithArray:_originDataArr order:_sortOrder];
}

- (void)nextSlide:(NSDictionary *)dict finished:(BOOL)finished {
    if (dict) {
        [_viewDataDictArr addObject:dict];
        NSIndexPath *idx = IndexPath_Sec0(_viewDataDictArr.count-1);
        [_collection insertItemsAtIndexPaths:@[idx]];
        [_collection scrollToItemAtIndexPath:[idx indexPathByAddingIndex:1] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:1];
        [_lastStepButton setEnabled:1];
    }
    if (finished) {
        [self setEnabled:0];
        [self stopTimer:0];
    }
}

- (void)updateBackEmptyPositionCX:(CGFloat)x CY:(CGFloat)y {
    [_collectionEmptyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collection).mas_offset(x);
        make.centerY.equalTo(self.collection.mas_centerY).mas_offset(y);
    }];
}

//MARK: - UICollectionViewDelegate & DataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [Config postNotification:ELTextFieldShouldResignNotification message:0];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //MARK: - 执行顺序5
    return _viewDataDictArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ELCollectionViewCell *cell;
    if (_sortType == SortTypeHeap) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ELTreeUnitCell.class) forIndexPath:indexPath];
        
    } else if (_sortType == SortTypeBubble || _sortType == SortTypeSelection){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ELCommonLinearCell.class) forIndexPath:indexPath];
    } else if (_sortType == SortTypeInsertion) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ELInsertionSortCell.class) forIndexPath:indexPath];
    } else if (_sortType == SortTypeFast) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ELRepeatLinearCell.class) forIndexPath:indexPath];
    }
    
    cell.dataDict = _viewDataDictArr[indexPath.item];
    [cell setNeedsDisplay];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_sortType == SortTypeHeap) {
        NSUInteger nodeCount = ((NSArray *)(_viewDataDictArr[indexPath.item][kDataArr])).count;
        if (nodeCount >= 2) {
            _itemSize.height = [Config estimatedSizeThatFitsTree:nodeCount bottom:UnderTreeH].height;
        }
    }
    return _itemSize;
}

///行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (_sortType == SortTypeHeap) {
        return 10;
    }
    return 24;
}


@end
