//
//  DropDownMenuTableViewCell.swift
//  WhoDo-Swift
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 lanxiao. All rights reserved.
//

import UIKit
import SnapKit

class DropDownMenuTableViewCell: UITableViewCell {

    public  var label   :UILabel!
    
    public  var lineView:UIView!
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addView()
        
    }
    
    func addView(){
        label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        self.contentView.addSubview(label)
    
        label.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(0)
            make.right.equalTo(self.contentView).offset(0)
            make.height.equalTo(24)
        }
        
        lineView = UIView.init()
        lineView.backgroundColor = UIColor.orange
        self.contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.label.snp.bottom).offset(7)
            make.left.equalTo(self.contentView).offset(0)
            make.right.equalTo(self.contentView).offset(0)
            make.height.equalTo(1)
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
