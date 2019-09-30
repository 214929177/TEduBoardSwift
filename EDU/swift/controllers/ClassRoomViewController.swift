//
//  ClassRoomViewController.swift
//  EDU
//
//  Created by ryan on 2019/9/24.
//  Copyright © 2019 windbird. All rights reserved.
//

import Foundation
import SnapKit
import coswift
import RxSwift
import TEduBoard

@objc public class ClassRoomViewController: UIViewController {
    
    @IBOutlet weak var boardViewContainer: UIView!
    @IBOutlet weak var boarderViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var chatViewContainer: UIView!
    @IBOutlet weak var chatToggleButton: UIButton!
    @IBOutlet weak var chatContainerTop: NSLayoutConstraint!
    @IBOutlet weak var chatContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var chatContainerRight: NSLayoutConstraint!
    
    private weak var settingsView: BoardSettingsView?
    private weak var settingsViewTop: Constraint?
    private lazy var viewModel = ClassRoomViewModel()
    private lazy var disposeBag = DisposeBag()
    
    private let classRoom: ClassRoom
    private let user: User
    
    /// 白板设置UI打开关闭状态
    private var isSettingsOpen = false {
        didSet {
            UIView.animate(withDuration: 0.25) {
                if let settingsView = self.settingsView {
                    let height = self.isSettingsOpen ? 0 : -settingsView.height
                    self.settingsViewTop?.update(offset: height)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    /// 聊天页面打开关闭状态
    private var isChatOpen = true {
        didSet {
            UIView.animate(withDuration: 0.25) {[weak self] in
                if let self = self {
                    let screenSize = UIScreen.main.bounds.size
                    let screenWidth = min(screenSize.width, screenSize.height)
                    self.chatContainerRight?.constant = self.isChatOpen ? 0 : -screenWidth
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    /// 屏幕方向变化
    private var deviceOrientation: UIDeviceOrientation! {
        didSet {
            let screenSize = UIScreen.main.bounds.size
            let screenWidth = min(screenSize.width, screenSize.height)
            UIView.animate(withDuration: 0.25) {[weak self] in
                if let self = self {
                    self.chatContainerWidth.constant = screenWidth
                    switch self.deviceOrientation {
                    case .portrait:
                        self.chatToggleButton.isHidden = true
                        let borderContainerHeight = screenWidth * 9 / 16
                        self.boarderViewContainerHeight.constant = borderContainerHeight
                        self.chatContainerTop.constant = borderContainerHeight
                        self.isChatOpen = true
                    case .landscapeLeft, .landscapeRight:
                        self.chatToggleButton.isHidden = false
                        self.boarderViewContainerHeight.constant = screenSize.height
                        self.chatContainerTop.constant = 0
                        self.isChatOpen = false
                    default:
                        print("该方向不用处理……")
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    /// 是否允许绘制
    private var isDrawEnable: Bool = true {
        didSet {
            TICManager.sharedInstance()?.getBoardController()?.setDrawEnable(isDrawEnable)
        }
    }
    
    /// 是否使用扬声器
    private var isSpeakerEnable: Bool = true {
        didSet {
            let audioRoute:TRTCAudioRoute = isSpeakerEnable ? .modeSpeakerphone : .modeEarpiece
            TICManager.sharedInstance()?.getTRTCCloud()?.setAudioRoute(audioRoute)
        }
    }
    
    private var canUndo = false
    private var canRedo = false
    
    private init(_ classRoom: ClassRoom, _ user: User) {
        self.classRoom = classRoom
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    public required init?(coder: NSCoder) {
        fatalError("not implemented ... ")
    }
    
    @objc public class func controller(withClassRoom classRoom: ClassRoom, user: User) -> ClassRoomViewController {
        let classRoomController = ClassRoomViewController(classRoom, user)
        return classRoomController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = String(format: "%d教室", classRoom.classId)
        let settingsImage = UIImage(named: "settings")
        let boardSettingButton = UIBarButtonItem(image:settingsImage, style: .plain, target: self, action: #selector(showBoardSettingsView))
        navigationItem.rightBarButtonItem = boardSettingButton
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        addBoardView()
        addChatView()
        addBoardSettingsView()
        self.chatToggleButton.isHidden = true
        co_launch { [weak self] in
            if let self = self {
                let result = try! await(promise: self.viewModel.generateDeviceOrientation())
                if case .fulfilled(_) = result {
                    self.setupChatView()
                }
            }
        }
        viewModel.didOrientationChanged()
            .subscribe(
                onNext: {[weak self] orientation in self?.deviceOrientation = orientation },
                onDisposed: {UIDevice.current.endGeneratingDeviceOrientationNotifications()})
            .disposed(by: disposeBag)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsView?.notifyDataChanged()
    }
    
    private func setupChatView() {
        deviceOrientation = UIDevice.current.orientation
    }
    
    private func addBoardView() {
        if let boardController = TICManager.sharedInstance()?.getBoardController() {
            boardController.setBoardRatio("16:9")
            boardController.add(self)
//            boardController.setBackgroundColor(UIColor.white)
//            boardController.setBrush(UIColor.white)
//            boardController.setDrawEnable(true)
            if let boardView = boardController.getBoardRenderView() {
                boardViewContainer.addSubview(boardView)
                boardView.snp.makeConstraints { maker in
                    maker.left.right.top.bottom.equalTo(boardViewContainer)
                }
                boardViewContainer.bringSubviewToFront(boardView)
            }
        }
    }
    
    
    /// 白板设置
    private func addBoardSettingsView() {
        let settingsView = BoardSettingsView.instance()
        settingsView.didSelectSetting = { [weak self] (settingItem: BoardSettingItem) in
            if let boardController = TICManager.sharedInstance()?.getBoardController() {
                switch settingItem.type {
                case .camera:
                    self?.openCamera(settingItem: settingItem)
                case .micro:
                    self?.openMicrophone(settingItem: settingItem)
                case .speaker:
                    TICManager.sharedInstance()?.getTRTCCloud()?.setAudioRoute(TRTCAudioRoute.modeEarpiece)
                case .switchCamera:
                    TICManager.sharedInstance()?.getTRTCCloud()?.switchCamera()
                case .brush:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_PEN)
                case .text:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_TEXT)
                case .eraser:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_ERASER)
                case .circle:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_OVAL)
                case .fillCircle:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_OVAL_SOLID)
                case .rectangle:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_RECT)
                case .fillRectangle:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_RECT_SOLID)
                case .line:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_LINE)
                case .moveScale:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_ZOOM_DRAG)
                case .choose:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_POINT_SELECT)
                case .rectangle_choose:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_RECT_SELECT)
                case .laser:
                    boardController.setToolType(.TEDU_BOARD_TOOL_TYPE_LASER)
                case .clear:
                    boardController.clearDraws()
                case .undo:
                    if let self = self, self.canUndo {
                        boardController.undo()
                    }
                case .redo:
                    if let self = self, self.canUndo {
                        boardController.redo()
                    }
                default:
                    print("...")
                    
                }
            }
            self?.isSettingsOpen = false
        }
        self.settingsView = settingsView
        view.addSubview(settingsView)
        let settingViewHeight = settingsView.height
        settingsView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            if #available(iOS 11.0, *) {
                self.settingsViewTop = make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-settingViewHeight).constraint
            } else {
                self.settingsViewTop = make.top.equalTo(view).offset(-settingViewHeight).constraint
            }
            make.height.equalTo(settingViewHeight)
        }
    }
    
    // MARK: 打开、关闭摄像头
    private func openCamera(settingItem: BoardSettingItem) {
        co_launch {[weak self] in
            if let self = self {
                defer {
                    print("刷新视图……")
                    self.settingsView?.notifyDataChanged()
                }
                let isCameraUsable = try! await(promise: PermissionsManager.shared.requestAVPermission(for: .video))
                if case .fulfilled(let cameraUsable) = isCameraUsable, !cameraUsable {
                    settingItem.isEnable = false
                    let alertController = UIAlertController(title: "温馨提示", message: "当前应用无法开启摄像头，因为您已拒绝了应用访问摄像头权限", preferredStyle: .alert)
                    let _ = try! await(promise: alertController.present(from: self, confirm: "知道了", cancel: nil))
                    print("不可用返回……")
                    return
                }
                settingItem.isEnable = true
                settingItem.userEnable = !settingItem.userEnable
                let trtcCloud = TICManager.sharedInstance()?.getTRTCCloud()
                print("可用返回……")
                
//                settingItem.allEnable ? trtcCloud?.startLocalPreview(<#T##frontCamera: Bool##Bool#>, view: <#T##UIView!#>) : trtcCloud?.stopLocalPreview()
            }
        }
    }
    
    // MARK: 打开、关闭麦克风
    private func openMicrophone(settingItem: BoardSettingItem) {
        co_launch {[weak self] in
            if let self = self {
                defer { self.settingsView?.notifyDataChanged() }
                let isAudioUsable = try! await(promise: PermissionsManager.shared.requestAVPermission(for: .audio))
                if case .fulfilled(let audioUsable) = isAudioUsable, !audioUsable {
                    settingItem.isEnable = false
                    TICManager.sharedInstance()?.getTRTCCloud()?.stopLocalAudio()
                    let alertController = UIAlertController(title: "温馨提示", message: "当前应用无法开启麦克风，因为您已拒绝了应用访问麦克风权限", preferredStyle: .alert)
                    let _ =  try! await(promise: alertController.present(from: self, confirm: "知道了", cancel: nil))
//                    self.settingsView?.notifyDataChanged()
                    return
                }
                let trtcCloud = TICManager.sharedInstance()?.getTRTCCloud()
                settingItem.isEnable = true
                settingItem.userEnable = !settingItem.userEnable
                settingItem.allEnable ? trtcCloud?.startLocalAudio() : trtcCloud?.stopLocalAudio()
            }
        }
    }
    
    private func addChatView() {
        let conversation = TIMManager.sharedInstance()!.getConversation(TIMConversationType.GROUP, receiver: "10086")
        let chatController = TUIChatController(conversation: conversation) as TUIChatController
        addChild(chatController)
        chatViewContainer.addSubview(chatController.view)
        chatController.view.snp.makeConstraints { make in
            make.edges.equalTo(chatViewContainer)
        }
        chatController.didMove(toParent: self)
    }
    
    @objc private func showBoardSettingsView() {
        isSettingsOpen = !isSettingsOpen
    }
    
    @IBAction func showChatView(_ sender: Any) {
        isChatOpen = !isChatOpen
    }
    
    
}

extension ClassRoomViewController: TEduBoardDelegate {
    
    public func onTEBError(_ code: TEduBoardErrorCode, msg: String!) {
        print("白板出错：", code, msg ?? "")
    }
    
    public func onTEBWarning(_ code: TEduBoardWarningCode, msg: String!) {
        print("白板警告：", code, msg ?? "")
    }
    
    public func onTEBInit() {
            
    }
    
    public func onTEBHistroyDataSyncCompleted() {
        print("白板：", "历史数据同步完成……")
    }
    
    public func onTEBSyncData(_ data: String!) {
        print("白板：", "正在同步白板历史数据……")
    }
    
    public func onTEBUndoStatusChanged(_ canUndo: Bool) {
        self.canUndo = canUndo
        print("白板：", "是否可以返回上一步", canUndo)
    }
    
    public func onTEBRedoStatusChanged(_ canRedo: Bool) {
        self.canRedo = canRedo
        print("白板：", "是否可以重做上一步", canRedo)
    }
    
    public func onTEBImageStatusChanged(_ boardId: String!, url: String!, status: TEduBoardImageStatus) {
        
    }
    
    public func onTEBSetBackgroundImage(_ url: String!) {
        
    }
    
    public func onTEBBackgroundH5StatusChanged(_ boardId: String!, url: String!, status: TEduBoardBackgroundH5Status) {
        
    }
    
    public func onTEBAddBoard(_ boardIds: [Any]!, fileId: String!) {
        
    }
    
    public func onTEBDeleteBoard(_ boardIds: [Any]!, fileId: String!) {
        
    }
    
    public func onTEBGotoBoard(_ boardId: String!, fileId: String!) {
        
    }
    
    public func onTEBAddFile(_ fileId: String!) {
        
    }
    
    public func onTEBAddH5PPTFile(_ fileId: String!) {
        
    }
    
    public func onTEBAddTranscodeFile(_ fileId: String!) {
        
    }
    
    public func onTEBDeleteFile(_ fileId: String!) {
        
    }
    
    public func onTEBSwitchFile(_ fileId: String!) {
        
    }
    
    public func onTEBFileUploadProgress(_ fileId: String!, currentBytes: Int32, totalBytes: Int32, uploadSpeed: Int32, percent: Float) {
        
    }
    
    public func onTEBFileUploadStatus(_ fileId: String!, status: TEduBoardUploadStatus, errorCode: Int32, errorMsg: String!) {
        
    }
}
