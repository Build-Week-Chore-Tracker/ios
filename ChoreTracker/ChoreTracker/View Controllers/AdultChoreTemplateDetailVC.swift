//
//  AdultChoreTemplateDetailVC.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/26/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import CoreData

class AdultChoreTemplateDetailVC: UIViewController {

    var choreTemplate: ChoreTemplate?
    var pickerData: [String] = []
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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var pictureSwitch: UISwitch!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var periodPicker: UIPickerView!
    
    @IBOutlet weak var childPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .loginBackground
        periodPicker.delegate = self
        periodPicker.dataSource = self
        childPicker.delegate = self
        childPicker.dataSource = self
        pickerData.append("Daily")
        pickerData.append("Weekly")
        pickerData.append("Monthly")
        updateViews()
    }
    
    
    @IBAction func saveTemplateTapped(_ sender: Any) {
        var period: String = ""
        var assignedChild: User?
        guard   let name = nameTextField.text, !name.isEmpty,
                let description = descriptionTextField.text, !description.isEmpty,
                let notes = notesTextField.text, !notes.isEmpty,
                let points = pointsTextField.text
        else {
            alert(vc: self, title: "Error", message: "Please enter data for all fields.", error: nil)
            return
        }
        guard let pointsInt = Int32(points) else {
            alert(vc: self, title: "Error", message: "Please enter a valid number for Points.", error: nil)
            return
        }
        if childPicker.selectedRow(inComponent: 0) != 0 {
            assignedChild = childrenList[childPicker.selectedRow(inComponent: 0)-1]
            print ("Saving assigned child as \(String(describing: assignedChild))")
        }
        period = pickerData[periodPicker.selectedRow(inComponent: 0)]
        guard let currentUser = UserController.currentUser else { return }
        if let choreTemplate = choreTemplate { //Editing, so update
            ChoreTemplateController.shared.update(choreTemplate: choreTemplate, name: name, choreDescription: description, period: period, pictureEvidence: pictureSwitch.isOn, points: pointsInt, custom: true, owner: currentUser, notes: notes, parentTemplate: nil, assignedUser: assignedChild ?? nil)
        } else { //Create new one
            ChoreTemplateController.shared.create(name: name, choreDescription: description, period: period, pictureEvidence: pictureSwitch.isOn, points: pointsInt, custom: true, owner: currentUser, notes: notes, parentTemplate: nil, assignedUser: assignedChild ?? nil)
        }
        
        self.navigationController?.popViewController(animated: true)
    
    }
    
    
    private func updateViews() {
        if let choreTemplate = choreTemplate {
            nameTextField.text = choreTemplate.name
            descriptionTextField.text = choreTemplate.choreDescription
            notesTextField.text = choreTemplate.notes
            pictureSwitch.isOn = choreTemplate.pictureEvidence
            pointsTextField.text = String(choreTemplate.points)
            if let period = choreTemplate.period {
                switch period {
                case "Daily":
                    periodPicker.selectRow(0, inComponent: 0, animated: false)
                case "Weekly":
                    periodPicker.selectRow(1, inComponent: 0, animated: false)
                case "Monthly":
                    periodPicker.selectRow(2, inComponent: 0, animated: false)
                default:
                    break
                }
            }
        }
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

extension AdultChoreTemplateDetailVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return 3
        case 1:
            return childrenList.count + 1
        default:
            return 0
        }
    }
    
    
}

extension AdultChoreTemplateDetailVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return pickerData[row]
        case 1:
            //print ("Doing Child Picker...")
            if row == 0 {
                //print ("row 0...None")
                return "None"
            } else {
                //print ("other rows... \(childrenList[row-1].name ?? "Empty")")
                return childrenList[row-1].name ?? ""
            }
        default:
            return ""
        }
        
    }
}
