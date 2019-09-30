//
//  ClassRoomViewController.m
//  EDU
//
//  Created by ryan on 2019/9/20.
//  Copyright © 2019 windbird. All rights reserved.
//

#import "ClassRoomViewController.h"
#import <coobjc.h>
#import "TICManager.h"
#import "UIAlertController+Easier.h"
#import "EDU-Swift.h"
@interface ClassRoomViewController ()

@property(assign, nonatomic) int classId;
@property(assign, nonatomic) RoleType role;
@property(assign, nonatomic, readonly) TICRoleType roleType;
@end

@implementation ClassRoomViewController

+ (instancetype)initWithClassId:(int)classId role:(RoleType) role {
    ClassRoomViewController *viewController = [self new];
    viewController.classId = classId;
    viewController.role = role;
    return viewController;
}

- (TICRoleType)roleType {
    return _role == RoleTypeTeacher ? TIC_ROLE_TYPE_ANCHOR: TIC_ROLE_TYPE_AUDIENCE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self joinClass];
}

- (void)joinClass {
    co_launch(^{
        TICClassroomOption *option = [TICClassroomOption new];
        option.classId = self.classId;
        option.roleType =  self.roleType;
        option.classScene = TIC_CLASS_SCENE_VIDEO_CALL;
        TICResult *result = await([TICHelper.shared joinClassRoomWithOption:option]);
        if(result.isSuccess) {
            NSLog(@"欢迎来到%d直播间", self.classId);
            return;
        }
        NSString *errorMsg = [NSString stringWithFormat:@"进入房间失败%@", result.desc];
        UIAlertController *alertController = [UIAlertController alertControllerWithMessage:errorMsg];
        NSString *action = await([alertController co_presentFrom:self confirmActionTitle:@"退出" cancelActionTitle:@"再试一次"]);
        if([action isEqualToString:@"退出"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self joinClass];
    });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onTICRecvCustomMessage:(NSData *)data fromUserId:(NSString *)fromUserId {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICRecvGroupCustomMessage:(NSData *)data groupId:(NSString *)groupId fromUserId:(NSString *)fromUserId {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICRecvGroupTextMessage:(NSString *)text groupId:(NSString *)groupId fromUserId:(NSString *)fromUserId {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICRecvMessage:(TIMMessage *)message {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICRecvTextMessage:(NSString *)text fromUserId:(NSString *)fromUserId {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICClassroomDestroy {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICMemberJoin:(NSArray *)members {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICMemberQuit:(NSArray *)members {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICSendOfflineRecordInfo:(int)code desc:(NSString *)desc {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICUserAudioAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICUserSubStreamAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICUserVideoAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICForceOffline {
    NSLog(@"%@ %s", [self class] , __func__);
}

- (void)onTICUserSigExpired {
    NSLog(@"%@ %s", [self class] , __func__);
}

@end
