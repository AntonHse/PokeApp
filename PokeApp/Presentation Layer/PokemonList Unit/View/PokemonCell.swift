import UIKit

final class PokemonCellModel {
    let id: String
    var image: UIImage?
    let placeholderImage: UIImage?
    let name: String
    
    init(id: String, image: UIImage? = nil, placeholderImage: UIImage?, name: String) {
        self.id = id
        self.image = image
        self.placeholderImage = placeholderImage
        self.name = name
    }
}

final class PokemonCell: UITableViewCell {
    
    var onCellTap: ((_ id: String) -> ())?
    
    // MARK: - Private Properties
    private var id: String = ""
    private let backgroundCellView = BounceButton()
    private let iconView = AnimatableImageView()
    private let numberLabel = UILabel()
    private let label = UILabel()
    
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
        iconView.placeholderImage = nil
        numberLabel.text = nil
        label.text = nil
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundCellView.layer.cornerRadius = frame.height / 4
        backgroundCellView.layer.masksToBounds = true
    }
    
    // MARK: - Public Methods
    func set(pokemonModel: PokemonCellModel) {
        self.id = pokemonModel.id
        numberLabel.text = "№ \(pokemonModel.id)"
        iconView.image = pokemonModel.image 
        iconView.placeholderImage = pokemonModel.placeholderImage
        label.text = pokemonModel.name.capitalized
    }
    
    func set(image: UIImage?) {
        iconView.set(image: image, animation: true)
    }
}

// MARK: - Private Methods
private extension PokemonCell {
    func setup() {
        selectionStyle = .none
        isUserInteractionEnabled = true
        backgroundColor = .clear
        
        label.numberOfLines = 0
        label.font = Fonts.kefa(size: 20)
        label.textColor = .black
        
        numberLabel.font = Fonts.kefa(size: 18)
        numberLabel.textColor = .black
        numberLabel.adjustsFontSizeToFitWidth = true

        backgroundCellView.backgroundColor = .white
        backgroundCellView.layer.borderWidth = 1
        backgroundCellView.layer.borderColor = UIColor.black.cgColor
        backgroundCellView.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
    }
    
    func layout() {
        contentView.addSubview(backgroundCellView)
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backgroundCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            backgroundCellView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            backgroundCellView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ])
        
        backgroundCellView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: backgroundCellView.centerYAnchor),
            iconView.topAnchor.constraint(equalTo: backgroundCellView.topAnchor, constant: 2),
            iconView.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: -2),
            iconView.leftAnchor.constraint(equalTo: backgroundCellView.leftAnchor, constant: 8),
            iconView.heightAnchor.constraint(equalToConstant: 64),
            iconView.widthAnchor.constraint(equalToConstant: 64)
        ])
        
        backgroundCellView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: backgroundCellView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 8),
        ])
        
        backgroundCellView.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: backgroundCellView.centerYAnchor),
            numberLabel.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 2),
            numberLabel.rightAnchor.constraint(equalTo: backgroundCellView.rightAnchor, constant: -8),
            numberLabel.widthAnchor.constraint(equalToConstant: 71)
        ])
    }
    
    // MARK: - Actions
    @objc func cellTapped() {
        onCellTap?(id)
    }
}
