import UIKit
import MiniAppCore

final class MiniAppCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .black
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var activeConstraints: [NSLayoutConstraint] = []
    private var miniAppView: UIView?
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellState()
    }
}

// MARK: - Private Methods

private extension MiniAppCell {
    
    func resetCellState() {
        miniAppView?.removeFromSuperview()
        miniAppView = nil
        
        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints.removeAll()
    }
    
    func configureCompactMode() {
        isUserInteractionEnabled = false
        stackView.axis = .horizontal
        miniAppView?.isHidden = true
        
        activeConstraints = [
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(activeConstraints)
    }
    
    func configureInteractiveMode(with view: UIView) {
        isUserInteractionEnabled = true
        stackView.axis = .vertical
        miniAppView = view
        miniAppView?.isHidden = false
        
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        activeConstraints = [
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            view.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(activeConstraints)
    }
}

// MARK: - Methods

extension MiniAppCell {
    
    func configure(with miniApp: MiniAppProtocol, displayMode: DisplayMode) {
        iconImageView.image = miniApp.icon
        titleLabel.text = miniApp.title
        
        switch displayMode {
        case .compact:
            configureCompactMode()
        case .interactive:
            configureInteractiveMode(with: miniApp.view)
        }
    }
}
