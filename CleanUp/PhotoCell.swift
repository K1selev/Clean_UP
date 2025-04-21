//
//  PhotoCell.swift
//  CleanUp
//
//  Created by Сергей Киселев on 07.04.2025.
//

import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    let imageView = UIImageView()
    let checkmarkView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        
        imageView.layer.cornerRadius = 14
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        checkmarkView.tintColor = .systemGreen
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.image = UIImage(named: "checkbox_not")
        checkmarkView.isHidden = false
        contentView.addSubview(checkmarkView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            checkmarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            checkmarkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            checkmarkView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func setAsset(_ asset: PHAsset, selected: Bool) {
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { [weak self] image, _ in
            self?.imageView.image = image
        }
        checkmarkView.image = selected ? UIImage(named: "checkbox_yes") : UIImage(named: "checkbox_not")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
