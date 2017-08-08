//
//  Edisode.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit

//通过关键字final限制了它不能继续被继承
final class Edisode: NSObject {
    var title : String
    var type  : String
    var length : Int
    //自定义描述文件
    override var description: String {
        return title + "\t" + type + "\t" + String(length)
    }
    
    init(title: String ,type: String ,length: Int) {
        self.title = title
        self.type = type
        self.length = length
    }
}
