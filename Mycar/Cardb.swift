//
//  File.swift
//  Mycar
//
//  Created by Alireza on 25/09/2025.
//
//@State private var selectedcar:typecar?=nil
//@State private var Carname:String=""
//@State private var Plate:String=""
//@State private var Model:Int=2025
//@State private var inspectionDate:Int=2025

import Foundation
import SQLite
struct Car {
    let name: String
    let plate: String
    let model: String
    let inspectionDate: String
    let typecar:String
}

struct fuel {
    let id:Int64
    let total: String
    let liters: String
    let price: String
    let kilometer: String
    let date:String
}
struct reportfuel {
    let id:Int64
    let lastkh: String
    let currentkh: String
    let finalfuel: String
    let idfuel: String
 
}
class cardb {
    private var db: Connection!
   
    private let id = Expression<Int64>("id")

    //
   
    
    

    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/cars.sqlite3")
            createTable()
        } catch {
            print("❌ Error opening database: \(error)")
        }
    }

    private func createTable() {
        do {
            try db.run(Table("cars").create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<String>("plate"))
                t.column(Expression<String>("model"))
                t.column(Expression<String>("inspectionDate"))
                t.column(Expression<String>("typecar"))
                
                
            })
            print("✅ Table car created")
        } catch {
            print("❌ Table car creation failed: \(error)")
        }
        
        
        do {
            try db.run(Table("fuel").create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(Expression<String>("total"))
                t.column(Expression<String>("liters"))
                t.column(Expression<String>("price"))
                t.column(Expression<String>("kilometer"))
                t.column(Expression<String>("date"))
            })
            print("✅ Table fuel created")
        } catch {
            print("❌ Table fuel creation failed: \(error)")
        }
        
        
        do {
            try db.run(Table("reportfuel").create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(Expression<String>("lastkh"))
                t.column(Expression<String>("currentkh"))
                t.column(Expression<String>("finalfuel"))
                t.column(Expression<String>("idfuel"))
              
            })
            print("✅ Table reportfuel created")
        } catch {
            print("❌ Table reportfuel creation failed: \(error)")
        }
        
     
        
        
        
        
    }

    func insertCar(typecarvalue: String, carnamevalue: String, plateValue: String, modelvalue: String, inspectionDateValue: String) {
        do {
            try db.run(
                "INSERT INTO cars (typecar,name, plate, model, inspectionDate) VALUES (?, ?, ?, ?, ?)",
                typecarvalue, carnamevalue, plateValue, modelvalue, inspectionDateValue
            )
            print("✅ Car inserted (RAW)")
        } catch {
            print("❌ Insert RAW failed: \(error)")
        }
    }

    func editCar (typecarvalue: String, carnamevalue: String, plateValue: String, modelvalue: String, inspectionDateValue: String) {
        do {
            let changes = try db.run(
                "UPDATE cars SET typecar = ?, name = ?, model = ?, inspectionDate = ?,plate= ?",
                typecarvalue, carnamevalue, modelvalue, inspectionDateValue, plateValue
            )
            print( "✅ Car updated (RAW)")
        } catch {
            print("❌ Update RAW failed: \(error)")
        }
    }

    func getAllCars_string() -> [String] {
        var result: [String] = []
        do {
            for car in try db.prepare(Table("cars")) {
                let info = "\(car[Expression<String>("name")]) •\(car[Expression<String>("Plate")]) • \(car[Expression<String>("Model")]) • \(car[Expression<String>("inspectionDate")])"
                result.append(info)
            }
        } catch {
            print("❌ Select failed: \(error)")
        }
        return result
    }
    
    
    
    func getAllCars() -> [Car] {
        var result: [Car] = []
        do {
            // اگر جدول خالی باشد، این حلقه اصلاً اجرا نمی‌شود و [] برمی‌گردد
            for row in try db.prepare(Table("cars")) {
                let carObject = Car(
                    name: row[Expression<String>("name")],
                    plate: row[Expression<String>("plate")],
                    model: row[Expression<String>("model")],
                    inspectionDate: row[Expression<String>("inspectionDate")],   // ممکن است nil باشد
                    typecar: row[Expression<String>("typecar")]                  // ممکن است nil باشد
                )
                result.append(carObject)
            }
        } catch {
            // خطاهایی مثل "no such table/column" اینجا می‌آیند
            print("❌ Select failed: \(error)")
            return []   // خیلی مهم: خالی برگردون تا UI کرش نکند
        }
        return result
    }


 
    func deleteCar(plateValue: String) {
        do {
            let car = Table("cars").filter(Expression<String>("Plate") == plateValue)
            try db.run(car.delete())
            print("✅ Car deleted")
        } catch {
            print("❌ Delete failed: \(error)")
        }
    }
    func deleteallCar() {
        do {
 
            try db.run(Table("cars").delete())
            print("✅ Car deleted")
        } catch {
            print("❌ Delete failed: \(error)")
        }
    }
    
    
    
    //################ fuel
    
    func insertfuel(total: String, liters: String, price: String, date: String, kilometer: String) {
        do {
            try db.run(
                "INSERT INTO fuel (total,liters, price, kilometer, date) VALUES (?, ?, ?, ?, ?)",
                total, liters, price, kilometer, date
            )
            print("✅ Car inserted (RAW)")
        } catch {
            print("❌ Insert RAW failed: \(error)")
        }
    }
    
    
    func getAllfuel() -> [fuel] {
        var result: [fuel] = []
        do {
            // اگر جدول خالی باشد، این حلقه اصلاً اجرا نمی‌شود و [] برمی‌گردد
            for row in try db.prepare(Table("fuel")) {
                let carObject = fuel(
                    id: row[Expression<Int64>("id")],
                    total : row[Expression<String>("total")],
                    liters: row[Expression<String>("liters")],
                    price: row[Expression<String>("price")],
                    kilometer: row[Expression<String>("kilometer")],   // ممکن است nil باشد
                    date: row[Expression<String>("date")]                  // ممکن است nil باشد
                )
                result.append(carObject)
            }
        } catch {
            // خطاهایی مثل "no such table/column" اینجا می‌آیند
            print("❌ Select failed: \(error)")
            return []   // خیلی مهم: خالی برگردون تا UI کرش نکند
        }
        return result
    }

    //################# end fuel
    
    

    
    //%%%%%%%%%%%%%%%%%%  start reportfuel
    func insertreportfuel(lastkh: String, currentkh: String, finalfuel: String, idfuel: String ){
        do {
            try db.run(
                "INSERT INTO reportfuel (lastkh,currentkh, finalfuel, idfuel) VALUES (?, ?, ?, ?)",
                lastkh, currentkh, finalfuel, idfuel
            )
            print("✅ reportfuel inserted (RAW)")
        } catch {
            print("❌ Insert reportfuel failed: \(error)")
        }
    }
    
    
    func getAllreportfuel() -> [reportfuel] {
        var result: [reportfuel] = []
        do {
            // اگر جدول خالی باشد، این حلقه اصلاً اجرا نمی‌شود و [] برمی‌گردد
            for row in try db.prepare(Table("reportfuel")) {
                let carObject = reportfuel(
                    id: row[Expression<Int64>("id")],
                    lastkh : row[Expression<String>("lastkh")],
                    currentkh: row[Expression<String>("currentkh")],
                    finalfuel: row[Expression<String>("finalfuel")],
                    idfuel: row[Expression<String>("idfuel")]   // ممکن است nil باشد
                                  // ممکن است nil باشد
                )
                result.append(carObject)
            }
        } catch {
            // خطاهایی مثل "no such table/column" اینجا می‌آیند
            print("❌ Select failed: \(error)")
            return []   // خیلی مهم: خالی برگردون تا UI کرش نکند
        }
        return result
    }
}


