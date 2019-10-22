//
//  Controller_User_interface_new_FS_export.swift
//  Holoss
//
//  Created by Rok Kosuta on 14/12/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class UI_fullScreen_export : UI_fullScreen_Generic, UITextFieldDelegate, FullScreenProtocol
{
    var export_btn : UIButton?
    
    var image_selection_1_btn : UIButton?
    var image_selection_2_btn : UIButton?
    var image_selection_3_btn : UIButton?
    
    var image_selection_custom : UIButton?
    
    func generate_and_send_html()
    {
        let j = Global.GlobalVariables.vc?.sc_controller_delegate?.get_current_model_string()
        Global.GlobalVariables.vc?.send_vie_email_HTML_export(str: ExportGenerator().generate(str : j!))
    }
    
    func generate_and_sand_html_with_image(img : UIImage)
    {
        let j = Global.GlobalVariables.vc?.sc_controller_delegate?.get_current_model_string()
        Global.GlobalVariables.vc?.send_vie_email_HTML_export(str: ExportGenerator().generate_custom_image(str: j!, image: img))
    }
    
    //MARK: FullScreenProtocol method
    func delegate_show(parent_view: UIView)
    {
        print("UI_fullScreen_export.delegate_show")
        
        Global.Animate.full_screen_show_example(duration: Global.settings.length_of_hide_full_fs_view(), view: self, parent_view: parent_view, while_hiden_f:  nil, completion_f: nil)
        off_SC()
        //generate_sand_send_html()
    }
    
    func delegate_did_finish_hidding()
    {
        
    }
    
    class func create(frame : CGRect, f_execute_before_closing : @escaping (UIView)->()) -> UI_fullScreen_export //, delegate : UI_fullScreen_export_delegate) -> UI_fullScreen_export
    {
        let res = UI_fullScreen_export.init()
        res.create_internal(frame: frame)//, delegate: delegate)
        res.execute_before_closing = f_execute_before_closing
        return res
    }
    
    private func create_internal(frame : CGRect)//, delegate : UI_fullScreen_export_delegate)
    {
        self.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.backgroundColor = Global.Constants.Colors.standard_color_background_of_view()
        
        create_button_close()
        create_title_label(string: "Export")
        
        
        
        //color selection btn 1
        export_btn = UIButton.init()
        export_btn?.setImage( UIImage.init(named: "000.jpg")?.resizeImage(targetSize: CGSize.init(width: 80, height: 80)), for: .normal)
        export_btn?.backgroundColor = UIColor.black
        export_btn?.setTitleColor(UIColor.orange, for: .normal)
        export_btn?.addTarget(self, action: #selector(self.selection_img_1_action(_:)), for: .touchUpInside)
        export_btn?.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        export_btn?.frame = CGRect.init(x: self.frame.width * 0.1, y: self.frame.height * 0.2, width: 80, height: 80)
        self.addSubview(export_btn!)
        
        //color selection btn 2
        export_btn = UIButton.init()
        export_btn?.setImage( UIImage.init(named: "001.jpg")?.resizeImage(targetSize: CGSize.init(width: 80, height: 80)), for: .normal)
        export_btn?.backgroundColor = UIColor.black
        export_btn?.setTitleColor(UIColor.orange, for: .normal)
        export_btn?.addTarget(self, action: #selector(self.selection_img_2_action), for: .touchUpInside)
        export_btn?.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        export_btn?.frame = CGRect.init(x: self.frame.width * 0.1 + 80 * 1 + 10, y: self.frame.height * 0.2, width: 80, height: 80)
        self.addSubview(export_btn!)
        
        //color selection btn 3
        export_btn = UIButton.init()
        export_btn?.setImage( UIImage.init(named: "002.jpg")?.resizeImage(targetSize: CGSize.init(width: 80, height: 80)), for: .normal)
        export_btn?.backgroundColor = UIColor.black
        export_btn?.setTitleColor(UIColor.orange, for: .normal)
        export_btn?.addTarget(self, action: #selector(self.selection_img_3_action), for: .touchUpInside)
        export_btn?.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        export_btn?.frame = CGRect.init(x: self.frame.width * 0.1 + 80 * 2 + 10 * 2, y: self.frame.height * 0.2, width: 80, height: 80)
        self.addSubview(export_btn!)
        
        image_selection_custom = UIButton.init()
        image_selection_custom?.setTitle("From Gallery", for: .normal)
        image_selection_custom?.frame = CGRect.init(x: self.frame.width * 0.1, y: self.frame.height * 0.4, width: 100, height: 50)
        //image_selection_custom?.setImage( UIImage.init(named: "002.jpg")?.resizeImage(targetSize: CGSize.init(width: 80, height: 80)), for: .normal)
        image_selection_custom?.backgroundColor = UIColor.black
        image_selection_custom?.setTitleColor(UIColor.orange, for: .normal)
        image_selection_custom?.addTarget(self, action: #selector(self.image_selection_custom_action), for: .touchUpInside)
        image_selection_custom?.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        //image_selection_custom?.frame = CGRect.init(x: self.frame.width * 0.5, y: self.frame.height * 0.8, width: 100, height: 100)
        self.addSubview(image_selection_custom!)
        
    }
    
    func export_with_image(img : UIImage?)
    {
        if let safe_img = img
        {
            print("UI_fullScreen_export.export_with_image img.size->", safe_img.size)
            generate_and_sand_html_with_image(img : safe_img)
        }
    }
    
    @objc func image_selection_custom_action()
    {
        print("UI_fullScreen_export.image_selection_custom_action")
        Global.GlobalVariables.vc?.get_image(callback_f: export_with_image)
    }
    
    @objc func selection_img_1_action(_ btn : UIButton)
    {
        self.export_with_image(img: UIImage.init(named: "000.jpg"))
    }
    
    @objc func selection_img_2_action()
    {
        self.export_with_image(img: UIImage.init(named: "001.jpg"))
    }
    
    @objc func selection_img_3_action()
    {
        self.export_with_image(img: UIImage.init(named: "002.jpg"))
    }
    
    
    @objc func export_btn_action()
    {
        print("UI_fullScreen_export.export_btn_action")
        generate_and_send_html()
    }
    
    @objc override func button_close_action()
    {
        on_SC()
        self.execute_before_closing?(self)
    }
}


