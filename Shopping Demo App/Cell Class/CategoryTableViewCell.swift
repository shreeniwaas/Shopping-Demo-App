//
//  CategoryTableView.swift
//  Shopping Demo App
//
//  Created by Srinivas Katta on 07/09/22.
//

import UIKit
import Alamofire

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var categoryCollectionView: UICollectionView!
    
    // for CATEGORIES API
    var categoriesListArray = [String]()
    
    // FOR BABY PRODUCTS
    var babyProductLastName = [String]()
    var babyProductQuantity = [String]()
    var babyRateArray = [String]()
    
    // FOR CHOCOLATES
    var lastNameArray = [String]()
    var quantityArray = [String]()
    var rateArray = [String]()
    
    var categoriesClicked: (() -> ())?
    var productsClicked: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionView", bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionCell")
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        fetchCategoriesFromLocalJson()
        // These will be called at app startup
        getBabyProductsAPI()
        getChocolatesApi()
    }
    
    func readJSONFromFile(fileName: String) -> Dictionary<String, Any>? {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            } catch {
                print("the error is \(error.localizedDescription)")
            }
        }
        return json as? Dictionary<String, Any>
    }
    
    
    func fetchCategoriesFromLocalJson(){
        let categoriesObj = readJSONFromFile(fileName: "CategoriesList")
        let categoriesArrayAtJson : NSArray = categoriesObj?["Categories"] as! NSArray
        categoriesListArray.removeAll()
        
        for i in 0..<categoriesArrayAtJson.count{
            let categoryName = categoriesArrayAtJson[i] as? [String:Any]
            let name = categoryName?["catName"] as? String
            categoriesListArray.append(name ?? "no name found")
        }
    }

    // HITTING API BY ALAMOFIRE
    func getBabyProductsAPI(){
        guard let babyProductApi = URL(string: APIConstants.babyProcutsAPI) else {return}
        var myUrlRequest = URLRequest(url: babyProductApi)
        myUrlRequest.httpMethod = APIMethods.getMethod
        myUrlRequest.setValue(Headers.appJson, forHTTPHeaderField: Headers.contentKey)
        
        AF.request(myUrlRequest).responseJSON { [self] myResponse in
             
            if let myData = myResponse.data {
                
                do{
                     let checkingData = try JSONSerialization.jsonObject(with: myData, options: []) as? Dictionary<String, Any>
                    DispatchQueue.main.async { [self] in
                        if let babyProducts = checkingData?["BabyFoods"] as? NSArray {
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
                            }
                            print(babyProductLastName)
                            print(babyProductQuantity)
                            print(babyRateArray)
                            categoryCollectionView.reloadData()
                        }
                    
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }

    }
    
    // HITTING API BY NSURL SESSION
    
    func getChocolatesApi(){
        
        guard let chocolateUrl = URL(string: APIConstants.chocolateAPI) else {return}
        var myUrlRequest = URLRequest(url: chocolateUrl)
        //        let params = ["Id":"24"]
        //        let encodedParams = try? JSONSerialization.data(withJSONObject: params, options: [])
        //        myUrlRequest.httpBody = encodedParams
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
                    rateArray.removeAll()
                    for i in 0..<chocolatesData.count{
                        let products = chocolatesData[i] as! [String:Any]
                        let lastName = products["lastName"] as! String
                        let quantity = products["quantites_Available"] as! String
                        let rate = products["rate"] as! String
                        lastNameArray.append(lastName)
                        quantityArray.append(quantity)
                        rateArray.append(rate)
                    }
                    categoryCollectionView.reloadData()
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
        gettingData.resume()
    }
}
extension CategoryTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if categoryCollectionView.tag == 1 {
            return categoriesListArray.count
        }
        if categoryCollectionView.tag == 2 {
            return babyProductLastName.count
        }
        else  {
           return lastNameArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CategoryCollectionViewCell
        
        if categoryCollectionView.tag == 1 {
            cell.categoryLabel.text = categoriesListArray[indexPath.item]
        }
        if categoryCollectionView.tag == 2 {
            cell.categoryLabel.text = babyProductLastName[indexPath.item]
        }
        if categoryCollectionView.tag == 3 {
            cell.categoryLabel.text = lastNameArray[indexPath.item]
        }
            return cell
           
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categoryCollectionView.tag == 1 {
            categoriesClicked?()
        }
        else {
            productsClicked?()
        }
    }
}
