//
//  StructWithoutdelegate.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit

//MARK: - 为什么delegate模式不适用于struct类型？

protocol FinishAlertViewDelegate: class {
    func buttonPressed(at index: Int)
}

class StructWithoutdelegate {
    var buttons:[String] = ["Cancle","The next"]
    var buttonPressed:((Int) -> Void)?
    weak var delegate :FinishAlertViewDelegate?
    
    //我们就不能在StructWithoutdelegate里，使用weak修饰delegate属性了，因为实现FinishAlertViewDelegateNoClass的，不一定是一个引用类型，还有可能是值类型。
    var delegateNoClass: FinishAlertViewDelegateNoClass?
    
    
    func goToNext(){
        delegate?.buttonPressed(at: 1)
        delegateNoClass?.buttonPressed(at: 1)
        buttonPressed?(1)
    }
    
}

//MAKR: - struct类型可以通过buttonPressed(at:)修改自身的属性，我们还要用mutating来修饰这个方法；
protocol FinishAlertViewDelegateNoClass{
   mutating  func buttonPressed(at index: Int)
}

//MARK: - struct来实现这个protocol：
struct PressCounter: FinishAlertViewDelegateNoClass {
    var count = 0
    
    mutating func buttonPressed(at Index: Int) {
        self.count += 1
    }
}

//MARK: - 使用callback替代protocol，是一个有利也有弊的方案。Callback带来了更大的灵活性和更简洁的代码，却也在使用引用类型时，埋下了引用循环的隐患。

//MARK: - 当然，技术细节上的差异只是你在选择实现方案的一部分考量，另一部分，则来自于代码呈现的语义。通常，如果你有若干功能非常相关的回调函数，你还是应该把它们归拢到一起，通过一个protocol来约束他们。这样，实现这些回调函数的类型，也就变成一个遵从了protocol的类型（毕竟你无法让一个对象的delegate同时等于多个对象），这一定是比散落在各处的callback要好多了。



