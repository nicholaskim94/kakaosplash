//
//  PhotoDetailViewController.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/23.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    typealias ParentViewMdoel = HasObservablePhotos & HasObservableFocusedIndex
    
    private let parentViewModel: ParentViewMdoel
    private let dependencies: Dependencies
    
    // MARK: - UI elements
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: CGRect.zero)
        let doneButtonItem = UIBarButtonItem(title: "Back",
                                             style: .done,
                                             target: self,
                                             action: #selector(back))

        navigationItem.leftBarButtonItem = doneButtonItem
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.barTintColor = .black
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.delegate = self
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        return navigationBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .black
        collectionView.register(PhotoDetailViewCell.self,
                                forCellWithReuseIdentifier: PhotoDetailViewCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()
    
    
    init(dependencies: Dependencies, parentViewModel: ParentViewMdoel) {
        self.dependencies = dependencies
        self.parentViewModel = parentViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let index = parentViewModel.focusedIndex.value {
            let indexPath = IndexPath(row: index, section: 0)
            if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
                collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            }
            
            if let photo = parentViewModel.photos.value.item(at: index) {
                title = photo.user.name
            }
        }
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
    
        view.addSubview(collectionView)
        view.addSubview(navigationBar)
        
        view.backgroundColor = .black
        
        let navigationBarContraints = [
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44)
        ]
        let collectionViewConstraints = [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(navigationBarContraints + collectionViewConstraints)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoDetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentViewModel.photos.value.count + 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let identifier = PhotoDetailViewCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! PhotoDetailViewCell

        guard let photo = parentViewModel.photos.value
            .item(at: indexPath.row) else {
            return cell
        }

        cell.photo = photo

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotoDetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingFinished(scrollView: scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            //didEndDecelerating will be called for sure
            return
        }
        scrollingFinished(scrollView: scrollView)
    }

    func scrollingFinished(scrollView: UIScrollView) {
        let scrollViewOffset = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.size.width

        if scrollViewWidth == 0 {
            return
        }

        let currentPage = Int(floor(scrollViewOffset/scrollViewWidth))

        if parentViewModel.focusedIndex.value != currentPage {
             parentViewModel.focusedIndex.value = currentPage
            
            if let photo = parentViewModel.photos.value.item(at: currentPage) {
                title = photo.user.name
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {

    // Remove spacing between blocks
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - UINavigationBarDelegate
extension PhotoDetailViewController: UINavigationBarDelegate {
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
