//
//  SplashViewController.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/18.
//

import UIKit

class SplashViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Kakaosplash, Photos for everyone"
        label.textColor = .white
        label.font = FontProvider.font(size: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.replaceRootViewController(to: PhotoListViewController())
        }
    }
    
    private func setupViews() {
        view.addSubview(label)
        
        view.backgroundColor = .black
        
        let labelConstraints = [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    private func replaceRootViewController(to viewController: UIViewController) {
        let applicationDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let window = applicationDelegate?.window else { return }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
}