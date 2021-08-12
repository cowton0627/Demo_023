//
//  ViewController.swift
//  Demo_023
//
//  Created by 鄭淳澧 on 2021/8/12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var lunarCalLabel: UILabel!
    @IBOutlet weak var daySegControl: UISegmentedControl!
    @IBOutlet weak var leapYearSwitch: UISwitch!
    @IBOutlet weak var leapMonthLabel: UILabel!
    @IBOutlet weak var leapMonthSwitch: UISwitch!
    @IBOutlet weak var zodiacPikView: UIPickerView!
    
    var zodiacs = [Zodiac]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zodiacPikView.delegate = self
        zodiacPikView.dataSource = self
        leapMonthLabel.isHidden = true
        leapMonthSwitch.isHidden = true
        updateUI()
        showLunarDate()
        fetchData()
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        updateUI()
        showLunarDate()
        print(Calendar.current.dateComponents(in: TimeZone.current, from: myDatePicker.date))
    }
    
    func isLeapYear(year: Int) -> Bool{
       
        if (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0 && year % 3200 != 0){
            return true
        } else { return false }
    }
    
    func whichDayIndex(day: Int) -> Int {
        var dayIndex: Int = -1
        switch day {
         case 1, 2, 3, 4, 5 , 6, 7: dayIndex = day - 1
         default: break
        }
        return dayIndex
    }

    func showLunarDate() {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.calendar = Calendar(identifier: .chinese)
        formatter.locale = Locale(identifier: "zh_TW")
//        formatter.dateFormat = ""
        let date = myDatePicker.date
        lunarCalLabel.text = formatter.string(from: date)
    }
    
    func updateUI() {
    
        let pickedYear = Calendar.current.dateComponents(in: TimeZone.current, from: myDatePicker.date).year
        
        if isLeapYear(year: pickedYear!) {
            leapYearSwitch.isOn = true
        } else { leapYearSwitch.isOn = false }
        
        let pickedDay = Calendar.current.dateComponents(in: TimeZone.current, from: myDatePicker.date).weekday
        
        daySegControl.selectedSegmentIndex = whichDayIndex(day: pickedDay!)
        
        leapMonthSwitch.isOn = Calendar.current.dateComponents(in: TimeZone.current, from: myDatePicker.date).isLeapMonth!
        
        zodiacPikView.selectRow(judgeZodiac(), inComponent: 0, animated: true)
    }
    
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "Zodiac", withExtension: "json") else {
            print("can't find this url.")
            return
        }

        do {
            let decoder = JSONDecoder()
            
            let data = try Data(contentsOf: url)
            let zodiacs = try decoder.decode([Zodiac].self, from: data)
            self.zodiacs = zodiacs
            print(zodiacs.count)
        } catch {
            print("Can't get jsonData from url.")
        }
        
    }
    
    func judgeZodiac() -> Int{

        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let pickedMonth = formatter.string(from: myDatePicker.date)
        formatter.dateFormat = "dd"
        let pickerDay = formatter.string(from: myDatePicker.date)
        
        var showZodiacIndex = -1
        
        if pickedMonth == "01" && pickerDay <= "19"{
            showZodiacIndex = 0
        } else if pickedMonth == "01" && pickerDay > "19" {
            showZodiacIndex = 1
        } else if pickedMonth == "02" && pickerDay <= "18"{
            showZodiacIndex = 1
        } else if pickedMonth == "02" && pickerDay > "18" {
            showZodiacIndex = 2
        } else if pickedMonth == "03" && pickerDay <= "20"{
            showZodiacIndex = 2
        } else if pickedMonth == "03" && pickerDay > "20" {
            showZodiacIndex = 3
        } else if pickedMonth == "04" && pickerDay <= "19"{
            showZodiacIndex = 3
        } else if pickedMonth == "04" && pickerDay > "20" {
            showZodiacIndex = 4
        } else if pickedMonth == "05" && pickerDay <= "20"{
            showZodiacIndex = 4
        } else if pickedMonth == "05" && pickerDay > "21" {
            showZodiacIndex = 5
        } else if pickedMonth == "06" && pickerDay <= "20"{
            showZodiacIndex = 5
        } else if pickedMonth == "06" && pickerDay > "21" {
            showZodiacIndex = 6
        } else if pickedMonth == "07" && pickerDay <= "22"{
            showZodiacIndex = 6
        } else if pickedMonth == "07" && pickerDay > "23" {
            showZodiacIndex = 7
        } else if pickedMonth == "08" && pickerDay <= "22"{
            showZodiacIndex = 7
        } else if pickedMonth == "08" && pickerDay > "23" {
            showZodiacIndex = 8
        } else if pickedMonth == "09" && pickerDay <= "22"{
            showZodiacIndex = 8
        } else if pickedMonth == "09" && pickerDay > "23" {
            showZodiacIndex = 9
        } else if pickedMonth == "10" && pickerDay <= "22"{
            showZodiacIndex = 9
        } else if pickedMonth == "10" && pickerDay > "23" {
            showZodiacIndex = 10
        } else if pickedMonth == "11" && pickerDay <= "21"{
            showZodiacIndex = 10
        } else if pickedMonth == "11" && pickerDay > "22" {
            showZodiacIndex = 11
        } else if pickedMonth == "12" && pickerDay <= "21"{
            showZodiacIndex = 11
        } else  {
            showZodiacIndex = 0
        }
        
        return showZodiacIndex

    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return zodiacs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return zodiacs[row].name
    }
    
}


