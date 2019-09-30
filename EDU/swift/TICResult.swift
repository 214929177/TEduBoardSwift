//
//  TICResult.swift
//  EDU
//
//  Created by ryan on 2019/9/24.
//  Copyright © 2019 windbird. All rights reserved.
//

import Foundation

/// TIC相关接口调用结果
public class TICResult: NSObject {

    private var _code: Int32
    public var desc: String?
    
    /// TIC相关接口调用错误码
    /// - 创建课堂：
    ///   - 10021   教室已被他人创建
    ///   - 10025   教室已创建
    /// - 销毁教室：
    ///   - 10010   教室不存在
    ///   - 10007   非创建没有权限销毁教室
    /// - 进入教室：
    ///   - 10015   教室不存在
    ///   - 10013   已在教室中
    public var code: Int32 {
        return _code
    }
    
    public var isSuccess: Bool {
        return _code == 0
    }
    
    public var isClassCreated: Bool {
        return isSuccess || _code == 10021 || code == 10025
    }
    
    public var hasJoinedClass: Bool {
        return isSuccess || _code == 10013
    }
    
    private init(code: Int32) {
        self._code = code
    }
    
    public class func result(WithCode code: Int32, desc: String?) -> TICResult {
        let result = TICResult(code: code)
        result.desc = desc
        return result
    }
}
