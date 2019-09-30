//
//  PermissionsManager.swift
//  EDU
//
//  Created by ryan on 2019/9/29.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit
import coswift
import Photos

public class PermissionsManager: NSObject {
    
    public static let shared = PermissionsManager()
    
    private override init() {
    }
    
    public func isAVAuthorized(for mediaType: AVMediaType) -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        return status == .authorized
    }
    
    public func isPhotoLibraryAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    public func requestAVPermission(for mediaType: AVMediaType) -> Promise<Bool> {
        let promise = Promise<Bool>()
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: mediaType) { enable in
                promise.fulfill(value: enable)
            }
        } else {
            DispatchQueue.global().async {
                promise.fulfill(value: status == .authorized)
            }
        }
        return promise
    }
    
    public func requestPhotoPermission() -> Promise<Bool> {
        let promise = Promise<Bool>()
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                promise.fulfill(value: status == .authorized)
            }
        } else {
            DispatchQueue.global().async {
                promise.fulfill(value: status == .authorized)
            }
        }
        return promise
    }
}
