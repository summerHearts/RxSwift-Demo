//
//  PHPPhotoLibrary+Rx.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17./02.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import Foundation
import Photos
import RxCocoa
import RxSwift

extension PHPhotoLibrary {
    static var isAuthorized :Observable<Bool> {
        
        
        return Observable.create{ observable in
            DispatchQueue.main.async {
                if  authorizationStatus() == .authorized {
                    observable.onNext(true)
                    observable.onCompleted()
                }else{
                    requestAuthorization{
                        observable.onNext($0 == .authorized)
                        observable.onCompleted()
                    }
                }
            }
            return Disposables.create {}
        }
    }
}
