//
//  ChildTableVC.swift
//  ChoreTracker
//
//  Created by Percy Ngan on 9/24/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import CoreData

class ChildTableVC: UITableViewController {

	let choreController = ChoreController()
	let choreTemplateController = ChoreTemplateController()

	lazy var fetchResultsController: NSFetchedResultsController<Chore>  = {

		let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "choreTemplate.name", ascending: true)]

		// YOU MUST make the descriptor with the same key path as the sectionNameKeyPath be the first sort descriptor in this array

		let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
											 managedObjectContext: CoreDataStack.shared.mainContext,
											 sectionNameKeyPath: "choreTemplate.name",
											 cacheName: nil)

		frc.delegate = self as NSFetchedResultsControllerDelegate

		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}

		return frc
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .loginBackground

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	// MARK: - Methods



	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchResultsController.sections?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchResultsController.sections?[section].numberOfObjects ?? 0
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChoreCell", for: indexPath)

		let chore = fetchResultsController.object(at: indexPath)

		cell.textLabel?.text = chore.choreTemplate?.name

		return cell
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		guard let sectionInfo = fetchResultsController.sections?[section] else { return nil }

		return sectionInfo.name.capitalized
	}

	/*
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
	// Return false if you do not want the specified item to be editable.
	return true
	}
	*/


	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			let chore = fetchResultsController.object(at: indexPath)

			choreController.delete(chore: chore)
		}

		// MARK: - Navigation

		// In a storyboard-based application, you will often want to do a little preparation before navigation
		func prepare(for segue: UIStoryboardSegue, sender: Any?) {
			// Get the new view controller using segue.destination.
			if segue.identifier == "ChildChoreSegue" {
				guard let detailVC = segue.destination as? ChildChoreDetailVC, let indexPath = tableView.indexPathForSelectedRow else { return }

				let chore = fetchResultsController.object(at: indexPath)

				detailVC.chore = chore
				detailVC.choreController = choreController
			}
		}
	}
}

extension ChildTableVC: NSFetchedResultsControllerDelegate {

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
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
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		@unknown default:
			return
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {

		let sectionSet = IndexSet(integer: sectionIndex)

		switch type {
		case .insert:
			tableView.insertSections(sectionSet, with: .automatic)
		case .delete:
			tableView.deleteSections(sectionSet, with: .automatic)
		default:
			return
		}
	}
}
