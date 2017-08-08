//
//  ClosureShouldBeUsedViewController.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit

class ClosureShouldBeUsedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //MARK: -  在编程语言的组合逻辑判断中，存在着一个逻辑，叫做short circuit。简单来说，就是：
        
        //MARK: - 对于多个逻辑与&&串联的情况，如果某一个表达式的值为false就不再继续评估后续的表达式了；
        //MARK: - 对于多个逻辑或||串联的情况，如果某一个表达式的值为true就不再继续评估后续的表达式了；
        //MARK: -  一个由表达式评估方式引发的问题
        
        //MARK: -  通常，我们还会依赖这个特性来编写代码，例如，判断数组第一个元素是否大于0：
        let numbers: [Int] = [1, 2, 3]
        
        if !numbers.isEmpty && numbers[0] > 0 {
            print(numbers)
        }
        
        //MARK: - 悲剧了，Swift原生的&&依旧可以正常工作，但我们的logicAnd却阵亡了。道理很简单，函数在执行前，要先评估它的所有参数，在评估到numbers[0]的时候，发生了运行时异常。此时，我们在logicAnd内部通过guard模拟的short circuit完全派不上用场。
        let numberss: [Int] = []
        if logicAnd(!numberss.isEmpty, numbers[0] > 0) {
            // This failed
        }

        //MARK: -要时刻记着第二个Bool表达式要通过一个closure来表示
        if logicAnds(!numbers.isEmpty, { numbers[0] > 0 }) {
            
        }
        
        //MARK: - @autoclosure来修饰参数类型就可以只写上用于得到返回值的表达式，Swift会自动把这个表达式变成一个closure
        if logicAndss(!numbers.isEmpty, numbers[0] > 0) {
            
        }
    }
    
    //MARK: - 只有当!numbers.isEmpty为true时，才会评估后面的表达式，因此，我们并不会因为数组越界导致程序崩溃。当如果我们自己定义一个执行逻辑或运算的函数：
    func logicAnd(_ l: Bool, _ r: Bool) -> Bool {
        guard l else { return false }
        
        return r
    }
    
    
    //MARK: - 我们把通过第二个参数获取Bool值的过程，封装在一个函数里。在评估logicAnd参数的时候，会评估到一个函数类型。我们把真正获取Bool的动作，推后到函数执行的时候。
    func logicAnds(_ l :Bool, _ r:() -> Bool) -> Bool {
        guard l else {
            return false
        }
        return r()
    }
    
    
    //MARK: - Swift里允许我们通过@autoclosure来修饰参数类型
    func logicAndss(_ l: Bool, _ r: @autoclosure () -> Bool) -> Bool {
        guard l else { return false }
        
        return r()
    }


}
