//
//  ClassRoomRootView.swift
//  EDU
//
//  Created by ryan on 2019/9/26.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit

class ClassRoomRootView: UIView, UIGestureRecognizerDelegate {
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented...")
    }
    
    private func addGetusre() {
        panGesture.minimumNumberOfTouches = 3
        panGesture.maximumNumberOfTouches = 3
        panGesture.addTarget(self, action: #selector(pan))
    }
    
    @objc private func pan() {
        
    }
    
    
}
