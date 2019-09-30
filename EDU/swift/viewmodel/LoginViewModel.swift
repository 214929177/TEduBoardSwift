//
//  LoginViewModel.swift
//  EDU
//
//  Created by ryan on 2019/9/24.
//  Copyright © 2019 windbird. All rights reserved.
//

import Foundation
import RxSwift
import coswift

public class LoginViewModel {
    
    private var _userId: String?
    private var _classId: UInt32?
    
    public var userId: String? {
        return _userId
    }
    
    public var classId: UInt32? {
        return _classId
    }
    
    func isUserIdObservable(_ userIdObservable:Observable<String?>) -> Observable<Bool> {
        return userIdObservable.map { userId -> Bool in
            self._userId = userId
            if let userId = userId {
                return userId.count > 0
            }
            return false
        }
    }
    
    func isClassIdObservable(_ classIdObservable: Observable<String?>) -> Observable<Bool> {
        return classIdObservable.map { classId -> Bool in
            if let classId = classId {
                let classNO = UInt32(classId)
                self._classId = classNO
                return classId.count > 0 && classNO != nil
            }
            return false
        }
    }
    
    func isAllValidate(_ userIdObservable:Observable<String?>, _ classIdObservable: Observable<String?> ) -> Observable<Bool> {
        let isUserIdObs = isUserIdObservable(userIdObservable)
         let isClassIdObs = isClassIdObservable(classIdObservable)
        return Observable.combineLatest(isUserIdObs, isClassIdObs).map { (isUser, isClassId) -> Bool in
            return isUser && isClassId
        }
    }
    
    func createClassRoomOption(classId: UInt32) -> TICClassroomOption {
        let classRoomOption = TICClassroomOption()
        classRoomOption.classId = classId
        classRoomOption.classScene = TICClassScene.CLASS_SCENE_VIDEO_CALL
        classRoomOption.roleType = TICRoleType.ROLE_TYPE_AUDIENCE
        return classRoomOption
    }
    
    func login(userId: String, classId: UInt32) -> Single<(success:Bool, desc:String)> {
        return Single<(success:Bool, desc:String)>.create { emitter -> Disposable in
            co_launch {
                let userSig = GenerateTestUserSig.genTestUserSig(userId)
                let user = User(userId: userId)
                let loginResult = try! await(promise: user.login(userSig: userSig))
                if case .fulfilled(let result) = loginResult {
                    print(userId, "登录成功", result.isSuccess)
                    if !result.isSuccess {
                        emitter(.success((false, "登录失败，请稍候再试")))
                        return
                    }
                    let roomOption = self.createClassRoomOption(classId: classId)
                    let createRoomResult = try! await(promise: TICHelper.shared.createClassRoom(withClassId: classId, classScene: TICClassScene.CLASS_SCENE_VIDEO_CALL))
                    if case .fulfilled(let result) = createRoomResult {
                        print(userId, "创建教室成功:", result.isSuccess)
                        if !result.isClassCreated {
                            emitter(.success((false, "教室教室创建失败")))
                            return
                        }
                    }
                    let joinRoomResult = try! await(promise: TICHelper.shared.joinClassRoom(option: roomOption))
                    if case .fulfilled(let result) = joinRoomResult {
                        print(userId, "进入教室成功", result.isSuccess)
                        if result.isSuccess {
                            emitter(.success((true, String(format: "欢迎来到%d教室", classId))))
                            return
                        }
                        if result.code == 10015 {
                            emitter(.success((false, "教室不存在")))
                            return
                        }
                        emitter(.success((false, String(format: "暂时不能进入%d,教室,稍候再试", classId))))
                    }
                } else {
                    print("请求出错了？？？")
                }
            }
            return Disposables.create()
        }
    }
}

