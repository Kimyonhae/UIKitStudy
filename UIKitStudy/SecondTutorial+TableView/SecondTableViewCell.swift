import UIKit

final class SecondTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "SecondTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setUpTopContentConfiguration()
        setUpBottomContentConfiguration()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder: not implemented")
    }
    
    // MARK: - UI Component Area
    
    private let container: UIView = {
        let c = UIView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.backgroundColor = .white
        c.layer.cornerRadius = 12
        return c
    }()
    
    private let topContentGroup: UIView = {
        let t = UIView()
        t.translatesAutoresizingMaskIntoConstraints = false

        return t
    }()
    
    private var title: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.text = "Title"
        t.font = .systemFont(ofSize: 18, weight: .semibold)
        t.numberOfLines = 1
        return t
    }()
    
    private var subTitle: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.text = "SubTitle"
        t.font = .systemFont(ofSize: 14, weight: .medium)
        t.numberOfLines = 1
        
        return t
    }()
    
    private var checkButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        let config: UIImage.SymbolConfiguration = .init(pointSize: 24)
        b.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: config), for: .normal)
        b.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: config), for: .selected)

        return b
    }()
    
    private let separatorLine: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .secondarySystemBackground
        
        return s
    }()
    
    /// Bottom Area
    private let bottomContainer: UIStackView = {
        let b = UIStackView()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.axis = .horizontal
        b.distribution = .fill
        b.spacing = 8
        b.alignment = .center
        
        // Internal padding
        b.isLayoutMarginsRelativeArrangement = true
        b.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        return b
    }()
    
    private var bottomDayText: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.text = "Today"
        t.font = .systemFont(ofSize: 16, weight: .semibold)
        t.textColor = .systemGray
        
        return t
    }()
    
    private var bottomDateLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.text = Date.now.description
        t.font = .systemFont(ofSize: 16, weight: .light)
        t.textColor = .systemGray
        
        return t
    }()
    
    private var bottomImages: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.image = UIImage(systemName: "person.crop.circle.badge.ellipsis")
        
        return i
    }()
    
    // MARK: - TopContent Constraint UI
    private func setUpTopContentConfiguration() {
        topContentGroup.addSubview(title)
        topContentGroup.addSubview(subTitle)
        topContentGroup.addSubview(checkButton)
        container.addSubview(topContentGroup)
        container.addSubview(separatorLine)
        contentView.addSubview(container)
        
        // Action Button
        checkButton.addAction(UIAction { [weak self] _ in
            self?.toggleButton()
        }, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            topContentGroup.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            topContentGroup.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            topContentGroup.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            topContentGroup.bottomAnchor.constraint(equalTo: separatorLine.topAnchor),
            
            checkButton.centerYAnchor.constraint(equalTo: topContentGroup.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: topContentGroup.trailingAnchor),
            
            title.topAnchor.constraint(equalTo: topContentGroup.topAnchor),
            title.leadingAnchor.constraint(equalTo: topContentGroup.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: topContentGroup.trailingAnchor),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            subTitle.leadingAnchor.constraint(equalTo: topContentGroup.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: topContentGroup.trailingAnchor,),
            subTitle.bottomAnchor.constraint(equalTo: topContentGroup.bottomAnchor, constant: -12),
            
            separatorLine.topAnchor.constraint(equalTo: topContentGroup.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: topContentGroup.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: topContentGroup.trailingAnchor),
            separatorLine.widthAnchor.constraint(equalTo: topContentGroup.widthAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    // MARK: - BottomContent Constraint UI
    private func setUpBottomContentConfiguration() {
        bottomContainer.addArrangedSubview(bottomDayText)
        bottomContainer.addArrangedSubview(bottomDateLabel)
        bottomContainer.addArrangedSubview(bottomImages)
        container.addSubview(bottomContainer)
        
        bottomDayText.setContentHuggingPriority(.required, for: .horizontal)
        bottomDayText.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            bottomContainer.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 12),
            bottomContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            bottomContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            bottomContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            bottomImages.widthAnchor.constraint(equalToConstant: 24),
            bottomImages.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
}


// MARK: - Helper Function Extension

extension SecondTableViewCell {
    func set(with item: ScheduleItem) {
        title.text = item.title
        subTitle.text = item.subtitle
        bottomDateLabel.text = item.dateText
        
        buttonStateCheck(isCompleted: item.isCompleted)
    }
    
    func buttonStateCheck(isCompleted: Bool) {
        checkButton.isSelected = isCompleted
    }
    
    /// Toggle Button State Change
    func toggleButton() {
        UIView.transition(
            with: checkButton,
            duration: 0.25,
            options: .transitionCrossDissolve
        ) {
            self.checkButton.isSelected.toggle()
        }
    }
}

// MARK: - Override Function Extension

extension SecondTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        subTitle.text = nil
        bottomDateLabel.text = nil
        checkButton.isSelected = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        if selected {
            self.container.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.container.layer.shadowColor = UIColor.black.cgColor
            self.container.layer.shadowOpacity = 0.15
            self.container.layer.shadowRadius = 8
            self.container.layer.shadowOffset = CGSize(width: 0, height: 4)
        } else {
            self.container.transform = .identity
            self.container.layer.shadowOpacity = 0
        }
    }
}

