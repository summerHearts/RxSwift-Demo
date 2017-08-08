//
//  SortViewController.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {
    
    typealias SortDescriptor<T> = (T, T) -> Bool

    override  dynamic func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        //MARK: -  排序的使用
        let edisodes = [
            Edisode(title: "title 1", type: "Free", length: 520),
            Edisode(title: "title 4", type: "Paid", length: 500),
            Edisode(title: "title 2", type: "Free", length: 330),
            Edisode(title: "title 5", type: "Paid", length: 260),
            Edisode(title: "title 3", type: "Free", length: 240),
            Edisode(title: "title 6", type: "Paid", length: 390),
            ]
        
        /*
         key：表示要排序的属性；
         ascending：表示是否按升序排序；
         selector：表示要进行比较的方法；
         */
        
        //MARK: - 显然，尽管NSSortDescriptor的思想并不难掌握，但把它用在Swift里，还是显的有点儿水土不服，这主要表现在：
         
        //MARK: -  首先，从定义之初，就限制了我们必须使用class，必须从NSObject派生。但显然，这样的信息在Swift更适合定义成struct；
        //MARK: -  其次，我们要在使用API的时候，把Array bridge到NSArray，从NSArray再bridge回来的时候，类型变成了Any，我们还要手工找回类型信息；
        //MARK: -  最后，Key-Value coding和selector都没有利用编译器提供足够充分的类型检查；
    
        let typeDescriptor = NSSortDescriptor(
            key: #keyPath(Edisode.type),
            ascending: true,
            selector: #selector(NSString.localizedCompare(_:))
        )
    
        let lengthDescriptor = NSSortDescriptor(
            key: #keyPath(Edisode.length),
            ascending: true)
        
        let descriptors = [ typeDescriptor ,lengthDescriptor]
        let sortedEpisodes = (edisodes as NSArray).sortedArray(using: descriptors)
        sortedEpisodes.forEach { print($0 as! Edisode) }
        
        
        //MARK: - 如何通过类型系统模拟OC的运行时特性？
        
       //MARK: -  观察这两个例子，如果我们要抽象SortDescriptor的创建过程，要解决两个问题：
        
       //MARK: -  首先，对于要排序的值，不能简单的认为就是SortDescriptor泛型参数的对象，它还有可能是这个对象的某个属性。因此，我们应该用一个函数来封装获取排序属性这个过程；
        
       //MARK: -  其次，对于排序的动作，有可能是localizedCompare这样的方法，也有可能是系统默认的<操作符，因此，我们同样要用一个函数来抽象这个比较的过程；
        
       //MARK: -  理解了这两点之后，我们就可以试着为SortDescriptor，创建一个工厂函数了：
        let lengthDescriptors: SortDescriptor<Edisode> =
            makeDescriptor(key: { $0.length }, <)
        
        let typeDescriptors: SortDescriptor<Edisode> =
            makeDescriptor(key: { $0.type }, {
                $0.localizedCompare($1) == .orderedAscending
            })
        
        let mixDescriptor = combine(rules:
            [typeDescriptors, lengthDescriptors])
        edisodes.sorted(by: mixDescriptor)
            .forEach { print($0) }
    }
    
    
    func makeDescriptor<Key,Value>(key: @escaping(Key) -> Value, _ isAscending:@escaping (Value,Value) -> Bool) -> SortDescriptor<Key> {
        return {isAscending(key($0),key($1))}
    }
    
    //MARK: - 合并多个排序条件
    //MARK: -  接下来，我们要继续模拟通过一个数组来定义多个排序条件的功能。怎么做呢？我们有两种选择：
    
    //MARK: -  通过extension Sequence，添加一个接受[SortDescriptor<T>]为参数的sorted(by:)方法；
    //MARK: -   定义一个可以把[SortDescriptor<T>]合并为一个SortDescriptor<T>的方法。这样，就可以先合并，再调用sorted(by:)进行排序；
    //MARK: -  哪种方法更好呢？为了尽可能使用统一的方式使用Swift集合类型，我们还是决定采用第二种方式。
    
    //MARK: -  那么，如何合并多个descriptors呢？核心思想有三条，在合并[SortDescriptor]的过程中：
    
    //MARK: -  如果某个descriptor可以比较出大小，那么后面的所有descriptor就都不再比较了；
    //MARK: -  只有某个descriptor的比较结果为相等时，才继续用后一个descriptor进行比较；
    //MARK: -  如果所有的descriptor的比较结果都相等，则返回false；
    
    func combine<T>(rules: [SortDescriptor<T>]) -> SortDescriptor<T> {
        return { l, r in
            for rule in rules {
                if rule(l, r) {
                    return true
                }
                
                if rule(r, l) {
                    return false
                }
            }
            
            return false
        }
    }

    //MARK: - 如果要在swift中使用objc_msgSend方法，可以在函数上使用动态修饰符
    override dynamic func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // THIS IS AN OVERRIDDEN METHOD
    }
    
    dynamic func hello() {
        // THIS IS A METHOD FROM SUBCLASS
    }

}
