//
//  ebook.swift
//  Query
//
//  Created by Fernanda Girelli on 10/16/24.
//


import Foundation



class eBookResult: Codable {
    let items: [eBook]
}

struct eBook: Codable, Identifiable{
    let id: String
    let volumeInfo: VolumeInfo
    
}

class VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let averageRating: Double?
    let imageLinks: ImageLinks
    let description: String?
   
    
}
class ImageLinks: Codable {
    let thumbnail: String
    let smallThumbnail: String
}
