//
//  ClassRoom.swift
//  EDU
//
//  Created by ryan on 2019/9/24.
//  Copyright © 2019 windbird. All rights reserved.
//

import Foundation

@objc public class ClassRoom : NSObject {
    
    private var _classId: UInt32
    public var classId: UInt32 {
        return _classId
    }
    
    @objc public class func isValidateClassId(_ classId: String?) -> Bool {
        if let length = classId?.count, length > 0, let _ = Int(classId!) {
            return true
        }
        return false
    }
    
    @objc public init(classId: UInt32) {
        self._classId = classId
    }
}
