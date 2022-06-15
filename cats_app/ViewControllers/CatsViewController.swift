//
//  CatsViewController.swift
//  cats_app
//
//  Created by Alejandra on 14/6/22.
//

import UIKit

class CatsViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var headerLabel = UILabel.newHeaderLabel()
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var refreshControl = UIRefreshControl()
    
    private var cats: [Cat] = []
    private var catImages: [UIImage] = []
    private var dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup UI
private extension CatsViewController {
    func setup() {
        setupViews()
        setupCollectionView()
        setupUI()
        Task {
            await loadData()
            notifyAllCatsLoaded()
        }
    }
    
    func setupViews() {
        view.addSubview(headerLabel)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }
    
    func setupLayout() {
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        collectionView.register(
            CatCollectionViewCell.self,
            forCellWithReuseIdentifier: CatCollectionViewCell.cellIdentifier
        )
    }
    
    func setupUI() {
        view.backgroundColor = .white
        headerLabel.text = "My cats"
    }
}

// MARK: - Load Data
private extension CatsViewController {
    
    func loadData() async {
        showLoader()
        do {
            cats = try await ApiManager.shared.getDecodedData(from: .getAllCats(limit: 24))
            await getCatsImages()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCatsImages() async {
        for var i in 0..<cats.count {
            let id = cats[i].id
            await getCatImage(for: id)
            i += 1
        }
    }
    
    func getCatImage(for id: String) async {
        dispatchGroup.enter()
        do {
            let imageData: Data = try await ApiManager.shared.getData(from: .getCat(id))
            if let image = UIImage(data: imageData) {
                catImages.append(image)
            }
            dispatchGroup.leave()
        } catch {
            print(error.localizedDescription)
            dispatchGroup.leave()
        }
    }
    
    func notifyAllCatsLoaded() {
        dispatchGroup.notify(queue: .main) {
            self.hideLoader()
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Handlers
private extension CatsViewController {
    @objc func didRefresh() {
        refreshControl.endRefreshing()
        cleanup()
        Task {
            await loadData()
            notifyAllCatsLoaded()
        }
    }
}

// MARK: - Helper
private extension CatsViewController {
    func showLoader() {
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
    }
    
    func cleanup() {
        cats = []
        catImages = []
        collectionView.reloadData()
    }
}

// MARK: - Compositional Layout Setup
private extension CatsViewController {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2
        )
        
        let verticalStackItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.5)
            )
        )
        
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2
        )
        
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            ),
            subitem: verticalStackItem,
            count: 2
        )
        
        let tripletStackItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        tripletStackItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2
        )
        
        let tripletStackGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.3)
            ),
            subitem: tripletStackItem,
            count: 3
        )
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.7)
            ),
            subitems: [
                item,
                verticalStackGroup]
        )
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [
                horizontalGroup,
                tripletStackGroup]
        )
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDataSource Methods
extension CatsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CatCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? CatCollectionViewCell
        cell?.image = catImages[indexPath.item]
        return cell ?? UICollectionViewCell()
    }
}
