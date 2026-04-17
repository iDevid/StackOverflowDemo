//
//  ImageLoaderError.swift
//  ImageLoader
//
//  Created by Davide Sibilio on 17/04/26.
//

public enum ImageLoaderError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}
