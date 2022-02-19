//
//  WorldClockTableViewController.swift
//  worldClock
//
//  Created by 蕭鈺蒖 on 2022/2/10.
//

import UIKit

class WorldClockTableViewController: UITableViewController {
    
    var cityList = [cityInfo](){
        didSet{
            cityInfo.saveInfo(info: cityList)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cityList = cityInfo.loadData(){
            self.cityList = cityList
        }
        
        tableView.rowHeight = 90
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tableView.isEditing ? nil : self.tableView.reloadData()
        }
        timer.fire()
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(WorldClockTableViewCell.self)", for: indexPath) as? WorldClockTableViewCell else {return UITableViewCell()}
        let cityInfo = cityList[indexPath.row]
        cell.cityLabel.text = cityInfo.cityName
        cell.relativeHourLabel.text = cityInfo.relativeHour
        cell.relativeDateLabel.text = cityInfo.relativeDate
        cell.timeLabel.text = cityInfo.localTime
        
        // if u click edit button, the timeLabel will be hidden
        cell.timeLabel.isHidden = isEditing
        
        // the background color of cell won't change when you click the cell
        cell.selectionStyle = .none
        
        cell.overrideUserInterfaceStyle = .dark
        

        // Configure the cell...

        return cell
    }
    @IBAction func unwindToSearchTableViewController(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? SearchTableViewController,
           let city = sourceViewController.city{
            if !(cityList.contains(where: { cityInfo in
                cityInfo.cityName == city.cityName
            })){
                cityList.append(city)
            }
            
            
            tableView.reloadData()
        }
    }
    
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        cityList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
   

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // make the cell become movable
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let removeItem = cityList[fromIndexPath.row]
        cityList.remove(at: fromIndexPath.row)
        cityList.insert(removeItem, at: to.row)

    }
    

    @IBAction func clickEditButton(_ sender: UIBarButtonItem) {
        // set whether the view controller show the editable view
        super.setEditing(!tableView.isEditing , animated: true)
        sender.title = isEditing ? "Done": "Edit"
        
        tableView.allowsSelectionDuringEditing = true
        tableView.reloadData()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
