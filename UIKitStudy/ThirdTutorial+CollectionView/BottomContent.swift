import UIKit

final class BottomContent: UIView {
    // MARK: - State
    private let menuBgColor: UIColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    private let menuAccentColor: UIColor = UIColor(red: 254/255, green: 176/255, blue: 229/255, alpha: 1)
    private var data: [Menu] = [
        Menu(title: "Sad", isSelected: false),
        Menu(title: "Happy", isSelected: true),
        Menu(title: "Angry", isSelected: false),
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMenuLayout()
        setUpTextAndButtonLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Closer 전달
    var onNextCliked: (() -> Void)?
    
    // MARK: - UI Component
    private let menu: UIScrollView = {
        let m = UIScrollView()
        m.translatesAutoresizingMaskIntoConstraints = false
        m.showsVerticalScrollIndicator = false
        m.showsHorizontalScrollIndicator = false
        m.delaysContentTouches = true
        m.canCancelContentTouches = true
        
        return m
    }()
    
    private let textLabel: UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.text = "How do you\n feel Today?"
        t.textAlignment = .center
        t.numberOfLines = 2
        t.font = .systemFont(ofSize: 28, weight: .semibold)
        t.textColor = .white
        
        return t
    }()
    
    private let skipButton: UIButton = {
        let s = UIButton()
        s.translatesAutoresizingMaskIntoConstraints = false
        var config: UIButton.Configuration = .plain()
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.title = "Skip"
        s.configuration = config
        
        return s
    }()
    
    private let nextButton: UIButton = {
        let s = UIButton()
        s.translatesAutoresizingMaskIntoConstraints = false
        var config: UIButton.Configuration = .bordered()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        config.title = "Next >"
        s.configuration = config
        
        return s
    }()
    
    private var items: [UIButton] = []
    
    // MARK: - Layout Constraint
    
    private func setUpMenuLayout() {
        for (_, m) in data.enumerated() {
            let item: UIButton = createMenuItem(menu: m)
            
            items.append(item)
            menu.addSubview(item)
        }
        
        addSubview(menu)
        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: topAnchor),
            menu.leadingAnchor.constraint(equalTo: leadingAnchor),
            menu.trailingAnchor.constraint(equalTo: trailingAnchor),
            menu.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        for (i, item) in items.enumerated() {
            item.addAction(UIAction { [weak self] _ in
                self?.changeSelectedMenu(index: i)
            }, for: .touchUpInside)
            NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: menu.contentLayoutGuide.topAnchor),
                item.bottomAnchor.constraint(equalTo: menu.contentLayoutGuide.bottomAnchor),
                item.widthAnchor.constraint(equalTo: menu.frameLayoutGuide.widthAnchor, multiplier: 0.4),
                item.heightAnchor.constraint(equalTo: menu.frameLayoutGuide.heightAnchor)
            ])
            
            if i == 0 {
                item.leadingAnchor.constraint(equalTo: menu.contentLayoutGuide.leadingAnchor).isActive = true
            } else {
                item.leadingAnchor.constraint(equalTo: items[i - 1].trailingAnchor, constant: 10).isActive = true
            }
            
            if items[i] == items.last {
                item.trailingAnchor.constraint(equalTo: menu.contentLayoutGuide.trailingAnchor).isActive = true
            }
        }
    }
    
    private func setUpTextAndButtonLayout() {
        addSubview(textLabel)
        addSubview(skipButton)
        addSubview(nextButton)
        
        nextButton.addAction(UIAction { [weak self] _ in self?.onNextCliked?()}, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: menu.bottomAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            skipButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 12),
            skipButton.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor, constant: 12),
            skipButton.widthAnchor.constraint(equalTo: textLabel.widthAnchor, multiplier: 0.3),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 12),
            nextButton.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: -12),
            nextButton.widthAnchor.constraint(equalTo: textLabel.widthAnchor, multiplier: 0.6),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

// MARK: - Helper Function
extension BottomContent {
    func changeSelectedMenu(index: Int) {
        for i in data.indices {
            data[i].isSelected = (i == index)
            
            var config: UIButton.Configuration? = items[i].configuration
            config?.baseBackgroundColor = data[i].isSelected ? menuAccentColor : menuBgColor
            config?.baseForegroundColor = data[i].isSelected ? .black : .white
            items[i].configuration = config
        }
    }
}

extension BottomContent {
    func createMenuItem(menu: Menu) -> UIButton {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        var config: UIButton.Configuration = .bordered()
        config.title = menu.title
        config.cornerStyle = .capsule
        config.baseBackgroundColor = menu.isSelected ? menuAccentColor : menuBgColor
        config.baseForegroundColor = menu.isSelected ? .black : .white
        
        b.configuration = config
        
        return b
    }
    
    struct Menu {
        let title: String
        var isSelected: Bool
    }
}
