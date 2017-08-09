//
//  CartViewController.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/8/9.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import NSObject_Rx

/*
 代码中变量类型都是CGPoint和Double，不能清晰的表达业务需求。所以，我们可以通过typealias进行改造
 */
typealias ProductSectionModel = AnimatableSectionModel<String, ProductModel>


class CartViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!{
        didSet{
            //自动反选操作
            mainTableView.rx
                .enableAutoDeselect()
                .disposed(by: rx_disposeBag)
        }
    }
    
    @IBOutlet weak var priceLbl: UILabel!

    //MARK: - 在didSet中做一些UI 控件的样式操作，或者刷新操作都是可以的
    @IBOutlet weak var buyBtn: UIButton! {
        didSet{
            buyBtn.layer.masksToBounds = true
            buyBtn.layer.borderWidth = 0.5
            buyBtn.layer.cornerRadius = 5
            buyBtn.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ProductSectionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let products = [1,2,3,4,5].map {
            ProductModel(productId: 1000 + $0 , name: "Product\($0)", unitPrice: $0 * 100 ,count: Variable(0))
        };

        //数据源信号
        let sectionInfo = Observable.just([ProductSectionModel(model: "Section1", items: products)])
            .shareReplay(1)
        
        mainTableView.register(UINib(nibName: "ProductCell",bundle: nil), forCellReuseIdentifier: ProductCellIdentifier)

        
        dataSource.configureCell = { _, tableView, indexPath, product in
            let cell = tableView.dequeueReusableCell(withIdentifier:ProductCellIdentifier, for: indexPath) as? ProductCell
            cell?.product = product
            return cell!
        }
        
        sectionInfo
            .bind(to: mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        let totalPrice = sectionInfo.map{  //先把所有组中的元素摊平成一个数组
            $0.flatMap{
                $0.items
            }
            }.flatMap{
                $0.reduce(.just(0)){acc,x in
                    
                    Observable.combineLatest(acc,x.count.asObservable().map{
                        x.unitPrice * $0
                    },resultSelector: +)
                }
            }
            .shareReplay(1)
        
        totalPrice
            .map { "总价：\($0) 元" }
            .bind(to: priceLbl.rx.text)
            .disposed(by: rx.disposeBag)
        
        totalPrice
            .map { $0 != 0 }
            .bind(to: buyBtn.rx.isEnabled)
            .disposed(by: rx.disposeBag)
    }
}
