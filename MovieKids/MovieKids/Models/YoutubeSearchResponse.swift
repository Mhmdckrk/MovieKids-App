//
//  YoutubeSearchResponse.swift
//  MovieKids Project (Netflix Clone)
//
//  Created by Mahmud Cikrik on 06/01/2023.
//

import Foundation



struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
