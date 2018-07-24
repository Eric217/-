//
//  Definition.h
//  SortReveal
//
//  Created by Eric on 2018/5/13.
//  Copyright © 2018 Eric. All rights reserved.
//

#ifndef Definition_h
#define Definition_h

//MARK: - COMMON

#define ScreenW UIScreen.mainScreen.bounds.size.width
#define ScreenH UIScreen.mainScreen.bounds.size.height

#define IPHONE4  (ScreenH == 480  || ScreenW == 480 )
#define IPHONE5  (ScreenH == 568  || ScreenW == 568 )
#define IPHONE6  (ScreenH == 667  || ScreenW == 667 )
#define IPHONE6P (ScreenH == 736  || ScreenW == 736 )
#define IPhoneX  (ScreenH == 812  || ScreenW == 812 )
#define IPADPro  (ScreenH == 1366 || ScreenW == 1366)

#define UserDefault   NSUserDefaults.standardUserDefaults
#define systemBlue    [UIColor colorWithRed:0 green:111.0/255 blue:1 alpha:1]
#define IPAD (UIDevice.currentDevice.userInterfaceIdiom==UIUserInterfaceIdiomPad)
#define IPHONE        (!IPAD)
#define SystemVersion [UIDevice currentDevice].systemVersion.doubleValue


// FUNC - Common And Simple
#define DISPATCH_AT_ONCE(block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ block(); })

#define String(Int) [NSString stringWithFormat:@"%d", Int]
#define StringOfChar(Char) [NSString stringWithFormat:@"%c", Char]
#define StringOfCGF(CGF) [NSString stringWithFormat:@"%f", CGF];

#define IndexPath_Sec0(Item) [NSIndexPath indexPathForItem:Item inSection:0]
#define IndexPath(Item, Section) [NSIndexPath indexPathForItem:Item inSection:Section]

#define IOS11AVAIL(block) if (@available(iOS 11.0, *)) { block(); }

#define ConstChar_(str) [str cStringUsingEncoding:kCFStringEncodingUTF8]
#define putsNS(nsstr) puts(ConstChar_(nsstr))

#define TRIM(str, charSet) [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:charSet]]

//MARK: - PROJECT

#define kFirstOpened        @"fsfwsewopo"

#define kStatus             @"status"
#define kMessage            @"msg"

#define kSkipNullStep       @"skip n ull"
#define kTimeInterval       @"dawfew a f"
#define kFlowExecWay        @"greswe qqa"
#define kNumericCompare     @"Numsfg dsa"
#define kPreferredHeap      @"prefd heap"
#define kAutomaticOrderASD  @"fegad sase"
#define kIgnoringCases      @"imng fades"

#define kDataArr            @"da  a A rr"
#define kStackArr           @"sta cjearr"
#define kColorArr           @"col  orArr"
#define kPositionArr        @"pos insArr"
#define kTitleArr           @"tis dArray"
#define kCommingText        @"wsg fws ew"
#define kHistoryPosition    @"grs aereed"

#define kSortOrder          @"sort__Type"
#define kSortType           @"sort_Order"
#define SortNameFile        @"SortNames.plist"
#define SortOrderFile       @"SortOrder.plist"
#define TravesalFile        @"Travesals.plist"
#define GraphAlgoFile       @"GraphAlgorithm.plist"

#define UnitSizeDefault     44
#define TreeFontDefault     24
#define SepaWidtDefault     1.52*UnitSizeDefault
#define LineWidthDefault    2


//Dependent
#define UnderTreeH          68*UnitSize/UnitSizeDefault
#define EmptyNode           @"e符†"

#define LetterFont          @"TimesNewRomanPSMT"
#define LetterFont_B        @"TimesNewRomanPS-BoldMT"
#define LetterFont_I        @"TimesNewRomanPS-ItalicMT"
#define LetterFont_BI       @"TimesNewRoman-BoldItalicMT"
#define PromptText          @"提示"


typedef NS_ENUM(NSUInteger, SortType) {
    SortTypeBubble = 0,
    SortTypeInsertion = 2,
    SortTypeHeap = 3,
    SortTypeSelection = 1,
    SortTypeFast = 4,
};

///section * 10 + row = raw value
typedef NS_ENUM(NSUInteger, SortOrder) {
    SortOrderNumberA = 0,
    SortOrderNumberD = 1,
    SortOrderCharacA = 10,
    SortOrderCharacD = 11,
    SortOrderDictioA = 20,
    SortOrderDictioD = 21,
    SortOrderAutomatic = 30,
};

typedef NS_ENUM(NSUInteger, ScreenMode) {
    
        ScreenModeFloatingOrThirth = 0,
    //    ScreenModeHalfIpad,
    //    ScreenModeTwoThirth,
    //    ScreenModeFullScreen,
    //    ScreenModeCanPullHideLeft,
    //    ScreenModeCanShowBoth,
    //    ScreenModeNoSplit,
};

#define SingleStep          @"单步执行"
#define GroupStep           @"单组跳过"
typedef NS_ENUM(NSUInteger, ExecuteWay) {
    ExecuteWayStep = 0,
    ExecuteWayGroup = 1,
};

#define MinHeapSorter @"最小堆"
#define MaxHeapSorter @"最大堆"
#define BothHeap      @"自动"
typedef NS_ENUM(NSUInteger, PreferredHeap) {
    PreferMinHeap = 1,
    PreferMaxHeap = 2,
    PreferBoth = 0,
};

#define TravesalPre1  1
typedef NS_ENUM(NSUInteger, TravesalType) {
    TravesalPre = 0,
    TravesalIn,
    TravesalPost,
    TravesalLevel
};

#endif /* Definition_h */
