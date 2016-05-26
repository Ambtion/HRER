//
//  HRAddressBookManager.h
//  HRER
//
//  Created by quke on 16/5/26.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


typedef void (^CallBack)(NSArray * resultList, ABAuthorizationStatus status);

@interface HRAddressBookManager : NSObject
+ (void)readAllPersonAddressWithCallBack:(CallBack)callBack;
@end
