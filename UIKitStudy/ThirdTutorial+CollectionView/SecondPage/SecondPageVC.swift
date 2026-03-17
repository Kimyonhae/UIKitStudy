import UIKit

final class SecondPageVC: UIViewController {
    
    // MARK: - State
    
    let colors: [[UIColor]] = [
        [
            .secondarySystemBackground,
            .systemYellow,
            .secondarySystemBackground,
            .systemYellow
        ],
    ]
    
    // MARK: - UI Component
    
    private let topContent: SecondPageVC_TopContent = .init()
    private let bottomContent: UICollectionView = {
        let layout: UICollectionViewLayout = .init()
        let b = UICollectionView(frame: .zero, collectionViewLayout: layout)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 20
        b.showsVerticalScrollIndicator = false
        b.showsHorizontalScrollIndicator = false
        return b
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .secondarySystemBackground
        setUpTopLayout()
        setUpCollectionView()
        setUpBottomLayoutConstraint()
        bottomContentRegisterCell()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Layout Constraint
    
    private func setUpTopLayout() {
        topContent.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContent)
        
        NSLayoutConstraint.activate([
            topContent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topContent.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
        ])
    }
    
    private func setUpCollectionView() {
        bottomContent.delegate = self
        bottomContent.dataSource = self
    }
    
    private func setUpBottomLayoutConstraint() {
        view.addSubview(bottomContent)
        
        NSLayoutConstraint.activate([
            bottomContent.topAnchor.constraint(equalTo: topContent.bottomAnchor, constant: 12),
            bottomContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            bottomContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            bottomContent.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func bottomContentRegisterCell() {
        bottomContent.register(SecondPageCell.self, forCellWithReuseIdentifier: SecondPageCell.reuseIdentifier)
        bottomContent.register(
            SecondPageCollectionHeaderCell.self,
            forSupplementaryViewOfKind: SecondPageCollectionHeaderCell.reuseIdentifier,
            withReuseIdentifier: SecondPageCollectionHeaderCell.reuseIdentifier
        )
        bottomContent.setCollectionViewLayout(
            createLayout(),
            animated: false
        )
    }
}

// MARK: - Create UICollectionViewCompositionalLayout function
extension SecondPageVC {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            self?.createSection(
                itemWidth: .fractionalWidth(1.0),
                itemHeight: .absolute(100),
                groupWidth: .fractionalWidth(1.0),
                groupHeight: .absolute(100),
                interGroupSpacing: 10,
                contentInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10),
                headerHeight: 80,
            )
        }
    }
    
    private func createSection(
        itemWidth: NSCollectionLayoutDimension,
        itemHeight: NSCollectionLayoutDimension,
        groupWidth: NSCollectionLayoutDimension,
        groupHeight: NSCollectionLayoutDimension,
        interItemSpacing: NSCollectionLayoutSpacing = .fixed(0),
        interGroupSpacing: CGFloat = 0.0,
        contentInsets: NSDirectionalEdgeInsets = .zero,
        headerHeight: CGFloat? = nil,
        scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none
    ) -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: itemWidth, heightDimension: itemHeight)
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: groupWidth, heightDimension: groupHeight)
        
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = interItemSpacing
        let section: NSCollectionLayoutSection = .init(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = contentInsets
        section.orthogonalScrollingBehavior = scrollBehavior
        section.boundarySupplementaryItems = []
        // Header Content 추가
        if let headerHeight = headerHeight {
            let headerContent: NSCollectionLayoutBoundarySupplementaryItem = .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(headerHeight)),
                elementKind: SecondPageCollectionHeaderCell.reuseIdentifier,
                alignment: .top,
                absoluteOffset: .zero
            )
            headerContent.pinToVisibleBounds = true
            
            section.boundarySupplementaryItems.append(headerContent)
        }
        
        return section
    }
}

// MARK: - CollectionView DataSource, Delegate
extension SecondPageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondPageCell.reuseIdentifier, for: indexPath) as! SecondPageCell
        
        cell.backgroundColor = colors[indexPath.section][indexPath.item]
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1.0
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case SecondPageCollectionHeaderCell.reuseIdentifier:
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SecondPageCollectionHeaderCell.reuseIdentifier, for: indexPath)
                cell.backgroundColor = .white
                return cell
            default: return UICollectionReusableView()
        }
    }
}

#Preview {
    let tabBar = UITabBarController()
    
    // Home
    let homeVC = SecondPageVC()
    let homeNav = UINavigationController(rootViewController: homeVC)
    homeVC.navigationController?.setNavigationBarHidden(true, animated: false)
    homeNav.tabBarItem = UITabBarItem(
        title: "Home",
        image: UIImage(systemName: "house"),
        tag: 0
    )

    // Profile
    let test1 = TestVC1()
    let testNav = UINavigationController(rootViewController: test1)
    testNav.tabBarItem = UITabBarItem(
        title: "test1",
        image: UIImage(systemName: "cross.circle"),
        tag: 1
    )

    let test2 = TestVC2()
    let testNav2 = UINavigationController(rootViewController: test2)
    testNav2.tabBarItem = UITabBarItem(
        title: "test2",
        image: UIImage(systemName: "flask.fill"),
        tag: 2
    )
    
    let test3 = TestVC3()
    let testNav3 = UINavigationController(rootViewController: test3)
    testNav3.tabBarItem = UITabBarItem(
        title: "test3",
        image: UIImage(systemName: "staroflife"),
        tag: 3
    )
    
    tabBar.viewControllers = [homeNav, testNav, testNav2, testNav3]

    return tabBar
}

// MARK: - UICollectionReuseCell

final class SecondPageCollectionHeaderCell: UICollectionReusableView {
    
    static let reuseIdentifier: String = "SecondPageCollectionHeaderCell"
    
    // MARK: - UI Component
    
    private let capsule: UIView = {
        let c = UIView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.backgroundColor = .secondarySystemBackground
        c.layer.cornerRadius = 5
        
        return c
    }()
    private let title: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = .systemFont(ofSize: 24, weight: .semibold)
        t.text = "Special For You"
        
        return t
    }()
    
    private let button: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "See all"
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .systemGray2
        
        // 글꼴 사이즈 제어
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            return outgoing
        }
        
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        
        return b
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraint
    private func setUpConstraint() {
        addSubview(capsule)
        addSubview(title)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            capsule.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            capsule.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsule.widthAnchor.constraint(equalToConstant: 70),
            capsule.heightAnchor.constraint(equalToConstant: 10),
            
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - Navigation Controller Mock

final class TestVC1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}

final class TestVC2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

final class TestVC3: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
    }
}

