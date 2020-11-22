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

    // MARK: - UI elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        tableView.register(PhotoListViewCell.self,
                           forCellReuseIdentifier: PhotoListViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()
    
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
        
        setupViews()
        
        bindToViewModel()
        viewModel.fetchPhotoList()
    }
    
    
    
    private func setupViews() {
        view.addSubview(tableView)
        
        view.backgroundColor = .black
        
        let tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    private func bindToViewModel() {
        
        viewModel.photos.bind { [weak self] photos in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        viewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.showError(message: error.localizedDescription)
            }
        }
        
        viewModel.focusedIndex.bind { [weak self] index in
            guard let index = index else { return }

            DispatchQueue.main.async { [weak self] in
                let indexPath = IndexPath(row: index, section: 0)
                self?.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
            }
        }
    }
    
    
    private func showError(message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PhotoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.value.count + 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = PhotoListViewCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! PhotoListViewCell

        guard let photo = viewModel.photos.value
            .item(at: indexPath.row) else {
            return cell
        }

        cell.photo = photo

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.focusedIndex.value = indexPath.row
        
        let viewController = PhotoDetailViewController(dependencies: dependencies, parentViewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let photo = viewModel.photos.value
            .item(at: indexPath.row) else {
            return 0
        }
        
        let ratio = CGFloat(photo.height) / CGFloat(photo.width)
        let cellHeight = tableView.bounds.width * ratio
        
        return cellHeight
    }
}

// MARK: - UITableViewDataSourcePrefetching {
extension PhotoListViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchNextPhotoListPage()
        }
    }
}

private extension PhotoListViewController {

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        let photosCount = viewModel.photos.value.count
        return indexPath.row >= photosCount
    }
}
