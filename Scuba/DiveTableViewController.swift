//
//  DiveTableViewController.swift
//  Scuba
//
//  Created by Hubert Ka on 2018-01-09.
//  Copyright © 2018 Hubert Ka. All rights reserved.
//

import UIKit
import os.log

class DiveTableViewController: UITableViewController {

    //MARK: Properties
    var dives = [Dive]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved dives, otherwise load sample data
        if let savedDives = loadDives() {
            dives += savedDives
        }
        else {
            // Load sample data.
            loadSampleDives()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dives.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DiveTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DiveTableViewCell else {
            fatalError("The dequeued cell is not an instance of DiveTableViewCell.")
        }
        
        // Fetches the appropriate dive for the data source layout.
        let dive = dives[indexPath.row]

        // Configure the cell.
        cell.diveNumberLabel.text = dive.diveNumber
        cell.activityLabel.text = dive.activity
        cell.dateLabel.text = dive.date
        cell.locationLabel.text = dive.location
        cell.photoImageView.image = dive.photo

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dives.remove(at: indexPath.row)
            saveDives()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch(segue.identifier ?? "") {
        case "AddDive":
            os_log("Adding a new dive.", log: OSLog.default, type: .debug)
            
        case "ShowDive":
            guard let diveDetailViewController = segue.destination as? DiveViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDiveCell = sender as? DiveTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDiveCell) else {
                fatalError("The selected cell is not being displayed by the table.")
            }
            
            let selectedDive = dives[indexPath.row]
            diveDetailViewController.dive = selectedDive
            
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier ?? "")")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToDiveList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DiveViewController, let dive = sourceViewController.dive {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing dive.
                dives[selectedIndexPath.row] = dive
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                
                // Add a new dive.
                let newIndexPath = IndexPath(row: 0, section: 0)
                
                dives.insert(dive, at: 0)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the dives.
            saveDives()
        }
    }

    //MARK: Private Methods
    private func loadSampleDives() {
        let photo1 = UIImage(named: "dive1")
        let photo2 = UIImage(named: "dive2")
        let photo3 = UIImage(named: "dive3")
        
        guard let dive1 = Dive(diveNumber: "1", activity: "Refresh dive, Dominican Republic", date: "10/03/17", location: "St George Wreck, Bayahibe", photo: photo1) else {
            fatalError("Unable to instantiate dive1.")
        }
        
        guard let dive2 = Dive(diveNumber: "2", activity: "Fun dive 1, Dominican Republic", date: "10/03/17", location: "St George Wreck, Bayahibe", photo: photo2) else  {
            fatalError("Unable to instantiate dive2.")
        }
        
        guard let dive3 = Dive(diveNumber: "3", activity: "Fun dive 2, Dominican Republic", date: "10/03/17", location: "Atlantic Princess, Bayahibe", photo: photo3) else {
            fatalError("Unable to instantiate dive3.")
        }
        
        dives += [dive3, dive2, dive1]
    }
    
    private func saveDives() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dives, toFile: Dive.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Dives successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save dives...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadDives() -> [Dive]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Dive.ArchiveURL.path) as? [Dive]
    }
}
