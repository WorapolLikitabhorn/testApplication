//
//  ViewController.swift
//  testapp
//
//  Created by Admin on 5/3/2562 BE.
//  Copyright © 2562 Admin. All rights reserved.
//

import UIKit
import SQLite3
class ViewController: UIViewController {
    
    let fileName = "db.sqlite"
    let fileManager = FileManager.default
    var dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    var status : String = ""
   
   
  
    @IBAction func buttonSave(_ sender: UIButton) {
        let place = textFieldplace.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let product = textFieldproduct.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        self.sql = "INSERT INTO questionnaire (place,product,date,status) VALUES (?,?,?,'พอใจ')"
        sqlite3_prepare (self.db , self.sql, -1 , &self.stmt , nil)
       
        sqlite3_bind_text(self.stmt , 1 , place, -1 , nil)
        sqlite3_bind_text(self.stmt , 2 , product, -1 , nil)
        
        
        sqlite3_step(self.stmt)
        
        textFieldplace.text  = ""
        textFieldproduct.text = ""
        select()
        
        print(" saved successfully")
    }
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePikerselect: UIDatePicker!
    @IBOutlet weak var textFieldproduct: UITextField!
    @IBOutlet weak var textFieldplace: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dbURL = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor : nil,
            create :false
        )
        .appendingPathComponent(fileName)
        
        let openDb = sqlite3_open(dbURL.path,&db)
        if openDb != SQLITE_OK {
            print("Opeing database Error")
            return
        }
        sql = "CREATE TABLE IF NOT EXISTS questionnaire" +
              "id INTEGER PRIMARY KEY AUTOINCREMENT," +
              "place TEXT, product TEXT , date TEXT , status TEXT"
        let createTb = sqlite3_exec(db, sql, nil, nil, nil)
        if createTb != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db))
            print(err)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func select(){
        sql = "SELECT * FROM questionnaire"
        sqlite3_prepare(db , sql , -1, &pointer, nil)
        textView.text = ""
        var id: Int32
        var place: String
        var product: String
        var date: String
        var status : String
        
        while (sqlite3_step(pointer) == SQLITE_ROW){
            id = sqlite3_column_int(pointer , 0)
            textView.text?.append("ลำดับที่ : \(id)\n")
            
            date = String(cString : sqlite3_column_text(pointer, 3))
            textView.text?.append("วันที่ : \(date)\n")
            
            place = String(cString : sqlite3_column_text(pointer, 1))
            textView.text?.append("สถาที่ : \(place)\n")
            
            product = String(cString : sqlite3_column_text(pointer, 2))
            textView.text?.append("สินค้า : \(product)\n")
            
            status = String(cString : sqlite3_column_text(pointer, 4))
            textView.text?.append("ความพึงพอใจ : \(status)\n")
        }
    }

}

