import UIKit

final class CardView: UIView {
    
    // MARK: - UIComponent
    private let title: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.numberOfLines = 2
        t.text = "Emotional\nBalance"
        t.font = .systemFont(ofSize: 18, weight: .semibold)
        t.textColor = .white
        
        return t
    }()
    
    private let minuteContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        v.backgroundColor = .systemGray
        
        return v
    }()
    
    private let minute: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.numberOfLines = 1
        t.text = "15 min"
        t.font = .systemFont(ofSize: 14, weight: .medium)
        t.textColor = .white
        t.textAlignment = .left
        t.clipsToBounds = true
        
        return t
    }()
    
    private let play: UIButton = {
        let p = UIButton()
        p.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .medium)
        config.image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
        config.imagePadding = 4
        config.baseBackgroundColor = .systemCyan
        config.baseForegroundColor = .black
        p.configuration = config
        return p
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        minuteContainer.layer.cornerRadius = play.frame.height / 2
        layer.cornerRadius = (frame.width / 2) / 4
    }
    
    // MARK: - Layout Constraint
    private func setUpLayout() {
        addSubview(title)
        addSubview(minuteContainer)
        minuteContainer.addSubview(minute)
        addSubview(play)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            minuteContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            minuteContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            minuteContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            minute.topAnchor.constraint(equalTo: minuteContainer.layoutMarginsGuide.topAnchor),
            minute.leadingAnchor.constraint(equalTo: minuteContainer.layoutMarginsGuide.leadingAnchor),
            minute.trailingAnchor.constraint(equalTo: minuteContainer.layoutMarginsGuide.trailingAnchor),
            minute.bottomAnchor.constraint(equalTo: minuteContainer.layoutMarginsGuide.bottomAnchor),
            
            play.centerYAnchor.constraint(equalTo: minuteContainer.centerYAnchor),
            play.trailingAnchor.constraint(equalTo: minuteContainer.trailingAnchor),
            play.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            play.widthAnchor.constraint(equalToConstant: 35),
            play.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}

extension CardView {
    func configure(
        _ title: String,
        minute: String,
        isWhite: Bool,
    ) {
        self.title.text = title
        self.minute.text = minute
        backgroundColor = isWhite ? .white : .black
        minuteContainer.backgroundColor = isWhite ? .systemGray3 : .systemGray
        self.title.textColor = isWhite ? .black : .white
    }
}
