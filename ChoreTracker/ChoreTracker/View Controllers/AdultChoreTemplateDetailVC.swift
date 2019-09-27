//
//  AdultChoreTemplateDetailVC.swift
//  ChoreTracker
//
//  Created by Joshua Sharp on 9/26/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class AdultChoreTemplateDetailVC: UIViewController {

    var choreTemplate: ChoreTemplate?
    var choreTemplateController: ChoreTemplateController?
    var pickerData: [String] = []
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var pictureSwitch: UISwitch!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var periodPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .loginBackground
        periodPicker.delegate = self
        periodPicker.dataSource = self
        pickerData.append("Daily")
        pickerData.append("Weekly")
        pickerData.append("Monthly")
        updateViews()
    }
    
    
    @IBAction func saveTemplateTapped(_ sender: Any) {
        var period: String = ""
        guard   let choreTemplateController = choreTemplateController,
                let name = nameTextField.text, !name.isEmpty,
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
        period = pickerData[periodPicker.selectedRow(inComponent: 0)]
        guard let currentUser = UserController.currentUser else { return }
        choreTemplateController.create(name: name, choreDescription: description, period: period, pictureEvidence: pictureSwitch.isOn, points: pointsInt, custom: true, owner: currentUser, notes: notes, parentTemplate: nil, assignedUser: nil)
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    private func updateViews() {
        if let choreTemplate = choreTemplate {
            nameTextField.text = choreTemplate.name
            descriptionTextField.text = choreTemplate.description
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
        return 3
    }
    
    
}

extension AdultChoreTemplateDetailVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
