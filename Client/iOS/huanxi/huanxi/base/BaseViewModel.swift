//
//  BaseViewModel.swift
//  huanxi
//
//  Created by rslz on 2024/12/18.
//

import RxCocoa
import RxSwift
import UIKit

class BaseViewModel: NSObject {
    var disposeBag = DisposeBag()
    
    deinit {
        print("deint ------  \(self.classForCoder)")
    }
}
