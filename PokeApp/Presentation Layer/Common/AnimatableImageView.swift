import UIKit

final class AnimatableImageView: UIView {
    
    var image: UIImage? {
        didSet {
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
        }
    }

    var placeholderImage: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            } else {
                imageView.contentMode = .center
                imageView.image = placeholderImage
            }
        }
    }
    
    // MARK: - Private Properties
    private let imageView = UIImageView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        imageView.contentMode = .center
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func set(image: UIImage?, animation: Bool = true) {
        guard let image = image, self.image == nil, animation else {
            imageView.image = image
            return
        }
        animateChange(newImage: image)
    }
}

// MARK: - Private Methods
private extension AnimatableImageView {
    func layout() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func animateChange(newImage: UIImage) {
        scaleInAndRotate(newImage: newImage)
    }
    
    func scaleInAndRotate(newImage: UIImage) {
        guard let _ = placeholderImage else {
            imageView.image = image
            return
        }

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            },
            completion: { _ in
                self.scaleOut(newImage: newImage)
            })
    }
    
    func scaleOut(newImage: UIImage) {
        imageView.contentMode = .scaleAspectFit
        imageView.image = newImage

        UIView.animate(withDuration: 1) {
            self.imageView.transform = CGAffineTransform.identity
        }
    }
}
