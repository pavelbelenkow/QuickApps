import UIKit
import MiniAppCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: createMainViewController())
        window?.makeKeyAndVisible()
        return true
    }
    
    private func createMainViewController() -> MainViewController {
        let model = MiniAppModel()
        let viewModel = MainViewModel(model: model)
        return MainViewController(viewModel: viewModel)
    }
}
