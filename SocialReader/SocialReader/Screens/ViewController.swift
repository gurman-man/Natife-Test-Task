//
//  ViewController.swift
//  SocialReader
//
//  Created by mac on 14.01.2026.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Enums
    // Section for DiffableDataSource
    enum Section {
        case main
    }
    
    // MARK: - Properties
    private let viewModel = PostListViewModel()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Post>!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        bindViewModel()
        
        // start dowloading
        viewModel.loadData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Social Reader"
        navigationItem.backButtonTitle = ""
        
        let layout = createLayout()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // stretching to full size
        collectionView.backgroundColor = .systemGroupedBackground
        
        collectionView.delegate = self
        
        // Register cell
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseId)
        view.addSubview(collectionView)
    }
    
    // MARK: - Setup Navigation
    private func setupNavigation() {
        
    }
    
    // MARK: - Composition Layout
    private func createLayout() -> UICollectionViewLayout {
        
        // 1. Item (one cell)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 2. Group (cell's group, vertically)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group =  NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 3. Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10 // paddind between posts
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Data Source (Diffable)
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: collectionView) { [weak self] (collectionView, indexPath, post) -> UICollectionViewCell? in
            
            // Verify Cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseId, for: indexPath) as? PostCell else {
                return UICollectionViewCell()
            }
            
            // Configure Cell
            cell.configure(with: post)
            
            // Handling button "Expand"
            cell.onExpandTap = {
                self?.viewModel.tooglePostStage(postId: post.postId)
            }
            
            return cell
        }
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        // Notify the view to update when data changes
        viewModel.onStateChanged = { [weak self] in
            self?.updateSnapshot()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    // Updates the collection view content by applying a new data snapshot
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.posts)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailVC = DetailViewController(postId: post.postId)
        navigationController?.pushViewController(detailVC, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

