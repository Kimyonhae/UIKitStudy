import UIKit
import Observation

final class ObservationTrackingVC: UIViewController {

    // MARK: - State
    private let vm: ViewModel = .init()
    
    // MARK: - UI Component
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.backgroundColor = .red
        c.delaysContentTouches = true
        
        return c
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpCollectionViewConstraint()
    }    
    
    // MARK: - Initialize
    
    // MARK: - Constraint
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ObservationTrackingCell.self, forCellWithReuseIdentifier: ObservationTrackingCell.reuseIdentifier)
        collectionView.setCollectionViewLayout(
            createLayout(),
            animated: false
        )
    }
    
    private func setUpCollectionViewConstraint() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

#Preview {
    ObservationTrackingVC()
}

// MARK: Helper Function

extension ObservationTrackingVC {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            self?.getSection(index: section)
        }
        return layout
    }
    
    private func getSection(index: Int) -> NSCollectionLayoutSection {
        createSection()
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(100)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}

// MARK: - Delegate and DataSource

extension ObservationTrackingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        vm.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ObservationTrackingCell.reuseIdentifier,
            for: indexPath
        ) as! ObservationTrackingCell
        collectionView.touchesShouldCancel(in: cell)
        let item: Item = vm.data[indexPath.section][indexPath.item]
        
        cell.contentView.backgroundColor = item.bgColor.mapping()
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
        cell.bind(with: item)
        return cell
    }
}

// MARK: - Data Model

extension ObservationTrackingVC {

    enum DefineColor: Hashable {
        case red
        case green
        case blue
        case pink
        
        func mapping() -> UIColor {
            switch self {
            case .red:
                UIColor.red
            case .green:
                UIColor.green
            case .blue:
                UIColor.blue
            case .pink:
                UIColor.systemPink
            }
        }
    }
    
    @Observable
    class Item {
        let title: String
        let imageName: String
        let bgColor: DefineColor
        var isToggle: Bool
        
        init(title: String, imageName: String, bgColor: DefineColor, isToggle: Bool = false) {
            self.title = title
            self.imageName = imageName
            self.bgColor = bgColor
            self.isToggle = isToggle
        }
    }
}
