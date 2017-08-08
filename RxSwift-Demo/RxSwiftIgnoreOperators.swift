//
//  RxSwiftIgnoreOperators.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftIgnoreOperators: NSObject {

    //operator是ignoreElements，它会忽略序列中所有的.next事件
    func ignoreElements(){
        let task = PublishSubject<String>()
        
        let bag = DisposeBag()
        
        task.ignoreElements().subscribe{
            print($0)
        }.addDisposableTo(bag)
        
        
        task.onNext("0")
        task.onNext("1")
        task.onNext("2")
        task.onNext("3")
        task.onCompleted()
    }
    
    //除了一次性忽略所有的.next之外，我们还可以选择忽略事件序列中特定个数的.next。例如，在我们的例子里，假设队列中前两个任务都是流水线上其它人完成的，而你只需要完成第三个任务
    func skipElements(){
        let task = PublishSubject<String>()
        
        let bag = DisposeBag()
        
        task.skip(2).subscribe{
            print($0)
            }.addDisposableTo(bag)
        
        
        task.onNext("0")
        task.onNext("1")
        task.onNext("2")
        task.onNext("3")
        task.onCompleted()
    }
    
    
    //除了可以忽略指定个数的事件外，我们还可以通过一个closure自定义忽略的条件，这个operator叫做skipWhile。但它和我们想象中有些不同的是，它不会“遍历”事件序列上的所有事件，而是当遇到第一个不满足条件的事件之后，就不再忽略任何事件了
    func skipWhileElements(){
        let task = PublishSubject<String>()
        let bag = DisposeBag()
        task.skipWhile{
              $0 != "2"
        }.subscribe{
            print($0)
        }.addDisposableTo(bag)
        task.onNext("0")
        task.onNext("1")
        task.onNext("2")
        task.onNext("3")
        task.onCompleted()
    }
    
    //不会订阅到任何事件。这就是skipUntil的效果，它会一直忽略tasks中的事件，直到bossIsAngry中发生事件为止。把它用序列图表示出来
    func skipUntilElements(){
        let tasks = PublishSubject<String>()
        
        let bossIsArray = PublishSubject<Void>()
        
        let bag = DisposeBag()
        
        tasks.skipUntil(bossIsArray).subscribe{
            print($0)
        }.addDisposableTo(bag)
        
        tasks.onNext("0")
        tasks.onNext("1")
        tasks.onNext("2")
        bossIsArray.onNext();
        tasks.onNext("3")
        tasks.onCompleted()
    }
    
    //distinctUntilChanged忽略序列中连续重复的事件
    func distinctUntilChangedElements(){
        let task = PublishSubject<String>()
        
        let bag = DisposeBag()
        
        task.distinctUntilChanged().subscribe{
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
    
}
