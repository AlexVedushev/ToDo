//
//  ToDoListVC.swift
//  TODO
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class ToDoListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ToDoListViewModel!
    
    private var disposeBag = DisposeBag()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm MM.dd.yyyy"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionData>(configureCell: {[weak self] dataSource, tableView, IndexPath, toDo in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ToDoTVCell.self), for: IndexPath) as! ToDoTVCell
            cell.titleLabel.text = toDo.title
            cell.textToDoLabel.text = toDo.text
            cell.dateLabel.text = self?.dateFormatter.string(from: toDo.createDate) ?? ""
            return cell
        })
        let itemSelect = tableView.rx.itemSelected
            .asDriver()
            .map{ $0.row }
        
        let viewDidAppearDriver = rx.viewDidAppear
            .asDriver(onErrorJustReturn: false)
        
        let input = ToDoListViewModel.Input(viewDidAppear: viewDidAppearDriver,
                                            itemSelectDriver: itemSelect)
        let output = viewModel.transform(input: input)
        
        output.sectionDriver
            .asObservable()
            .bind(to:
                tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.editToDoDriver
            .drive()
            .disposed(by: disposeBag)
    }

}
