import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var miniAppsCollectionView: MiniAppsCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = MiniAppsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.interactionDelegate = self
        return view
    }()
    
    private let viewModel: any MainViewModelProtocol
    
    // MARK: - Initializers
    
    init(viewModel: any MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRightBarButtonItem()
        setupMiniAppsCollectionView()
        bindViewModel()
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    func setupRightBarButtonItem() {
        let modes = [Const.compactMode, Const.interactiveMode]
        let menu = UIMenu(
            children: modes.map {
                UICommand(
                    title: String($0),
                    action: #selector(modeButtonTapped),
                    propertyList: $0,
                    state: $0 == Const.compactMode ? .on : .off
                )
            }
        )
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Const.modeIcon),
            menu: menu
        )
        
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }
    
    func setupMiniAppsCollectionView() {
        view.addSubview(miniAppsCollectionView)
        
        NSLayoutConstraint.activate([
            miniAppsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            miniAppsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            miniAppsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            miniAppsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func bindViewModel() {
        viewModel.displayModeSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                guard let self else { return }
                
                miniAppsCollectionView.reloadData()
                updateMenuState(mode)
            }
            .store(in: &viewModel.cancellables)
    }
    
    func updateMenuState(_ selectedMode: DisplayMode) {
        let modeInString = selectedMode == .compact ? Const.compactMode : Const.interactiveMode
        
        guard
            let rightBarButtonItem = navigationItem.rightBarButtonItem,
            let menu = rightBarButtonItem.menu
        else { return }
        
        for case let menuItem in menu.children {
            if let command = menuItem as? UICommand {
                command.state = (command.propertyList as? String == modeInString) ? .on : .off
            }
        }
    }
    
    func setupMiniAppView(_ view: UIView, for viewController: UIViewController) {
        viewController.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - Obj-c Methods

@objc
private extension MainViewController {
    
    func modeButtonTapped(_ sender: UICommand) {
        if let mode = sender.propertyList as? String {
            mode == Const.compactMode ?
            viewModel.changeDisplayMode(to: .compact) :
            viewModel.changeDisplayMode(to: .interactive)
        }
    }
}

// MARK: - MiniAppsCollectionViewDelegate Methods

extension MainViewController: MiniAppsCollectionViewDelegate {
    
    func getMiniApps() -> MiniAppModel {
        viewModel.getMiniApps()
    }
    
    func getCurrentDisplayMode() -> DisplayMode {
        viewModel.displayModeSubject.value
    }
    
    func didTapMiniApp(at index: Int) {
        let viewController = UIViewController()
        let view = viewModel.getMiniApps().miniApps[index].view
        
        setupMiniAppView(view, for: viewController)
        present(viewController, animated: true)
    }
}
