//
//  SearchTableViewController.swift
//  worldClock
//
//  Created by 蕭鈺蒖 on 2022/2/11.
//

import UIKit

protocol SearchTableViewControllerDelegate {
    func searchTableViewController( _ controller : SearchTableViewController, addCity city:cityInfo)
}

class SearchTableViewController: UITableViewController {
    
    var delegate : SearchTableViewControllerDelegate?
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if searching {
            return nil
        }
       
        return cityDictinaryKey[section]
    }

    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching{
            city = filterCityList[indexPath.row]
        }else {

            city = cityDictionary[cityDictinaryKey[indexPath.section]]![indexPath.row]
        }
        delegate?.searchTableViewController(self, addCity: city!)
        
        navigationController?.popViewController(animated: true)
    }

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

