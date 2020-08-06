//
//  SearchTableViewController.swift
//  AppleSearch35
//
//  Created by Alex Lundquist on 8/6/20.
//  Copyright © 2020 Alex Lundquist. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
  
  //MARK: -Outlets
  @IBOutlet weak var appleSearchBar: UISearchBar!
  @IBOutlet weak var appleSegmentedController: UISegmentedControl!
  
  //MARK: -Properties
  var musicItems: [MusicSearchResults] = []
  var appItems: [AppSearchResults] = []
  //MARK: -LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    //Set the SearchBar Delegate
    appleSearchBar.delegate = self
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return appleSegmentedController.selectedSegmentIndex == 0 ? musicItems.count : appItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell()}
    if appleSegmentedController.selectedSegmentIndex == 0 {
      let musicItems = self.musicItems[indexPath.row]
      cell.musicItems = musicItems
    } else {
      let appItems = self.appItems[indexPath.row]
      cell.appItems = appItems
    }
    return cell
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   //Setting Custom Back Button Text
   navigationItem.backBarButtonItem = UIBarButtonItem(
   title: "Back", style: .plain, target: nil, action: nil)
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

//MARK: -Extensions
extension SearchTableViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    guard let searcTerm = appleSearchBar.text, !searcTerm.isEmpty else { return }
    if appleSegmentedController.selectedSegmentIndex == 0 {
      SearchResultsController.fetchMusicItem(for: searcTerm) { (result) in
        DispatchQueue.main.async {
          switch result {
            case .success(let musicItems):
              self.musicItems = musicItems
              self.tableView.reloadData()
            case .failure(let error):
              print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
          } //End Switch
        } //DispatchQueue
      } //End FetchMusic
    } else  {//End if Segmented
      SearchResultsController.fetchAppItem(for: searcTerm) { (result) in
        DispatchQueue.main.async {
          switch result {
            case .success(let appItems):
              self.appItems = appItems
              self.tableView.reloadData()
            case .failure(let error):
              print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
          }//End Switch
        } //DispatchQueue
      } //End FetchApp
    } //End Else
  } //End SearchBarButtonClicked
} //End extension
