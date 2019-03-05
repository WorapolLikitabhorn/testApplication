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
    

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePikerselect: UIDatePicker!
    @IBOutlet weak var textFieldproduct: UITextField!
    @IBOutlet weak var textFieldplace: UITextField!
    
    let fileName = "db.sqlite"
    let fileManager = FileManager.default
    var dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    var status : String = ""
    
    
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
        sql = "CREATE TABLE IF NOT EXISTS Quest (id INTEGER PRIMARY KEY AUTOINCREMENT, product TEXT, place TEXT, date TEXT, feeling TEXT)"
        
        let createTb = sqlite3_exec(db, sql, nil, nil, nil)
        if createTb != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db))
            print(err)
        }
        
        sql = "INSERT INTO Quest (id, product, place, date, feeling) VALUES ('1', 'สบู่อาบน้ำ' , 'โรบินสันปราจีนบุรี','22/02/2561','ดีมาก')"
        sqlite3_exec(db,sql,nil,nil,nil)
        
        select()
        
    }
    
    @IBAction func unhappy(_ sender: Any) {
        let products = textFieldproduct.text! as NSString
        let places = textFieldplace.text! as NSString
        
        let currentDate = datePikerselect.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "dd/MM/YYYY"
        let thaiLocale = NSLocale(localeIdentifier: "TH_th")
        myFormatter.locale = thaiLocale as Locale
        let currentDateText = myFormatter.string(from: currentDate)
        
        self.sql = "INSERT INTO Quest VALUES (null,?,?,?,'ไม่พอใจ')";
        sqlite3_prepare(self.db, self.sql, -1, &self.stmt, nil)
        
        sqlite3_bind_text(self.stmt, 1, products.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 2, places.utf8String , -1, nil)
        sqlite3_bind_text(self.stmt, 3, currentDateText, -1, nil)
        sqlite3_step(self.stmt)
        
        select()
        
    }
    
    @IBAction func nothing(_ sender: Any) {
        let products = textFieldproduct.text! as NSString
        let places = textFieldplace.text! as NSString
        
        let currentDate = datePikerselect.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "dd/MM/YYYY"
        let thaiLocale = NSLocale(localeIdentifier: "TH_th")
        myFormatter.locale = thaiLocale as Locale
        let currentDateText = myFormatter.string(from: currentDate)
        
        self.sql = "INSERT INTO Quest VALUES (null,?,?,?,'เฉยๆ')";
        sqlite3_prepare(self.db, self.sql, -1, &self.stmt, nil)
        
        sqlite3_bind_text(self.stmt, 1, products.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 2, places.utf8String , -1, nil)
        sqlite3_bind_text(self.stmt, 3, currentDateText, -1, nil)
        sqlite3_step(self.stmt)
        
        select()
    }
    
    @IBAction func happy(_ sender: Any) {
        
        let products = textFieldproduct.text! as NSString
        let places = textFieldplace.text! as NSString
        
        let currentDate = datePikerselect.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "dd/MM/YYYY"
        let thaiLocale = NSLocale(localeIdentifier: "TH_th")
        myFormatter.locale = thaiLocale as Locale
        let currentDateText = myFormatter.string(from: currentDate)
        
        self.sql = "INSERT INTO Quest VALUES (null,?,?,?,'พอใจ')";
        sqlite3_prepare(self.db, self.sql, -1, &self.stmt, nil)
        
        sqlite3_bind_text(self.stmt, 1, products.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 2, places.utf8String , -1, nil)
        sqlite3_bind_text(self.stmt, 3, currentDateText, -1, nil)
        sqlite3_step(self.stmt)
        
        select()
        
    }
    
    @IBAction func refreshComponent(_ sender: Any) {
        self.viewDidLoad()
    }
    
    func select(){
        sql = "SELECT * FROM Quest"
        sqlite3_prepare(db , sql , -1, &pointer, nil)
        textView.text = ""
        
        var id: Int32
        var product: String
        var place: String
        var date: String
        var feeling : String
        
        while (sqlite3_step(pointer) == SQLITE_ROW) {
            id = sqlite3_column_int(pointer , 0)
            textView.text?.append("ลำดับที่ : \(id)\n")
            
            product = String(cString : sqlite3_column_text(pointer, 1))
            textView.text?.append("สินค้า : \(product)\n")
            
            place = String(cString : sqlite3_column_text(pointer, 2))
            textView.text?.append("สถาที่ : \(place)\n")
            
            date = String(cString : sqlite3_column_text(pointer, 3))
            textView.text?.append("วันที่ : \(date)\n")
            
            feeling = String(cString : sqlite3_column_text(pointer, 4))
            textView.text?.append("ความพึงพอใจ : \(feeling)\n")
        }
    }

}

