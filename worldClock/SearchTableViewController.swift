//
//  SearchTableViewController.swift
//  worldClock
//
//  Created by 蕭鈺蒖 on 2022/2/11.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var cityDictionary = [String : [cityInfo]]()
    var cityDictinaryKey = [String]()
    var searching = false
    lazy var filterCityList = knownCityList
    var knownCityList = [cityInfo]()
    var city : cityInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarSetting()
        sectionHeaderSetting()

        
    }
    
    func searchBarSetting(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchTextField.textColor = .white
        searchController.automaticallyShowsCancelButton = true
    }
    
    
    func sectionHeaderSetting(){
        for cityID in knownTimeZoneID{
            let city = cityInfo(identify: cityID)
            knownCityList.append(city)
            
            if cityDictionary.keys.contains(city.cityPrefix){
                cityDictionary[city.cityPrefix]!.append(city)
            }else{
                cityDictionary[city.cityPrefix] = [city]
            }
        }
        cityDictinaryKey = Array(cityDictionary.keys).sorted(by: <)
    }
    
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searching {
            return 1
        }
        return cityDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterCityList.count
        }
        return cityDictionary[cityDictinaryKey[section]]!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(SearchTableViewCell.self)", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        if searching {
            let cityId = filterCityList[indexPath.row]
            cell.SearchCityLabel.text = cityId.cityName
        }else{
            let cityId = cityDictionary[cityDictinaryKey[indexPath.section]]![indexPath.row]
            
            cell.SearchCityLabel.text = cityId.cityName

        }
        
        
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if searching {
            return nil
        }
       
        return cityDictinaryKey[section]
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if searching{
            guard let row = tableView.indexPathForSelectedRow?.row else {return }
            city = filterCityList[row]
        }else {
            guard let section = tableView.indexPathForSelectedRow?.section else {return }
            guard let row = tableView.indexPathForSelectedRow?.row else {return }
            city = cityDictionary[cityDictinaryKey[section]]![row]
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        
        if let searchText = searchController.searchBar.text,
           searchText.isEmpty == false{
            searching = true
            filterCityList = knownCityList.filter({ city in
                city.cityName.localizedStandardContains(searchText)
            })
            
            
        }else{
            searching = false
            filterCityList = knownCityList
        }
        
        tableView.reloadData()
        
    
    }
}

