//
//  BaseView.swift
//  EDU
//
//  Created by ryan on 2019/9/26.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit

class BaseView: UIView, UIGestureRecognizerDelegate {

    private var _name: String
    public var name: String { return _name}
    
    init(frame: CGRect, name: String) {
        self._name = name
        super.init(frame: frame)
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented...")
    }
    
    private func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGesture.minimumNumberOfTouches = 3
        panGesture.maximumNumberOfTouches = 3
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapGesture.numberOfTouchesRequired = 3
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func pan() {
        print(name, ": pan")
    }
    
    @objc private func tap() {
        print(name, ": tap")
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(name, ": gestureRecognizerShouldBegin")
        if name == "YELLOW" {
            return false
        }
        return true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if let baseView = view as? BaseView {
            print(_name, ": hitTest ", baseView.name, event?.allTouches?.count)
        }
        return view
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        print(_name, ": pointInside")
        return super.point(inside: point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(_name, ": touchBegin")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(_name, ": touchMove")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
