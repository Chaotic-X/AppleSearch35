//
//  SearchItem.swift
//  AppleSearch35
//
//  Created by Alex Lundquist on 8/6/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation

struct MusicTopLevelObject: Decodable {
  let results: [MusicSearchResults]
}

struct MusicSearchResults: Decodable {
  let artistName: String
  let trackName: String
  let artworkUrl100: String
}

struct AppTopLevelObject: Decodable {
  let results: [AppSearchResults]
}

struct AppSearchResults: Decodable {
  let trackName: String
  let description: String
  let artworkUrl100: String
}
