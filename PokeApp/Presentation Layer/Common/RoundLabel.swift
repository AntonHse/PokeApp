import UIKit

final class RoundLabel: UIView {
    
    var text: String? {
        didSet {
            handleNameColor(text: text ?? "")
            label.text = text?.capitalized
        }
    }
    
    // MARK: - Private Properties
    private let label = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}

// MARK: - Private Methods
private extension RoundLabel {
    
    func setup() {
        label.font = Fonts.kefa(size: 16)
        backgroundColor = .systemBlue
    }
    
    func layout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    // MARK: - Logic in View Model
    func handleNameColor(text: String) {
        switch text {
        case "water":
            backgroundColor = .blue
        case "grass":
            backgroundColor = .systemGreen
        case "poison":
            backgroundColor = .green
        case "fire":
            backgroundColor = .red
        case "flying":
            backgroundColor = .systemBlue
        case "bug":
            backgroundColor = .systemBrown
        case "ground":
            backgroundColor = .brown
        case "ghost":
            backgroundColor = .systemGray3
        case "electric":
            backgroundColor = .systemYellow
        case "ice":
            backgroundColor = .systemBlue
        case "dragon":
            backgroundColor = .systemRed
        default:
            backgroundColor = .black
        }
        
        label.textColor = (backgroundColor ?? .black).isLight() ? .black : .white
    }
}
