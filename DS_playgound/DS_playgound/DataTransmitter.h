//
//  Protocols.h
//  SortReveal
//
//  Created by Eric on 2018/4/16.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataTransmitter <NSObject>

///用identifier 判断是否是要传输的目的对象
- (void)transmitData:(id _Nullable )data withIdentifier:(nullable NSString *)identitifier;

@end




