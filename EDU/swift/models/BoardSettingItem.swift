//
//  BoardSettingItem.swift
//  EDU
//
//  Created by ryan on 2019/9/26.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit

/// 白板设置选项
public class BoardSettingItem {
    
    private(set) public var iconName: String
    private(set) public var type: BoardSettingType
    public var diableIconName: String?
    public var isEnable = false
    public var userEnable = true
    public var allEnable: Bool { return isEnable && userEnable }
    
    public init(iconName: String, type: BoardSettingType) {
        self.iconName = iconName
        self.type = type
    }
}
