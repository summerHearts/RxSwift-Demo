//
//  RxSwiftLoginController.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Alamofire

enum ServerResponse {
    case Failure(cause: String)
    case Success
}

protocol APIServerService {
    func authenticatedLogin(username: String, password: String) -> Observable<ServerResponse>
}

protocol ValidationService {
    func validUsername(username: String) -> Bool
    func validPassword(password: String) -> Bool
}


struct LoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    let isCredentialsValid: Driver<Bool>
    let loginResponse: Driver<ServerResponse>
    
    
    init(
        dependencies:(
        APIprovider: APIServerService,
        validator: ValidationService),
        input:(
        username:Driver<String>,
        password: Driver<String>,
        loginRequest: Driver<Void>)) {
        
        
        isCredentialsValid = Driver.combineLatest(input.username, input.password) { dependencies.validator.validUsername(username: $0) && dependencies.validator.validPassword(password: $1) }
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1) }
        
        loginResponse = input.loginRequest.withLatestFrom(usernameAndPassword).flatMapLatest { (username, password) in
            
            return dependencies.APIprovider.authenticatedLogin(username: username, password: password)
                .asDriver(onErrorJustReturn: ServerResponse.Failure(cause: "Network Error"))
        }
    }
}


struct Validation: ValidationService {
    func validUsername(username: String) -> Bool {
        return username.characters.count > 4
    }
    
    func validPassword(password: String) -> Bool {
        return password.characters.count > 3
    }
}


struct APIServer: APIServerService {
    func authenticatedLogin( username: String, password: String) -> Observable<ServerResponse> {
        return Observable.just(ServerResponse.Success)
    }
}

class RxSwiftLoginController: UIViewController {

    let loginRequestPublishSubject = PublishSubject<Void>()
    let disposeBag = DisposeBag()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var viewModel: LoginViewModel = {
        LoginViewModel(
            dependencies: (
                APIprovider: APIServer(),
                validator: Validation()
            ),
            input: (
                username: self.usernameTextField.rx.text.orEmpty.asDriver(),
                password: self.passwordTextField.rx.text.orEmpty.asDriver(),
                loginRequest: self.loginButton.rx.tap.asDriver()
            )
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.isCredentialsValid.drive(loginButton.rx.isEnabled).addDisposableTo(disposeBag)
        
        viewModel.loginResponse.drive( onNext: { [weak self]  loginResponse in
            
            self?.navigationController?.pushViewController(SimpleCollectionViewController(), animated: true)
        }, onCompleted: {
        }) {
            
        }.addDisposableTo(disposeBag)
    }
}
