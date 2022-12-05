//
//  BookTableViewController.swift
//  bookdana
//
//  Created by 渡辺大智 on 2022/11/26.
//

import UIKit

class BookDanaTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    var books = [Book]()

    @IBAction func unwindToBookList(sender: UIStoryboardSegue) {
        guard let sourceVC = sender.source as? BookSubscribeViewController, let book = sourceVC.bookInformation else {
            return
        }
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            self.books[selectedIndexPath.row] = book
        } else {
            self.books.append(book)
        }
        saveBooks(bookData: self.books)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let bookData = loadBooks() {
            self.books = bookData
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let bookData = loadBooks() {
            self.books = bookData
        }
        return self.books.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath)

        // Configure the cell...
        if let bookData = loadBooks() {
            self.books = bookData
        }
        cell.textLabel?.text = self.books[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "booktana"
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
            self.books.remove(at: indexPath.row)
            saveBooks(bookData: books)
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //画面が遷移する前に呼ばれるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "editBookInformation" {
            let bookInformationVC = segue.destination as! BookSubscribeViewController
            bookInformationVC.bookInformation = self.books[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }

}

extension BookDanaTableViewController {
    func saveBooks(bookData: [Book]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(bookData) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "books")
        print("保存した")
    }
    
    func loadBooks() -> [Book]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "books"),
              let books = try? jsonDecoder.decode([Book].self, from: data) else {
            return nil
        }
        print("読み込んだ")
        return books
    }
}
