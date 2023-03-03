import Foundation

extension String {
    /// Create a URL from the string
    /// - returns: A new URL based on the given string value
    func toURL() -> URL? {
        guard let url = URL(string: self) else { return nil }
        return url
    }
}
