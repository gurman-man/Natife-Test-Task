//
//  DetailViewController.swift
//  SocialReader
//
//  Created by mac on 16.01.2026.
//

import UIKit

class DetailViewController: UIViewController {

    private let postId: Int
    
    // MARK: - UI Elements
    
    // Spinner
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // Main Container for scroll
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    // Vertically stack for: image, header, text
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Horizontally stack for: date & likes
    private let footerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Content elements
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.heightAnchor.constraint(equalToConstant: 250).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemRed
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    
    init(postId: Int) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

    
    // MARK: - Setup UI
    
    private func setupUI() {
            view.backgroundColor = .systemBackground
            title = "Post Details"
            
            // 1. Add ScrollView
            view.addSubview(scrollView)
            
            // 2. Add StackView inside ScrollView
            scrollView.addSubview(contentStackView)
            
            // 3. Add spinner
            view.addSubview(activityIndicator)
            
            // 4. ScrollView Constraints
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            // 5. StackView Constraints
            NSLayoutConstraint.activate([
                contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
                contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                
                contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
            ])
            
            // 6. Fill the Vertically stack
            contentStackView.addArrangedSubview(postImageView)
            contentStackView.addArrangedSubview(titleLabel)
            contentStackView.addArrangedSubview(descriptionLabel)
        
            // 7. Fill the Horizontally stack
            footerStack.addArrangedSubview(likesLabel)
            footerStack.addArrangedSubview(dateLabel)
            contentStackView.addArrangedSubview(footerStack)
        }
    
    // MARK: - Data Loading
    
    private func loadData() {
        activityIndicator.startAnimating()
        
        Task {
            do {
                // Fetch post details from the network
                let detail = try await NetworkService.shared.fetchPostDetails(id: postId)
                
                await MainActor.run {
                    updateUI(with: detail)
                    activityIndicator.stopAnimating()
                }
            } catch {
                await MainActor.run {
                    activityIndicator.stopAnimating()
                    showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(with detail: PostDetail) {
        titleLabel.text = detail.title
        descriptionLabel.text = detail.text
        likesLabel.text = "♥️ \(detail.likesCount)"
        
        let date = Date(timeIntervalSince1970: detail.timeshamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = formatter.string(from: date)
        
        // Start asynchronous image loading from ext
        postImageView.loadImage(from: detail.postImage)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
