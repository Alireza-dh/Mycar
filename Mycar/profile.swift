//
//  Homepage.swift
//  Mycar
//
//  Created by Alireza on 24/09/2025.
//

import SwiftUI


struct typecar:Identifiable,Hashable
{
    let id=UUID()
    let Name:String
}
struct BlueTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2))
            .padding(.horizontal, 20)
    }
}




struct profile: View {
    @State private var db = cardb()
    @State private var selectedcar:typecar?=nil
    @State private var Carname:String=""
    @State private var Plate:String=""
    @State private var Model:Int=2025
    @State private var inspectionDate:Int=2025
    @State private var isalert:Bool=false
    
    @State  private var Alarammassage:String=""
    @State private var Allarmtitle:String=""
    @State private var isdata:Bool=false
    let cars=[
        typecar(Name:"Benzin"),
        typecar(Name:"Electric"),
        
    ]
    var years:[Int]=Array(1800...2025)
    
    
    
    var body: some View
    {
   
        VStack(spacing: 20)
        {
            Image("gazeboCar")
                .resizable()
                  .scaledToFit()
                  .clipShape(RoundedRectangle(cornerRadius: 16))
                  .overlay(
                      RoundedRectangle(cornerRadius: 16)
                          .stroke(Color.blue, lineWidth: 3)
                  )
                   .frame(height: 200)
            
            
            
            Picker("Select Car",selection: $selectedcar){
                ForEach(cars)
                { car in
                    Text(car.Name).tag(Optional(car))
                }
            }
            .pickerStyle(.palette)  // سبک سگمنت
                           
                           .background(Color.white)              // پس‌زمینه سفید
                           .cornerRadius(10)
                           .overlay(
                               RoundedRectangle(cornerRadius: 10)
                                   .stroke(Color.blue, lineWidth: 1) // قاب آبی
                           )
                           .padding(.horizontal, 20)
           
            if let selected=selectedcar
            {
               Text("You selected: \(selected.Name)")
            
            }
            
            TextField("Enter your Car Name", text:$Carname).textFieldStyle(BlueTextFieldStyle())
           
            TextField("Enter your Plate Number", text:$Plate).textFieldStyle(BlueTextFieldStyle())
       
           Group{
            
               Text   ("Select Car Model") .frame(maxWidth: .infinity).background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(8)
                   .padding(.horizontal, 20)
                   .bold()
              Picker("Select Car Model",selection: $Model){
               ForEach(years,id:\.self)
                  { year in
                      Text("\(year)").tag(year)
                  }
                  
              }
              .pickerStyle(.menu)  // سبک سگمنت
                             
                             .background(Color.white)              // پس‌زمینه سفید
                             .cornerRadius(10)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 10)
                                     .stroke(Color.blue, lineWidth: 1) // قاب آبی
                             )
                             .padding(.horizontal, 20)

                            
            }
            
            Group{
             
                Text   ("Select Car inspectionDate").frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .bold()
               Picker("Select Car inspectionDateValue",selection: $inspectionDate){
                ForEach(years,id:\.self)
                   { year in
                       Text("\(year)").tag(year)
                   }
                   
               }.pickerStyle(.menu)  // سبک سگمنت
                
                    .background(Color.white)              // پس‌زمینه سفید
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 1) // قاب آبی
                    )
                    .padding(.horizontal, 20)
             }
        } .alert(isPresented: $isalert) {
            Alert(title: Text(Allarmtitle), message: Text(Alarammassage).foregroundColor(.red.opacity(0.8)), dismissButton: .default(Text("OK")))
        }.onAppear {
            
        
        
           
            let allCars = db.getAllCars()
          
            if allCars.isEmpty {
                // مثلاً یک پیام «هیچ ماشینی ثبت نشده» نشان بده
            } else {
                // لیست را نمایش بده
                for car in allCars {
                  //  print("🚗 \(car.name) | \(car.plate) | \(car.model) | \(car.inspectionDate)")
                   
                  Carname=car.name
                    Plate=car.plate
                    Model=Int(car.model)!
                    inspectionDate=Int(car.inspectionDate)!
                    selectedcar=typecar(Name:car.typecar)
                    isdata=true
                }
            }
      

            
           
           

        }
   
        
        if isdata
            {
            Button("Update Data"){
                if Carname.isEmpty  || Plate.isEmpty
                {
                    //isalert.toggle()
                    Allarmtitle="Error"
                    Alarammassage="Please Fill All Fields"
                   isalert.toggle()
                    
                }
                
                    else
                if let selected=selectedcar
                {
                 
                        edirCar()
                        Allarmtitle="Success"
                        Alarammassage="Data Save Succesfully"
                       isalert.toggle()
                
                }
                else
                {    Allarmtitle="Error"
                    Alarammassage="Please Select Type your Car"
                   isalert.toggle()
                  
                    }
            }  .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
        }
        else
            {
            Button("Save Data"){
                if Carname.isEmpty  || Plate.isEmpty
                {
                    //isalert.toggle()
                    Allarmtitle="Error"
                    Alarammassage="Please Fill All Fields"
                   isalert.toggle()
                    
                }
                    else
                if let selected=selectedcar
                {
                 
                        Savecar()
                        Allarmtitle="Success"
                        Alarammassage="Data Save Succesfully"
                       isalert.toggle()
                
                }
                else
                {    Allarmtitle="Error"
                    Alarammassage="Please Select Type your Car"
                   isalert.toggle()
                  
                    }
            }  .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
        }
      
        
        
        
        
        
    }
       
    func Savecar()
    {
        
        
        let tcar:String=String(describing: selectedcar?.Name)
      
                          
        db.insertCar(typecarvalue:tcar,carnamevalue:Carname,plateValue:Plate,modelvalue:"\(Model)",inspectionDateValue:"\(inspectionDate)")
    }
    func edirCar()
    {
    
        let tcar:String=String(describing: selectedcar?.Name)
   
        db.editCar(typecarvalue:tcar,carnamevalue:Carname,plateValue:Plate,modelvalue:"\(Model)",inspectionDateValue:"\(inspectionDate)")
                

    }
    
}
#Preview
{
    profile()
}
