import UIKit

final class SecondPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfiguration()
    }
    
    private func setConfiguration() {
        self.view.backgroundColor = .systemBlue
        self.navigationItem.title = "Second Page"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

#Preview {
    let first = FirstUIKitTutorialViewController()
    let second = SecondPageViewController()
    let nv = UINavigationController(
        rootViewController: first
    )
    
    nv.pushViewController(second, animated: true)
    return nv
}
