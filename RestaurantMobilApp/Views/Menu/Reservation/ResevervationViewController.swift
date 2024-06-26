//
//  ResevervationViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 10.06.2024.
//

import UIKit
import SnapKit
import SpreadsheetView

class ResevervationViewController: UIViewController {
    
    
    weak var coordinator: MainCoordinatorProtocol?
    var spreadsheetView: SpreadsheetView!
    let dates = ["14/06/2024", "15/06/2024", "16/06/2024", "17/06/2024", "18/06/2024", "19/06/2024", "20/06/2024"]
    let days = ["MONDAY", "TUESDAY", "WEDNSDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                     UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                     UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                     UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
                     UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
                     UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1),
                     UIColor(red: 0.153, green: 0.569, blue: 0.835, alpha: 1)]
    let hours = ["8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 AM", "1:00 PM", "2:00 PM",
                 "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM", "12:00 PM"]
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    
    //Bu datanın servisten veya harici bir yerden gelmesi gerekli durağan veri olduğu için bu sayafa da tıklanınca vs reservation al gibi herhangi bir işlem yapılmamıştır. Sadece alertte login olduysa içerik basılmıştır.
    
    var data = [
        ["full", "full", "4 tables are empty", "full", "full", "full", "2 tables are empty", "full", "full", "7 tables are empty", "full", "full", "full", "full", "full", "12 tables are empty", "full", "full", "full", "full"],//monday
        ["full", "full", "full", "3 tables are empty", "full", "full", "2 tables are empty", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full"],//tuesday
        ["full", "full", "full", "full", "full", "full", "full", "full", "full", "14 tables are empty", "full", "full", "full", "full", "2 tables are empty", "full", "full", "full", "4 tables are empty", "full"],//wednesday
        ["full", "full", "6 tables are empty", "full", "full", "full", "full", "full", "full", "full", "5 tables are empty", "full", "full", "full", "full", "full", "full", "full", "full", "full"],//thursday
        ["full", "full", "5 tables are empty", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "full", "3 tables are empty", "full"],//friday
        ["full", "full", "full", "7 tables are empty", "full", "full", "full", "full", "full", "full", "full", "15 tables are empty", "full", "full", "full", "full", "full", "full", "full", "4 tables are empty"],//saturday
        ["5 tables are empty", "full", "full", "full", "full", "full", "full", "full", "full", "full", "7 tables are empty", "full", "full", "6 tables are empty", "full", "full", "full", "full", "4 tables are empty", "full"]//sunday
    ]
    
}


extension ResevervationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spreadsheetView.flashScrollIndicators()
    }
    
    private func setupUI() {
        
        spreadsheetView = SpreadsheetView()
        
        view.addSubview(spreadsheetView)
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self

        spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

        spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheetView.gridStyle = .none

        spreadsheetView.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
        spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheetView.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
        spreadsheetView.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        
        view.backgroundColor = .white
        self.navigationItem.title = "Reservation"
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        spreadsheetView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}

extension ResevervationViewController: SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    
    // MARK: DataSource

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + days.count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + 1 + hours.count
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return 70
        } else {
            return 120
        }
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 24
        } else if case 1 = row {
            return 32
        } else {
            return 40
        }
    }

    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }

    //dates, days, dayColors, data
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case (1...(dates.count + 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.label.text = dates[indexPath.column - 1]
            return cell
        } else if case (1...(days.count + 1), 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            cell.label.text = days[indexPath.column - 1]
            cell.label.textColor = dayColors[indexPath.column - 1]
            return cell
        } else if case (0, 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
            cell.label.text = "TIME"
            return cell
        } else if case (0, 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            cell.label.text = hours[indexPath.row - 2]
            cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            return cell
        } else if case (1...(days.count + 1), 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            let text = data[indexPath.column - 1][indexPath.row - 2]
            if !text.isEmpty {
                cell.label.text = text
                let color = dayColors[indexPath.column - 1]
                cell.label.textColor = color
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 2, color: color)
                cell.borders.bottom = .solid(width: 2, color: color)
            } else {
                cell.label.text = nil
                cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
                cell.borders.top = .none
                cell.borders.bottom = .none
            }
            return cell
        }
        return nil
    }

    /// Delegate

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        
        let f = indexPath.column
        let t = indexPath.row - 1
        
        print("Selected: (row: \(t), column: \(f))")
        debugPrint("öge -> \(data[f-1][t-1])")//burada direk tıklanan öge içerindeki değeri ele alıyoruz!
        
        
        let value = LocalDataBaseProcess().getDATA(key: "isLogin")
        print("Res_isLogin -> \(value)")
        
        if value == "login" {
            let alert = UIAlertController(title: "SELECTEC ITEM", message: "\(data[f-1][t-1])", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "LOGIN FAILED", message: "You must be logged in to make a reservation", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
}



