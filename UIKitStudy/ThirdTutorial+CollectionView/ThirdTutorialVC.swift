import UIKit

final class ThirdTutorialVC: UIViewController {
    
    // MARK: - UI Componenet
    private let topContent: TopContentView = .init()
    
    private let bottomContent: BottomContent = .init()
   
    // MARK: - LifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpLayout()
        
        // TODO: Closer Capture
        bottomContent.onNextCliked = {
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            
            sceneDelegate.switchToMainTabBar()
        }
    }
    
    // MARK: - Layout Constraint
    private func setUp() {
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUpLayout() {
        [topContent,bottomContent].forEach { content in
            content.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(content)
        }
        
        NSLayoutConstraint.activate([
            topContent.topAnchor.constraint(equalTo: view.topAnchor),
            topContent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topContent.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            bottomContent.topAnchor.constraint(equalTo: topContent.bottomAnchor, constant: 24),
            bottomContent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

#Preview {
    ThirdTutorialVC()
}
