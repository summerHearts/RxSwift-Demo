//
//  RxSwiftTransformingOperators.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*
     RxSwift中四种转换操作符：
     
     map
     flatMap
     flatMapLatest
     scan

 */

class RxSwiftTransformingOperators: NSObject {

    //通过使用一个闭包函数将原来的Observable序列转换为一个新的Observable序列
    func mapOperator(){
        let disposeBag = DisposeBag()
        Observable.of(1,2,3)
            .map({
            return $0 * $0
        }).subscribe({print($0)})
          .disposed(by: disposeBag)
    }
    
    func flatmapOperator(){
        let disposeBag = DisposeBag()
        
        struct Student {
            var score:Variable<Int>
        }
        
        let student1 = Student(score: Variable(60))
        let student2 = Student(score: Variable(70))
        
        let observables = Variable(student1)
        observables.asObservable()
            .flatMap({
                $0.score.asObservable()
            })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        student1.score.value = 75
        observables.value = student2
        student1.score.value = 85
        student2.score.value = 20
    }
}
