//
//  TableViewController.swift
//  IOSParseXMLTutorial210102
//
//  Created by leslie on 1/2/21.
//

import UIKit

struct Info: Codable {
    
    var CFBundleExecutable: String
}

struct Book {
    var bookTitle: String
    var bookAuthor: String
}

class TableViewController: UITableViewController {

    var books: [Book] = []
    var elementName: String = String()
    var bookTitle = String()
    var bookAuthor = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Access And Read App’s Info.plist variables with Codable Struct.
        if  let path        = Bundle.main.path(forResource: "Info", ofType: "plist"),    //Info.plist file Name
            let xml         = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(Info.self, from: xml)    //Info Struct Name
        {
            print(preferences)
        }
        else {
            return
        }

        // Access And Read XML file variables with XMLParserDelegate
        if let path = Bundle.main.url(forResource: "Books", withExtension: "xml") {
            
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let book = books[indexPath.row]
         
        cell.textLabel?.text = book.bookTitle
        cell.detailTextLabel?.text = book.bookAuthor
        
        return cell
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TableViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("--Start parsing..")
        if elementName == "book" {
            bookTitle = String()
            bookAuthor = String()
        }
//        print("bookTitle: \(bookTitle)")
//        print("bookAuthor: \(bookAuthor)")
//        print("elementName: \(self.elementName)")
//        print("books: \(books)")
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("--End parsing..")
        if elementName == "book" {
            let book = Book(bookTitle: bookTitle, bookAuthor: bookAuthor)
            books.append(book)
        }
//        print("bookTitle: \(bookTitle)")
//        print("bookAuthor: \(bookAuthor)")
//        print("elementName: \(self.elementName)")
//        print("books: \(books)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("--Parsing char..")
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if self.elementName == "title" {
                bookTitle += data
            }
            else if self.elementName == "author" {
                bookAuthor += data
            }
        }
//        print("bookTitle: \(bookTitle)")
//        print("bookAuthor: \(bookAuthor)")
//        print("elementName: \(self.elementName)")
//        print("books: \(books)")
    }
}
