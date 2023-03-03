import UIKit

protocol ImageCacheStorageProtocol {
    func getFromCache(id: String) -> UIImage?
    func loadImage(id: String, urlString: String?, completion: @escaping ((UIImage?) -> ()))
}

final class ImageCacheStorage: ImageCacheStorageProtocol {
    
    static let shared: ImageCacheStorageProtocol = ImageCacheStorage()
    
    // MARK: - Private Properties
    private let cache = NSCache<NSString, UIImage>()
    private var queue = DispatchQueue(label: "com.pokeApp.imageLoad", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit)
    
    // MARK: - Init
    private init() {}
    
    // MARK: - ImageCacheStorageProtocol
    func loadImage(id: String, urlString: String?, completion: @escaping ((UIImage?) -> ())) {
        guard let urlString = urlString, let url = NSURL(string: urlString) else {
            return completion(nil)
        }

        if let cachedImage = cache.object(forKey: id as NSString) {
            completion(cachedImage)
        } else {
            queue.async { [weak self] in
                guard let data = try? Data(contentsOf: url as URL),
                      let image = UIImage(data: data) else { return DispatchQueue.main.async { completion(nil) } }
                
                self?.cache.setObject(image, forKey: id as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    func getFromCache(id: String) -> UIImage? {
        return cache.object(forKey: id as NSString)
    }
}
