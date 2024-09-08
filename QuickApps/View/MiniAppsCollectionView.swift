import UIKit

// MARK: - Delegates

protocol MiniAppsCollectionViewDelegate: AnyObject {
    func getMiniApps() -> MiniAppModel
    func getCurrentDisplayMode() -> DisplayMode
    func didTapMiniApp(at index: Int)
}

final class MiniAppsCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    weak var interactionDelegate: MiniAppsCollectionViewDelegate?
    
    // MARK: - Initialisers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI

private extension MiniAppsCollectionView {
    
    func setupAppearance() {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }
        
        backgroundColor = .white
        
        register(MiniAppCell.self, forCellWithReuseIdentifier: Const.miniAppCellReuseIdentifier)
        
        allowsMultipleSelection = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        
        dataSource = self
        delegate = self
    }
}

// MARK: - DataSource Methods

extension MiniAppsCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactionDelegate?.getMiniApps().miniApps.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let miniApp = interactionDelegate?.getMiniApps().miniApps[indexPath.row],
            let displayMode = interactionDelegate?.getCurrentDisplayMode(),
            let miniAppCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.miniAppCellReuseIdentifier, for: indexPath) as? MiniAppCell
        else { return UICollectionViewCell() }
        
        miniAppCell.configure(with: miniApp, displayMode: displayMode)
        
        return miniAppCell
    }
}

// MARK: - Delegate Methods

extension MiniAppsCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let displayMode = interactionDelegate?.getCurrentDisplayMode() else { return .zero }
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        switch displayMode {
        case .compact:
            return CGSize(width: screenWidth, height: screenHeight / 8)
        case .interactive:
            return CGSize(width: screenWidth, height: screenHeight / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactionDelegate?.didTapMiniApp(at: indexPath.row)
    }
}
