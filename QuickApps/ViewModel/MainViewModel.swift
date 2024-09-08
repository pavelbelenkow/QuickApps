import Combine

// MARK: - Protocols

protocol MainViewModelProtocol: ObservableObject {
    var displayModeSubject: CurrentValueSubject<DisplayMode, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    
    func getMiniApps() -> MiniAppModel
    func changeDisplayMode(to mode: DisplayMode)
}

final class MainViewModel: MainViewModelProtocol {
    
    // MARK: - Subject Properties
    
    private(set) var displayModeSubject: CurrentValueSubject<DisplayMode, Never> = .init(.compact)
    
    // MARK: - Private Properties
    
    private let model: MiniAppModel
    
    // MARK: - Properties
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    init(model: MiniAppModel) {
        self.model = model
    }
    
    // MARK: - Deinitializers
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - Methods

extension MainViewModel {
    
    func getMiniApps() -> MiniAppModel {
        model
    }
    
    func changeDisplayMode(to mode: DisplayMode) {
        displayModeSubject.send(mode)
    }
}
