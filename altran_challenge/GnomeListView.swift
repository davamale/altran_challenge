//
//  GnomeListView.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import UIKit

class GnomeListView: UIViewController {
    
    //MARK: - Properties
    fileprivate lazy var tableView: UITableView = {
       
        let tv = UITableView()
        
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let viewModel = GnomeListViewModel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Actions
}

//MARK: - UITableView DataSource
extension GnomeListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: - UITableView Delegate
extension GnomeListView: UITableViewDelegate {
    
}

extension GnomeListView: Customizable {
    
    func prepareUI() {
        
        
        view.addSubview(tableView)
    }
    
    func addContraints() {
        
    }
}





