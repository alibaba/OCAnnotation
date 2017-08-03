## Introduction
OCAnnotation is a light-weighted framework empowering the Objective-C language with the ability of annotation. As in Java, annotation is a form of syntactic metadata that can be added to the source code. It provides a handy way to apply certain behaviors to related program elements, such as class, methods, etc. By embedding this feature, we could make Objective-C a more flexible language, and bring our iOS development work more convenience and possibilities.

This framework is developed and maintained by the Ant Wealth software development team. It is already applied in our project in multiple modules, including but not limited to logging，network layer and data layer. We would like to share this exquisite tool with you, and be expectantly looking forward to you exploring its usage with all your imagination. 


## Feature
+ support annotations in all .h/.m files
+ support annotations added to @interface, @implementation, @property, method, etc.
+ support custom definition of annotation type
+ support custom definition of annotation key-values 

## Installation
1. Download the .gem and install it:
```
gem install ocannotation
```

2. Copy the config file (.oca.config) to your project's root path, modify your custom configuration as needed.
3. Under your project's directory, run the set-up command (we also provide command oca_clean, you could use it to reset your status):
```
oca_setup
```
If you run it successfully, you would get the result much like the following:
<div  align="center">    
<img src="https://gw.alipayobjects.com/zos/rmsportal/ewqZMSDrALbItySuRXGC.png" width = "800" align=center />
</div>

4. Add OCAnnotation in your Podfile:
```
pod 'OCAnnotation'
```
Well now you are all set to go~

## How to Use
#### Setup
Basically the mistery behind this tool is to scan all annotations in your project and do the modeling. Thus, at the launch time of your app, some setup work is required to be done. 
Here is an example code segment:
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    OCAAnnotationManager *annotationManager = [OCAAnnotationManager sharedManager];

    // custom annotation type registration (optional)
    [annotationManager registerAnnotationType:@"RemoteLog"
                                     position:OCAAnnotationPositionMethod
                                        class:[AFWRemoteLogMethodAnnotation class]];

    // annotation setup
    NSDictionary *configs = kAFWAnnotationConfigs; // using the macro name you write in the Annotation/.config file
    [[OCAAnnotationManager sharedManager] addConfigsWithConfigDic:configs];
}
```
Notice: After the scanning, the generated file (CustomFileName.gen.h) will be copied to your project path. You need to use 'Add file to...' to add file reference to your project so that you could access the generated macro successfully.

#### Custom Annotations
'Type' is a custom variable representing a certain type of group of annotations. Generally, a type is related to a specific use scenario. 
To make your own custom annotation type, you are required to create an annotation class for that type, and the class should be a subclass of OCABaseAnnotation. 
In OCAnnotation.framework，OCABaseAnnotation is the base annotation model class defining some basic behaviors. We also provide OCABaseClassAnnotation/OCABaseMethodAnnotation/OCABasePropertyAnnotation, which are base models for  annotations attached to class/method/property. You could inherit them as well.
As stated in the section above, you need to register your custom type at launch time:
```
// custom annotation type registration (optional)
[annotationManager registerAnnotationType:@"RemoteLog"
                                 position:OCAAnnotationPositionMethod
                                    class:[AFWRemoteLogMethodAnnotation class]];
```

In your subclass, you could do anything magic in the init method, with all the information in annotations packed in the variable 'params' for you. 
Quick example:
```
- (instancetype)initWithSourceFile:(NSString *)sourceFile
                         className:(NSString *)className
                            params:(NSDictionary *)params
                    methodSelector:(NSString *)methodSelector
                              type:(NSString *)type
{
    self = [super initWithSourceFile:sourceFile
                           className:className
                              params:params
                      methodSelector:methodSelector
                                type:type];
    if (self) {
        self.remoteLogId = self.parameters[@"remoteLogId"];
        self.remoteLogMethod = self.parameters[@"remoteLogMethod"];
        
        @weakify(self);
        self.onAnnotationCreated = ^(OCABaseAnnotation *anno){
            @strongify(self);
            [self registerRemoteLogAOP];
        };
        
    }
    return self;
}
```

#### Add Annotations
Above any program element, add your annotation in format “#pragma annotation(key:"value")”. 
For example, if you would like to add annotation on @interface UIApplicationDelegate (Different key-value pair can use comma/space as separator. Key and value can be related by colon or equals sign):
```
#pragma annotation(type:"default",param1:"value1",param2:"value2")
@interface UIApplicationDelegate()
```
That's it. You have successfully added an annotation to @interface UIApplicationDelegate.


## Demo
We provide a demo project named OCAnnotationDemo in which we show the basic usage of this tool. You are welcome to download and play with it. 

## To-do
+ SwiftAnnotation
