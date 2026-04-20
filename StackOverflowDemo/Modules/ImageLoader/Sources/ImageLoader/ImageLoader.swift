import UIKit

/// Protocol for loading images from URLs asynchronously.
public protocol ImageLoading {
    /// Loads a UIImage from a URL.
    /// - Parameters:
    ///   - urlString: The image URL as a string.
    ///   - cachePolicy: How to handle caching
    /// - Returns: A decoded UIImage.
    func loadImage(
        from urlString: String,
        cachePolicy: NSURLRequest.CachePolicy
    ) async throws -> UIImage
}

/// A concrete ImageLoading class
public class ImageLoader: ImageLoading {
    private let urlSession: URLSession

    /// Initializes the loader with a URLSession.
    /// - Parameter urlSession: The session to use for HTTP requests. Defaults to URLSession.shared.
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    /// Fetches and decodes an image from a URL.
    /// Caching is handled automatically by URLSession based on HTTP headers and cache policy.
    /// - Parameters:
    ///   - urlString: The image URL.
    ///   - cachePolicy: How to use the HTTP cache.
    /// - Returns: The decoded image.
    /// - Throws: `ImageLoaderError`
    public func loadImage(
        from urlString: String,
        cachePolicy: NSURLRequest.CachePolicy
    ) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageLoaderError.invalidURL
        }

        var request = URLRequest(url: url)
        request.cachePolicy = cachePolicy

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ImageLoaderError.invalidResponse
        }

        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.decodingFailed
        }

        return image
    }
}
