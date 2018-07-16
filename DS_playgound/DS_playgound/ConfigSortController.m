//
//  ConfigViewController.m
//  SortReveal
//
//  Created by Eric on 2018/4/12.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ConfigSortController.h"
#import "SelectOrderController.h"
#import "DataTransmitter.h"
#import "UIImage+operations.h"
#import "UIView+frameProperty.h"
#import "UIViewController+funcs.h"
#import "UIButton+init.h"
#import "UILabel+init.h"
#import "SortDescriptionController.h"
#import <Masonry/Masonry.h>


@interface ConfigSortController () <UITextViewDelegate, DataTransmitter>

@property (strong, nonatomic) UILabel *sortNameLabel;
@property (strong, nonatomic) UITextView *inputField;
@property (strong, nonatomic) UIButton *selectOrder;
@property (strong, nonatomic) UIButton *startShow;
@property (strong, nonatomic) UIBarButtonItem *resumeShow;
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UIView *selectOrderContainerView;

@property (nonatomic, copy) NSString *sortName;

@property (strong, nonatomic) UIViewController *anotherRootVC;

@property (strong, nonatomic) UINavigationController *sortingNavVC;

@property (assign) SortOrder sortOrder;
@property (assign) SortType sortType;

@end

#define label1Text @"输入要演示的排序内容。"
#define label2Text @"以空格分隔每个元素。"

@implementation ConfigSortController

//MARK: - Life Circle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.splitViewController.view.width == self.view.width && _sortingNavVC) {
        self.navigationItem.rightBarButtonItems = @[_resumeShow];
    } else {
        self.navigationItem.rightBarButtonItems = @[];
    }
    [self.navigationController.navigationBar setTintColor:UIColor.blackColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
 
    if (IPHONE) {
        if ([self isDevicePortait]) {
            [self updateConstraintsStatus:0];
       
        } else {
            if ([_inputField isFirstResponder] && !IPHONE6P) {
                [self updateConstraintsStatus:2];
            } else {
                [self updateConstraintsStatus:1];
            }
            if (IPHONE6P) {
                [_inputField resignFirstResponder];
                if (_sortingNavVC && self.splitViewController.view.width == self.view.width) {
                    self.navigationItem.rightBarButtonItem = _resumeShow;
                } else
                    self.navigationItem.rightBarButtonItem = nil;
            }
        }
    } else {
        if (![self isDevicePortait] && self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryOverlay && [_inputField isFirstResponder])
            [self updateConstraintsStatus:1];
        else {
            [self updateConstraintsStatus:0];
        }
    }
    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImage *img = [UIImage pushImage];
    self.navigationItem.title = @"配置排序";
    
    //left back item
   
    UIButton * _backButton = [UIButton customBackBarButtonItemWithTitle:@"返回" target:self action:@selector(dismiss:)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    
    bool oldDevice = SystemVersion < 9 || IPHONE4;
    self.navigationItem.leftBarButtonItems = oldDevice ? @[[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)]] : @[backItem];

    //right resume item
    UIButton *butt = [UIButton buttonWithTitle:@"继续演示" fontSize:17 textColor:UIColor.blackColor target:self action:@selector(resumeDisplay:) image:img];
    [butt setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [butt setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
    [butt setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    _resumeShow = oldDevice ? [[UIBarButtonItem alloc] initWithTitle:@"继续演示" style:UIBarButtonItemStylePlain target:self action:@selector(resumeDisplay:)] : [[UIBarButtonItem alloc] initWithCustomView:butt];

    //three labels
    _sortNameLabel = [UILabel labelWithCentredTitle:0 fontSize:(IPAD ? 29 : 27)];
    _label1 = [UILabel labelWithCentredTitle:label1Text fontSize:18];
    _label2 = [UILabel labelWithCentredTitle:label2Text fontSize:18];
    [self.view addSubview:_sortNameLabel];
    [self.view addSubview:_label1];
    [self.view addSubview:_label2];
    [_sortNameLabel setText:_sortName];
    [_sortNameLabel setUserInteractionEnabled:1];
    [_sortNameLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDescription)]];

    UIButton *butt2 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [butt2 addTarget:self action:@selector(showDescription) forControlEvents:UIControlEventTouchUpInside];
    
    //start show
    _startShow = [UIButton buttonWithTitle:@"开始演示" fontSize:23 textColor:UIColor.blackColor target:self action:@selector(startDisplay:) image:img];
    [_startShow setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_startShow setImageEdgeInsets:UIEdgeInsetsMake(0, 125, 0, 0)];
    [self.view addSubview:_startShow];
    
    //sort order
    _selectOrderContainerView = [[UIView alloc] init];
    [_selectOrderContainerView setBackgroundColor:UIColor.clearColor];
    [self.view addSubview:_selectOrderContainerView];
    UILabel *wayDec = [UILabel labelWithCentredTitle:@"排序方式" fontSize:20];
    [_selectOrderContainerView addSubview:wayDec];
    _selectOrder = [UIButton buttonWithTitle:@"自动推断" fontSize:20 textColor:systemBlue target:self action:@selector(selectOrder:) image:img];
    [_selectOrder setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [_selectOrder setImageEdgeInsets:UIEdgeInsetsMake(0, 90, 0, 0)];
    [_selectOrderContainerView addSubview:_selectOrder];
    
    //input field
    _inputField = [[UITextView alloc] init];
    [_inputField setFont:[UIFont systemFontOfSize:22]];
    [[_inputField layer] setCornerRadius:4];
    _inputField.clipsToBounds = 1;
    [_inputField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_inputField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _inputField.returnKeyType = UIReturnKeyDone;
    [_inputField setContentInset:UIEdgeInsetsMake(0, 8, 0, 8.5)];
    _inputField.delegate = self;
    [self.view addSubview:_inputField];
    
    [_sortNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(36);
        make.top.equalTo(self.view).offset(64+[Config v_pad:44 plus:28 p:26 min:24]);
    }];
    [_sortNameLabel addSubview:butt2];
    [butt2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sortNameLabel);
        make.centerX.equalTo(self.sortNameLabel).offset(84);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_startShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset([Config v_pad:58 plus:34 p:30 min:24]);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.sortNameLabel.mas_bottom).offset([Config v_pad:45 plus:36 p:32 min:25]);;
    }];
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.label1.mas_bottom).offset(3);
    }];
    [_selectOrderContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.startShow.mas_top).inset([Config v_pad:65 plus:40 p:36 min:32]);
        make.size.mas_equalTo(CGSizeMake(240, 61));
    }];
    [wayDec mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.selectOrderContainerView);
        make.centerY.equalTo(self.selectOrderContainerView);
        make.size.mas_equalTo(CGSizeMake(126, 55));
    }];
    [_selectOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectOrderContainerView);
        make.right.equalTo(self.selectOrderContainerView).inset(14);
        make.size.mas_equalTo(CGSizeMake(114, 55));
        
    }];
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).inset(40);
        make.top.equalTo(self.label1.mas_bottom).offset(24 + (IPAD ? 29 : 24));
        make.bottom.equalTo(self.selectOrderContainerView.mas_top).inset(IPAD ? 29 : 25);
    }];
    
    //other initializers
    [Config addObserver:self selector:@selector(resignResponder) notiName:ELTextFieldShouldResignNotification];
    
    if (![UserDefault boolForKey:kFirstOpened]) {
        [Config saveDouble:1 forKey:kFirstOpened];
        [Config saveDouble:1 forKey:kNumericCompare];
    }
    _sortOrder = SortOrderAutomatic;
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
}

//MARK: - Update Constraints
///只有三种状态 - 0: 所有竖直情况正常 1: 手机尺寸横着正常 2: 手机尺寸横着有键盘
- (void)updateConstraintsStatus:(int)status {
    if (status == 0) {
        if (IPHONE && !IPHONE6P) {
            _label1.text = label1Text;
            _label2.text = label2Text;
        }
        
        [self updateOrderBott:[Config v_pad:65 plus:40 p:36 min:32] startBott:[Config v_pad:58 plus:36 p:30 min:24]];
        [self updateLabelsNameLabelTop:64+[Config v_pad:44 plus:30 p:26 min:24] height:36 label1Top:[Config v_pad:45 plus:36 p:32 min:25] label1H:24 label2H:21];
        [self updateTextViewLeft:IPAD ? 50 : 40 top:(IPAD ? 29 : 24) bottom:IPAD ? 29 : 25];
    } else if (status == 1) {
        if (IPHONE) {
            if (IPHONE6P) {
                [self updateLabelsNameLabelTop:50 height:33 label1Top:3.5 label1H:15 label2H:15];
                [self updateOrderBott:-13 startBott:7];
                [self updateTextViewLeft:47 top:4 bottom:-4];
            } else {
                _label1.text = [label1Text stringByAppendingString:label2Text];
                _label2.text = @"";
                [self updateLabelsNameLabelTop:37 height:36 label1Top:3 label1H:24 label2H:0];
                [self updateTextViewLeft:95 top:-12 bottom:-4];
                [self updateOrderBott:-15 startBott:IPhoneX ? 10 : 6.5];
            }
            
        } else {
            [self updateLabelsNameLabelTop:70 height:36 label1Top:1 label1H:24 label2H:21];
            [self updateOrderBott:-15 startBott:6.5];
            [self updateTextViewLeft:60 top:7 bottom:-4];
        }
    } else if (status == 2) {
        
        if (IPHONE6 || IPhoneX) {
            [self updateLabelsNameLabelTop:8 height:0 label1Top:34 label1H:24 label2H:0];
            [self updateTextViewLeft:95 top:-14 bottom:-4];
        } else {
            [self updateLabelsNameLabelTop:8 height:0 label1Top:8 label1H:0 label2H:0];
            [self updateTextViewLeft:80 top:8 bottom:-4];
        }
    }
}

- (void)updateConstraintsStatus:(int)status animated:(BOOL)animated {
    
    if (animated) {
        [UIView animateWithDuration:0.28 animations:^{
            [self updateConstraintsStatus:status];
        }];
    } else
        [self updateConstraintsStatus:status];
    
}

- (void)updateLabelsNameLabelTop:(CGFloat)y1 height:(CGFloat)h0 label1Top:(CGFloat)y2 label1H:(CGFloat)h1 label2H:(CGFloat)h2 {
    [_sortNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(y1);
        make.height.mas_equalTo(h0);
    }];
    [_label1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sortNameLabel.mas_bottom).offset(y2);
        make.height.mas_equalTo(h1);
    }];
    [_label2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h2);
    }];
}

- (void)updateOrderBott:(CGFloat)y3 startBott:(CGFloat)y4 {
    [_selectOrderContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.startShow.mas_top).inset(y3);
    }];
    
    [_startShow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset(y4);
    }];
    
}

///left 40-80
- (void)updateTextViewLeft:(CGFloat)l1 top:(CGFloat)y1 bottom:(CGFloat)y2 {
    [_inputField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label1.mas_bottom).offset(24 + y1);
        make.bottom.equalTo(self.selectOrderContainerView.mas_top).inset(y2);
        make.left.equalTo(self.view).offset(l1);
        make.right.equalTo(self.view).inset(l1);
    }];
}


//MARK: - 点击各个控件事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:1];
}

- (void)showDescription {
    SortDescriptionController *desc = [[SortDescriptionController alloc] initWithTitle:_sortName sortType:_sortType];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:desc];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    nav.preferredContentSize = CGSizeMake(ScreenW-100, ScreenH-60);
    [self presentViewController:nav animated:1 completion:nil] ;
}

- (void)dismiss:(id)sender {
    [self.view.window setRootViewController:_anotherRootVC];
}

- (void)selectOrder:(id)sender {
    [_inputField endEditing:1];
    SelectOrderController *selectVC = [[SelectOrderController alloc] init];
    selectVC.delegate = self;
    [self.navigationController pushViewController:selectVC animated:1];
    
}

- (void)resumeDisplay:(id)sender {
    [self showDetailVC:_sortingNavVC isNav:1];
}

- (void)startDisplay:(id)sender {
 
    NSMutableArray *inputData = [self inputArr];
    NSArray *errorMsg = [self guardSortOrderWithInputData:inputData];
    if (errorMsg) {
        if (errorMsg.count == 2) {
            [self presentAlertWithCancelAndConfirm:@"提示" message:errorMsg[0] Action:^() {
                [self transmitData:@[@30, @"自动推断"] withIdentifier:0];
                [self startDisplayWithoutError:inputData];
            }];
        } else if (errorMsg.count == 1) {
            [self presentTip:@"提示" message:errorMsg[0] Action:^() {
                [self.inputField becomeFirstResponder];
            }];
        }
        return;
    }
    [self startDisplayWithoutError:inputData];
}

//MARK: - 业务衍生函数
- (void)startDisplayWithoutError:(NSMutableArray *)inputData {
    if (!_sortingNavVC) { //直接正常display开始
        if (!inputData.count)
            return;
        UIViewController *svc = [[SortingViewController alloc] initWithArr:inputData sortType:_sortType sortOrder:_sortOrder];
        self.sortingNavVC = [self showDetailVC:svc isNav:0];
        
    } else {
        [_sortingNavVC.viewControllers[0] stopTimer:0];
        NSString *msg = @"有演示中的排序。要开始新的排序吗";
        [self presentAlertWithCancelAndConfirm:@"提示" message:msg Action:^() {
            if (!inputData.count) {
                [self showDetailVC:[[SortingViewController alloc] init] isNav:0];
                self.sortingNavVC = 0;
            } else {
                UIViewController *svc = [[SortingViewController alloc] initWithArr:inputData sortType:self.sortType sortOrder:self.sortOrder];
               self.sortingNavVC = [self showDetailVC:svc isNav:0];
            }
        }];
       
    }
    
    //    TODO: - hide
    //    if ([self.splitViewController canPullHideLeft]) {}
}

- (NSArray *)guardSortOrderWithInputData:(NSArray *)inputData {
    if (inputData.count > 15)
        return @[@"您的屏幕大小可能不适合15个以上元素演示"];
    if (_sortOrder == SortOrderNumberA || _sortOrder == SortOrderNumberD) {
        BOOL e = 0;
        for (NSString *i in inputData) {
            [Config doubleValue:i error:&e];
            if (e) {
                return @[@"选择的排序方式与输入内容不符。要自动推断排序方式并继续吗", @" "];
            }
        }
    }
    return 0;
}
- (void)resignResponder {
    [_inputField resignFirstResponder];
}

- (NSMutableArray *)inputArr {
    NSMutableArray *inputData = [[_inputField.text componentsSeparatedByString:@" "] mutableCopy];
    if ([inputData containsObject:@""]) {
        [inputData removeObject:@""];
    }
    return inputData;
}

///展示detailVC，detailVC业务上一定是NavVC，但为了方便，这里vc如果是普通vc，则包装成navVC，最后返回detailNav
- (UINavigationController *)showDetailVC:(UIViewController *)vc isNav:(BOOL)isNavVC {
    UINavigationController *n;
    if (isNavVC) {
        n = (UINavigationController *)vc;
    } else {
        n = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    [n setToolbarHidden:0];
    [_inputField resignFirstResponder];
    [self.splitViewController showDetailViewController:n sender:0];
    return n;
}


//MARK: - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (![textView.text isEqualToString:@""] ) {
        DISPATCH_AT_ONCE(^{
            UITextPosition *end = [textView endOfDocument];
            UITextPosition *start = [textView beginningOfDocument];
            textView.selectedTextRange = [textView textRangeFromPosition:start toPosition:end];
        });
        
    }
    
    if (![self isDevicePortait]) {
        if (IPAD || IPHONE6P) {
            if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryOverlay) {
                [self updateConstraintsStatus:1 animated:1];
            }
        } else {
            [self updateConstraintsStatus:2 animated:1];
        }
    }
    return 1;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (IPHONE && ![self isDevicePortait]) {
        [self updateConstraintsStatus:1 animated:1];
    } else if (IPAD) {
        [self updateConstraintsStatus:0 animated:1];
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqual: @""] && [text characterAtIndex:0] == '\n') {
        [textView endEditing:1];
        return 0;
    }
    return 1;
}

//MARK: - UISplitViewDelegate
- (void)collapseSecondaryViewController:(UIViewController *)secondaryViewController forSplitViewController:(UISplitViewController *)splitViewController {
    [self.navigationController pushViewController:secondaryViewController animated:1];
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return 0;
}

//MARK: - 构造、析构
- (instancetype)initWithSortType:(SortType)type anotherRoot:(UIViewController *)rootvc {
    self = [super init];
    if (self) {
        _sortType = type;
        NSArray *names = [Config getArrayDataFromFile:SortNameFile];
        _sortName = names[type];
        _anotherRootVC = rootvc;
    }
    return self;
}
- (void)dealloc {
    [Config removeObserver:self];
}
 
//MARK: - SimpleTransferDelegate
///NSArray, 0: order number 1: name
- (void)transmitData:(id)data withIdentifier:(nullable NSString *)identitifier {
    NSArray *a = data;
    _sortOrder = ((NSNumber *)a[0]).longValue;
    [_selectOrder setTitle:a[1] forState:UIControlStateNormal];
}




@end
