//
//  ViewController.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

enum Count {
    case add
    case subtract
    case custom(Int)
}

enum CustomError: Error {
    case somethingWrong
}
class ViewController: UIViewController {

    
    @IBOutlet weak var pushButton: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var subtractButton: UIButton!
    
    @IBOutlet weak var countTextField: UITextField!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushButton.rx.tap.subscribe { [weak self] (event : Event<()>) in
            
           self?.navigationController?.pushViewController(PaymentViewController(), animated: true)
            
        }.addDisposableTo(bag)
        
        button2.rx.tap.subscribe { [weak self] (event : Event<()>) in
            
            self?.navigationController?.pushViewController(RxTableViewController(), animated: true)
            
        }.addDisposableTo(bag)
        
        button3.rx.tap.subscribe { [weak self] (event : Event<()>) in
            
            self?.navigationController?.pushViewController(RxSwiftLoginController(), animated: true)
            
        }.addDisposableTo(bag)
        
        addButton.rx.tap.subscribe { [weak self] (event : Event<()>) in
            
            self?.navigationController?.pushViewController(RxSwiftTwoWayBindController(), animated: true)
            
        }.addDisposableTo(bag)
        
        subtractButton.rx.tap.subscribe { [weak self] (event : Event<()>) in
            
            self?.navigationController?.pushViewController(CartViewController(), animated: true)
        
        }.addDisposableTo(bag)
        
        sendMethodS()
    
    }
    
    //MARK: - 链中间的一些Observable处理
    func chainObserver(){
        //情况是我有一个长链（像a，b，c，d，e，...），我想在链中间的一些Observable,那么该怎么处理呢
        
        let a = PublishSubject<Int>()
        let b = PublishSubject<Int>()
        let c = PublishSubject<Int>()
        
        a.bind(to: b).addDisposableTo(bag)
        b.bind(to: c).addDisposableTo(bag)
        
        c.subscribe(onNext: {
            print($0) // called
        }).addDisposableTo(bag)
        
        
        let d = a.do(onNext: {
            print($0)
        })
        Observable.of(b, c, d).merge().subscribe(onNext: {
            print($0) // called
        }).addDisposableTo(bag)
    
        a.onNext(1)
        a.onNext(2)
    }
    
    func sendMethodS(){
        
        //实际上，NSObject.rx.sentMessage和NSObject.rx.methodInvoked是基于方法swizzling，基于Swift方法调用的v表，它不受方法swizzling的影响。
        // 如果要在swift中使用objc_msgSend方法，可以在函数上使用动态修饰符。
        
        let list = SortViewController()
        
        list.rx.sentMessage(#selector(SortViewController.hello)).subscribe(onNext: {
            print($0)
        }).addDisposableTo(bag)
        
        list.rx.sentMessage(#selector(SortViewController.viewDidAppear(_:))).subscribe(onNext: {
            print($0)
        }).addDisposableTo(bag)
        
        list.viewDidAppear(true)
        list.hello()
    }
    
    func filterArray (){
        var allCites: Variable<[CiteModel?]> = Variable([])
        var searchQuery: Variable<String> = Variable("")
        
        let model1 = CiteModel()
        model1.cite = "131"
        
        let model2 = CiteModel()
        model2.cite = "331"
        
        let model3 = CiteModel()
        model3.cite = "121"
        
        let model4 = CiteModel()
        model4.cite = "1224"
        
        allCites.value = [model1, model2, model3]
        
        
        //通过combineLatest我们可以很容易实现两者任意一个改变都去改变输出结果的效果
        var shownCites: Observable<[CiteModel?]> = Observable.combineLatest(allCites.asObservable(), searchQuery.asObservable()) { allCites, query in
            allCites.filter { ($0?.cite.contains(query))! }
        }
        
        func filterCitesByQuery(query: String) {
            searchQuery.value = query
        }
        
        
        filterCitesByQuery(query: "2")
        
        shownCites.subscribe {  (event: Event<[CiteModel?]>) in
            //guard： 用来处理提前返回，给str重新赋值，如果str=nil，直接return。优点是防止代码嵌套过多
            guard event.element != nil else { return }
            
            for element in event.element! {
                print(element?.cite ?? "")
            }
            }.addDisposableTo(bag)
        
        
        allCites.value = [model1, model2, model3,model4]
        
        //通过Observable.from 将每一个元素都传递出来
        allCites.asObservable()
            .flatMap { CiteModel in
                Observable.from(CiteModel) // <- magic here
            }
            .subscribe(onNext: { item in
                print(item?.cite ?? "")
            })
            .addDisposableTo(bag)
    }
    
    //MARK: - 单选操作
    func rxRedio(){
        // force unwrap to avoid having to deal with optionals later on
        let buttons = [self.pushButton, self.button2, self.button3].map { $0! }
        
        // create an observable that will emit the last tapped button (which is
        // the one we want selected)
        let selectedButton = Observable.from(
            buttons.map { button in
                button.rx.tap.map { button }
            }
            ).merge()
        
        // for each button, create a subscription that will set its `isSelected`
        // state on or off if it is the one emmited by selectedButton
        buttons.reduce(Disposables.create()) { disposable, button in
            let subscription = selectedButton.map { $0 == button }
                .bind(to: button.rx.isSelected)
            
            // combine two disposable together so that we can simply call
            // .dispose() and the result of reduce if we want to stop all
            // subscriptions
            return Disposables.create(disposable, subscription)
            }
            .addDisposableTo(bag)
    }

    func rxNotification(){
        
        self.pushButton.rx.tap.subscribe {  (event: Event<()>) in
             NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "121"), object: nil)
        }.addDisposableTo(bag)
        
        let a = NotificationCenter.default.rx.notification(NSNotification.Name.UIApplicationWillEnterForeground)
        let b = NotificationCenter.default.rx.notification(Notification.Name(rawValue: "121"))
        
        Observable.of(a, b)
            .merge()
            .takeUntil(self.rx.deallocated)
            .subscribe{ _ in
                print("如何合并两个通知")
            }.addDisposableTo(bag)
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "121")).subscribe { _ in
        
        }.addDisposableTo(bag)

    }
    
    func rxEventOperator(){
        let rxEventOperator = RxSwiftEventOperator()
        rxEventOperator.elementAt()
        rxEventOperator.filterOperator()
        rxEventOperator.takeOperator()
        rxEventOperator.takeWhileOperator()
        rxEventOperator.takeWhileWithIndexOperator()
        rxEventOperator.takeUntilOperator()
    }
    
    func rxIgnoreOperators(){
        let rxIgnoreOperators = RxSwiftIgnoreOperators()
        rxIgnoreOperators.ignoreElements()
        rxIgnoreOperators.skipElements()
        rxIgnoreOperators.skipWhileElements()
        rxIgnoreOperators.skipUntilElements()
        rxIgnoreOperators.distinctUntilChangedElements()
    }
    
    func rxtransformingOperators() {
        let transformingOperators = RxSwiftTransformingOperators()
        transformingOperators.mapOperator()
        transformingOperators.flatmapOperator()
    }
    
    func rxCombination (){
        let combination = RxSwiftCombination()
        combination.startWith()
        combination.merge()
        combination.zip()
        combination.combineLatests()
        combination.switchLatest()
        
    }

    func rxSubject (){
        let subject =  RxSwiftSubject()
        subject.publicSubject()
        subject.behaviorSubject()
        subject.replaySubject()
        subject.asyncSubject()
        subject.variable()
    }
    
    func rxDemo() {
        
        let  eventNumberObservable =  Observable.from(["1","2","3","4","5","6","7"]).map{ Int($0) }.filter {
            if let item = $0 , item % 2  == 0   {
                print("event: \(item)")
                return true
            }
            
            return false
        }
        
        
        eventNumberObservable.subscribe { event in
            print("event: \(event)")
            }.addDisposableTo(bag)
        
        
        eventNumberObservable.skip(2).subscribe(onNext: { event in
            print(event ?? "")
        }, onError: { error in
            print(error.localizedDescription)
        }, onCompleted: {
            print("completed")
        }) {
            print("disposable")
            }.addDisposableTo(bag)
        
        
        _ = Observable<Int>.create{ observer in
            
            // next event
            observer.onNext(10)
            
            observer.onNext(11)
            
            // complete event
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        
        let customOb = Observable<Int>.create { observer in
            // next event
            observer.onNext(10)
            
            observer.onError(CustomError.somethingWrong)
            
            observer.onNext(11)
            
            // complete event
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        
        customOb.subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Game over") }
            ).addDisposableTo(bag)
    }
    
}

