/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreData

class PeopleTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "People"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PeopleTableViewController.addPerson(_:)))
        
        reloadData()
    }
    
    func reloadData() {
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        do {
            if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Person] {
                people = results
            }
        } catch {
            fatalError("There was an error fetching the list of people!")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath)
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func addPerson(sender: AnyObject?) {
        let alert = UIAlertController(title: "New person", message: "Add new person", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action:UIAlertAction) in
            let textField = alert.textFields?.first
            if let name = textField?.text {
                guard let personEntity = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.managedObjectContext) else {
                    fatalError("Could not find entity descriptions!")
                }
                let person = Person(entity: personEntity, insertIntoManagedObjectContext: self.managedObjectContext)
                person.name = name
                self.saveContext()
                self.people.append(person)
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) in
            
        }
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}
