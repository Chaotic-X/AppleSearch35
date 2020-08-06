//
//  ItemTableViewCell.swift
//  AppleSearch35
//
//  Created by Alex Lundquist on 8/6/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

  //MARK: -Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var artistOrDesctiptionLabel: UILabel!
  @IBOutlet weak var artWorkImageView: UIImageView!
  
  //MARK: -Properties
  var musicItems: MusicSearchResults? {
    didSet{
      udpateViewWithMusicItem()
    }
  }
  var appItems: AppSearchResults? {
    didSet{
      updateViewWithAppItem()
    }
  }
  
  //MARK: -Helper Methods
  func udpateViewWithMusicItem() {
    if let stringURL = musicItems?.artworkUrl100 {
      SearchResultsController.fetchImage(forItem: stringURL) { (result) in
        DispatchQueue.main.async {
          switch result {
            case .success(let image):
              self.artWorkImageView.image = image
            case .failure(let error):
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
          } //End Switch
          self.titleLabel.text = self.musicItems?.trackName
          self.artistOrDesctiptionLabel.text = self.musicItems?.artistName
        } //End DispatchQueue
      } //End fetchImage
    } //If let
  } //End Function
  
  func updateViewWithAppItem() {
    if let stringURL = appItems?.artworkUrl100 {
      SearchResultsController.fetchImage(forItem: stringURL) { (result) in
        DispatchQueue.main.async {
          switch result {
            case .success(let image):
              self.artWorkImageView.image = image
            case .failure(let error):
              print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
          } //End Switch
          self.titleLabel.text = self.appItems?.trackName
          self.artistOrDesctiptionLabel.text = self.appItems?.description
        } //End DispatchQueue
      } //End fetchImage
    } //If let
  } //End Function
}
