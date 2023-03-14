### GEANT4 Kernel

![image](https://user-images.githubusercontent.com/25675833/224873814-ad4f46ec-800b-4484-a28f-f52cf8742f9b.png)
![image](https://user-images.githubusercontent.com/25675833/224873630-fbe0876b-29b0-438d-a451-a00c4dfa1cbd.png)

GEANT4 does not provide `main()`
1. Initialization classes 
  - defined by `G4RunManager::SetUserInitiaIization()`.
  - Invoked at the initialization 
    + ***G4VUserDetectorConstruction*** 
    + ***G4VUserPhysicsList***
    + ***G4VUserActionlnitiaIization***  
2. Action classes 
  - Instantiate in your `G4VUserActionInitiaIization`. 
  - Invoked during an event loop 
    + ***G4VUserPrimaryGeneratorAction*** 
    + G4UserRunAction 
    + G4UserEventAction 
    + G4UserStackingAction 
    + G4UserTrackingAction 
    + G4UserSteppingAction  
Classes written in bold are mandatory. 

#### User classes
Five base classes with virtual methods the user may override to step during the execution of the application
- [G4UserRunAction](https://geant4.kek.jp/Reference/v11.1.0/classG4UserRunAction.html)
- [G4UserEventAction]
- G4UserTrackingAction
- G4UserStackingAction
- G4UserSteppingAction  
Default implementation (not purely virtual): Do nothing. Override only the methods you need.

###### G4UserRunAction
```
virtual G4Run * GenerateRun ()
```
This method is invoked at the beginning of BeamOn. Because the user can inherit the class G4Run and create his/her own concrete class to store some information about the run, the GenerateRun() method is the place to instantiate such an object  
e.g., instantiate user-customized run object.
```
virtual void BeginOfRunAction (const G4Run *aRun)
```
> This method is invoked before entering the event loop. This method is invoked after the calculation of the physics tables.  
> e.g., define histograms.
```
virtual void EndOfRunAction (const G4Run *aRun)
```
> This method is invoked at the very end of the run processing. It is typically used for a simple analysis of the processed run.  
> e.g., analyze the run and store histograms.
```
virtual void SetMaster (G4bool val=true)
```
```
G4bool IsMaster () const
```
###### G4UserEventAction


