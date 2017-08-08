//
//  SimpleCollectionViewController.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


struct CommonUnit {
    let marginItem = 20
    let navPlusStatus:CGFloat = 64
    let animationTime:TimeInterval = 0.33
    let delayTime:TimeInterval = 0
    let bannerHeight:CGFloat = 120
    let navbar_change_point = 50
    let cellReuse = "cell0"
    let headerReuse = "headerView"
    
    let color = UIColor(colorLiteralRed: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
}



class SimpleCollectionViewController: UIViewController,FinishAlertViewDelegate {

    var mainCollection:UICollectionView!
    let commonUse = CommonUnit()
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    private let disposeBag = DisposeBag()
    
    var episodeAlert: StructWithoutdelegate!
    var counter: PressCounter!

    func buttonPressed(at index: Int) {
        print("Go to the next episode...")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        createCollectionView()
 
        structWithOutDelegate()
    }
    
    func structWithOutDelegate (){
        
        self.episodeAlert = StructWithoutdelegate()
        // 2. Register itself
        self.episodeAlert.delegate = self
        
        
        self.counter = PressCounter()
        
        self.episodeAlert.delegateNoClass = self.counter
        
        self.episodeAlert.goToNext()
        self.episodeAlert.goToNext()
        self.episodeAlert.goToNext()
        self.episodeAlert.goToNext()
        
        print(self.counter.count)
        
        self.episodeAlert.buttonPressed = { self.counter.buttonPressed(at: $0)}
        
        
        self.episodeAlert.goToNext()
        self.episodeAlert.goToNext()
        self.episodeAlert.goToNext()
        self.episodeAlert.goToNext()
        
        print(self.counter.count)
        
        
        //MARK: - why?
        //MARK: - 这是因为PressCounter是一个值类型，当我们执行self.episodeAlert.delegate = self.counter时，delegate实际上是self.counter的拷贝，它们引用的并不是同一个对象，因此调用goToTheNext()的时候，增加的只是self.episodeAlert.delegate，而不是self.counter。
        
        //MARK: - 通过这个例子，你就知道了，去掉delegate protocol的class约束，并不是一个好主意，这不仅让class类型在实现protocol的时候引入了strong reference；而对于struct类型来说，哈，它原来根本就不配做个delegate。
    }
    
    func createCollectionView(){
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        self.view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        mainCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: commonUse.bannerHeight * 2), collectionViewLayout: layout)
        mainCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        mainCollection.backgroundColor = UIColor.white
        mainCollection.register(NumberCell.self, forCellWithReuseIdentifier: commonUse.cellReuse)
        
        
        self.view.addSubview(mainCollection)
        
        let items = Observable.just(
            (0..<5).map{"\($0)"}
        )
        
        items
            .bind(to: mainCollection.rx.items(cellIdentifier: commonUse.cellReuse, cellType: NumberCell.self)) { (row, element, cell) in
                cell.themeLabel?.text = "\(row)"
                cell.backgroundColor = UIColor.purple
            }
            .disposed(by: disposeBag)
    }
    
}
