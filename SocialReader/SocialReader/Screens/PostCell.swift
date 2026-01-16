//
//  PostCell.swift
//  SocialReader
//
//  Created by mac on 15.01.2026.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    static let reuseId = "PostCell"
    
    // Closure for handling button
    var onExpandTap: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 2 // default expand
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Expand", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    // Standard initializer for code-based UI
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Required initializer for Storyboard support (not used here)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    // Add all items to ContentView
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(expandButton)
        contentView.addSubview(likesLabel)
        contentView.addSubview(dateLabel)
        
        // UI
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    // Congigure Consraints
    private func setupConstraints() {
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            // 1. TITLE (up)
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // 2. BODY (under Title)
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // 3. EXPAND BUTTTON (under Body)
            expandButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            expandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            expandButton.heightAnchor.constraint(equalToConstant: 20),
            expandButton.widthAnchor.constraint(equalToConstant: 100),
            
            // 4. LIKES & DATE (under Button)
            likesLabel.topAnchor.constraint(equalTo: expandButton.bottomAnchor, constant: 12),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            dateLabel.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // 5. Binding to the bottom (Bottom Anchor)
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.previewText
        likesLabel.text = "♥️ \(post.likesCount)"
        
        // Date conversion
        let date = Date(timeIntervalSince1970: post.timeshamp)
        let formetter = DateFormatter()
        formetter.dateStyle = .medium
        dateLabel.text = formetter.string(from: date)
        
        let buttonTitle = post.isExpanded ? "Collapse" : "Expand"
        expandButton.setTitle(buttonTitle, for: .normal)
        bodyLabel.numberOfLines = post.isExpanded ? 0 : 2
    }
    
    // MARK: - Actions

    @objc func expandButtonTapped() {
        onExpandTap?()
    }
}
