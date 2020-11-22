//
//  PhotoListViewCell.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/22.
//

import UIKit

class PhotoListViewCell: UITableViewCell {
    public static let identifier = "PHOTO_LIST_VIEW_CELL"
    public var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            if let url = NSURL(string: photo.urls.small) {
                ImageCache.shared.load(url: url, item: photo) { [weak self] _, image in
                    self?.photoImageView.image = image
                }
            }
            label.text = photo.user.name
        }
    }
    
    // MARK: UI elements
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = FontProvider.font(size: 14, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(label)
        
        contentView.backgroundColor = .greyScale4
        
        let imageViewContraints = [
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ]
    
        NSLayoutConstraint.activate(imageViewContraints + labelConstraints)
    }
}
