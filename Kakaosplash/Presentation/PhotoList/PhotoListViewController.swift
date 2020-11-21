//
//  PhotoListViewController.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/18.
//

import UIKit

class PhotoListViewController: UIViewController {
    
    private let viewModel: PhotoListViewModel
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.viewModel = dependencies.makePhotoListViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
