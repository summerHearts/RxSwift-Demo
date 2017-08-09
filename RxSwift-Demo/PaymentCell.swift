//
//  PaymentCell.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/8/9.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let PaymentCellIdentifier : String = "PaymentCellIdentifier"
class PaymentCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var isSelectImageView: UIImageView!
    
    var payment:ModelPayment! {
        didSet{
            iconImageView.image = payment.iconAndName.icon
            nameLbl.text = payment.iconAndName.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
}

extension Reactive where Base: PaymentCell {
    var isSelectedPayment: UIBindingObserver<UIImageView, Bool> {
        return UIBindingObserver<UIImageView, Bool>(UIElement: self.base.isSelectImageView) { imageView,isSelected in
            if isSelected {
                imageView.image = #imageLiteral(resourceName: "ic_selected")
            } else {
                imageView.image = #imageLiteral(resourceName: "ic_select")
            }
        }
    }
}
