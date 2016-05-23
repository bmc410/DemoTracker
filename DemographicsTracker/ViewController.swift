//
//  ViewController.swift
//  DemographicsTracker
//
//  Created by Bill McCoy on 5/20/16.
//  Copyright © 2016 WellSpan Health. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var names = [String]()
    var people = [NSManagedObject]()
    var address = [NSManagedObject]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.didReceiveMemoryWarning()
        title = "Patients"
        
        let personfetchRequest = NSFetchRequest(entityName: "Person")
        let addressfetchRequest = NSFetchRequest(entityName: "Address")
        
        //3
        do {
            var results =
                try managedObjectContext.executeFetchRequest(personfetchRequest)
            people = results as! [NSManagedObject]
            results =
                try managedObjectContext.executeFetchRequest(addressfetchRequest)
            address = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        tableView.registerClass(UITableViewCell.self,
                                forCellReuseIdentifier: "Cell")
       
        
        self.tableView.reloadData()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath)
            as! Contact
       
        
        let person = people[indexPath.row] as! Person
        let addr = address[indexPath.row] as! Address
        cell.NameCell.text = person.firstName! + " " + person.lastName!
        cell.StreetCell.text = addr.street
        cell.StateCell.text = addr.state
        cell.CityCell.text = addr.city
        cell.ZipCell.text = addr.zip
        cell.MRN.text = "MRN: " + person.mrn!
        
        return cell
    }
}

