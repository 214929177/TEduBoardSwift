//
//  ClassRoomViewController.h
//  EDU
//
//  Created by ryan on 2019/9/20.
//  Copyright © 2019 windbird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TICManager.h"
#import "EDU-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassRoomViewController : UIViewController<TICMessageListener, TICEventListener, TICStatusListener, TIMConnListener>

+ (instancetype)initWithClassId:(int)classId role:(RoleType) role ;

@end

NS_ASSUME_NONNULL_END
