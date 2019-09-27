//
//  AdultChoreDetailVC.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import CoreData

class AdultChoreDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chore: Chore?
    var choreController: ChoreController?
    
    lazy var frc: NSFetchedResultsController<ChoreTemplate>? = {
        let fetchRequest: NSFetchRequest<ChoreTemplate> = ChoreTemplate.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let currentUser = UserController.currentUser else { return nil }
        fetchRequest.predicate = NSPredicate(format: "owner == %@", currentUser)
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do { try frc.performFetch() } catch { fatalError("NSFetchedResultsController failed: \(error)") }
        print ("AdultChoreDetailTableVC: Chores fetched: \(String(describing: frc.fetchedObjects?.count))")
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
		view.backgroundColor = .loginBackground
        childPicker.delegate = self
        childPicker.dataSource = self
    }

	override func viewWillAppear(_ animated: Bool) {
		navigationItem.title = "Chores"
	}
    
    @IBAction func savetapped(_ sender: Any) {
    }
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var pointsText: UILabel!
    @IBOutlet weak var pictureSwitch: UISwitch!
    @IBOutlet weak var childPicker: UIPickerView!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    
    var childrenList: [User] = {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let currentUser = UserController.currentUser else { return [] }
        //print ("childrenList: CurrentUser = \(String(describing: currentUser))")
        fetchRequest.predicate = NSPredicate(format: "parent == %@", currentUser)
        do {
            let children = try context.fetch(fetchRequest)
            //print ("childrenList: Children = \(String(describing: children))")
            return children
        } catch {
            NSLog("uniqueLoginName: Error fetching children for picker")
            return []
        }
    } ()
    
    
    private func updateViews(_ choreTemplate: ChoreTemplate? = nil) {
        if let choreTemplate = choreTemplate {
            //Setup from ChoreTemplate
            descriptionText.text = choreTemplate.choreDescription
            notesText.text = choreTemplate.notes
            let pointsString = String(choreTemplate.points)
            pointsText.text = pointsString
            if let assignedUser = choreTemplate.assignedUser {
                
            }
            
    //            if childPicker.selectedRow(inComponent: 0) != 0 {
    //                assignedChild = childrenList[childPicker.selectedRow(inComponent: 0)-1]
    //                print ("Saving assigned child as \(String(describing: assignedChild))")
    //            }
            
        }
    }
}

extension AdultChoreDetailVC: UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let frc = frc else { return 0}
        return frc.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let frc = frc else { return 0}
        return frc.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let frc = frc else { return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoreTemplateCell", for: indexPath)
        let choreTemplate = frc.object(at: indexPath)
        cell.textLabel?.text = choreTemplate.name
        cell.detailTextLabel?.text = choreTemplate.choreDescription
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let frc = frc else { return }
        if editingStyle == .delete {
            // Delete the row from the data source
            ChoreTemplateController.shared.delete(choreTemplate: frc.object(at: indexPath))
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AdultChoreTemplateDetailVC else { return }
        guard let frc = frc else { return }
        switch segue.identifier {
        case "ChoreTemplateDetailSegue":
            if let indexPath = tableView.indexPathForSelectedRow {
                let choreTemplate = frc.object(at: indexPath)
                vc.choreTemplate = choreTemplate
                NSLog("AdultChoreDetailVC: Sending choreTemplate: \(String(describing: choreTemplate))")
            }
        case "AddChoreSegue":
            break
        default:
            break
        }
    }
}


extension AdultChoreDetailVC: UITableViewDelegate {
 
    private func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        guard let frc = frc else { return }
        let choreTemplate = frc.object(at: didSelectRowAt)
        updateViews(choreTemplate)
    }
}

extension AdultChoreDetailVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError("Unknown Change Type occured")
        }
    }
}

extension AdultChoreDetailVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return childrenList.count + 1
    }
    
    
}

extension AdultChoreDetailVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print ("Doing Child Picker...")
        if row == 0 {
            //print ("row 0...None")
            return "None"
        } else {
            //print ("other rows... \(childrenList[row-1].name ?? "Empty")")
            return childrenList[row-1].name ?? ""
        }
    }
}
