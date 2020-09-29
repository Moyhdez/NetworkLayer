//
//  Movie.swift
//  ModernNetworkLayer
//
//  Created by Moises Hernandez Zamarripa on 29/09/20.
//  Copyright © 2020 cjapps. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let posterPath: String
    let backdropPath: String
    let title: String
    let releaseDate: Date
    let overview: String
}
