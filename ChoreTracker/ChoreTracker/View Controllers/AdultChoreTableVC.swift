//
//  AdultChoreTableViewController.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import CoreData

class AdultChoreTableViewController: UITableViewController {
    
    let choreController = ChoreController()
    
    lazy var choreFRC: NSFetchedResultsController<Chore>? = {
        let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
        guard let currentUser = UserController.currentUser else { return nil }
        fetchRequest.predicate = NSPredicate(format: "owner == %@", currentUser)
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do { try frc.performFetch() } catch { fatalError("NSFetchedResultsController failed: \(error)") }
        print ("AdultChoreTableVC: Chores fetched: \(String(describing: frc.fetchedObjects?.count))")
        return frc
    }()
    
    @IBAction func unwindToTableView(segue: UIStoryboardSegue) {}


    
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .loginBackground
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let frc = choreFRC else { return 0}
        return frc.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let frc = choreFRC else { return 0}
        return frc.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "adultChoreCell", for: indexPath) as? AdultChoreViewCell,
            let frc = choreFRC
            else { return UITableViewCell() }
        cell.chore = frc.object(at: indexPath)
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let frc = choreFRC else { return }
        if editingStyle == .delete {
            // Delete the row from the data source
            ChoreController.shared.delete(chore: frc.object(at: indexPath))
        } else if editingStyle == .insert {
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

		navigationItem.title = nil
		
        guard let vc = segue.destination as? AdultChoreDetailVC else { return }
        guard let frc = choreFRC else { return }
        vc.choreController = choreController
        switch segue.identifier {
        case "EditChoreSegue":
            if let indexPath = tableView.indexPathForSelectedRow {
                let chore = frc.object(at: indexPath)
                vc.chore = chore
                NSLog("AdultChoreTableVC: Sending chore: \(String(describing: chore.choreTemplate?.name))")
            }
        case "AddChoreSegue":
            break
        default:
            break
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension AdultChoreTableViewController: NSFetchedResultsControllerDelegate {
    
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
