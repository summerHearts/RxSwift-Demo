//
//  RxSwiftCombination.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*
     本篇文章将要学习如何将多个Observables组合成一个Observable。
     Combination Operators在RxSwift中的实现有五种：
     1   startWith
     2   merge
     3   zip
     4   combineLatest
     5   switchLatest
 */
class RxSwiftCombination: NSObject {
    //在Observable释放元素之前，发射指定的元素序列
    func startWith (){
        let disposeBag = DisposeBag()
        Observable.of(["1","2","3"]).startWith(["0"]).subscribe({ (event) in
            print(event)
        }).disposed(by: disposeBag)
    }
    
    //将多个Observable组合成单个Observable,并且按照时间顺序发射对应事件
    func merge() {
        let disposeBag = DisposeBag()
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        subject1.onNext("🐶")
        subject1.onNext("🐑")
        subject2.onNext("🐎")

        subject2.onNext("🦊")
        subject1.onNext("🐯")
        subject2.onNext("🦁️")
    }
    
    /*
     将多个Observable(注意：必须是要成对)组合成单个Observable，当有事件到达时，会在每个序列中对应的索引上对应的元素发出。
     */
    func zip(){
        let disposeBag = DisposeBag()

        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()

        Observable.zip(subject1, subject2) { string1,string2 in
            "\(string1)--\(string2)"
            }.subscribe(onNext: {print($0)}).disposed(by: disposeBag)

        subject1.onNext("A")
        subject1.onNext("B")
        subject1.onNext("C")
        subject2.onNext("1")
        subject2.onNext("2")

    }

    //当一个项目由两个Observables发射时，通过一个指定的功能将每个Observable观察到的最新项目组合起来，并根据该功能的结果发射事件
    func combineLatests(){
        let disposeBag = DisposeBag()

        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()

        Observable.combineLatest(subject1, subject2) { string1,string2 in
            "\(string1)--\(string2)"
            }.subscribe(onNext: {print($0)}).disposed(by: disposeBag)

        subject1.onNext("A")

        subject2.onNext("1")
        subject2.onNext("2")

        subject1.onNext("B")
        subject1.onNext("C")
    }
    //切换Observable队列
    func switchLatest() {
        let disposeBag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: "1")
        let subject2 = BehaviorSubject(value: "A")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .switchLatest()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("2")
        subject1.onNext("3")
        
        variable.value = subject2
        
        subject1.onNext("4")
        subject2.onNext("B")
    }
}
