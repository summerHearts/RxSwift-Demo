//
//  RxSwiftEventOperator.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class RxSwiftEventOperator: NSObject {

    //选择序列中的第n个事件
    func elementAt(){
        let task = PublishSubject<String>()
        
        let bag = DisposeBag()
        
        task.elementAt(2)
            .subscribe{
               print($0)
        }.addDisposableTo(bag)
        
        task.onNext("0")
        task.onNext("1")
        task.onNext("1")
        task.onNext("2")
        task.onNext("2")
        task.onNext("3")
        task.onCompleted()
    }
    
    
    //除了用事件的索引来选择之外，我们也可以用一个closure设置选择事件的标准，这就是filter的作用，它会选择序列中所有满足条件的元素
    
    func filterOperator(){
        let task = PublishSubject<String>()
        
        let bag = DisposeBag()
        
        task.filter {
            $0 == "1"
        }.subscribe{
            print($0)
        }.addDisposableTo(bag)
        
        task.onNext("0")
        task.onNext("1")
        task.onNext("1")
        task.onNext("2")
        task.onNext("2")
        task.onNext("3")
        task.onCompleted()
    }
    
    //选择一次性订阅多个事件
    func takeOperator(){
        let task = PublishSubject<String>()
        
        let bag = DisposeBag()
        
        task.take(2)
            .subscribe{
                print($0)
            }.addDisposableTo(bag)
        
        task.onNext("0")
        task.onNext("1")
        task.onNext("1")
        task.onNext("2")
        task.onNext("2")
        task.onNext("3")
        task.onCompleted()
    }
    
    //用一个closure来指定“只要条件为true就一直订阅下去”这样的概念。例如，只要任务不是2就一直订阅下去.这看似很简单，但有时候，我们经常会对它的用法产生一些错觉。例如，错把订阅终止条件写在了takeWhile参数里，就像这样：实际上只能订阅到.completed。因为，当匹配到第一个事件的时候，"T1" == "T3"是false，所以订阅就结束了
    func takeWhileOperator(){
        let task = PublishSubject<String>()
        
        let bag = DisposeBag()
        
        task.takeWhile{
//            $0 != "2"   //正确用法
             $0 == "3"
        }.subscribe{
            print($0)
        }.addDisposableTo(bag)
        
        task.onNext("0")
        task.onNext("1")
        task.onNext("1")
        task.onNext("2")
        task.onNext("2")
        task.onNext("3")
        task.onCompleted()
    }
    
    //只是在它的closure里，可以同时访问到事件值和事件在队列中的索引  在closure里写的，是读取事件的条件，而不是终止读取的条件
    func takeWhileWithIndexOperator(){
        let task = PublishSubject<String>()
        
        let bag = DisposeBag()
        
        task.takeWhileWithIndex{ (value ,index) in
            value != "2" && index < 2
        }.subscribe{
                print($0)
        }.addDisposableTo(bag)
        
        task.onNext("0")
        task.onNext("1")
        task.onNext("1")
        task.onNext("2")
        task.onNext("2")
        task.onNext("3")
        task.onCompleted()
    }
    
    //takeUntil operator，但bossHasGone还没有任何事件发生，因此我们仍旧会订阅到所有事件 除了使用closure表示订阅条件之外，我们也可以依赖另外一个外部事件，表达“直到某件事件发生前，一直订阅”这样的语义
    func takeUntilOperator(){
        let tasks = PublishSubject<String>()
        let bossHasGone = PublishSubject<Void>()
        let bag = DisposeBag()
        
    
        tasks.takeUntil(bossHasGone).subscribe {
              print($0)
        }.addDisposableTo(bag)
        
        tasks.onNext("🐶")
        tasks.onNext("🦊")
        bossHasGone.onNext()
        tasks.onNext("🦅")
        tasks.onCompleted()
        
    }
    
}
