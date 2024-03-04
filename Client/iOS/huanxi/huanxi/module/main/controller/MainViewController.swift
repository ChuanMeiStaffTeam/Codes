//
//  MainViewController.swift
//  huanxi
//
//  Created by jack on 2024/2/18.
//

import UIKit

class MainViewController: BaseViewController {
    
    let vm = MainViewModel()
    var mainView: MainView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        mainView.reloadMainViewData(vm.mainList)
    }
    
    
    func setupView() {

        mainView = MainView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .screenHeight - .bottomSafeAreaHeight - .tabBarHeight))
        view.addSubview(mainView)
        
    }
    
    
}
