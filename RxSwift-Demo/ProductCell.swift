//
//  ProductCell.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/8/9.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import Foundation

let   ProductCellIdentifier : String = "ProductCellIdentifier"

class ProductCell: UITableViewCell {

    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var minusBtn: UIButton! {
        didSet{
            minusBtn
                .rx
                .tap
                .bind { [weak self] in
                    self?.product.count.value -= 1
                }
                .disposed(by: rx_disposeBag)
        }
    }
    @IBOutlet weak var plusBtn: UIButton! {
        didSet{
            plusBtn
                .rx
                .tap
                .bind { [weak self] in
                    self?.product.count.value += 1
                }
                .disposed(by: rx_disposeBag)
        }
    }
    
    
    var product:ProductModel! {
        didSet{
            if product == nil {
                fatalError()
            }
            
            nameLbl.text = product.name
            priceLbl.text = "单价: \(product.unitPrice) 元"
            
            product
                .count
                .asObservable()
                .bind { [weak self] in
                    if $0 < 0 {
                        fatalError()
                    }
                    self?.minusBtn.isEnabled = $0 != 0
                    self?.countLbl.text = String($0)
                }
                .disposed(by: rx.prepareForReuseBag)
            
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
