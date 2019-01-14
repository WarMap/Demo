//
//  main.m
//  NSObject
//
//  Created by warmap on 2019/1/14.
//  Copyright © 2019 warmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <mach/mach.h>
#import <objc/runtime.h>
#import "MJClassInfo.h"

vm_size_t getUsedMemory() {
    task_basic_info_data_t info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO,
                                   (task_info_t) &info, &size);
    
    if(kerr == KERN_SUCCESS) {
        return info.resident_size;
    } else {
        return 0;
    }
}

vm_size_t getFreeMemory() {
    mach_port_t host = mach_host_self();
    mach_msg_type_number_t size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vmstat;
    
    host_page_size(host, &pagesize);
    host_statistics(host, HOST_VM_INFO, (host_info_t) &vmstat, &size);
    
    return vmstat.free_count * pagesize;
}

int main(int argc, char * argv[]) {
    
    //观察oc的类和元类
    NSObject *obj = [[NSObject alloc] init];
    mj_objc_class *cls = (__bridge mj_objc_class *)[obj class];
    mj_objc_class *meta = cls->metaClass();
    class_rw_t *rw = meta->data();
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
