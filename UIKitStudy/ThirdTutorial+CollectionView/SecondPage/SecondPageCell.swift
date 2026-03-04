import UIKit

final class SecondPageCell: UICollectionViewCell {
    static let reuseIdentifier: String = "SecondPageCell"
    
    // MARK: - UI Component
    
    private let title: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = .systemFont(ofSize: 18, weight: .semibold)
        t.text = "Special For You"
        
        return t
    }()
    
    private lazy var tag1: PaddingLabel = self.createText("5 min", bgColor: .white)
    private lazy var tag2: PaddingLabel = self.createText("10 min", bgColor: .systemCyan)
    
    private let button: UIButton = {
        var config: UIButton.Configuration = .plain()
        config.baseForegroundColor = .white
        let size: UIImage.SymbolConfiguration = .init(pointSize: 36, weight: .bold)
        config.image = UIImage(systemName: "play.circle", withConfiguration: size)
        
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
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(title)
        addSubview(tag1)
        addSubview(tag2)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            tag1.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 24),
            tag1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            tag2.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 24),
            tag2.leadingAnchor.constraint(equalTo: tag1.trailingAnchor, constant: 12),
            
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - Helper Function

extension SecondPageCell {
    private func createText(_ title: String, bgColor: UIColor) -> PaddingLabel {
        let t = PaddingLabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.font = .systemFont(ofSize: 14, weight: .medium)
        t.text = title
        t.backgroundColor = bgColor
        t.textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        t.layer.cornerRadius = 14
        t.clipsToBounds = true
        
        return t
    }
}
