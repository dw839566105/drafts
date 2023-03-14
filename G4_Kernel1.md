# GEANT4 Kernel1

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

## User classes
Five base classes with virtual methods the user may override to step during the execution of the application
- [G4UserRunAction](https://geant4.kek.jp/Reference/v11.1.0/classG4UserRunAction.html)
- [G4UserEventAction](https://geant4.kek.jp/Reference/v11.1.0/classG4UserEventAction.html)
- [G4UserTrackingAction](https://geant4.kek.jp/Reference/v11.1.0/classG4UserTrackingAction.html)
- [G4UserStackingAction](https://geant4.kek.jp/Reference/v11.1.0/classG4UserStackingAction.html)
- [G4UserSteppingAction](https://geant4.kek.jp/Reference/v11.1.0/classG4UserSteppingAction.html)

Default implementation (not purely virtual): Do nothing. Override only the methods you need.

### G4UserRunAction
```
virtual G4Run * GenerateRun ()
```
> This method is invoked at the beginning of BeamOn. Because the user can inherit the class G4Run and create own concrete class to store some information about the run, the GenerateRun() method is the place to instantiate such an object. e.g., instantiate user-customized run object.
```
virtual void BeginOfRunAction (const G4Run *aRun)
```
> This method is invoked before entering the event loop. This method is invoked after the calculation of the physics tables. e.g., define histograms.
```
virtual void EndOfRunAction (const G4Run *aRun)
```
> This method is invoked at the very end of the run processing. It is typically used for a simple analysis of the processed run. e.g., analyze the run and store histograms.
```
virtual void SetMaster (G4bool val=true)
```
```
G4bool IsMaster () const
```
### G4UserEventAction
```
virtual void 	SetEventManager (G4EventManager *value)
```

```
virtual void 	BeginOfEventAction (const G4Event *anEvent)
```
> This method is invoked before converting the primary particles to G4Track objects. A typical use of this method would be to initialize and/or book histograms for a particular event. e.g., event selection.
```
virtual void 	EndOfEventAction (const G4Event *anEvent)
```
> This method is invoked at the very end of event processing. It is typically used for a simple analysis of the processed event. e.g., output event information.

### G4UserStackingAction
```
void 	SetStackManager (G4StackManager *value)
```

```
virtual G4ClassificationOfNewTrack 	ClassifyNewTrack (const G4Track *aTrack)
```
is invoked by G4StackManager whenever a new G4Track object is "pushed" onto a stack by G4EventManager.  
`G4ClassificationOfNewTrack` has four possible values:
 - fUrgent - track is placed in the urgent stack
 - fWaiting - track is placed in the waiting stack, and will not be simulated until the urgent stack is empty
 - fPostpone - track is postponed to the next event
 - fKill - the track is deleted immediately and not stored in any stack.

These assignments may be made based on the origin of the track which is obtained as follows:
```G4int parent_ID = aTrack->get_parentID();```
where
```
parent_ID = 0 // indicates a primary particle
parent_ID > 0 // indicates a secondary particle
parent_ID < 0 // indicates postponed particle from previous event.
```

```
virtual void 	NewStage ()
```
is invoked when the *urgent* stack is empty and the *waiting* stack contains at least one `G4Track` object.
```
virtual void 	PrepareNewEvent ()
```
is invoked at the beginning of each event. At this point no primary particles have been converted to tracks, so the `urgent` and `waiting` stacks are empty.

### G4UserTrackingAction

```
virtual void 	SetTrackingManagerPointer (G4TrackingManager *pValue)
```
```
virtual void 	PreUserTrackingAction (const G4Track *)
```
Decide trajectory should be stored or not. Create user-defined trajectory
```
virtual void 	PostUserTrackingAction (const G4Track *)
```
Delete unnecessary trajectory. 

void UserSteppingAction(const G4Step*) 
Kill / the track 
 
### G4UserSteppingAction
```
virtual void 	SetSteppingManagerPointer (G4SteppingManager *pValue)
```

```
virtual void 	UserSteppingAction (const G4Step *)
```
Get information about particles; kill / suspend / postpone tracks under specific circumstances; Draw the step (for a track not to be stored as a trajectory)

User-customized `Trajectory` is not addressed here. 
