//
//  ClassRoomViewModel.swift
//  EDU
//
//  Created by ryan on 2019/9/29.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import coswift

class ClassRoomViewModel: NSObject {
    
    func generateDeviceOrientation() -> Promise<Bool> {
        let promise = Promise<Bool>()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        DispatchQueue.global().async {
            while UIDevice.current.isGeneratingDeviceOrientationNotifications {
                if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                        promise.fulfill(value: true)
                    }
                    break
                }
            }
        }
        return promise
    }
    
    func didOrientationChanged() -> Observable<UIDeviceOrientation> {
        return NotificationCenter.default.rx
            .notification(UIDevice.orientationDidChangeNotification, object: nil)
            .map { notification -> UIDeviceOrientation in
                return UIDevice.current.orientation
        }
    }
    
}
