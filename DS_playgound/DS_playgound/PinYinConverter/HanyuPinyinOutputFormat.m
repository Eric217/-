//
//  SortReveal
//
//  Created by Eric on 2018/4/18.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "HanyuPinyinOutputFormat.h"

@implementation HanyuPinyinOutputFormat

+ (HanyuPinyinOutputFormat *)commonFormat {
    HanyuPinyinOutputFormat *f = [[HanyuPinyinOutputFormat alloc] init];
    f.caseType = CaseTypeLowercase;
    f.vCharType = VCharTypeWithV;
    f.toneType = ToneTypeWithoutTone;
    return f;
}

+ (HanyuPinyinOutputFormat *)formatWithVCharType:(VCharType)vt caseType:(CaseType)ct toneType:(ToneType)tt {
    HanyuPinyinOutputFormat *f = [[HanyuPinyinOutputFormat alloc] init];
    f.caseType = ct;
    f.vCharType = vt;
    f.toneType = tt;
    return f;
}

- (id)initWithVCharType:(VCharType)vt caseType:(CaseType)ct toneType:(ToneType)tt {
  if (self = [super init]) {
      _caseType = ct;
      _vCharType = vt;
      _toneType = tt;
  }
  return self;
}

@end
