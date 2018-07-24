//
//  SwitchCell2.m
//  DS_playgound
//
//  Created by Eric on 2018/7/12.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "SwitchCell2.h"

@implementation SwitchCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _switcher = [[UISwitch alloc] init];
        [self setAccessoryView:_switcher];
    }
    return self;
    
}

- (void)addTarget:(id)target action:(nonnull SEL)action {
    [_switcher addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

@end

