//
//  EHUserCodeSendService.h
//  EduHeader
//
//  Created by Hao King on 15/10/15.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"

@interface EHUserCodeSendService : HTBaseService

- (void)requestCodeWithPhone:(NSString *)phone block:(ServiceCallBackBlock)block;

@end
