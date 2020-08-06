//
//  SearchResultsController.swift
//  AppleSearch35
//
//  Created by Alex Lundquist on 8/6/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import Foundation
import class UIKit.UIImage

class SearchResultsController {
  //MARK: -Constants for "Magic Strings"
  static let baseURL = URL(string: "https://itunes.apple.com")
  static let searchComponent = "search"
  static let searchTermKey = "term"
  static let entityKey = "entity"
  static let entityMusicValue = "musicTrack"
  static let entityAppValue = "software"
//  static let
  //MARK: -Music Fetch
  //We are using MusicSearchResults becuase that is what we are looking to return. Whether that be a 2nd - 3rd - 4th level deep item.
  static func fetchMusicItem(for searchTerm: String, completion: @escaping(Result<[MusicSearchResults], ResultsError>) -> Void) {
    //1. Build URL
    guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
    //1a. Build URL components
    //1st:  appendingPathComponents
    let searchURL = baseURL.appendingPathComponent(searchComponent)
    //2nd: our query items - need URLComponents to allow us to append QueryItems
    var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
    //3rd: Build out our query items
    let searchQuery = URLQueryItem(name: searchTermKey, value: searchTerm)
    let entityQuery = URLQueryItem(name: entityKey, value: entityMusicValue)
    //4th: Now create an array of those queryitems in the order in which they appear in the URL we are building
    components?.queryItems = [searchQuery, entityQuery]
    //5th: Now put it all together calling the url property on "components" since its optional. Guard againts that.
    guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
    print(finalURL.absoluteString)
    //2.) - Contact server by building our URLSession
    URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
      //3.) - Handle errors from the server
      if let error = error {
        print("Error contacting the server in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        return completion(.failure(.thrownError(error)))
      }
      //4.) - Check if data exists and guard against it
      guard let data = data else { return completion(.failure(.noData))}
      //5.) - Initialize the data in a do-catch
      do{
        //****I Need detailed documentation here on what the hell is happening****
        ///We are using MusicTopLevelObject and NOT [MusicSearchResults] because we are decoding from our "TopLevelObject"
        ///and then assigning that to a property that will take on whatever "TYPE" comes back from that TopLevelObject.
        ///If that is an array. Then that will be an array.
        ///We should have defined the return object or completing with object as an array up top in brackets [ReturnObject/CompletingWith]
        ///If it's a dictonary, then we return the object or complete with the object withOUT braces "ReturnObject/CompletingWith"
        ///All of this should have been defined in our Model as to what type we should be returning/completing with
        let topLevelObject = try JSONDecoder().decode(MusicTopLevelObject.self, from: data)
        //Because we are looking for an array of results which is defined in our model object. We append our topLevelObject with ".results"
        // results was defined in our JSON as to what to use as a "name" for our topLevelObject in our Model.
        // The JSON defined it as an Array
        let musicItems = topLevelObject.results
        //Because all we are looking to do is return an Array of reults. We are done here and simply return that item.
        //In this case that is musicItem
        //if we had more levels to dig into.. we would build that out by accessing what is in "results".
        //The item up top is what we are wanting to return. If that is in a 2nd - 3rd - 4th layer deep, then that is what we put up top.
        //in our JSON we will always start with the TopLevelObject
        return completion(.success(musicItems))
      } catch {
        return completion(.failure(.thrownError(error)))
      }
      //6.) - RESUME!!!
    }.resume() //End of URLSession
  } //End of fetchMusic
  
  //MARK: -App Fetch
  static func fetchAppItem(for searchTerm: String, completion: @escaping(Result<[AppSearchResults], ResultsError>) -> Void) {
    //1.) Build URL
    guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
    //1a.) Build URL components
    //1st:  appendingPathComponents
    let searchURL = baseURL.appendingPathComponent(searchComponent)
    //2nd: our query items - need URLComponents to allow us to append QueryItems
    var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
    //3rd: Build out our query items
    let searchQuery = URLQueryItem(name: searchTermKey, value: searchTerm)
    let entityQuery = URLQueryItem(name: entityKey, value: entityAppValue)
    //4th: Now create an array of those queryitems in the order in which they appear in the URL we are building
    components?.queryItems = [searchQuery, entityQuery]
    //5th: Now put it all together calling the url property on "components" since its optional. Guard againts that
    guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
    print(finalURL.absoluteString)
    //2.) - Contact server by building our URLSession
    URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
      //3.) - Handle errors from the server
      if let error = error {
        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        return completion(.failure(.thrownError(error)))
      }
      //4.) - Check if data exists and guard against it
      guard let data = data else { return completion(.failure(.noData))}
      //5.) - Initialize the data in a do-catch
      do {
        let topLevelObject = try JSONDecoder().decode(AppTopLevelObject.self, from: data)
        let appItems = topLevelObject.results
        return completion(.success(appItems))
      } catch {
        return completion(.failure(.thrownError(error)))
      }
      //6.) - RESUME!!!
    }.resume()
  } //End of FetchApp
  
  //MARK: -Image Fetch
  static func fetchImage(forItem imageURL: String, completion: @escaping(Result<UIImage, ResultsError>) -> Void) {
    //1.) Build URL
    guard let imageURL = URL(string: imageURL) else { return completion(.failure(.invalidURL))}
    //2.) - Contact server by building our URLSession
    URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
      //3.) - Handle errors from the server
      if let error = error {
        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        return completion(.failure(.thrownError(error)))
      }
      //4.) - Check if data exists and guard against it
      guard let data = data else { return completion(.failure(.noData))}
      //5.) - Initialize our image from our data
      //5a so we unwrap our image and call our UIImage(data: Data?) option to set out image
      guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
      //return and complete with out image
      return completion(.success(image))
      //6.) - RESUME!!!
    }.resume()
  } //End of FetchImage
} //End of SearchResults Class
