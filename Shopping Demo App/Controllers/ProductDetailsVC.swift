//
//  ProductDetailsVC.swift
//  Shopping Demo App
//
//  Created by Srinivas Katta on 07/09/22.
//

import UIKit
import Alamofire

class ProductDetailsVC: UIViewController {
    
    @IBOutlet var foodListTable: UITableView!
    var receivedTitle = ""
    
    // FOR BABY PRODUCTS
    var babyProductLastName = [String]()
    var babyProductQuantity = [String]()
    var babyRateArray = [String]()
    
    // FOR CHOCOLATES
    var lastNameArray = [String]()
    var quantityArray = [String]()
    var ratesFromAPI = [String]()
    
    // TO RECIEVE TAGS FROM seeAllButtonClicked IN HomeViewController
    var receivedTagOfSeeAllButton = Int()
    
    // TO APPEND THE DROP DOWN CLICKED VALUE
    var userDefinedQuantitiesArray = [String]()
    var ratesOfSelectedQuantitiesArray = [Float]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = receivedTitle
        foodListTable.register(UINib(nibName: "FoodListTableView", bundle: Bundle.main), forCellReuseIdentifier: "ListCell")
        
        getData()
    }
    
    func getData(){
        if receivedTagOfSeeAllButton == 1 {
            getBabyProductsAPI()
        }
        if receivedTagOfSeeAllButton == 2{
            getChocolatesApi()
        }
    }
    
    func getBabyProductsAPI(){
        guard let babyProductApi = URL(string: APIConstants.babyProcutsAPI) else {return}
        var myUrlRequest = URLRequest(url: babyProductApi)
        myUrlRequest.httpMethod = APIMethods.getMethod
        myUrlRequest.setValue(Headers.appJson, forHTTPHeaderField: Headers.contentKey)
        
        AF.request(myUrlRequest).responseJSON { [self] myResponse in
            if let myData = myResponse.data {
                do{
                    let checkingData = try JSONSerialization.jsonObject(with: myData, options: []) as! Dictionary<String, Any>
                    //  print("checkingData is \(checkingData)")
                    DispatchQueue.main.async { [self] in
                        if let babyProducts = checkingData["BabyFoods"] as? NSArray {
                            babyProductLastName.removeAll()
                            babyProductQuantity.removeAll()
                            babyRateArray.removeAll()
                            
                            for i in 0..<babyProducts.count {
                                let products = babyProducts[i] as! [String : Any]
                                let lastName = products["lastName"] as! String
                                let quantity = products["quantites_Available"] as! String
                                let rate = products["rate"] as! String
                                
                                babyProductLastName.append(lastName)
                                babyProductQuantity.append(quantity)
                                babyRateArray.append(rate)
                                userDefinedQuantitiesArray.append("")
                                ratesOfSelectedQuantitiesArray
                                .append(0.00)
                            }
                            foodListTable.reloadData()
                        }
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
    
    // HITTING API BY NSURL SESSION
    func getChocolatesApi(){
        
        guard let chocolateUrl = URL(string: APIConstants.chocolateAPI) else {return}
        var myUrlRequest = URLRequest(url: chocolateUrl)
        myUrlRequest.httpMethod = APIMethods.getMethod
        myUrlRequest.setValue(Headers.appJson, forHTTPHeaderField: Headers.contentKey)
        let gettingData = URLSession.shared.dataTask(with: myUrlRequest) { [self] myData, myResponse, myError in
           
            guard let theData = myData, myError == nil else{
                print(myError?.localizedDescription as Any)
                return
            }
            do{
                let checkingData = try JSONSerialization.jsonObject(with: theData, options: []) as! Dictionary<String,Any>
                
                DispatchQueue.main.async { [self] in
                    let chocolatesData = checkingData["Chocolates"] as! NSArray
                    
                    lastNameArray.removeAll()
                    quantityArray.removeAll()
                    ratesFromAPI.removeAll()
                    for i in 0..<chocolatesData.count{
                        let products = chocolatesData[i] as! [String:Any]
                        let lastName = products["lastName"] as! String
                        let quantity = products["quantites_Available"] as! String
                        let rate = products["rate"] as! String
                        lastNameArray.append(lastName)
                        quantityArray.append(quantity)
                        ratesFromAPI.append(rate)
                        userDefinedQuantitiesArray.append("")
                        ratesOfSelectedQuantitiesArray
                        .append(0.00)
                        
                    }
                    foodListTable.reloadData()
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
        gettingData.resume()
    }
    
    // THIS INPUT IS PASSED IN cellForRowAt IN CHOCALTES
    func presentAlertSheet(inputTitle: String, inputArray: [String], clickedIndex : Int, rateAtSelectedCell : Float?, rateForThisQuantity : Float?) {
       
        let alert = UIAlertController(title: inputTitle, message: nil, preferredStyle: .actionSheet)
        for selectedQuantity in inputArray{
            let displayer = UIAlertAction(title: selectedQuantity, style: .default, handler:{ [self] (action) in
                userDefinedQuantitiesArray.remove(at: clickedIndex)
                userDefinedQuantitiesArray.insert(selectedQuantity, at: clickedIndex)
                
                if let rateAtSelectedCell = rateAtSelectedCell{
                    if let rateForThisQuantity = rateForThisQuantity{
                        let rateToDisplay = ((rateAtSelectedCell) * (Float(selectedQuantity) ?? 0.00))/(rateForThisQuantity)
                        ratesOfSelectedQuantitiesArray.remove(at: clickedIndex)
                        ratesOfSelectedQuantitiesArray.insert(rateToDisplay, at: clickedIndex)
                    }
                }
                foodListTable.reloadData()
                
            })
            alert.addAction(displayer)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            // It will dismiss action sheet
            
            print("Cancel clicked")
            
        }
        alert.addAction(cancelAction)
        // For i Pads :
        alert.popoverPresentationController?.sourceView = self.view
        let xOrigin = self.view.bounds.width/2
        let yOrigin = self.view.bounds.height/4
        let popoverRect = CGRect(x: xOrigin, y:yOrigin, width: 1, height: 1)
        alert.popoverPresentationController?.sourceRect = popoverRect
        alert.popoverPresentationController?.permittedArrowDirections = .up
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension ProductDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if receivedTagOfSeeAllButton == 1{
            return babyProductLastName.count
            
        }
        else{
            return lastNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! FoodListTableViewCell
        if receivedTagOfSeeAllButton == 1{
            
            cell.foodListName.text = babyProductLastName[indexPath.row]
            if ratesOfSelectedQuantitiesArray[indexPath.row] == 0.00{
                cell.foodListPriz.text = "Amount: --"
                
            }else{
                cell.foodListPriz.text = "Amount: " + "\(ratesOfSelectedQuantitiesArray[indexPath.row])" + " ₹"
            }
            cell.foodListSize.text = "Quantity:" + userDefinedQuantitiesArray[indexPath.row]


        }
        if receivedTagOfSeeAllButton == 2{
            cell.foodListName.text = lastNameArray[indexPath.row]
           
            if ratesOfSelectedQuantitiesArray[indexPath.row] == 0.00{
                cell.foodListPriz.text = "Amount: --"
                
            }else{
                cell.foodListPriz.text = "Amount: " + "\(ratesOfSelectedQuantitiesArray[indexPath.row])" + " ₹"
            }
            cell.foodListSize.text = "Quantity:" + userDefinedQuantitiesArray[indexPath.row]

        }
        
        cell.quantitySelectDropDownButtonClicked = { [self] in
            
            if receivedTagOfSeeAllButton == 1{
                print(indexPath.row)
                let babyProductQuant = babyProductQuantity[indexPath.row]
               
                //THIS choclates HAS 10gm,20gm,50gm,100gm QUANTITIES
                var babyQuantitiesForAlertActionSheet = babyProductQuant.components(separatedBy: "gm,")
                if babyQuantitiesForAlertActionSheet.last == ""{
                    babyQuantitiesForAlertActionSheet.removeLast()
                }
                let rateAtSelectedCellString = babyRateArray[indexPath.row]
                let rateForThisQuantityString = babyQuantitiesForAlertActionSheet.first
                
                let rateAtSelectedCellFloat = Float(rateAtSelectedCellString )
                let rateForThisQuantityFloat = Float(rateForThisQuantityString ?? "0.00")
                
                presentAlertSheet(inputTitle: "babyProducts Quantity", inputArray: babyQuantitiesForAlertActionSheet, clickedIndex: indexPath.row,rateAtSelectedCell: rateAtSelectedCellFloat,rateForThisQuantity: rateForThisQuantityFloat)
                        }
                
            
            if receivedTagOfSeeAllButton == 2 {
                let chocolateQuantity = quantityArray[indexPath.row]
                
                //THIS choclates HAS 10gm,20gm,50gm,100gm QUANTITIES
                var choclatesQuantitiesForAlertActionSheet = chocolateQuantity.components(separatedBy: "gm,")
                if choclatesQuantitiesForAlertActionSheet.last == ""{
                    choclatesQuantitiesForAlertActionSheet.removeLast()
                }
                let rateAtSelectedCellString = ratesFromAPI[indexPath.row]
                let rateForThisQuantityString = choclatesQuantitiesForAlertActionSheet.first
                
                let rateAtSelectedCellFloat = Float(rateAtSelectedCellString )
                let rateForThisQuantityFloat = Float(rateForThisQuantityString ?? "0.00")
                
                presentAlertSheet(inputTitle: "choclates Quantities", inputArray: choclatesQuantitiesForAlertActionSheet, clickedIndex: indexPath.row,rateAtSelectedCell: rateAtSelectedCellFloat,rateForThisQuantity: rateForThisQuantityFloat)
            }
        }
        return cell
        }
        
        
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
}

