import UIKit

protocol PokemonDetailsVCProtocol {
    func dispayCells(models: [PokemonProfileCellModel])
    func setNavBarTitle(_ title: String)
    func setBackgroundColor(_ color: UIColor)
}

final class PokemonDetailsVC: UIViewController {
    
    // MARK: - Private Properties
    private let contentView: PokemonDetailsView
    private let interactor: PokemonDetailsInteractor
    
    // MARK: - Init
    init(interactor: PokemonDetailsInteractor) {
        self.interactor = interactor
        self.contentView = PokemonDetailsView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        layout()
    }
}

// MARK: - PokemonDetailsVCProtocol
extension PokemonDetailsVC: PokemonDetailsVCProtocol {
    func setNavBarTitle(_ title: String) {
        self.title = title.capitalized
    }
    
    func dispayCells(models: [PokemonProfileCellModel]) {
        contentView.set(cellModels: models)
    }
    
    func setBackgroundColor(_ color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = color
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: Fonts.kefa(size: 20)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        view.backgroundColor = color
    }
}

// MARK: - Private Methods
private extension PokemonDetailsVC {
    func setup() {
        interactor.setupInitialData()
        
        setBackgroundColor(.gray)
    }
    
    func layout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - LoadingProtocol
extension PokemonDetailsVC: LoadingProtocol {
    func startLoading() {
        contentView.showLoader()
    }
    
    func stopLoading() {
        contentView.hideLoader()
    }
}
