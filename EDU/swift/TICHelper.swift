//
//  TICHelper.swift
//  EDU
//
//  Created by ryan on 2019/9/24.
//  Copyright © 2019 windbird. All rights reserved.
//

import Foundation
import coswift

public class TICHelper: NSObject {
    
    public static let shared = TICHelper()
    private var _isSDKInit = false
    
    public var isSDKInit: Bool {
        return _isSDKInit
    }
    
    public func initSDK(appId: Int32) -> Promise<TICResult> {
        let promise = Promise<TICResult>()
        TICManager.sharedInstance()?.`init`(appId, callback: { (module, code, desc) in
            let result = TICResult.result(WithCode: code, desc: desc)
            self._isSDKInit = result.isSuccess
            promise.fulfill(value: result)
        })
        return promise
    }
    
    /// 创建教室
    /// - Parameter classId: 教室ID
    /// - Parameter classScene: TICClassScene
    /// - Returns: Promise => CITResult
    public func createClassRoom(withClassId classId: UInt32, classScene: TICClassScene) -> Promise<TICResult> {
        let promise = Promise<TICResult>()
        TICManager.sharedInstance()?.createClassroom(Int32(classId), classScene: classScene, callback: { (module, code, desc) in
            let result = TICResult.result(WithCode: code, desc: desc)
            promise.fulfill(value: result)
        })
        return promise
    }
    
    /// 进入教室
    /// - Parameter option: TICClassroomOption
    /// - Returns: Promise => CITResult
    public func joinClassRoom(option: TICClassroomOption) -> Promise<TICResult> {
        let promise = Promise<TICResult>()
        TICManager.sharedInstance()?.joinClassroom(option, callback: { (module, code, desc) in
            let result = TICResult.result(WithCode: code, desc: desc)
            promise.fulfill(value: result)
        })
        return promise
    }
    
    
    
}
