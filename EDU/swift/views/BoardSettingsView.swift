//
//  BoardSettingsView.swift
//  EDU
//
//  Created by ryan on 2019/9/26.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit

class BoardSettingsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cellID = "cell_id"
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var didSelectSetting: ((BoardSettingItem) -> Void)?
    
    private lazy var viewModel = {
        return BoardSettingsViewModel()
    }()
    
    
    public lazy var height: Int = {
        return viewModel.collectionViewHeight
    }()
    
    
    public class func instance() -> BoardSettingsView {
        return Bundle.main.loadNibNamed("BoardSettingsView", owner: nil, options: nil)!.first as! BoardSettingsView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .zero
        collectionView.register(UINib(nibName: "BoardSettingsCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    public func notifyDataChanged() {
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BoardSettingsCell
        let settingItem = viewModel.sections[indexPath.section].items[indexPath.item]
        if case .micro = settingItem.type {
            settingItem.isEnable = PermissionsManager.shared.isAVAuthorized(for: .audio)
        }
        if case .camera = settingItem.type {
            settingItem.isEnable = PermissionsManager.shared.isAVAuthorized(for: .video)
        }
        cell.settingItem = settingItem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let settingItem = viewModel.sections[indexPath.section].items[indexPath.item]
        didSelectSetting?(settingItem)
    }
    
}
