//
//  ProductModel.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/8/9.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources


struct ProductModel {
    //MARK: - 参数 商品ID  商品名称  商品单位价格  商品数量
    let productId : Int
    let name: String
    let unitPrice : Int
    let count: Variable<Int>
}

extension ProductModel: Hashable {
    //MARK: - 必须实现比较方法
    var hashValue : Int {
        return productId.hashValue
    }
    
    public static func == (lhs:ProductModel,rhs: ProductModel) ->Bool {
        return lhs.productId == rhs.productId
    }
}

extension ProductModel: IdentifiableType {
    //MARK: - 唯一标示必须实现该方法
    var identity : Int {
        return productId.hashValue
    }
}
