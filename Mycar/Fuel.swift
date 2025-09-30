import SwiftUI
import Vision
import PhotosUI
import UIKit
import AVFoundation


// MARK: - Main screen




struct Fuel: View {

    @State private var db = cardb()
    @State private var total: String = ""
    @State private var liters: String = ""
    @State private var price: String = ""
    @State private var kilometer: String = ""
    
    
    @State private var isalert:Bool=false
    @State  private var Alarammassage:String=""
    @State private var Allarmtitle:String=""
    @State private var allfuel:[fuel]=[]
    @State private var allreportfuel:[reportfuel]=[]
   
    @EnvironmentObject var appDate: AppDate
    
    var body: some View {
        
        
        VStack(spacing: 15) {
            
            Group {
                Text("Total amount").frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .bold()
                TextField("Total", text: $total)
                    .textFieldStyle(BlueTextFieldStyle())
                
                
                Text("Liters").frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .bold()
                TextField("Liters", text: $liters)
                    .textFieldStyle(BlueTextFieldStyle())
                
                
                Text("Price per liter").frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .bold()
                TextField("Price (DKK)", text: $price)
                    .textFieldStyle(BlueTextFieldStyle())
                
                
                Text("Curent kilometer").frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .bold()
                TextField("kilometer", text: $kilometer)
                    .textFieldStyle(BlueTextFieldStyle())
                
                
                Button("Save Data"){
                    if liters.isEmpty  || kilometer.isEmpty
                    {
                        
                        Allarmtitle="Error"
                        Alarammassage="Please Fill All Fields"
                        isalert.toggle()
                        
                        
                    }
                    
                    else
                    
                    {
                        
                        savefuel()
                        
                    }
                    
                }  .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                
                
                
                
                
                
                
                
                // هدر
                HStack {
                    Text("Row").bold().frame(width: 50, alignment: .leading)
                    Text("Total").bold().frame(width: 50, alignment: .leading)
                    Text("Liters").bold().frame(width: 50, alignment: .leading)
                    Text("Price").bold().frame(width: 50, alignment: .leading)
                    Text("Km").bold().frame(width: 60, alignment: .leading)
                    Text("Date").bold().frame(width: 60, alignment: .leading)
                }
                .padding(.horizontal)
                
                // ردیف‌ها
                
                List(allfuel, id: \.id) { item in
                    
                    
                    HStack {
                        
                        Text("\(item.id)").frame(width: 50, alignment: .leading)
                        Text(item.total).frame(width: 50, alignment: .leading)
                        Text(item.liters).frame(width: 50, alignment: .leading)
                        Text(item.price).frame(width: 50, alignment: .leading)
                        Text(item.kilometer).frame(width: 60, alignment: .leading)
                        Text(item.date).frame(width: 60, alignment: .leading)
                        
                        
                    }
                    
                    .font(.callout)
                    .contentShape(Rectangle()) // لازم برای اینکه کل ردیف قابل کلیک بشه
                    .onTapGesture {
                        //Alarammassage=("Row tapped: \(item.date)")
                       // isalert.toggle()
                        // یا مثلا Navigation به جزئیات:
                        // selectedFuel = item
                        // showDetail.toggle()
                    }
                }
                
            
    
            }
            
        }
        
        .alert(isPresented: $isalert) {
           Alert(title: Text(Allarmtitle), message: Text(Alarammassage).foregroundColor(.red.opacity(0.8)), dismissButton: .default(Text("OK")))
        }.onAppear {
            allfuel = db.getAllfuel()
            allreportfuel=db.getAllreportfuel()
            if allreportfuel.count == 0
                {
                Alarammassage=("report fuel empty")
                isalert.toggle()
            }
            else {
                Alarammassage=("report fuel \(allreportfuel.last!.finalfuel)")
                isalert.toggle()
            }
        
        }
     
    }
    func savefuel()
    {
        
        let lastkilometer=allfuel.last?.kilometer ?? "0"
        let allkilometer=Int(kilometer)!-Int(lastkilometer)!
        let currentfuel=Double(allkilometer)/Double(liters)!
        var finalfuel =  100.0 / currentfuel
        
        
       
        let lastidfuel=allfuel.last.map { String(describing: $0.id) } ?? ""
       
        if allfuel.count == 0
        {}
        else
        {
            db.insertreportfuel(lastkh: lastkilometer, currentkh: kilometer, finalfuel: String(format: "%.2f", finalfuel), idfuel: lastidfuel)
            
        }
        
 
    db.insertfuel(total:total, liters: liters, price: price, date:  appDate.launchDateString, kilometer: kilometer)
        Allarmtitle="Success"
        Alarammassage="Data Save Succesfully"
       isalert.toggle()
        total=""
       liters=""
        price=""
      kilometer=""
    }
}

// MARK: - Preview
#Preview { Fuel() }
