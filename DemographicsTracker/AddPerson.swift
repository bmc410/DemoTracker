//
//  AddPerson.swift
//  DemographicsTracker
//
//  Created by Bill McCoy on 5/23/16.
//  Copyright © 2016 WellSpan Health. All rights reserved.
//

import UIKit
import CoreData

class AddPerson: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var people = [NSManagedObject]()
    var stateList = ["AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID", "IL","IN","KS","KY","LA","MA","MD","ME","MH","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY", "OH","OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Street: UITextField!
    @IBOutlet weak var City: UITextField!
    @IBOutlet weak var ZIP: UITextField!
    @IBOutlet weak var State: UITextField!
    
    
    
    @IBAction func SavePerson(sender: UIBarButtonItem) {
        savePersonToDB()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        State.text = stateList[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        pickerView.backgroundColor = .whiteColor()
        pickerView.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(AddPerson.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        
        pickerView.delegate = self
       
        State.inputAccessoryView = toolBar
        State.inputView = pickerView
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func donePressed() {
        State.resignFirstResponder()
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    func getMaxID() -> Int{
        let fetchRequest = NSFetchRequest(entityName: "Person")
        var maxID: Int?
        
        //3
        do {
            let results =
                try managedObjectContext.executeFetchRequest(fetchRequest)
            let countID =  results.count - 1
            let topPerson = results[countID] as! Person
            maxID = Int(topPerson.personID!) + 1
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return maxID!

    }
    
    func savePersonToDB() {
        
        let person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.managedObjectContext) as! Person
        let address = NSEntityDescription.insertNewObjectForEntityForName("Address", inManagedObjectContext: self.managedObjectContext) as! Address

        
        person.firstName = FirstName.text
        person.lastName = LastName.text
        person.mrn = randomAlphaNumericString(9)
        person.personID = getMaxID()
        address.city = City.text
        address.street = Street.text
        address.state = State.text
        address.zip = ZIP.text
        address.personID = person.personID
        
        //4
        do {
            try managedObjectContext.save()
            //5
            //people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
       
}
