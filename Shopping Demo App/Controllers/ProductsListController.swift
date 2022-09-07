//
//  CategoriesController.swift
//  Shopping Demo App
//
//  Created by Srinivas Katta on 07/09/22.
//

import UIKit

class ProductsListController: UIViewController {

    @IBOutlet var productListCollectionView: UICollectionView!
    var categoriesListArrayTwo = [String]()

    var receivedTagOfSeeAllButton = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        productListCollectionView.register(UINib(nibName: "ProductCollectionView", bundle: Bundle.main), forCellWithReuseIdentifier: "productCell")
        fetchCategories()
    }

    // API hitting by directly ---> TO READ JSON
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
    
    
    func fetchCategories(){
        let categoriesObj = readJSONFromFile(fileName: "CategoriesList")
        /*        print("Keys \(categoriesObj?.keys)")
         print("values \(categoriesObj?.values)") TO ACCESS ALL KEYS AND VALUES */
        let categoriesArrayAtJson : NSArray = categoriesObj?["Categories"] as! NSArray
        categoriesListArrayTwo.removeAll()
        
        for i in 0..<categoriesArrayAtJson.count{
            let categoryName = categoriesArrayAtJson[i] as? [String:Any]
            let name = categoryName?["catName"] as? String
            categoriesListArrayTwo.append(name ?? "no name found")
        }
    }

}
extension ProductsListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesListArrayTwo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        
        if receivedTagOfSeeAllButton == 0{
            
            cell.productName.text = categoriesListArrayTwo[indexPath.item]
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthh = (productListCollectionView.frame.size.width - 20) / 2
        return CGSize(width: widthh, height: widthh)
        
    }
    
    
}
