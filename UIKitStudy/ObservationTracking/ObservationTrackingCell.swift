import UIKit

final class ObservationTrackingCell: UICollectionViewCell {
    static let reuseIdentifier: String = "ObservationTrackingCell"
    
    private let button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var item: ObservationTrackingVC.Item?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews는 언제 불리는가?")
    }
    
    // 이 메소드가 Observation에 의해 반복 호출되도록 구성합니다.
    override func updateProperties() {
        // 이 블록 안에서 접근하는 프로퍼티(isToggle)가 변하면 onChange가 실행됩니다.
        guard let item = item else { return }
        
        print("UI 갱신됨: \(item.title), 상태: \(item.isToggle)")
        
        if item.isToggle {
            contentView.backgroundColor = UIColor.systemPurple
        } else {
            contentView.backgroundColor = item.bgColor.mapping()
        }
    }
    
    private func setupUI() {
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // 버튼은 데이터 구조를 toggle하기만 합니다.
        button.addAction(UIAction { [weak self] _ in
            self?.item?.isToggle.toggle()
        }, for: .touchUpInside)
    }
    
    func bind(with item: ObservationTrackingVC.Item) {
        self.item = item
    }
    
    override func prepareForReuse() {
        self.item = nil
    }
}
