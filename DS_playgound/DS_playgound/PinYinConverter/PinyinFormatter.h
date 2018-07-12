
//  Created by kimziv on 13-9-14.
//

#import "HanyuPinyinOutputFormat.h"

@interface PinyinFormatter : NSObject {
    
}

+ (NSString *)formatHanyuPinyinWithNSString:(NSString *)pinyinStr
                withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat;
+ (NSString *)convertToneNumber2ToneMarkWithNSString:(NSString *)pinyinStr;

 
@end


