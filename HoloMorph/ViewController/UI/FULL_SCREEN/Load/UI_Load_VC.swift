//
//  UI_fullScreen_load_n2.swift
//  Holoss
//
//  Created by Rok Kosuta on 28/01/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class UI_Load_VC : UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate
{
    struct DataCells
    {
        let path : String
        let creation_date : Date?
        
        func get_display_representation() -> String
        {
            if let safe_creation_date = self.creation_date
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .medium
                
                return dateFormatter.string(from: safe_creation_date)
            }
            return path
        }
    }
    
    var uni_close_button : ButtonClose?
    var button_save : ButtonSave?
    
    var table_view : UITableView? = UITableView()
    var f_from_UI_Load_VC_save_current_hologram : ((String)->())?
    var f_from_UI_Load_VC_load_hologram_at_path : ((String)->())?
    var f_from_UI_Load_VC_send_hologram_named : ((String)->())?
    
    var cells_data : [DataCells] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.view.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.view.backgroundColor =  Global.Constants.Colors.standard_color_background_of_view() //UIColor.rgbaFrom0to255(r: 45, g: 68, b: 113, a: 255)
        
        //save
        button_save = ButtonSave.create(frame: self.view.frame)
        button_save?.method = { [weak self] in
            let generated_name = UUID.init().uuidString
            self?.f_from_UI_Load_VC_save_current_hologram?( generated_name )
            self?.load_data()
        }
        self.view.addSubview(button_save!.btm!)
        
        //close
        uni_close_button = ButtonClose.create(frame: self.view.frame)
        uni_close_button?.method = { [weak self] in
            self?.removeFromParent()
            self?.table_view = nil
            self?.dismiss(animated: true, completion: nil)
        }
        self.view.addSubview( uni_close_button!.btm! )
        
        //tableview
        table_view?.frame = CGRect.init(x: 0, y: 80, width: screenWidth, height: screenHeight - 80)
        
        self.table_view?.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.table_view?.dataSource = self
        self.table_view?.delegate = self
        self.table_view?.rowHeight = 50
        self.table_view?.allowsSelection = true
        self.table_view?.backgroundColor = Global.Constants.Colors.standard_color_background_of_view() //UIColor.rgbaFrom0to255(r: 45, g: 68, b: 113, a: 255)
        self.view?.addSubview(self.table_view!)
        
        
        load_data()
    }
    
    deinit
    {
        print("UI_Load_VC deinit")
        self.table_view?.removeFromSuperview()
        self.table_view = nil
    }
    
    //func data load
    func load_data()
    {
        cells_data = []
        let n = MY_IO.list_of_files_in_directory_and_return_all_file_names().filter( { (s : String) -> Bool in
            if s == "Hologram_standard"
            {
                return false
            }
            else if s == "Inbox"
            {
                return false
            }
            return true
        })
        
        for i in n
        {
            cells_data.append( DataCells.init(path: i, creation_date: MY_IO.return_creation_date_of_file(name: i)) )
        }
        cells_data.sort(by: {(a : DataCells, b : DataCells)->Bool in
            return a.creation_date! > b.creation_date!
        })
        
        self.table_view?.reloadData()
    }
    
    //table view delegaes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cells_data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell : UITableViewCell? = self.table_view!.dequeueReusableCell(withIdentifier: "MyCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MyCell")
        }
        
        //cell.textLabel!.text = cells_data[indexPath.row].path
        cell!.textLabel!.text = cells_data[indexPath.row].get_display_representation()
        
        cell!.backgroundColor = UIColor.rgbaFrom0to255(r: 78, g: 99, b: 142, a: 255)
        let v1 = UIView.init(frame: CGRect.init(x: self.table_view!.frame.width * 0.5, y: 0, width: self.table_view!.frame.width * 0.5, height: 50))
        let v1_button = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: v1.frame.width * 0.333, height: v1.frame.height))
        v1_button.setTitle("Send", for: .normal)
        v1_button.addTarget(self, action:#selector(buttonPressed(_:)), for:.touchUpInside)
        v1_button.tag = 1
        v1.addSubview(v1_button)
        
        let v2_button = UIButton.init(frame: CGRect.init(x: v1.frame.width * 0.333, y: 0.0, width: v1.frame.width * 0.333, height: v1.frame.height))
        v2_button.setTitle("Load", for: .normal)
        v2_button.addTarget(self, action:#selector(buttonPressed(_:)), for:.touchUpInside)
        v2_button.tag = 2
        v1.addSubview(v2_button)
        
        let v3_button = UIButton.init(frame: CGRect.init(x: v1.frame.width * 0.333 * 2.0, y: 0.0, width: v1.frame.width * 0.333, height: v1.frame.height))
        v3_button.setTitle("Delete", for: .normal)
        v3_button.addTarget(self, action:#selector(buttonPressed(_:)), for:.touchUpInside)
        v3_button.tag = 3
        v1.addSubview(v3_button)
        
        v1.backgroundColor = Global.Constants.Colors.standard_color_table_cell_background() //UIColor.rgbaFrom0to255(r: 119, g: 136, b: 170, a: 255)
        v1_button.setTitleColor(UIColor.rgbaFrom0to255(r: 21, g: 43, b: 85, a: 255), for: .normal)
        v2_button.setTitleColor(UIColor.rgbaFrom0to255(r: 21, g: 43, b: 85, a: 255), for: .normal)
        v3_button.setTitleColor(UIColor.rgbaFrom0to255(r: 21, g: 43, b: 85, a: 255), for: .normal)
        
        cell!.addSubview( v1 )
        
        //print("cell.frame = ",cell.frame)
        return cell!
        
        /*
        let cell : UITableViewCell = (self.table_view!.dequeueReusableCell(withIdentifier: "MyCell") as UITableViewCell)
        
        //cell.textLabel!.text = cells_data[indexPath.row].path
        cell.textLabel!.text = cells_data[indexPath.row].get_display_representation()
        
        cell.backgroundColor = UIColor.rgbaFrom0to255(r: 78, g: 99, b: 142, a: 255)
        let v1 = UIView.init(frame: CGRect.init(x: self.table_view!.frame.width * 0.5, y: 0, width: self.table_view!.frame.width * 0.5, height: 50))
        let v1_button = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: v1.frame.width * 0.333, height: v1.frame.height))
        v1_button.setTitle("Send", for: .normal)
        v1_button.addTarget(self, action:#selector(buttonPressed(_:)), for:.touchUpInside)
        v1_button.tag = 1
        v1.addSubview(v1_button)
        
        let v2_button = UIButton.init(frame: CGRect.init(x: v1.frame.width * 0.333, y: 0.0, width: v1.frame.width * 0.333, height: v1.frame.height))
        v2_button.setTitle("Load", for: .normal)
        v2_button.addTarget(self, action:#selector(buttonPressed(_:)), for:.touchUpInside)
        v2_button.tag = 2
        v1.addSubview(v2_button)
        
        let v3_button = UIButton.init(frame: CGRect.init(x: v1.frame.width * 0.333 * 2.0, y: 0.0, width: v1.frame.width * 0.333, height: v1.frame.height))
        v3_button.setTitle("Delete", for: .normal)
        v3_button.addTarget(self, action:#selector(buttonPressed(_:)), for:.touchUpInside)
        v3_button.tag = 3
        v1.addSubview(v3_button)
        
        v1.backgroundColor = Global.Constants.Colors.standard_color_table_cell_background() //UIColor.rgbaFrom0to255(r: 119, g: 136, b: 170, a: 255)
        v1_button.setTitleColor(UIColor.rgbaFrom0to255(r: 21, g: 43, b: 85, a: 255), for: .normal)
        v2_button.setTitleColor(UIColor.rgbaFrom0to255(r: 21, g: 43, b: 85, a: 255), for: .normal)
        v3_button.setTitleColor(UIColor.rgbaFrom0to255(r: 21, g: 43, b: 85, a: 255), for: .normal)
        
        cell.addSubview( v1 )
        
        //print("cell.frame = ",cell.frame)
        return cell
        */
    }
    
    func presentMailWithAttachment(vc : inout MFMailComposeViewControllerDelegate)
    {
        if( MFMailComposeViewController.canSendMail() )
        {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = vc
            
            //Set the subject and message of the email
            mailComposer.setSubject("Holoss hologram")
            mailComposer.setMessageBody("This is what they sound like.", isHTML: false)
            
            let filePath = Global.paths.get_standard_path()
            
            if let fileData = NSData(contentsOfFile : filePath)
            {
                mailComposer.addAttachmentData(fileData as Data, mimeType: ".txt", fileName: "out.txt")
            }
            
            (vc as! UIViewController).present(mailComposer, animated: true, completion: nil)
        }
    }
    
    
    
    @objc func buttonPressed(_ sender: AnyObject)
    {
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? UITableViewCell
        let indexPath = table_view?.indexPath(for: cell!)
        
        //print(indexPath?.row)
        
        func remove_alert(message: String, title: String = "", row : Int) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action_ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                MY_IO.remove_file(name: self.cells_data[row].path)
                self.load_data()
            })
            let action_cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                print("Cancel")
            })
            alertController.addAction(action_ok)
            alertController.addAction(action_cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        
        func load_alert(message: String, title: String = "", row : Int) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action_ok = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let generated_name = UUID.init().uuidString
                self.f_from_UI_Load_VC_save_current_hologram?( generated_name )
                self.load_data()
                
                self.f_from_UI_Load_VC_load_hologram_at_path?( self.cells_data[indexPath!.row].path )
                self.dismiss(animated: true, completion: nil)
            })
            let action_cancel = UIAlertAction(title: "Just load", style: .default, handler: { (action: UIAlertAction!) in
                print("just load")
                self.f_from_UI_Load_VC_load_hologram_at_path?( self.cells_data[indexPath!.row].path )
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(action_ok)
            alertController.addAction(action_cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if button?.tag == 1
        {
            print("send")
            
            self.dismiss(animated: true, completion: {()->() in
                self.f_from_UI_Load_VC_send_hologram_named?( self.cells_data[indexPath!.row].path )
            })
        }
        else if button?.tag == 2
        {
            print("Load")
            load_alert(message: "Save current scene?", title: "Alert!", row: indexPath!.row)
        }
        else if button?.tag == 3
        {
            remove_alert(message: "Are you sure you like to delete selected scene?", title: "Alert!", row : indexPath!.row)
        }
    }
    
}



