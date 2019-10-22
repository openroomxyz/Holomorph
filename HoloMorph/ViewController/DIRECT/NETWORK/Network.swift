//
//  Network.swift
//  HoloMorph
//
//  Created by Rok Kosuta on 10/04/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//

import Foundation

class Network : NSObject
{
    private var timer = Timer()
    static let network = Network.init()
    private var messageStack : MessageStack = MessageStack.init()
    
    private var local_counter = -1
    private var remote_coutner = -1
    
    private var readMessages : MessageStack = MessageStack.init()
    
    struct Message
    {
        enum MessageStatus
        {
            case sent
            case recived
            case saved
            case not_sent
        }
        
        let type : String
        let countent : String
        let page : Int
        let pages : Int
        let messageid : String
        let from : String
        let to : String
        let status : MessageStatus
        
        static func tryGenerateMessage(body : String, head : String) -> Message?
        {
            var arr = head.split(separator: " ")
            print("ARR CUUNT = ",arr.count)
            
            var g_type : String?
            var g_id : String?
            var g_page : Int?
            var g_pages : Int?
            var g_messageid : String?
            var g_from : String?
            var g_to : String?
            
            if(arr.count == 8) //ali vsebuje dovolj parametrov
            {
                g_type = String(arr[0])
                g_id = String(arr[1])
                g_page = Int(arr[3])
                g_pages = Int(arr[4])
                g_messageid = String(arr[5])
                g_from = String(arr[6])
                g_to = String(arr[7])
            }
            //ali so parametri pravih tipov
            //page, int
            return nil
        }
    }
    
    struct MessageStack
    {
        var messages : [Message] = []
    }
    
    func addMessage(m : Message)
    {
        messageStack.messages.append(m)
    }
    
    override init()
    {
        super.init()
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval()
    {
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateCounting()
    {
        NSLog("counting..")
        send_loop()
        read_loop()
    }
    
    func read_loop()
    {
        print("READ LOOP local:", self.local_counter," remote:",self.remote_coutner)
        get_counter()
        if self.local_counter < self.remote_coutner
        {
            read_countent_H_for_counter(c : self.local_counter)
        }
        print("END READ LOOP")
    }
    
    func send_loop()
    {
        print("SEND LOOP")
        if messageStack.messages.isEmpty
        {
            
        }
        else
        {
            print("messages in stack", messageStack.messages.count)
            let el = messageStack.messages.popLast()
            if let safe_el = el
            {
                send(content: safe_el.countent, type: safe_el.type, page: safe_el.page, pages: safe_el.pages, messageid: safe_el.messageid, from:safe_el.from, to: safe_el.to)
                messageStack.messages.insert(Message.init(type: safe_el.type, countent: safe_el.countent, page: safe_el.page, pages: safe_el.pages, messageid: safe_el.messageid, from: safe_el.from, to: safe_el.to, status: Message.MessageStatus.sent), at: 0)
            }
            
            
        }
        print("END SEND LOOP")
    }
    
    func send(content : String, type : String, page : Int, pages : Int, messageid : String, from : String, to : String)
    {
        let url = URL(string: "https://www.kaotik.si/php_re/a.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "countent="+content+"&type="+type+"&page="+String(page)+"&pages="+String(pages)+"&messageid="+messageid+"&from="+from+"&to="+to
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    func get_counter()
    {
        if let url = URL(string: "https://www.kaotik.si/php_re/counter.txt")
        {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                if let safe_remove_c =  Int(contents)
                {
                    self.remote_coutner = safe_remove_c
                    if self.local_counter == -1
                    {
                        self.local_counter = (safe_remove_c - 1)
                    }
                    else if self.local_counter > self.remote_coutner
                    {
                        self.local_counter = (safe_remove_c - 1)
                    }
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
    func read_countent_H_for_counter(c : Int)
    {
        if let url = URL(string: "https://www.kaotik.si/php_re/DATA/"+String(c)+"_H.txt")
        {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                var body = read_countent_B_for_counter(c : self.local_counter)
                if let safe_body = body
                {
                     decode(body: safe_body, head: contents)
                }
               
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
    func read_countent_B_for_counter(c : Int) -> String?
    {
        if let url = URL(string: "https://www.kaotik.si/php_re/DATA/"+String(c)+"_B.txt")
        {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                self.local_counter += 1
                return contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        return nil
    }
    
    func decode(body : String, head : String)
    {
        print("decode start")
        Message.tryGenerateMessage(body: body, head: head)
        print("decude end")
    }
}


/*
 let request = NSURLRequest(url: URL.init(string: "https://www.kaotik.si/php_re/a.php")!)
 // Perform the request
 
 
 NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{
 (response: URLResponse?, data: Data?, error: Error?)-> Void in
 
 // Get data as string
 let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
 print(str)
 }
 );
 */
