import UIKit

final class SecondPageVC_TopContent: UIView {
    
    // MARK: - UI Component
    private let profileName: UILabel = {
        let p = UILabel()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.text = "🔥 Hello World"
        p.font = .systemFont(ofSize: 24, weight: .semibold)
        
        return p
    }()
    
    private let notification: UIButton = {
        let n = UIButton(type: .system)
        n.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(
            pointSize: 22,
            weight: .regular
        )
        n.setImage(
            UIImage(systemName: "bell.circle", withConfiguration: symbolConfig),
            for: .normal
        )
        n.setImage(
            UIImage(systemName: "bell.circle.fill", withConfiguration: symbolConfig),
            for: .selected
        )
        n.backgroundColor = .black
        n.tintColor = .white
        n.clipsToBounds = true
        n.configuration = nil

        return n
    }()

    private let searchField: CustomTextField = .init(placeholder: "Search...")
    
    private let cardStack: UIStackView = {
        let c = UIStackView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.axis = .horizontal
        c.spacing = 16
        c.distribution = .fillEqually
        return c
    }()
    private let card1: CardView = {
        let c = CardView()
        c.configure("Emotional\nBalance", minute: "15 min", isWhite: false)
        return c
    }()
    private let card2: CardView = {
        let c = CardView()
        c.configure("Calm\nRelaxaion", minute: "12 min", isWhite: true)
        return c
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        notification.layer.cornerRadius = notification.bounds.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        addSubview(profileName)
        addSubview(notification)
        addSubview(searchField)
        cardStack.addArrangedSubview(card1)
        cardStack.addArrangedSubview(card2)
        addSubview(cardStack)
        
        NSLayoutConstraint.activate([
            profileName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            profileName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            notification.centerYAnchor.constraint(equalTo: profileName.centerYAnchor),
            notification.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            notification.widthAnchor.constraint(equalToConstant: 44),
            notification.heightAnchor.constraint(equalToConstant: 44),
            
            searchField.topAnchor.constraint(equalTo: notification.bottomAnchor, constant: 20),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            searchField.heightAnchor.constraint(equalToConstant: 59),
            
            cardStack.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            cardStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            cardStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            cardStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
