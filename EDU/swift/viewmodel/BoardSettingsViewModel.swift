//
//  BoardSettingsViewModel.swift
//  EDU
//
//  Created by ryan on 2019/9/27.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit
import Darwin

class BoardSettingsViewModel {
    
    private(set) public lazy var cameraItem = BoardSettingItem(iconName: "camera", type: .camera)
    private(set) public lazy var switchCameraItem = BoardSettingItem(iconName: "switch_camera", type: .switchCamera)
    private(set) public lazy var microItem = BoardSettingItem(iconName: "mocro", type: .micro)
    private(set) public lazy var speakerItem = BoardSettingItem(iconName: "load_speaker", type: .speaker)
    
    private(set) public lazy var brushItem = BoardSettingItem(iconName: "brush", type: .brush)
    private(set) public lazy var textItem = BoardSettingItem(iconName: "text", type: .text)
    private(set) public lazy var lineItem = BoardSettingItem(iconName: "line", type: .line)
    private(set) public lazy var circleItem = BoardSettingItem(iconName: "oval", type: .circle)
    private(set) public lazy var retangleItem = BoardSettingItem(iconName: "rectangle", type: .rectangle)
    private(set) public lazy var fillCircleItem = BoardSettingItem(iconName: "fill_circle", type: .fillCircle)
    private(set) public lazy var fillRectangleItem = BoardSettingItem(iconName: "fill_rect", type: .fillRectangle)
//    private(set) public lazy var fillRectangleItem1 = BoardSettingItem(iconName: "fill_rect", type: .fillRectangle)
//    private(set) public lazy var fillRectangleItem2 = BoardSettingItem(iconName: "fill_rect", type: .fillRectangle)
    
    private(set) public lazy var eraserItem = BoardSettingItem(iconName: "eraser", type: .eraser)
    private(set) public lazy var moveScaleItem = BoardSettingItem(iconName: "move", type: .moveScale)
    private(set) public lazy var chooseItem = BoardSettingItem(iconName: "choose", type: .choose)
    private(set) public lazy var multiChooseItem = BoardSettingItem(iconName: "rectangle_choose", type: .rectangle_choose)
    
    private(set) public lazy var undoItem = BoardSettingItem(iconName: "undo", type: .undo)
    private(set) public lazy var redoItem = BoardSettingItem(iconName: "redo", type: .redo)
    private(set) public lazy var clearItem = BoardSettingItem(iconName: "reset", type: .clear)
    
    private(set) public lazy var addPageItem = BoardSettingItem(iconName: "add_doc", type: .addPage)
//    private(set) public lazy var addPPTItem = BoardSettingItem(iconName: "add_ppt", type: .addPPT)
    private(set) public lazy var prePageItem = BoardSettingItem(iconName: "prestep", type: .lastPage)
    private(set) public lazy var nextPageItem = BoardSettingItem(iconName: "next_step", type: .nextPage)
    private(set) public lazy var deleteItem = BoardSettingItem(iconName: "delete_doc", type: .deletePage)
    private(set) public lazy var manageDocItem = BoardSettingItem(iconName: "manage_doc", type: .manageDoc)
    
    
    private(set) public lazy var deviceItems = { return [cameraItem, microItem, speakerItem, switchCameraItem] }()
    private(set) public lazy var toolsItems = {
        return [brushItem, textItem, lineItem, circleItem, retangleItem, fillCircleItem, fillRectangleItem]
    }()
    private(set) public lazy var actionItems = {
        return [eraserItem, chooseItem, multiChooseItem, moveScaleItem,  undoItem, redoItem, clearItem]
    }()
    private(set) public lazy var pageItems = {
        return [addPageItem, prePageItem, nextPageItem, deleteItem, manageDocItem]
    }()
    
    private(set) public lazy var sections  = { () -> [(title: String, items: [BoardSettingItem])] in
        cameraItem.diableIconName = "camera_disable"
        microItem.diableIconName = "micro_disable"
        return [(title: "设备", items: deviceItems),
                (title: "工具", items: toolsItems),
                (title: "动作", items: actionItems),
                (title: "页面", items: pageItems)]
    }()
    
    public var collectionViewHeight: Int {
        var numberOfRows = 0
        let screenWidth = Float(UIScreen.main.bounds.size.width)
        for section in sections {
            let rows = Int(ceil(Float(section.items.count) * 44 / screenWidth))
            numberOfRows += rows
        }
        return 44 * numberOfRows
    }
}
