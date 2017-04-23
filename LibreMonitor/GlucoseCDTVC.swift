//
//  GlucoseCDTVC.swift
//  LibreMonitor
//
//  Created by Uwe Petersen on 19.04.17.
//  Copyright © 2017 Uwe Petersen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GlucoseCDTVC: FetchedResultsTableViewController {
    
    var coreDataStack = CoreDataStack() {
        didSet { updateUI() }
    }
    var fetchedResultsController: NSFetchedResultsController<BloodGlucose>?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
     func updateUI() {
        
        let context = coreDataStack.managedObjectContext
        let request: NSFetchRequest<BloodGlucose> = BloodGlucose.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(
            key: "dateString",
            ascending: false,
            selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
        )]
        request.predicate = nil // all 
        fetchedResultsController = NSFetchedResultsController<BloodGlucose>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "glucoseCell", for: indexPath)
        if let bloodGlucose = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = bloodGlucose.value.description
            cell.detailTextLabel?.text = bloodGlucose.dateString ?? " "
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let bloodGlucose = fetchedResultsController?.object(at: indexPath) {
                coreDataStack.managedObjectContext.delete(bloodGlucose)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    // MARK: - TableView Delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
