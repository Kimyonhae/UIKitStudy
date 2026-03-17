import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let tutorialVC = SecondUIKitTutorialViewController()
        let nav = UINavigationController(rootViewController: tutorialVC)

        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

extension SceneDelegate {
    func switchToMainTabBar() {
        let tabBar = UITabBarController()

        // Home
        let homeVC = SecondPageVC()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )

        // Profile
        let test1 = TestVC1()
        let testNav = UINavigationController(rootViewController: test1)
        testNav.tabBarItem = UITabBarItem(
            title: "test1",
            image: UIImage(systemName: "cross.circle"),
            tag: 1
        )

        let test2 = TestVC2()
        let testNav2 = UINavigationController(rootViewController: test2)
        testNav2.tabBarItem = UITabBarItem(
            title: "test2",
            image: UIImage(systemName: "flask.fill"),
            tag: 2
        )
        
        let test3 = TestVC3()
        let testNav3 = UINavigationController(rootViewController: test3)
        testNav3.tabBarItem = UITabBarItem(
            title: "test3",
            image: UIImage(systemName: "staroflife"),
            tag: 3
        )
        
        tabBar.viewControllers = [homeNav, testNav, testNav2, testNav3]

        guard let window = self.window else { return }

        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            window.rootViewController = tabBar
        })
    }
}
