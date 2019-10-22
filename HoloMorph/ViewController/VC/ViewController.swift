//
//  ViewController.swift
//  Holoss
//
//  Created by Rok Kosuta on 07/10/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MessageUI
import Foundation
import Social
import ReplayKit
import AVKit


class VC_PinchTapLongPress
{
    private var on_pintch : ((UIPinchGestureRecognizer)->())?
    private var on_tap : ((UITapGestureRecognizer)->())?
    private var on_long_press : ((UILongPressGestureRecognizer)->())?
    init(vc : UIView, f_on_pintch : ((UIPinchGestureRecognizer)->())?, f_on_tap : ((UITapGestureRecognizer)->())?, f_on_long_press : ((UILongPressGestureRecognizer)->())?)
    {
        vc.addGestureRecognizer( UIPinchGestureRecognizer(target: self, action: #selector(self.pintch_zoom(sender:))) )
        vc.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognize:))) )
        vc.addGestureRecognizer( UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognize:))) )
        self.on_pintch = f_on_pintch
        self.on_tap = f_on_tap
        self.on_long_press = f_on_long_press
    }
    @objc private func handleLongPress( gestureRecognize : UILongPressGestureRecognizer)
    {
        on_long_press?(gestureRecognize)
    }
    @objc private func pintch_zoom( sender : UIPinchGestureRecognizer)
    {
        on_pintch?(sender)
    }
    @objc private func handleTap(gestureRecognize: UITapGestureRecognizer)
    {
        on_tap?(gestureRecognize)
    }
}


class ViewController : UIViewController, ARSCNViewDelegate, ARSessionDelegate, Controller_user_interface_new_Delegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RPPreviewViewControllerDelegate
{
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    private var user_interface : UI_Controller?
    var sc_controller_delegate : SC_Controller_Delegate?
    let myNotification = Notification.init(name : Notification.Name(rawValue: "MyNotification"))
    var send_events_to_SC = true
    var vc_pintchAndTapLongPress : VC_PinchTapLongPress?
    
    var return_back_to_load_save_view_after_sending_email : Bool = true
    var callback_when_we_have_new_last_selected_image_from_albtum : ((UIImage?)->())?
    
    var cursor_view : UIView?
    
    var isRecording : Bool = false
    let recorder = RPScreenRecorder.shared()
    var previewViewController : RPPreviewViewController?
    
    var direct : SC_Controller_Direct = SC_Controller_Direct()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: myNotification.name, object: nil, queue: nil, using: catchNotification)
        
        self.sceneView.session.delegate = self
        
        self.user_interface = UI_Controller(main_view: self.view, delegate: self)
        self.sc_controller_delegate = SC_Controller(scene_view: self.sceneView, delegate : self)
        
        self.direct.scene_view = self.sceneView
        
        //Pintch, Tap, LongPress
        func pintch_zoom( sender : UIPinchGestureRecognizer)
        {
            send_events_to_SC.ifTrueExecute { self.sc_controller_delegate?.pintch_zoom(sender: sender) }
            
        }
        func handleTap(gestureRecognize: UITapGestureRecognizer)
        {
            direct.handleTap(gestureRecognize: gestureRecognize)
            send_events_to_SC.ifTrueExecute { self.sc_controller_delegate?.handleTap(gestureRecognize: gestureRecognize) }
        }
        
        func handleLongPress(gestureRecognize: UILongPressGestureRecognizer) {}
        self.vc_pintchAndTapLongPress =  VC_PinchTapLongPress(vc: self.view, f_on_pintch: pintch_zoom, f_on_tap: handleTap, f_on_long_press: handleLongPress)
        
        //LET make starting scene
        //sc_controller_delegate?.load_scene(model: SceneModel.test_scene())
        
        Global.GlobalVariables.vc = self
        
        //pip
        //var a = UserDefaults.standard.bool(forKey: "rok")
        //UserDefaults.standard.bool(forKey: <#T##String#>)
        //print("kokulele", a)
        
        
        user_interface?.fs.settings?.update_on_start()
        
        cursor(show : true)
        
        
        
        
    }
    
    
    //replay
    func record()
    {
        recorder.startRecording(handler: { (error) in
            if (error != nil)
            {
                let alert = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction( UIAlertAction(title: "okey", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            print("OK")
        })
        print("rec:",recorder.isRecording)
        print("av:",recorder.isAvailable)
        print("enabled:",recorder.isCameraEnabled)
    }
    
    func stop()
    {
        
        recorder.stopRecording( handler: { previewViewController, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                previewViewController?.modalPresentationStyle = UIModalPresentationStyle.popover
                previewViewController?.popoverPresentationController?.sourceRect = CGRect.zero
                previewViewController?.popoverPresentationController?.sourceView = self.view
            }
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                previewViewController?.modalPresentationStyle = UIModalPresentationStyle.popover
                previewViewController?.popoverPresentationController?.sourceRect = CGRect.zero
                previewViewController?.popoverPresentationController?.sourceView = self.view
            }
            
            if previewViewController != nil {
                self.previewViewController = previewViewController
                previewViewController?.previewControllerDelegate = self
            }
            self.present(previewViewController!, animated: true, completion: nil)
        })
        return
    }
    
    func toggle_reaplay()
    {
        print("JA?")
        if isRecording
        {
            print("kwa!")
            stop()
            isRecording = false
            user_interface?.recording_video_off()
        }
        else
        {
            print("start recording!")
            record()
            isRecording = true
            user_interface?.recording_video_on()
        }
    }
    
    
    
    
    
    // MARK: RPPreviewViewControllerDelegate
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        print("previewControllerDidFinish")
        previewController.dismiss(animated: true, completion: nil)
    }
    
    func previewController(_ previewController: RPPreviewViewController,
                           didFinishWithActivityTypes activityTypes: Set<String>)
    {
        print("previewControllerDidFinish previewControllerDidFinish")
    }
    
    //end replay
    func cursor(show : Bool)
    {
        func show_cursor()
        {
            if cursor_view == nil
            {
                print("kaj?")
                cursor_view = UIView.init()
                cursor_view?.backgroundColor = UIColor.red
                cursor_view?.layer.cornerRadius = 2.0
                cursor_view?.frame = CGRect.init(x: self.view.frame.width * 0.5 - 2, y: self.view.frame.height * 0.5 - 2, width: 10, height: 10)
                self.view.addSubview(cursor_view!)
            }
            cursor_view?.isHidden = false
            self.view?.bringSubviewToFront(cursor_view!)
            
        }
        
        func hide_cursor()
        {
            cursor_view?.isHidden = true
        }
        
        if show
        {
            show_cursor()
        }
        else
        {
            hide_cursor()
        }
    }
    
    
    
    
    
    
    
    func delegate_menu_move_command(command: My_Enums.Menu_World_Move_Option) { self.sc_controller_delegate?.move_commands(command: command) }
    
    func delegate_new_color_selected(color : UIColor) { self.sc_controller_delegate?.mode_create__set_create_color(color: color) }
    
    func delegate_UI_menu_menu_command(selected_option: My_Enums.Menu_Menu_Option)
    {
        
        func remove_all_alert(_ message: String, title: String = "") {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action_ok = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                self.sc_controller_delegate?.delate_all()
            })
            let action_cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                print("Cancel")
            })
            alertController.addAction(action_ok)
            alertController.addAction(action_cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if selected_option == .email
        {
            var p = self
            self.presentMailWithAttachment(vc: &p)
        }
        else if selected_option == .load_save_send
        {
            let v = UI_Load_VC()
            v.f_from_UI_Load_VC_save_current_hologram = save_current_hologram
            v.f_from_UI_Load_VC_load_hologram_at_path = load_hologram_at_path
            v.f_from_UI_Load_VC_send_hologram_named = send_via_email_hologram_named
            self.present( v,  animated: true, completion: nil)
        }
        else if selected_option == .delete_all
        {
            remove_all_alert("Are you sure you like to remove all object-s?")
        }
    }
    
    func save_current_hologram( name : String)
    {
        print("VC Save current hologram under name : ", name)
        sc_controller_delegate?.save_with_name(name: name)
        sc_controller_delegate?.delate_all()
    }
    
    func load_hologram_at_path( path : String)
    {
        
        print("VC load_hologram_at_path :", path)
        let p = MY_IO.read_file(name: path)
        
        if let safe_scene = SceneModel.init_from_string(str : p)
        {
            sc_controller_delegate?.load_scene(model: safe_scene)
        }
        
    }
    
    func appDelegate_call_save_things_before_app_terminates()
    {
        print("appDelegate_call_save_things_before_app_terminates")
        save_current_hologram(name: UUID.init().uuidString)
    }
    
    
    func session(_ session: ARSession, didUpdate frame: ARFrame)
    {
        if (send_events_to_SC)
        {
            
            self.sc_controller_delegate?.session(session, didUpdate: frame, trackingOK: isTrackingReady)
            self.user_interface?.update_number_of_objects_in_current_scene(v: self.sc_controller_delegate!.number_of_created_elements(), max_number: self.sc_controller_delegate!.max_number_of_create_elements())
            
            if self.sc_controller_delegate!.show_cursor_view()
            {
                cursor(show: true)
            }
            else
            {
                cursor(show : false)
            }
        }
        
        if SC_Controller_Direct.enabled()
        {
            direct.session(session, didUpdate: frame)
        }
    }
    
    var isTrackingReady : Bool = false
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera)
    {
        func isReadyForDrawing(trackingState: ARCamera.TrackingState) -> Bool {
            switch trackingState {
            case .normal:
                return true
            default:
                return false
            }
        }
        
        let state = camera.trackingState
        isTrackingReady = isReadyForDrawing(trackingState: state)
    }
    
}

//Notofications
extension ViewController
{
    func catchNotification(notification:Notification) -> Void
    {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String,
            let _     = userInfo["date"]    as? Date else {
                print("No userInfo found in notification")
                return
        }
        
        if message == "SC_event_from_VC_ON"
        {
            send_events_to_SC = true
        }
        else if message == "SC_event_from_VC_OFF"
        {
            send_events_to_SC = false
        }
        
    }
}

//open in email
extension ViewController
{
    func event_from_open_in(url : URL, str : String)
    {
        print("ViewController.event_from_open_in   url:", url)
        if let safe_scene_model = SceneModel.init_from_string(str: str)
        {
            if let json_ok = safe_scene_model.getJSON_string()
            {
                MY_IO.write_to_file(txt: json_ok, name: safe_scene_model.id)
                MY_IO.remove_all_files_in_inbox_directory()
                load_hologram_at_path(path: safe_scene_model.id)
            }
        }
    }
}

//rotation and scale
extension ViewController
{
    func delegate_user_interface_rotation_and_scale(rotation: SCNVector3, scale: SCNVector3, additive_vs_multiplicative : Bool)
    {
        sc_controller_delegate?.delegate_rotation_and_scale(rotation: rotation, scale: scale, additive_vs_multiplicative : additive_vs_multiplicative)
    }
}

//touch events
extension ViewController
{
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { if send_events_to_SC {
        self.sc_controller_delegate?.touchesEnded(touches, with: event) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { if send_events_to_SC {
        self.sc_controller_delegate?.touchesBegan(touches, with: event) } }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { if send_events_to_SC { self.sc_controller_delegate?.touchesMoved(touches, with: event) } }
}

//Email
extension ViewController
{
    func send_via_email_hologram_named( name : String)
    {
        return_back_to_load_save_view_after_sending_email = true
        MY_IO.save_string_to_standar_path( MY_IO.read_file(name: name) )
        var p = self
        self.presentMailWithAttachment(vc: &p)
    }
    
    func send_vie_email_HTML_export( str : String)
    {
        return_back_to_load_save_view_after_sending_email = false
        MY_IO.save_string_to_standar_path( str )
        var p = self
        self.presentMailWithAttachmentHTML(vc: &p)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        print("ViewController.mailComposeController controller.dismiss")
        controller.dismiss(animated: true, completion: { ()->() in
            if self.return_back_to_load_save_view_after_sending_email
            {
                self.user_interface?.callback_from_Menu_Menu(selected_option: .load_save_send)
            }
            
        })
    }
    
    func presentMailWithAttachment(vc : inout ViewController)
    {
        func link_gen() -> String
        {
            return "<br /><a href='http://www.kaotik.si/HoloMorph/index.html'> Link to App site </a>"
        }
        
        print("Button email tapped")
        if( MFMailComposeViewController.canSendMail() )
        {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = vc
            
            //Set the subject and message of the email
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let s = dateFormatterGet.string(from: Date())
            
            mailComposer.setSubject("New Message From Holoss")
            mailComposer.setMessageBody("This Holoss message was sendt at "+s+link_gen(), isHTML: true)
            
            let filePath = Global.paths.get_standard_path()
            
            if let fileData = NSData(contentsOfFile : filePath)
            {
                mailComposer.addAttachmentData(fileData as Data, mimeType: ".txt", fileName: "Holoss_"+String(describing: Global.Converter.TimeConverter.conververtTimeSince1970_FromDouble_ToInt(Date().timeIntervalSince1970))+".txt")
                //mailComposer.addAttachmentData(fileData as Data, mimeType: ".txt", fileName: "Holoss_"+String(describing: Global.Converter.TimeConverter.conververtTimeSince1970_FromDouble_ToInt(Date().timeIntervalSince1970))+".txt")
            }
            vc.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func presentMailWithAttachmentHTML(vc : inout ViewController)
    {
        func link_gen() -> String
        {
            return "<br /><a href='http://www.kaotik.si/HoloMorph/index.html'> Link to App site </a>"
        }
        
        print("Button email tapped")
        if( MFMailComposeViewController.canSendMail() )
        {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = vc
            
            //Set the subject and message of the email
            mailComposer.setSubject("New Message From Holoss")
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let s = dateFormatterGet.string(from: Date())
            
            mailComposer.setMessageBody("This Holoss message was sent at "+s+link_gen(), isHTML: true)
            
            let filePath = Global.paths.get_standard_path()
            
            
            
            if let fileData = NSData(contentsOfFile : filePath)
            {
                mailComposer.addAttachmentData(fileData as Data, mimeType: "text/html", fileName: "Hollos_"+String(describing: Global.Converter.TimeConverter.conververtTimeSince1970_FromDouble_ToInt(Date().timeIntervalSince1970))+".html")
            }
            vc.present(mailComposer, animated: true, completion: nil)
        }
    }
}

extension ViewController
{
    func delegate_selected_from_SC_Controller(sel : My_Enums.Node_Graph_Type_Of_Node) { user_interface?.callback_from_ViewController_inSelectModeSelectedObjectOf(type: sel) }
    
    func delegate_user_interface__ObjectDependentSelectMenu__Selected(type: My_Enums.Select_Node_Options)
    {
        self.sc_controller_delegate?.select_event_object_dependent(event : type)
    }
    
    func delegate_user_interface__MainMenu__command(command: My_Enums.Menu_Main_Option)
    {
        switch command
        {
        case .create: self.sc_controller_delegate?.change_mode_to(mode: My_Enums.Mode.create)
        case .menu: break
        case .move_object: self.sc_controller_delegate?.change_mode_to(mode: My_Enums.Mode.move_object)
        case .move_world : self.sc_controller_delegate?.change_mode_to(mode: My_Enums.Mode.move_world)
        case .select : self.sc_controller_delegate?.change_mode_to(mode: My_Enums.Mode.select)
        }
    }
    
    func delegate_user_interface__CreateMenu__Create(type: My_Enums.Node_Graph_Type_Of_Node)
    {
        self.sc_controller_delegate?.create_command(command: type)
    }
    
    func delegate_user_interface_get_info_data() -> Info_Data
    {
        return self.sc_controller_delegate!.current_info()
    }
    
    func delegate_user_interface_new_tag_list(tag_list: Tag_List)
    {
        self.sc_controller_delegate?.new_tag_list(tag_list: tag_list)
    }
    
    func delegate_user_interface_get_description() -> Description
    {
        return self.sc_controller_delegate!.current_description()
    }
    
    func delegate_user_interface_new_desription(desc: Description)
    {
        self.sc_controller_delegate?.new_desription(des: desc)
    }
    
    func delegate_user_interface_get_tag_list() -> Tag_List
    {
        return self.sc_controller_delegate!.current_tag_list()
    }
}

//ViewController settings
extension ViewController
{
    //hide status bar this is where it shown how much battery we have etc
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        
        //configuration.isLightEstimationEnabled = true // YOU can chan on off learn about this!! it may have performace price?
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
}


//extension image picker
extension ViewController
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        print("ViewController.imagePickerController")
        let theInfo : NSDictionary = info as NSDictionary
        let img : UIImage? = (theInfo.object(forKey: convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)) as? UIImage)
        self.dismiss(animated: true, completion: nil)
        callback_when_we_have_new_last_selected_image_from_albtum?(img)
    }
    
    func get_image(callback_f : ((UIImage?)->())?)
    {
        callback_when_we_have_new_last_selected_image_from_albtum = callback_f
        print("ViewController.get_image")
        let imageVC = UIImagePickerController()
        imageVC.delegate = self
        imageVC.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imageVC, animated: true, completion: nil)
    }
}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
