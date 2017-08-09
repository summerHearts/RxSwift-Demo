//
//  ModelPayment.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

enum ModelPayment {
    
    /// 支付宝
    case alipay
    /// 微信
    case wechat
    /// 银联
    case unionpay
    // Apple Pay
    case applepay
    
    var iconAndName:(icon:UIImage,name:String) {
        switch self {
        case .alipay:
            return (icon:#imageLiteral(resourceName: "purchase_icon_alipay"),name:"支付宝支付")
        case .wechat:
            return (icon:#imageLiteral(resourceName: "purchase_icon_wechat"),name:"微信支付")
        case .unionpay:
            return (icon:#imageLiteral(resourceName: "purchase_icon_unionpay"),name:"银联支付")
        case .applepay:
            return (icon:#imageLiteral(resourceName: "purchase_icon_applepay"),name:"Apple Pay")
        }
    }
    
}

extension ModelPayment:Hashable {
    
}

extension ModelPayment:IdentifiableType {
    var identity : Int {
        return hashValue
    }
}
