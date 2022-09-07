//
//  ViewController.swift
//  Shopping Demo App
//
//  Created by Srinivas Katta on 07/09/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var categoriesArray = ["CATEGORIES", "Baby Products", "Choclates"]
   
    @IBOutlet var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
  
    func configure(){
        self.title = "Home"
        categoryTableView.register(UINib(nibName: "CategoryTableView", bundle: Bundle.main), forCellReuseIdentifier: "TableCell")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesArray.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoryCollectionView.tag = indexPath.section + 1
        cell.categoriesClicked = { [unowned self] in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsListController") as! ProductsListController
            vc.receivedTagOfSeeAllButton = cell.categoryCollectionView.tag - 1
            navigationController?.pushViewController(vc, animated: true)
        }
        cell.productsClicked = { [unowned self] in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            vc.receivedTagOfSeeAllButton = cell.categoryCollectionView.tag - 1
            vc.receivedTitle = categoriesArray[cell.categoryCollectionView.tag - 1]
            navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50.0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        
        if section != 0 {
            headerView.backgroundColor = .cyan
        }
        
        let seeAllButton = UIButton(frame: CGRect(x: (view.frame.width) - (headerView.frame.size.height + 40),
                                                  y: 5,
                                                  width: headerView.frame.size.height + 20,
                                                  height: headerView.frame.size.height - 10))
        
        seeAllButton.tag = section
        seeAllButton.setTitle("See All", for: UIControl.State.normal)
        seeAllButton.titleLabel?.tintColor = UIColor.red
        seeAllButton.addTarget(self, action: #selector(seeAllButtonClicked),for: .touchUpInside)
        seeAllButton.tintColor = .red
        seeAllButton.layer.cornerRadius = 20
        seeAllButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        // CREATING LABEL FOR HEADER TEXT
        let label = UILabel(frame: CGRect(x: 10,
                                          y: 5,
                                          width: headerView.frame.width - seeAllButton.frame.width,
                                          height: headerView.frame.size.height - 10))
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .red
        label.numberOfLines = 0
        label.text = categoriesArray[section]
        headerView.addSubview(label)
        headerView.addSubview(seeAllButton)
        return headerView
    }
    
    @objc func seeAllButtonClicked(buttonSender:UIButton){
        
        if buttonSender.tag == 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsListController") as! ProductsListController
            vc.receivedTagOfSeeAllButton = buttonSender.tag
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            vc.receivedTagOfSeeAllButton = buttonSender.tag
            vc.receivedTitle = categoriesArray[buttonSender.tag]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



