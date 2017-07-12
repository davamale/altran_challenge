//
//  GnomeListView.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import UIKit
import AndroidDialogAlert

// MARK: - Constants
fileprivate extension GnomeListView {
    
    struct Constants {
        /// Constants related do filterControl
        struct FilterControl {
            static let height: CGFloat = 30.0
            static let leading: CGFloat = 20
            static let trailing: CGFloat = -20.0
            
            static let maxWidth: CGFloat = 400
        }
        
        /// Constants related to tableView
        struct TableView {
            static let padding: CGFloat = 3
        }
    }
}

class GnomeListView: UIViewController {
    
    //MARK: - Properties
    fileprivate lazy var tableView: UITableView = {
       
        let tv = UITableView()
        
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        tv.register(GnomeCell.nib, forCellReuseIdentifier: GnomeCell.identifier)
        
        return tv
    }()
    
    fileprivate lazy var filterControl: UISegmentedControl = {
        
        let fc = UISegmentedControl(items: ["All", "No Friends", "No Job"])
        
        fc.tintColor = .white
        fc.translatesAutoresizingMaskIntoConstraints = false
        fc.selectedSegmentIndex = 0
        fc.addTarget(self, action: #selector(filterControlSelection(sender:)), for: .valueChanged)
        
        return fc
    }()
    
    fileprivate lazy var viewModel: GnomeListViewModel = {
        return GnomeListViewModel(delegate: self)
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        viewModel.initialFetch()
    }
    
    //MARK: Actions
    @objc func filterControlSelection(sender: UISegmentedControl) {
        
    }
    
}

//MARK: - UITableView DataSource
extension GnomeListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GnomeCell.identifier, for: indexPath) as! GnomeCell
        
        return cell.configure(withEntity: viewModel.object(atIndexPath: indexPath))
    }
}

//MARK: - UITableView Delegate
extension GnomeListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

//MARK: - GnomeListViewModel Delegate
extension GnomeListView: GnomeListViewModelDelegate {
    
    func showError(withMessage message: String) {
        
        let alert = AndroidDialogAlert(titleText: "Network Error", messageText: message, buttonText: "Cancel")
        alert.dialogBorderColor = .groupTableViewBackground
        
        alert.alternateButton(title: "Retry") { (alert) in
            self.viewModel.getList()
            alert.dismiss(animated: true, completion: nil)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func didFinishLoading() {
        //TODO: Hide loading
//        tableView.reloadData()
    }
    
    func didInsert(newObject: Gnome, at newIndexPath: IndexPath) {
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didUpdate(object:Gnome, at indexPath: IndexPath) {
        
    }
    
    func beginUpdates() {
        tableView.beginUpdates()
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
}

extension GnomeListView: Customizable {
    
    func prepareUI() {
        
        view.backgroundColor = .defaultBlue
        navigationController?.navigationBar.removeHairline()
        
        view.addSubview(tableView)
        view.addSubview(filterControl)
        
        addContraints()
    }
    
    func addContraints() {
        
        // filter control
        filterControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        filterControl.heightAnchor.constraint(equalToConstant: Constants.FilterControl.height).isActive = true
        filterControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filterControl.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.FilterControl.maxWidth).isActive = true
        
        let leadingFC = filterControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.FilterControl.leading)
        leadingFC.priority = 750
        leadingFC.isActive = true
        
        let trailingFC = filterControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.FilterControl.trailing)
        trailingFC.priority = 750
        trailingFC.isActive = true
        
        // table view
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: filterControl.bottomAnchor, constant: Constants.TableView.padding).isActive = true
        
    }
}





