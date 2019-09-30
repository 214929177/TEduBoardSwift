//
//  BoardSettingsCell.swift
//  EDU
//
//  Created by ryan on 2019/9/26.
//  Copyright © 2019 windbird. All rights reserved.
//

import UIKit

class BoardSettingsCell: UICollectionViewCell {

    @IBOutlet weak var iconButton: UIButton!
    
    public var settingItem: BoardSettingItem! {
        didSet {
            if !settingItem.allEnable, let disableIconName = settingItem.diableIconName {
                iconButton.setImage(UIImage(named: disableIconName), for: .normal)
            } else {
                iconButton.setImage(UIImage(named: settingItem.iconName), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconButton.isUserInteractionEnabled = false
        if let settingItem = settingItem {
            iconButton?.setImage(UIImage(named: settingItem.iconName), for: .normal)
        }
    }

}
