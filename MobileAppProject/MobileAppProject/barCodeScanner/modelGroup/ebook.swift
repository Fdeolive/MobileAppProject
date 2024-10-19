//
//  ebook.swift
//  Query
//
//  Created by Fernanda Girelli on 10/16/24.
//

import Foundation

// MARK: - EbookResult
class ebookResult: Codable {
    let resultCount: Int
    let results: [eBook]

    init(resultCount: Int, results: [eBook]) {
        self.resultCount = resultCount
        self.results = results
    }
}

// MARK: - Result
struct eBook: Codable, Identifiable{
    let price: Double?
    let genreIDS: [String]
    let releaseDate: String
    let id: Int
    let trackName: String
    let artistIDS: [Int]
    let kind: Kind
    let currency: Currency
    let description, trackCensoredName: String
    let fileSizeBytes: Int?
    let formattedPrice: String?
    let trackViewURL: String
    let artworkUrl60, artworkUrl100: String
    let artistViewURL: String
    let genres: [String]
    let artistID: Int
    let artistName: String
    let averageUserRating: Double?
    let userRatingCount: Int?

    enum CodingKeys: String, CodingKey {
        case price
        case genreIDS = "genreIds"
        case releaseDate
        case id = "trackId"
        case trackName
        case artistIDS = "artistIds"
        case kind, currency, description, trackCensoredName, fileSizeBytes, formattedPrice
        case trackViewURL = "trackViewUrl"
        case artworkUrl60, artworkUrl100
        case artistViewURL = "artistViewUrl"
        case genres
        case artistID = "artistId"
        case artistName, averageUserRating, userRatingCount
    }

    init(price: Double?, genreIDS: [String], releaseDate: String, trackID: Int, trackName: String, artistIDS: [Int], kind: Kind, currency: Currency, description: String, trackCensoredName: String, fileSizeBytes: Int?, formattedPrice: String?, trackViewURL: String, artworkUrl60: String, artworkUrl100: String, artistViewURL: String, genres: [String], artistID: Int, artistName: String, averageUserRating: Double?, userRatingCount: Int?) {
        self.price = price
        self.genreIDS = genreIDS
        self.releaseDate = releaseDate
        self.id = trackID
        self.trackName = trackName
        self.artistIDS = artistIDS
        self.kind = kind
        self.currency = currency
        self.description = description
        self.trackCensoredName = trackCensoredName
        self.fileSizeBytes = fileSizeBytes
        self.formattedPrice = formattedPrice
        self.trackViewURL = trackViewURL
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl100 = artworkUrl100
        self.artistViewURL = artistViewURL
        self.genres = genres
        self.artistID = artistID
        self.artistName = artistName
        self.averageUserRating = averageUserRating
        self.userRatingCount = userRatingCount
    }
}

enum Currency: String, Codable {
    case usd = "USD"
}

enum Kind: String, Codable {
    case ebook = "ebook"
}

