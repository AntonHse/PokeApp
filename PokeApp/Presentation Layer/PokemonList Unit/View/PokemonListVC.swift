import UIKit

protocol PokemonListVCProtocol: AnyObject {
    func dispayCells(models: [PokemonCellModel])
    func appendCells(models: [PokemonCellModel])
    func updateCell(model: PokemonCellModel)
    func hideTopRefreshControll()
    func hideBottomRefreshControll()
}

final class PokemonListVC: UIViewController {
    
    private let contentView: PokemonListView
    private let interactor: PokemonListInteractorProtocol
    private let router: PokemonListRouterProtocol
    
    // MARK: - Init
    init(interactor: PokemonListInteractor, router: PokemonListRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.contentView = PokemonListView()
        
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
    
    // MARK: - Private Methods
    private func setup() {
        title = "Pokemons"
        
        interactor.setupInitialData()

        contentView.onTopRefresh = { [weak self] in
            self?.interactor.reload()
        }

        contentView.onBottomRefresh = { [weak self] in
            self?.interactor.loadMorePokemons()
        }
        
        contentView.onCellTap = { [weak self] id in
            self?.router.routeToPokemonScreen(pokemonID: id)
        }
    }
    
    private func layout() {
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

// MARK: - PokemonListVCProtocol
extension PokemonListVC: PokemonListVCProtocol {
    func dispayCells(models: [PokemonCellModel]) {
        contentView.set(cellModels: models)
    }
    
    func appendCells(models: [PokemonCellModel]) {
        contentView.append(cellModels: models)
    }
    
    func updateCell(model: PokemonCellModel) {
        contentView.update(cellModel: model)
    }
    
    func hideTopRefreshControll() {
        contentView.hideTopRefresh()
    }
    
    func hideBottomRefreshControll() {
        contentView.hideBottomRefresh()
    }
}

// MARK: - LoadingProtocol
extension PokemonListVC: LoadingProtocol {
    func startLoading() {
        contentView.showLoader()
    }
    
    func stopLoading() {
        contentView.hideLoader()
    }
}
