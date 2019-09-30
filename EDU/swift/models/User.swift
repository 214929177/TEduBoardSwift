//
//  User.swift
//  EDU
//
//  Created by ryan on 2019/9/24.
//  Copyright © 2019 windbird. All rights reserved.
//

import Foundation
import coswift

public class User: NSObject {
    
    private var _userId: String
    public var userId: String { return _userId}

    public init(userId: String) {
        self._userId = userId
    }

    /// 用户登录
    /// - Parameter userSig: [userSig计算方式](https://cloud.tencent.com/document/product/647/17275)
    public func login(userSig: String) -> Promise<TICResult> {
        let promise = Promise<TICResult>()
        TICManager.sharedInstance()?.login(self._userId, userSig: userSig, callback: { (module, code, desc) in
            let result = TICResult.result(WithCode: code, desc: desc)
            promise.fulfill(value: result)
        })
        return promise
    }
}
