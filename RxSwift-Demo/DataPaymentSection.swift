//
//  DataPaymentSection.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct DataPaymentSection {
    let selectPayment:Variable<ModelPayment>
    init(defaultSelected: ModelPayment) {
        selectPayment = Variable(defaultSelected)
    }
}

extension DataPaymentSection : Hashable {
    var hashValue: Int {
        return selectPayment.value.hashValue
    }
    
    static func ==(lhs: DataPaymentSection, rhs: DataPaymentSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}

extension DataPaymentSection : IdentifiableType {
    var identity : Int {
        return selectPayment.value.hashValue
    }
}
