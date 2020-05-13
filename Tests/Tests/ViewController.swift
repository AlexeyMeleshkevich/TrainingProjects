//
//  ViewController.swift
//  Tests
//
//  Created by Alexey Meleshkevich on 12.05.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var chooseSubjectButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var testTableView: UITableView!
    var blurViewWindow: UIVisualEffectView!
    
    var pickerView: UIPickerView!
    let noDataLabel = UILabel()
    
    var chosenSubject: SubjectModel?
    
    let fakeData: [SubjectModel] = [SubjectModel(subjectName: "Теория Вероятности", tests: [TestModel(testPassed: true, testRating: 8, testName: "Введение"),
                                                                                                             TestModel(testPassed: true, testRating: 10, testName: "Задачи на вероятности"),
                                                                                                             TestModel(testPassed: false, testRating: nil, testName: "Математическая статистика")]),
                                    SubjectModel(subjectName: "Общая физика", tests: nil),
                                    SubjectModel(subjectName: "Дифференциальные уравнения", tests: nil),
                                    SubjectModel(subjectName: "Математический анализ", tests: [TestModel(testPassed: false, testRating: nil, testName: "Интегралы"),
                                                                                                                   TestModel(testPassed: true, testRating: 4, testName: "Оператор Гамильтона")]),
                                    SubjectModel(subjectName: "Аналитическая геометрия и линейная алгебра", tests: nil)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTableView.delegate = self
        testTableView.dataSource = self
    }
    
    func setToolbar() {
        let toolBar = UIToolbar()
        toolBar.isTranslucent = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonAction))
        ]
        
        view.addSubview(toolBar)
        
        NSLayoutConstraint.activate([
            toolBar.widthAnchor.constraint(equalToConstant: view.frame.width),
            toolBar.heightAnchor.constraint(equalToConstant: 40),
            toolBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toolBar.bottomAnchor.constraint(equalTo: pickerView.topAnchor)
        ])
    }
    
    @objc func doneButtonAction() {
        guard chosenSubject != nil else { showNotChosenAlert(); return }
        
        self.pickerView.removeFromSuperview()
        chooseSubjectButton.isHidden = false
        chooseSubjectButton.isEnabled = true
        
        checkForTests(subject: chosenSubject)
        testTableView.reloadData()
    }
    
    func showNotChosenAlert() {
        blurView()
        let alert = UIAlertController(title: "Ошибка", message: "Вы не выбрали предмет", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: (dismissBlur)))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func chooseSubject(_ sender: Any) {
        chooseSubjectButton.isHidden = true
        chooseSubjectButton.isEnabled = false
        
        pickerView = UIPickerView(frame: CGRect(x: view.frame.minX, y: view.frame.maxY, width: view.frame.width, height: 0))
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = UIColor.systemGray5
        self.view.addSubview(self.pickerView)
        NSLayoutConstraint.activate([
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pickerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            pickerView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        setToolbar()
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeCubic, animations: {
            self.pickerView.frame = CGRect(x: 0, y: 0, width: 0, height: 250)
        }, completion: nil)
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func blurView() {
        guard let window = view.window else { return }
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurViewWindow = UIVisualEffectView(effect: blurEffect)
        blurViewWindow.alpha = 0
        blurViewWindow.frame = window.bounds
        window.addSubview(blurViewWindow)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blurViewWindow.alpha = 1
        }
    }
    
    func dismissBlur(action: UIAlertAction!) {
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.blurViewWindow.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self?.blurViewWindow.removeFromSuperview()
            }
        }
    }
    
    func checkForTests(subject: SubjectModel?) {
        noDataLabel.textAlignment = .center
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.text = "Тестов нет"
        if subject?.tests == nil {
            testLabel.isHidden = true
            statusLabel.isHidden = true
            if !view.subviews.contains(noDataLabel) {
                view.addSubview(noDataLabel)
                NSLayoutConstraint.activate([
                    noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    noDataLabel.widthAnchor.constraint(equalToConstant: 100),
                    noDataLabel.heightAnchor.constraint(equalToConstant: 20)
                ])
            }
        } else {
            testLabel.isHidden = false
            statusLabel.isHidden = false
            if view.subviews.contains(noDataLabel) {
                noDataLabel.removeFromSuperview()
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fakeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fakeData[row].subjectName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.chosenSubject = fakeData[row]
        subjectName.text = chosenSubject?.subjectName
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == tableView.indexPathForSelectedRow?.row
        {
            return 120
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let testsNumber = chosenSubject?.tests?.count else { return 0 }
        return testsNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test", for: indexPath)
        cell.accessoryType = .none
        cell.accessoryView = nil
        
        guard let subject = chosenSubject else { return UITableViewCell() }
        guard let test = subject.tests?[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = test.testName
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if test.testPassed == true {
            cell.accessoryType = .checkmark
        } else {
            let notPassedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            notPassedLabel.text = "Не пройден"
            notPassedLabel.textAlignment = .right
            cell.accessoryView = notPassedLabel
        }
        NSLayoutConstraint.activate([
            (cell.textLabel?.topAnchor.constraint(equalTo: cell.topAnchor, constant: 15))!,
            (cell.textLabel?.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10))!
        ])
        
        let ratingLabel = UILabel()
        ratingLabel.removeFromSuperview()
        
        if test.testPassed == true && tableView.indexPathForSelectedRow?.row == indexPath.row {
            ratingLabel.text = "Оценка: \(String(test.testRating!))"
            ratingLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(ratingLabel)
            NSLayoutConstraint.activate([
                ratingLabel.topAnchor.constraint(equalTo: cell.textLabel!.bottomAnchor, constant: 50),
                ratingLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 10)
            ])
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        tableView.deselectRow(at: indexPath, animated: true)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

