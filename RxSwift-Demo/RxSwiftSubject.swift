//
//  RxSwiftSubject.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxSwiftSubject: NSObject {

    func publicSubject(){
        let subject = PublishSubject<String>()
        let sub1 = subject.subscribe(onNext: {
            print("Sub1 - what happened: \($0)")
        })
        subject.onNext("Episode1 updated")

        /*
         但是执行一下就会发现，控制台上不会显示任何订阅消息，也就是说sub1没有订阅到任何内容。这是因为PublishSubject执行的是“会员制”，它只会把最新的消息通知给消息发生之前的订阅者。
         */
        
        sub1.dispose()
        
        let sub2 = subject.subscribe(onNext: {
            print("Sub2 - what happened: \($0)")
        })
        
        subject.onNext("Episode2 updated")
        subject.onNext("Episode3 updated")
        
        sub2.dispose()
        
    }
    
    func behaviorSubject() {
        /*
         如果你希望Subject从“会员制”变成“试用制”，就需要使用BehaviorSubject。它和PublisherSubject唯一的区别，就是只要有人订阅，它就会向订阅者发送最新的一次事件作为“试用”。
         */
        let subject = BehaviorSubject<String>(value: "RxSwift step by step")
        
        _ = subject.subscribe(onNext: {
            print("Sub1 - what happened: \($0)")
        })
        
        subject.onNext("Episode1 updated")
        /*
         由于BehaviorSubject有了一个默认的事件，sub1订阅之后，就会陆续收到RxSwift step by step和Sub1 - what happened: Episode1 updated的消息了。此时，如果我们再添加一个新的订阅者：
         */
        _ = subject.subscribe(onNext: {
            print("Sub2 - what happened: \($0)")
        })
        /*
         此时，sub2就只能订阅到Sub2 - what happened: Episode1 updated消息了。
         */
    }
    
    
    func replaySubject() {
        /*
         ReplaySubject的行为和BehaviorSubject类似，都会给订阅者发送历史消息。不同地方有两点：
         
         ReplaySubject没有默认消息，订阅空的ReplaySubject不会收到任何消息；
         ReplaySubject自带一个缓冲区，当有订阅者订阅的时候，它会向订阅者发送缓冲区内的所有消息；
         */
        
        let subject = ReplaySubject<String>.create(bufferSize: 3)
        
        _ = subject.subscribe(onNext: {
            print("Sub1 - what happened: \($0)")
        })
        
        subject.onNext("Episode1 updated")
        subject.onNext("Episode2 updated")
        subject.onNext("Episode3 updated")
        
        _ = subject.subscribe(onNext: {
            print("Sub2 - what happened: \($0)")
        })

        /*
         由于subject缓冲区的大小是3，它会自动给sub2发送最新的三次历史事件。在控制台中执行一下，就可以看到注释中的结果了。
         */
    }
    
    func variable (){
        /*
         除了事件序列之外，在平时的编程中我们还经常需遇到一类场景，就是需要某个值是有“响应式”特性的，例如可以通过设置这个值来动态控制按钮是否禁用，是否显示某些内容等。为了方便这个操作，RxSwift还提供了一个特殊的subject，叫做Variable。
        */
        
        let stringVariable = Variable("Episode1")
        _ = stringVariable
            .asObservable()
            .subscribe {
                print("sub1: \($0)")
        }
        stringVariable.value = "Episode2"
       /*
         最后要说明的一点是，Variable只用来表达一个“响应式”值的语义，因此，它有以下两点性质：
         
         绝不会发生.error事件；
         无需手动给它发送.complete事件表示完成；
         */
    }
    
    
    func asyncSubject() {
        /*
         
         /// AsyncSubject发出源Observable发出的最后一个值（只有最后一个值）
         ///只有在该Observable完成之后。
         ///
         ///（如果源Observable不发出任何值，则AsyncSubject也会完成，而不会发出任何值。）

         */
        let subject = AsyncSubject<String>()
        
        subject.onNext("Episode1 updated")

        _ = subject.subscribe(onNext: {
            print("Sub1 - what happened: \($0)")
        })
        
        subject.onNext("Episode2 updated")
        let error = NSError.init(domain: "", code: 2, userInfo: ["213" :232])
//        subject.onError(error)
        subject.onCompleted()

    }
}
