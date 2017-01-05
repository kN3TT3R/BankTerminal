//
//  ViewController.swift
//  BankTerminal
//
//  Created by Kenneth Debruyn on 20/12/16.
//  Copyright © 2016 kN3TT3R. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var myChoiceTextView: UITextView!
    @IBOutlet weak var currentBalanceTextView: UITextView!
    @IBOutlet weak var transactionTotalTextView: UITextView!
    @IBOutlet weak var availableBalanceTextView: UITextView!
    @IBOutlet weak var fiveEuroBillTextView: UITextView!
    @IBOutlet weak var tenEuroBillTextView: UITextView!
    @IBOutlet weak var twentyEuroBillTextView: UITextView!
    @IBOutlet weak var fiftyEuroBillTextView: UITextView!
    @IBOutlet weak var hundredEuroBillTextView: UITextView!
    @IBOutlet weak var twoHundredEuroBillTextView: UITextView!
    @IBOutlet weak var fiveHundredEuroBillTextView: UITextView!
    @IBOutlet weak var enterPinCodeTextField: UITextField!
    @IBOutlet weak var resetAllValuesButton: UIButton!
    @IBOutlet weak var performTransactionButton: UIButton!
    @IBOutlet weak var printToConsoleButton: UIButton!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet var completeView: UIView!
    
    
    // MARK: - Global Constants & Variables
    var myChoiceArray: [String] = []
    var billCounterArray: [Int] = [0, 0, 0, 0, 0, 0, 0]
    let pinCode = "8888"
    var pinCodeFailedAttemptCounter = 3
    var currentBalance = 1711.26
    var transactionTotal = 0.00
    var availableBalance = 0.00
    let insufficientBalanceTitle = "Onvoldoende Saldo"
    let insufficientBalanceText = "Ik vrees dat u dit biljet niet kunt toevoegen. U heeft namelijk niet genoeg geld op uw bankrekening."
    let insufficientBillsTitle = "Deze coupure kan niet verwijderd worden."
    let insufficientBillsText = "Kies een ander type coupure waarvan het aantal groter is dan 0 of voeg andere coupures toe."
    let wrongPinCodeTitle = "Verkeerde Pincode"
    let cardBlockedTitle = "Aantal pogingen overschreden"
    let cardBlockedText = "Uw kaart werd geblokkeerd. Gelieve contact op te nemen met de klantendienst."
    let transactionTotalIsNullTitle = "Geen geldopname"
    let transactionTotalIsNullText = "U neemt geen geld op. Gelieve geld op te nemen."
    
    
    // MARK: - IBActions
    @IBAction func addBill(_ sender: UIButton) {
        if sender.tag == 1 {
            increaseTransaction(with: 5, atIndex: 0, for: sender.tag, textView: fiveEuroBillTextView)
        } else if sender.tag == 2 {
            increaseTransaction(with: 10, atIndex: 1, for: sender.tag, textView: tenEuroBillTextView)
        } else if sender.tag == 3 {
            increaseTransaction(with: 20, atIndex: 2, for: sender.tag, textView: twentyEuroBillTextView)
        } else if sender.tag == 4 {
            increaseTransaction(with: 50, atIndex: 3, for: sender.tag, textView: fiftyEuroBillTextView)
        } else if sender.tag == 5 {
            increaseTransaction(with: 100, atIndex: 4, for: sender.tag, textView: hundredEuroBillTextView)
        } else if sender.tag == 6 {
            increaseTransaction(with: 200, atIndex: 5, for: sender.tag, textView: twoHundredEuroBillTextView)
        } else if sender.tag == 7 {
            increaseTransaction(with: 500, atIndex: 6, for: sender.tag, textView: fiveHundredEuroBillTextView)
        }
        updateMyChoiceTextView()
    }
    
    @IBAction func removeBill(_ sender: UIButton) {
        if sender.tag == 8 {
            decreaseTransaction(with: 5, atIndex: 0, for: sender.tag, textView: fiveEuroBillTextView)
        } else if sender.tag == 9 {
            decreaseTransaction(with: 10, atIndex: 1, for: sender.tag, textView: tenEuroBillTextView)
        } else if sender.tag == 10 {
            decreaseTransaction(with: 20, atIndex: 2, for: sender.tag, textView: twentyEuroBillTextView)
        } else if sender.tag == 11 {
            decreaseTransaction(with: 50, atIndex: 3, for: sender.tag, textView: fiftyEuroBillTextView)
        } else if sender.tag == 12 {
            decreaseTransaction(with: 100, atIndex: 4, for: sender.tag, textView: hundredEuroBillTextView)
        } else if sender.tag == 13 {
            decreaseTransaction(with: 200, atIndex: 5, for: sender.tag, textView: twoHundredEuroBillTextView)
        } else if sender.tag == 14 {
            decreaseTransaction(with: 500, atIndex: 6, for: sender.tag, textView: fiveHundredEuroBillTextView)
        }
        updateMyChoiceTextView()
    }
    
    @IBAction func resetAllValues(_ sender: UIButton) {
        resetAllValues()
    }
    
    @IBAction func enterPinCode(_ sender: UITextField) {
        enterPinCodeTextField.isSecureTextEntry = true
        enterPinCodeTextField.text = sender.text
    }
    
    @IBAction func performTransaction(_ sender: UIButton) {
        /* Check if user added bills to the transaction */
        if transactionTotal == 0 {
            showAlert(transactionTotalIsNullText, withTitle: transactionTotalIsNullTitle)
            resetPinCode()
        } else {
            /* Check if user added correct pincode */
            if enterPinCodeTextField.text == pinCode {
                printToConsoleIfTransactionSuccessful()
                currentBalance -= transactionTotal
                availableBalance = currentBalance
                resetAllValues()
                pinCodeFailedAttemptCounter = 3
            } else {
                pinCodeFailedAttemptCounter -= 1
                if pinCodeFailedAttemptCounter != 0 {
                    showAlert("Deze Pincode is niet correct. Gelieve de juiste code in te voeren. U heeft nog \(pinCodeFailedAttemptCounter) pogingen over.", withTitle: wrongPinCodeTitle)
                    resetAllValues()
                } else {
                    showAlert(cardBlockedText, withTitle: cardBlockedTitle)
                    disableUserInteraction()
                    resetAllValues()
                }
            }
        }
    }
    
    @IBAction func printToConsole(_ sender: UIButton) {
        printSeperationLine()
        print("Ticket\n\nVorig Saldo: \t\t€ \(currentBalance)\nTransactietotaal: \t€ \(transactionTotal)\n\nNieuw Saldo: \t\t€ \(currentBalance - transactionTotal)")
        printSeperationLine()
    }
    
    
    // MARK: - Homemade functions
    func resetAllValues() {
        transactionTotal = 0.00
        resetArrays()
        updateBalanceTextViews(currentBalance, transactionTotal)
        updateMyChoiceTextView()
        resetAllBillTextViews()
        resetPinCode()
    }
    
    func resetPinCode() {
        enterPinCodeTextField.text = "Enter Pin Code"
        enterPinCodeTextField.isSecureTextEntry = false
    }
    
    func resetArrays() {
        billCounterArray = [0, 0, 0, 0, 0, 0, 0]
        myChoiceArray = []
    }
    
    func resetAllBillTextViews() {
        fiveEuroBillTextView.text = "0 biljetten van 5 euro"
        tenEuroBillTextView.text = "0 biljetten van 10 euro"
        twentyEuroBillTextView.text = "0 biljetten van 20 euro"
        fiftyEuroBillTextView.text = "0 biljetten van 50 euro"
        hundredEuroBillTextView.text = "0 biljetten van 100 euro"
        twoHundredEuroBillTextView.text = "0 biljetten van 200 euro"
        fiveHundredEuroBillTextView.text = "0 biljetten van 500 euro"
    }
    
    func increaseTransaction(with amount: Int, atIndex: Int, for sender: Int, textView: UITextView) {
        /* Check if user has enough money left available to add to the transaction */
        if (currentBalance - transactionTotal - Double(amount)) < 0 {
            showAlert(insufficientBalanceText, withTitle: insufficientBalanceTitle)
        } else {
            transactionTotal += Double(amount)
            availableBalance = currentBalance - transactionTotal
            updateBalanceTextViews(currentBalance, transactionTotal)
            myChoiceArray.append(String(amount))
            updateBillCounterArray(atIndex, for: sender)
            updateTextFor(textView, atIndex, amount)
        }
    }
    
    func decreaseTransaction(with amount: Int, atIndex: Int, for sender: Int, textView: UITextView) {
        /* Check if there are bills of this type available to be removed from transaction */
        if billCounterArray[atIndex] == 0 {
            showAlert(insufficientBillsText, withTitle: insufficientBillsTitle)
        } else {
            transactionTotal -= Double(amount)
            availableBalance = currentBalance - transactionTotal
            updateBalanceTextViews(currentBalance, transactionTotal)
            myChoiceArray.append("-\(amount)")
            updateBillCounterArray(atIndex, for: sender)
            updateTextFor(textView, atIndex, amount)
        }
    }
    
    func updateBillCounterArray(_ atIndex: Int,for sender: Int) {
        if (sender >= 1 && sender <= 7) {
            billCounterArray[atIndex] += 1
        } else {
            billCounterArray[atIndex] -= 1
        }
    }
    
    func updateTextFor(_ textView: UITextView,_ atIndex: Int,_ withBill: Int) {
        if billCounterArray[atIndex] == 1 {
            textView.text = "1 biljet van \(withBill) euro"
        } else {
            textView.text = "\(billCounterArray[atIndex]) biljetten van \(withBill) euro"
        }
    }
    
    func updateBalanceTextViews(_ currentBalance: Double,_ transactionTotal: Double) {
        currentBalanceTextView.text = String(format: "€ %.02f", currentBalance)
        transactionTotalTextView.text = String(format: "€ %.02f", transactionTotal)
        availableBalanceTextView.text = String(format: "€ %.02f", currentBalance - transactionTotal)
    }
    
    func updateMyChoiceTextView() {
        myChoiceTextView.text = "Uw Keuze:\n" + myChoiceArrayToString()
    }
    
    func myChoiceArrayToString() -> String {
        var myChoicesString = ""
        for myChoice in myChoiceArray {
            myChoicesString += myChoice + "\n"
        }
        return myChoicesString
    }
    
    func showAlert(_ alert: String, withTitle title: String) {
        let alertController = UIAlertController(title: title, message: alert, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func disableUserInteraction() {
        completeView.isUserInteractionEnabled = false
        resetAllValuesButton.setTitleColor(UIColor.lightGray, for: .normal)
        enterPinCodeTextField.textColor = UIColor.lightGray
        performTransactionButton.setTitleColor(UIColor.lightGray, for: .normal)
        printToConsoleButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    func printToConsoleIfTransactionSuccessful() {
        printSeperationLine()
        print("Gelieve uw geld uit de lade te nemen. Vergeet uw kaart niet!\nTicket\n\nVorig Saldo: \t\t€ \(currentBalance)\nTransactietotaal: \t€ \(transactionTotal)\n\nNieuw Saldo: \t\t€ \(currentBalance - transactionTotal)")
        printSeperationLine()
    }
    
    func printSeperationLine() {
        print("*** *** *** *** *** *** *** *** *** *** *** *** *** *** ***")
    }
    
    
    // MARK: - Overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBalanceTextViews(currentBalance, transactionTotal)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
