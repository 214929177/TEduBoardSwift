//
//  ResponderChainViewController.swift
//  EDU
//
//  Created by ryan on 2019/9/26.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit

class ResponderChainViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let rootView = BaseView(frame: view.bounds, name: "ROOT")
        rootView.backgroundColor = UIColor.white
        view.addSubview(rootView)
        
        let redView = BaseView(frame: CGRect(x: 15, y: 15, width: 400, height: 400), name: "RED")
        redView.backgroundColor = UIColor.red
        view.addSubview(redView)
        
        let yellowView = BaseView(frame: CGRect(x: 0, y: 0, width: 250, height: 250), name: "YELLOW")
        yellowView.backgroundColor = UIColor.yellow
        redView.addSubview(yellowView)
        
        let cyanView = BaseView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), name: "CYAN")
        cyanView.backgroundColor = UIColor.cyan
        yellowView.addSubview(cyanView)
        
        let purpleView = BaseView(frame: CGRect(x: 350, y: 350, width: 300, height: 300), name: "PURPLE")
        purpleView.backgroundColor = UIColor.purple
        view.addSubview(purpleView)
        
        let screenSize = UIScreen.main.bounds.size
        let greenView = BaseView(frame: CGRect(x: screenSize.width - 300, y: screenSize.height - 300, width: 300, height: 300), name: "GREEN")
        greenView.backgroundColor = UIColor.green
        view.addSubview(greenView)
        
        let panGetusre = UIPanGestureRecognizer(target: self, action: #selector(threeFingerPan))
        panGetusre.minimumNumberOfTouches = 3
        view.addGestureRecognizer(panGetusre)
    }

    @objc private func threeFingerPan() {
        print("三指滑动……")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
