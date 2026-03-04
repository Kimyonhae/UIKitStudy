import UIKit
import Combine

private let reuseIdentifier = "Cell"

class CacheStudyCollectionVC: UICollectionViewController {

    // MARK: - State
    private let vm: CacheStudyVCModel = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    /// 기본 init()에서 listConfiguration 레이아웃을 자동으로 설정
    init() {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfig)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Data Cache"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        bind()
    }
    
    private func bind() {
        vm.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }


    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let photo = vm.photos[indexPath.item]
        
        var content = UIListContentConfiguration.cell()
        content.text = photo.content
        content.secondaryText = "nickName : \(photo.nickname)"
        
        // 이미지 크기 및 레이아웃 설정
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        content.imageProperties.reservedLayoutSize = CGSize(width: 40, height: 40) // 이미지가 없어도 자리를 잡아줌
        content.imageProperties.cornerRadius = 20 // 동그랗게 원할 경우
        
        Task {
            do {
                if let profile = photo.profileImage.first {
                    let image = try await vm.loadImage(url: profile) // id 파라미터 제거
                    
                    var updatedContent = content
                    updatedContent.image = image.flatMap { self.cropToSquare($0, size: 40) }
                    cell.contentConfiguration = updatedContent
                }
            } catch {
                print("image Error : \(error)")
            }
        }
        
        cell.contentConfiguration = content
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }

    // MARK: - Helper
    
    /// 이미지를 정사각형으로 크롭 후 지정 크기로 리사이즈
    private func cropToSquare(_ image: UIImage, size: CGFloat) -> UIImage {
        let originalSize = image.size
        let side = min(originalSize.width, originalSize.height)
        let origin = CGPoint(
            x: (originalSize.width - side) / 2,
            y: (originalSize.height - side) / 2
        )
        let cropRect = CGRect(origin: origin, size: CGSize(width: side, height: side))
        
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return image }
        
        let targetSize = CGSize(width: size, height: size)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            UIImage(cgImage: cgImage).draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

#Preview {
    UINavigationController(rootViewController: CacheStudyCollectionVC())
}
