import UIKit

final class PokemonListView: UIView {
    
    var onTopRefresh: (() -> ())?
    var onBottomRefresh: (() -> ())?
    var onCellTap: ((_ id: String) -> ())?
    
    // MARK: - Private Properties
    private let topSpinner = UIRefreshControl()
    private let bottomSpinner = UIActivityIndicatorView(style: .large)
    private let spinner = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView(frame: .zero)
    private var cellModels: [PokemonCellModel] = []
    
    private var isUploading: Bool = false
    
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
    func set(cellModels: [PokemonCellModel]) {
        self.cellModels = cellModels
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    
        isUploading = false
    }
    
    func append(cellModels: [PokemonCellModel]) {
        self.cellModels += cellModels
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    
        isUploading = false
    }
    
    func update(cellModel: PokemonCellModel) {
        guard let index = cellModels.firstIndex(where: { cellModel.id == $0.id }) else { return }
        cellModels[index].image = cellModel.image

        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PokemonCell else { return }
        cell.set(image: cellModel.image)
        print(cellModel.id)
    }
    
    func showLoader() {
        spinner.startAnimating()
        spinner.isHidden = false
    }
    
    func hideLoader() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    func hideTopRefresh() {
        topSpinner.endRefreshing()
    }
    
    func hideBottomRefresh() {
        bottomSpinner.stopAnimating()
        bottomSpinner.isHidden = true
    }
    
    // MARK: - Private Methods
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .white
        tableView.register(cell: PokemonCell.self)
        
        bottomSpinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = bottomSpinner
        
        configureTopRefreshControl()
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
    }
    
    private func configureTopRefreshControl() {
        topSpinner.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        tableView.refreshControl = topSpinner
    }
    
    // MARK: - Actions
    @objc private func refreshView() {
        onTopRefresh?()
    }
}

// MARK: - UITableViewDataSource
extension PokemonListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PokemonCell.self), for: indexPath) as! PokemonCell
        cell.set(pokemonModel: cellModels[indexPath.row])
        cell.onCellTap = onCellTap
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
}

// MARK: - UITableViewDelegate
extension PokemonListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellModels.count - indexPath.row < 10, !isUploading {
            onBottomRefresh?()
            isUploading = true
        }
        
        if indexPath.row == cellModels.count - 1 {
            bottomSpinner.startAnimating()
            tableView.tableFooterView?.isHidden = false
        }
    }
}
