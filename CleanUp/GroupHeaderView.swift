//
//  GroupHeaderView.swift
//  CleanUp
//
//  Created by Сергей Киселев on 21.04.2025.
//

import UIKit

class GroupHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    var selectAllTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        actionButton.titleLabel?.font = .systemFont(ofSize: 16)
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, UIView(), actionButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func buttonTapped() {
        selectAllTapped?()
    }
    
    func configure(title: String, isAllSelected: Bool) {
        titleLabel.text = title
        actionButton.setTitle(isAllSelected ? "Deselect all" : "Select all", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
