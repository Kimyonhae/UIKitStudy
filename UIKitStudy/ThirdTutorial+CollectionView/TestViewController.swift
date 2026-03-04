import UIKit


final class TestViewController: UIViewController {
    
    private let colors: [[UIColor]] = [
        [.systemRed, .systemRed, .systemRed],
        [.systemBlue, .systemBlue,.systemBlue, .systemBlue],
        [.systemYellow, .systemYellow, .systemYellow, .systemYellow, .systemYellow],
    ]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.backgroundColor = .red
        
        return c
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<TestSection, Item>!
    
    private var dataSection: [[TestSection]] = [
        [
            TestSection.first(Item(color: .systemRed)),
            TestSection.first(Item(color: .systemRed)),
            TestSection.first(Item(color: .systemRed)),
        ],
        [
            TestSection.second(Item(color: .systemBlue)),
            TestSection.second(Item(color: .systemBlue)),
            TestSection.second(Item(color: .systemBlue)),
        ],
        [
            TestSection.third(Item(color: .systemYellow)),
            TestSection.third(Item(color: .systemYellow)),
            TestSection.third(Item(color: .systemYellow)),
            TestSection.third(Item(color: .systemYellow)),
            TestSection.third(Item(color: .systemYellow)),
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpDataSource()
        setUpCollectionViewConstraint()
        setUpNav()
    }

    private func setUpCollectionView() {
        
        collectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: TestCollectionViewCell.reuseIdentifier)
        collectionView.register(TestHeaderCollectionViewCell.self, forSupplementaryViewOfKind: TestHeaderCollectionViewCell.reuseIdentifier, withReuseIdentifier: TestHeaderCollectionViewCell.reuseIdentifier)
        collectionView.register(TestFooterCollectionViewCell.self, forSupplementaryViewOfKind: TestFooterCollectionViewCell.reuseIdentifier, withReuseIdentifier: TestFooterCollectionViewCell.reuseIdentifier)
        
        collectionView.setCollectionViewLayout(
            createLayout(),
            animated: false
        )
    }
    
    private func setUpCollectionViewConstraint() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setUpNav() {
        title = "DiffableSource"
        let right = UIBarButtonItem(title: "Plus", image: UIImage(systemName: "plus"), primaryAction: UIAction { [weak self] _ in
            self?.addItem()
        })

        let left = UIBarButtonItem(title: "Minus", image: UIImage(systemName: "minus"), primaryAction: UIAction {[weak self] _ in
            self?.minusItem()
        })
        navigationItem.rightBarButtonItems = [left, right]
    }
    
    private func addItem() {
        dataSection[2].append(TestSection.third(Item(color: .yellow)))
        updateDataSource()
    }
    
    private func minusItem() {
        dataSection[2].removeLast()
        updateDataSource()
    }
    
}


// MARK: - Helper Funciton
extension TestViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            let section = self?.dataSource.sectionIdentifier(for: sectionIndex)
            switch section {
                case .first:
                    return self?.getSection(
                                itemWidth: .fractionalWidth(1),
                                itemHeight: .absolute(100),
                                groupWidth: .fractionalWidth(1),
                                groupHeight: .absolute(100),
                                scrollBehavior: .continuousGroupLeadingBoundary
                            )
                case .second:
                    return self?.getSection(
                                itemWidth: .fractionalWidth(1 / 3),
                                itemHeight: .absolute(100),
                                groupWidth: .fractionalWidth(1),
                                groupHeight: .absolute(100),
                                scrollBehavior: .continuous,
                                interItemSpacing: 10,
                                interGroupSpacing: 10,
                                contentInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10),
                                headerHeight: 50.0,
                                footerHeight: 50.0
                            )
                case .third:
                    return self?.getSection(
                                itemWidth: .fractionalWidth(1 / 3),
                                itemHeight: .absolute(100),
                                groupWidth: .fractionalWidth(1),
                                groupHeight: .absolute(100),
                                interItemSpacing: 10,
                                interGroupSpacing: 10,
                                contentInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                            )
                default: return self?.emptySection()
            }
        }
    }
    
    func getSection(
        itemWidth: NSCollectionLayoutDimension,
        itemHeight: NSCollectionLayoutDimension,
        groupWidth: NSCollectionLayoutDimension,
        groupHeight: NSCollectionLayoutDimension,
        scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
        interItemSpacing: CGFloat = 0,
        interGroupSpacing: CGFloat = 0,
        contentInsets: NSDirectionalEdgeInsets = .zero,
        headerHeight: CGFloat? = nil,
        footerHeight: CGFloat? = nil
    ) -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: itemWidth, heightDimension: itemHeight)
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: groupWidth, heightDimension: groupHeight)
        
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(interItemSpacing)
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = scrollBehavior
        section.boundarySupplementaryItems = []
        
        if let headerHeight = headerHeight {
            let headerSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight))
            let header: NSCollectionLayoutBoundarySupplementaryItem = .init(
                layoutSize: headerSize,
                elementKind: TestHeaderCollectionViewCell.reuseIdentifier,
                alignment: .top,
                absoluteOffset: .zero
            )
            section.boundarySupplementaryItems.append(header)
        }
        
        if let footerHeight = footerHeight {
            let footerSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(footerHeight))
            let footer: NSCollectionLayoutBoundarySupplementaryItem = .init(
                layoutSize: footerSize,
                elementKind: TestFooterCollectionViewCell.reuseIdentifier,
                alignment: .bottom,
                absoluteOffset: .zero
            )
            section.boundarySupplementaryItems.append(footer)
        }
        
        return section
    }
    
    func emptySection(height: CGFloat = 0) -> NSCollectionLayoutSection {
        getSection(
            itemWidth: .fractionalWidth(1),
            itemHeight: .absolute(height),
            groupWidth: .fractionalWidth(1),
            groupHeight: .absolute(height)
        )
    }
}

// MARK: DiffableDataSource Function
extension TestViewController {
    
    private func setUpDataSource() {
        createDataSource()
        updateDataSource()
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, identifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.reuseIdentifier, for: indexPath) as! TestCollectionViewCell
            
            let section = self?.dataSection[indexPath.section][indexPath.item]
            switch section {
                case .first(let item): if let item = item {cell.backgroundColor = item.color}
                case .second(let item): if let item = item {cell.backgroundColor = item.color}
                case .third(let item): if let item = item {cell.backgroundColor = item.color}
                default: cell.backgroundColor = .clear
            }
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.black.cgColor
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
                case TestHeaderCollectionViewCell.reuseIdentifier:
                    let cell: TestHeaderCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TestHeaderCollectionViewCell.reuseIdentifier, for: indexPath) as! TestHeaderCollectionViewCell
                        cell.backgroundColor = .black
                        return cell
                case TestFooterCollectionViewCell.reuseIdentifier:
                    let cell: TestFooterCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TestFooterCollectionViewCell.reuseIdentifier, for: indexPath) as! TestFooterCollectionViewCell
                        cell.backgroundColor = .white
                        return cell
                default: return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: UICollectionReusableView.description(),
                    for: indexPath
                )
            }
        }
    }
    
    private func updateDataSource() {
        var snapshot: NSDiffableDataSourceSnapshot<TestSection, Item> = .init()
        for section in self.dataSection {
            let sectionName = section[0]
            var items: [Item] = []
            section.forEach { key in
                switch key {
                case .first(let item):
                    if let item = item {
                        items.append(item)
                    }
                case .second(let item):
                    if let item = item {
                        items.append(item)
                    }
                case .third(let item):
                    if let item = item {
                        items.append(item)
                    }
                }
            }
            
            snapshot.appendSections([sectionName])
            snapshot.appendItems(items, toSection: sectionName)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

#Preview {
    UINavigationController(rootViewController: TestViewController())
}


final class TestCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TestCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TestHeaderCollectionViewCell: UICollectionReusableView {
    
    static let reuseIdentifier: String = "TestHeaderCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TestFooterCollectionViewCell: UICollectionReusableView {
    
    static let reuseIdentifier: String = "TestFooterCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
