//
//  WebCatLogin.m
//  HRER
//
//  Created by quke on 16/5/24.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "WebCatLogin.h"
#import "WXApi.h"
#import "WXApiObject.h"

@implementation WebCatLogin

- (void)loginWithWebcat
{
    
}


-(void)sendAuthRequest
{
    
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123";
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}


- (void)onResp
{

}
@end
