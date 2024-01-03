//
//  Movie.swift
//  MovieKids Project (Netflix Clone)
//
//  Created by Mahmud Cikrik on 08/12/2023.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let title: String?
    let original_language: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    let genre_ids: [Int]
}
