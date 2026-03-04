import UIKit

final class FirstUIKitTutorialViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let b = AnimatedButton()
        
        b.translatesAutoresizingMaskIntoConstraints = false
        b.configure("Button")
        b.addAction(UIAction { [weak self] _ in
            self?.nextPage()
        }, for: .touchUpInside)
        
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConfiguration()
        setUpConstraint()
    }
    
    private func setUpConfiguration() {
        self.view.backgroundColor = .black
    }
    
    private func setUpConstraint() {
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func nextPage() {
        navigationController?.pushViewController(SecondPageViewController(), animated: true)
    }
}

final class AnimatedButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                options: [.curveEaseInOut, .allowUserInteraction]
            ) {
                self.alpha = 1
                self.transform = self.isHighlighted
                ? CGAffineTransform(scaleX: 1.2, y: 1.2)
                    
                : .identity
            }
        }
    }
    
    func configure(_ title: String) {
        var config: UIButton.Configuration = .filled()
        config.title = title
        config.baseBackgroundColor = .systemRed
        config.baseForegroundColor = .white
        
        self.configuration = config
        self.automaticallyUpdatesConfiguration = false
    }

}


#Preview {
    UINavigationController(
        rootViewController: FirstUIKitTutorialViewController()
    )
}
