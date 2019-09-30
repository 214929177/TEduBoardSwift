//
//  COAlertController.swift
//  EDU
//
//  Created by ryan on 2019/9/29.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit
import coswift

extension UIAlertController {
    
    func present(from controller: UIViewController, confirm: String?, cancel: String?) -> Promise<String> {
        let promise = Promise<String>()
        if let confirm = confirm {
            addAction(UIAlertAction(title: confirm, style: .default, handler: { action in
                promise.fulfill(value: confirm)
            }))
        }
        if let cancel = cancel {
            addAction(UIAlertAction(title: title, style: .cancel, handler: { action in
                promise.fulfill(value: cancel)
            }))
        }
        controller.present(self, animated: true, completion: nil)
        return promise
    }
}
