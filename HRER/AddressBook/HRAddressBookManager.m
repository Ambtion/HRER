//
//  HRAddressBookManager.m
//  HRER
//
//  Created by quke on 16/5/26.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRAddressBookManager.h"

@implementation HRAddressBookManager
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

+ (void)readAllPersonAddressWithCallBack:(CallBack)callBack

{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusNotDetermined: {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook WithCallBack:callBack];
            });
            break;
        }
            
        case kABAuthorizationStatusRestricted: {
            if (callBack) {
                callBack(nil,kABAuthorizationStatusRestricted);
            }
            break;
        }
        case kABAuthorizationStatusDenied: {
            //用户拒绝访问通讯录
            if (callBack) {
                callBack(nil,kABAuthorizationStatusDenied);
            }
            break;
        }
        case kABAuthorizationStatusAuthorized: {
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            [self copyAddressBook:addressBook WithCallBack:callBack];
            break;
        }
    }
}

+ (void)copyAddressBook:(ABAddressBookRef)addressBook WithCallBack:(CallBack)callBack
{
    
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSMutableArray * personList = [NSMutableArray arrayWithCapacity:0];
    
    for ( int i = 0; i < numberOfPeople; i++){
        
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);

        //姓
        NSString * name = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        //名
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));

        if (firstName) {
            name = [NSString stringWithFormat:@"%@%@",name,firstName];
        }

        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSMutableArray * phoneNumbers = [NSMutableArray arrayWithCapacity:0];
        
        for (int k = 0; k< ABMultiValueGetCount(phone); k++)
        {

            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            personPhone = [self correctPhoneNumber:personPhone];
            if (personPhone.length) {
                [phoneNumbers addObject:personPhone];
            }
        }
        
        if (name.length && phoneNumbers.count) {
            NSDictionary * dic = @{
                                   @"name":name,
                                   @"photoList":phoneNumbers
                                   };
            [personList addObject:dic];
        }
    }
    if (callBack) {
        callBack(personList,ABAddressBookGetAuthorizationStatus());
    }
}

+ (NSString *)correctPhoneNumber:(NSString *)number
{
    //去除空格
    number = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    number =  [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"+" withString:@""];
    //去除86
    if([number hasPrefix:@"86"])
        number = [number substringFromIndex:2];

    return number;
}

#pragma clang disgnostic pop

@end

