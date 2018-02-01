//
//  TextCell.swift
//  WxTouTiao
//
//  Created by Tebuy on 2018/1/30.
//  Copyright © 2018年 Tebuy. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
