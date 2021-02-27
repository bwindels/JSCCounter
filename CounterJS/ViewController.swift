//
//  ViewController.swift
//  CounterJS
//
//  Created by Bruno on 06/06/2020.
//  Copyright © 2020 Bruno. All rights reserved.
//

import Cocoa
import JavaScriptCore

class ViewController: NSViewController {

    @objc dynamic var viewModel : ViewModel = ViewModel();
    @objc dynamic var counterText : String = "loading..."
    private var jsContext : JSContext? = nil;
    private var addFunction : JSValue? = nil;
    
    @IBAction func didClickButton(_ sender: Any) {
        addFunction?.call(withArguments: [1000]);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "counter", withExtension: "js")!
        let script = try? String(contentsOf: url);
        jsContext = JSContext.init();
        jsContext?.exceptionHandler = {(_, err: JSValue?) -> Void in
            print("error", err as Any);
        };
        jsContext?.setObject(TimerJS(), forKeyedSubscript: "timer" as (NSCopying & NSObjectProtocol));
        let callback: @convention(block) (JSValue) -> Void = { (counter) in
            self.viewModel.setValue(counter.toString(), forKey: "counter");
        };
        jsContext?.setObject(callback, forKeyedSubscript: "callback" as (NSCopying & NSObjectProtocol));
        jsContext?.evaluateScript(script);
        addFunction = jsContext?.objectForKeyedSubscript("add");
    }
}

/*
 Example of what a dynamic, reusable view model that is bindable from Cocoa could look like,
 might be a very crappy way of doing things...
 
 This way though, property names could come straight from javascript and we could
 have generic code to map javascript viewmodels to swift ones.
 */
class ViewModel : NSObject {
    public var values : [String: Any] = [:];
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.willChangeValue(forKey: key);
        //print("writing", key, value as Any);
        values[key] = value;
        super.didChangeValue(forKey: key);
    }
    
    override func value(forKey key: String) -> Any? {
        //print("reading", key, values[key] as Any);
        return values[key]
    }
}


