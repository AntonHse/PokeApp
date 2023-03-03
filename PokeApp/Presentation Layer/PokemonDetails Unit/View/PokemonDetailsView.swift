import UIKit

final class PokemonDetailsView: UIView {
    
    private var cellModels: [PokemonProfileCellModel] = []
    
    private let spinner = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView(frame: .zero)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func set(cellModels: [PokemonProfileCellModel]) {
        self.cellModels = cellModels
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showLoader() {
        spinner.startAnimating()
        spinner.isHidden = false
    }
    
    func hideLoader() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    // MARK: - Private Methods
    private func setup() {
        backgroundColor = .clear
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .clear
        tableView.register(cell: PokemonProfileCell.self)
    }
    
    private func layout() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        bringSubviewToFront(spinner)
    }
}

// MARK: - UITableViewDataSource
extension PokemonDetailsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: PokemonProfileCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PokemonProfileCell
        cell.set(model: cellModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
}
