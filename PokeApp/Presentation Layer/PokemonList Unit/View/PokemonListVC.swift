import UIKit

final class PokemonListVC: UIViewController {
    
    private let interactor: PokemonListInteractor
    
    // MARK: - Init
    init(interactor: PokemonListInteractor) {
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
