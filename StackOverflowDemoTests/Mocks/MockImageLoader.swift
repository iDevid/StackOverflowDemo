//
//  MockImageLoader.swift
//  StackOverflowDemo
//
//  Created by Davide Sibilio on 18/04/26.
//

import ImageLoader
import UIKit

@testable import StackOverflowDemo

final class MockImageLoader: ImageLoading {
    var loadImageCallCount = 0

    func loadImage(
        from urlString: String,
        cachePolicy: NSURLRequest.CachePolicy
    ) async throws -> UIImage {
        loadImageCallCount += 1
        return UIImage()
    }
}
