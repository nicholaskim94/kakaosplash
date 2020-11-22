//
//  PhotoDetailViewCell.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/23.
//

import UIKit

class PhotoDetailViewCell: UICollectionViewCell {
    
    public static let identifier = "PHOTO_DETAIL_VIEW_CELL"

    public var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            if let url = NSURL(string: photo.urls.regular) {
                ImageCache.shared.load(url: url, item: photo) { [weak self] _, image in
                    self?.photoImageView.image = image
                }
            }
        }
    }
    
    // MARK: UI elements
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(photoImageView)
        
        contentView.backgroundColor = .black
        
        let imageViewContraints = [
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
    
        NSLayoutConstraint.activate(imageViewContraints)
    }
}
