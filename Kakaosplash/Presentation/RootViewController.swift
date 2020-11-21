//
//  RootViewController.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/21.
//

import UIKit

class RootViewController: UIViewController {
        
    var current: UIViewController
    var dependencies: Dependencies

    init() {
        self.dependencies = Dependencies()
        self.current = SplashViewController(dependencies: dependencies)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}
