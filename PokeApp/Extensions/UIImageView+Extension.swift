import UIKit

private let cache = NSCache<NSURL, UIImage>()

extension UIImageView {
    func setImage(with urlString: String, placeholder: UIImage?) {
        guard let url = NSURL(string: urlString) else {
            image = placeholder
            return
        }

        if let cachedImage = cache.object(forKey: url) {
            image = cachedImage
        } else {
            guard let data = try? Data(contentsOf: url as URL),
                  let image = UIImage(data: data) else { return }
            
            cache.setObject(image, forKey: url)
            self.image = image
        }
    }
}
