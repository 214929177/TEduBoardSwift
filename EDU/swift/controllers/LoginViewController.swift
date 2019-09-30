//
//  LoginViewController.swift
//  EDU
//
//  Created by ryan on 2019/9/24.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import coswift

@objc public class LoginViewController: UIViewController {
    
    @IBOutlet weak var userIDField: UITextField!
    @IBOutlet weak var classIDField: UITextField!
    @IBOutlet weak var joinClassButton: UIButton!
    
    private lazy var disposeBag: DisposeBag = { return DisposeBag()}()
    private lazy var loginViewModel: LoginViewModel = { return LoginViewModel()}()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "用户登录"
        enableInteraction(enable: false)
        initTICSDK()
    }
    
    private func initTICSDK() {
        co_launch {[weak self] in
            let appId = Int32(1400255804)
            let initSDKResult = try! await(promise: TICHelper.shared.initSDK(appId: appId))
            if case .fulfilled(let result) = initSDKResult, result.isSuccess {
                print("互动课堂SDK初始化成功了", result.code, result.desc ?? "")
                if let self = self {
                    self.enableInteraction(enable: true)
                    let userIdObservable = self.userIDField.rx.text.asObservable()
                    let classIdObservable = self.classIDField.rx.text.asObservable()
                    let joinClassEnableBinder = self.joinClassButton.rx.isEnabled
                    self.loginViewModel.isAllValidate(userIdObservable, classIdObservable).bind(to: joinClassEnableBinder).disposed(by: self.disposeBag)
                    self.userIDField.text = "kakaxi"
                    self.classIDField.text = "10086"
                    self.userIDField.sendActions(for: .editingChanged)
                    self.classIDField.sendActions(for: .editingChanged)
                }
                return
            }
            print("腾讯互动课堂SDK初始化失败了")
        }
    }
    
    private func enableInteraction(enable: Bool) {
        view.isUserInteractionEnabled = enable
        joinClassButton.isEnabled = enable
    }
    
    @IBAction func didClickButton(_ sender: UIButton) {
        enableInteraction(enable: false)
        let classRoom = ClassRoom(classId: loginViewModel.classId!)
        let user = User(userId: loginViewModel.userId!)
        loginViewModel.login(userId: loginViewModel.userId!, classId: loginViewModel.classId!).subscribe(onSuccess: { [weak self] (success, desc) in
            if let self = self {
                if success {
                    let roomController = ClassRoomViewController.controller(withClassRoom: classRoom, user: user)
                    self.navigationController?.pushViewController(roomController, animated: true)
                    return
                }
                self.enableInteraction(enable: true)
            }
        }).disposed(by: disposeBag)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let controller = ResponderChainViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
