//
//  PaymentViewController.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

typealias PaymentSectionModel = AnimatableSectionModel<DataPaymentSection, ModelPayment>

class PaymentViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView! {
        
        
        didSet{
            mainTableView.register(UINib(nibName: "PaymentCell",bundle: nil), forCellReuseIdentifier: PaymentCellIdentifier)

            mainTableView
            .rx
            .enableAutoDeselect()
            .disposed(by: rx_disposeBag)
            
            mainTableView
            .rx
            .modelSelected(ModelPayment.self)
            .bind(to: paymentSectionData.selectPayment)
            .disposed(by: rx.disposeBag)
            
        }
    }
    
    private var dataSource:RxTableViewSectionedReloadDataSource<PaymentSectionModel> {
        
        let  _dataSource = RxTableViewSectionedReloadDataSource<PaymentSectionModel>()
        _dataSource.configureCell = { ds, tb, ip, payment in
            let cell = tb.dequeueReusableCell(withIdentifier: PaymentCellIdentifier, for: ip) as? PaymentCell
            cell?.payment = payment
            let sectionData = ds[ip.section]//拿到这个组的SectionModel,里面保存了这个组选择的是哪一个
            let selectedPayment = sectionData.model.selectPayment.asObservable()
            
            selectedPayment
                .map { $0 == payment }
                .bind(to: cell!.rx.isSelectedPayment)
                .disposed(by: cell!.rx.prepareForReuseBag)
            
            return cell!
        }
        return _dataSource
        
    }
    
    let paymentSectionData = DataPaymentSection(defaultSelected: ModelPayment.alipay)
    
    var paymentSection:PaymentSectionModel {
        return PaymentSectionModel(
            model: paymentSectionData,
            items: [.alipay, .wechat, .applepay, .unionpay]);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        Observable.just([paymentSection])
            .bind(to: mainTableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        do {//title
            paymentSectionData.selectPayment.asObservable()
                .map { $0.iconAndName.name }
                .bind(to: self.rx.title)
                .disposed(by: rx.disposeBag)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
