//
//  BookDetailViewController.swift
//  bookdana
//
//  Created by 渡辺大智 on 2022/11/26.
//

import UIKit

class BookSubscribeViewController: UIViewController {

    var bookName: String?
    @IBOutlet weak var bookInformation: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        let text = self.bookInformation.text ?? ""
        self.saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let button = sender as? UIBarButtonItem, button === self.saveButton else {
            return
        }
        self.bookName = self.bookInformation.text ?? ""
    }

}
