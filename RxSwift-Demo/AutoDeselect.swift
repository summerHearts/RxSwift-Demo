//
//  AutoDeselect.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/8/9.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


extension Reactive where Base: UICollectionView {
    public func enableAutoDeselect() -> Disposable {
        return itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: base.deselectItem)
    }
}

extension Reactive where Base: UITableView{
    public func enableAutoDeselect() -> Disposable {
        return itemSelected
            .map{ (at: $0,animated: true)}
            .subscribe(onNext: base.deselectRow)
    }
}
