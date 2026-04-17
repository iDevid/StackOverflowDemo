import UIKit

public protocol ImageLoading {
    func loadImage(
        from urlString: String,
        cachePolicy: NSURLRequest.CachePolicy
    ) async throws -> UIImage
}

public class ImageLoader: ImageLoading {
    private let urlSession: URLSession

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

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
