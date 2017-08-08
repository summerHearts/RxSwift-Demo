//
//  RxTableViewController.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


extension Reactive where Base: UITableView {
    
    var didHighlightRowAt: ControlEvent<IndexPath> {
        let selector = #selector(UITableViewDelegate.tableView(_:didHighlightRowAt:))
        let events = delegate
            .methodInvoked(selector)
            .filter({ ($0.last as? IndexPath) != nil })
            .map({ $0.last as! IndexPath })
        return ControlEvent(events: events)
    }
}


class RxTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
            
            tableView.rx
                .itemSelected
                .subscribe { (indexPath) in
                    UserDefaults.standard.set("\(indexPath)", forKey: "key")
                   
                    self.navigationController?.pushViewController(RxSwiftLoginController(), animated: true)
                    
                }
                .disposed(by: disposeBag)
        }
    }
    
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .subscribe({ e in
                print(e)
            })
            .addDisposableTo(disposeBag)
        
        
        UserDefaults.standard.rx
            .observe(String.self, "key")
            .debounce(0.1, scheduler: MainScheduler.asyncInstance) //iOS bug, v10.2  必须要加这句话
            .subscribe(onNext: { (value) in
                if let value = value {
                    print(value)
                }
            })
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>()
        
        dataSource.configureCell = { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = item
            
            return cell
        }
        
        /*
         •tableView.rx.items是在可观察序列上运行的绑定函数
         元素（如Observable <[String]>）。
         •绑定创建一个不可见的ObserverType对象，它可以订阅您的
         序列，并将其自身设置为数据源和表视图的委托。
         •当一个新的元素数组在observable上传递时，绑定重新加载
         表视图。
         •要获取每个项目的单元格，RxCocoa会为重新加载的行的详细信息（和日期）调用闭包。
         */
        
        Observable.just([SectionModel(model: "", items: (0..<5).map({ "\($0)" }))])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        let observable = UITableView().rx.didHighlightRowAt.asObservable()
        observable.subscribe{ (indexPath) in
            
        }.disposed(by: disposeBag)
        
        //通过设置dataSource.sections达到刷新tableView 的目的
        dataSource.setSections([SectionModel(model: "", items: (0..<10).map({ "\($0)" }))])


    }
}
