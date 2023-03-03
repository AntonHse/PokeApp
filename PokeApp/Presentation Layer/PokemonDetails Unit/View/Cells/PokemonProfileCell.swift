import UIKit

final class PokemonProfileCellModel {
    let image: UIImage?

    let weightModel: (title: String, description: String)
    let heightModel: (title: String, description: String)
    let typeModels: [String]

    init(
        image: UIImage?,
        weightModel: (title: String, description: String),
        heightModel: (title: String, description: String),
        typeModels: [String]
    ) {
        self.image = image
        self.weightModel = weightModel
        self.heightModel = heightModel
        self.typeModels = typeModels
    }
}

final class PokemonProfileCell: UITableViewCell {
    
    // MARK: - Private Properties
    private let iconView = UIImageView()
    
    private let heightView = VerticalLabelDescriptionView()
    private let weightView = VerticalLabelDescriptionView()
    
    private var typeLabels: [RoundLabel] = []
    
    // MARK: - Init
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        iconView.image = nil
        heightView.set(title: "", description: "")
        weightView.set(title: "", description: "")
    }
    
    // MARK: - Public Methods
    func set(model: PokemonProfileCellModel) {
        iconView.image = model.image
        heightView.set(title: model.heightModel.title, description: model.heightModel.description)
        weightView.set(title: model.weightModel.title, description: model.weightModel.description)
        addTypes(names: model.typeModels)
    }
}

// MARK: - Private Methods
private extension PokemonProfileCell {
    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func layout() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 200),
            iconView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        addSubview(heightView)
        heightView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 16 + 70),
            heightView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            heightView.widthAnchor.constraint(equalToConstant: 100),
            heightView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
        
        addSubview(weightView)
        weightView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weightView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -16 - 70),
            weightView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            weightView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func addTypes(names: [String]) {
        typeLabels.removeAll()
        typeLabels.forEach { $0.removeFromSuperview() }

        names.forEach { name in
            let label = RoundLabel()
            let topAnchor: NSLayoutYAxisAnchor = typeLabels.last?.bottomAnchor ?? self.topAnchor
            label.text = name
            
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            ])
    
            typeLabels.append(label)
        }
    }
}
