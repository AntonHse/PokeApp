import UIKit

final class VerticalLabelDescriptionView: UIView {
    
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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
    func set(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}

// MARK: - Private Methods

private extension VerticalLabelDescriptionView {
    func setup() {
        titleLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        
        titleLabel.font = Fonts.kefa(size: 18)
        descriptionLabel.font = Fonts.kefa(size: 20)
    }
    
    func layout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
