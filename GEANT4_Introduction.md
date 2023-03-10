### GEANT4 Basic Concepts and Kernel Structure

Reference is [here](https://www.slac.stanford.edu/xorg/geant4/SLACTutorial14/Kernel1.pdf), the detailed development history and the application can be also found.

Terminology (jargons)
+ Run, event, track, step, step point
+ Track fg trajectory, step fg trajectory point
+ Process
  + At rest, along step, post step
+ Cut = production threshold
+ Sensitive detector, score, hit, hits collection,


### Run
Run in Geant4
+ As an analogy of the real experiment, a run of Geant4 starts with `Beam On`.
+ Within a run, the user **cannot** change
  + detector setup
  + settings of physics processes
+ Conceptually, a run is a collection of events which share the same detector and physics conditions.
  + **A run consists of one event loop**.
+ At the beginning of a run, geometry is optimized for navigation and crosssection tables are calculated according to materials appear in the geometry and the cut-off values defined.
+ `G4RunManager` class manages processing a run, a run is represented by `G4Run` class or a user-defined class derived from `G4Run`.
  + A run class may have a summary results of the run.
+ `G4UserRunAction` is the optional user hook.

### Event
+ An event is the basic unit of simulation in Geant4.
+ At beginning of processing, primary tracks are generated. These primary tracks are pushed into a stack.
+ A track is popped up from the stack one by one and “tracked”. Resulting secondary tracks are pushed into the stack.
  + This “tracking” lasts as long as the stack has a track.
+ When the stack becomes empty, processing of one event is over.
+ `G4Event` class represents an event. It has following objects at the end of its (successful) processing.
  + List of primary vertices and particles (as **input**)
  + Hits and Trajectory collections (as **output**)
+ `G4EventManager` class manages processing an event. G4UserEventAction is the optional user hook. 

### Track
+ Track is a snapshot of a particle.
  + It has physical quantities of current instance only. It does not record previous quantities.
  + Step is a “delta” information to a track. **Track is not a collection of steps. Instead, a track is being updated by steps**.
+ Track object is ***deleted*** when
  + it goes out of the world volume,
  + it disappears (by e.g. decay, inelastic scattering),
  + it goes down to zero kinetic energy and no *AtRest* additional process is required, or
  + the user decides to kill it artificially.
+ No track object persists at the end of event.
  + For the record of tracks, use trajectory class objects.
+ G4TrackingManager manages processing a track, a track is represented by G4Track class.
+ `G4UserTrackingAction` is the optional user hook. 

### Step
+ Step has two points and also delta information of a particle (energy loss on the step, time-of-flight spent by the step, etc.).
+ Each point knows the volume (and material). In case a step is limited by a volume boundary, the end point physically stands on the boundary, and it logically belongs to the next volume.
  + Because one step knows materials of two volumes, boundary processes
such as transition radiation or refraction could be simulated.
+ `G4SteppingManager` class manages processing a step, a step is represented by `G4Step` class.
+ `G4UserSteppingAction` is the optional user hook.

<!--
<p style="text-align: center;">
  <img src="https://user-images.githubusercontent.com/25675833/224241635-f4ab158f-09f7-4873-b6b6-2b60e6afcb27.png" width = "400" height = "200" alt="Step" align=center />
</p>
-->
 
![image](https://user-images.githubusercontent.com/25675833/224241635-f4ab158f-09f7-4873-b6b6-2b60e6afcb27.png#pic_center)

### Trajectory and trajectory point
+ Track does not keep its trace. No track object persists at the end of event.
+ `G4Trajectory` is the class which copies some of `G4Track` information. `G4TrajectoryPoint` is the class which copies some of `G4Step` information.
  + `G4Trajectory` has a vector of `G4TrajectoryPoint`.
  + At the end of event processing, `G4Event` has a collection of `G4Trajectory` objects.
    + ***/tracking/storeTrajectory must be set to 1***.
+ Keep in mind the distinction.
  + G4Track <--> G4Trajectory, G4Step <--> G4TrajectoryPoint
+ Given G4Trajectory and G4TrajectoryPoint objects persist till the end of an event, you should be careful not to store too many trajectories.
  + E.g. avoid for high energy EM shower tracks.
+ `G4Trajectory` and `G4TrajectoryPoint` store only the minimum information.
  + You can create your own trajectory / trajectory point classes to store information you need. `G4VTrajectory` and `G4VTrajectoryPoint` are base classes. 

### Particle
+ A particle in Geant4 is represented by three layers of classes.
1. G4Track
>  + Position, geometrical information, etc.
>  + This is a class representing a particle to be tracked.
2. G4DynamicParticle
>  + "Dynamic" physical properties of a particle, such as momentum, energy, spin, etc.
>  + Each G4Track object has its own and unique G4DynamicParticle object.
>  + This is a class representing an individual particle.
3. G4ParticleDefinition
>  + "Static" properties of a particle, such as charge, mass, life time, decay channels, etc.
>  + G4ProcessManager which describes processes involving to the particle.
>  + All G4DynamicParticle objects of *same kind* of particle share the *same G4ParticleDefinition*. 

### Tracking and processes 
Geant4 tracking is general. 
  + It is independent to 
    + the particle type 
    + the physics processes involving to a particle
  + It gives the chance to all processes 
    + To contribute to determining the step length 
    + To contribute any possible changes in physical quantities of the track 
    + To generate secondary particles 
    + To suggest changes in the state of the track, e.g. to suspend, postpone or kill it. 

### Processes
+ In Geant4, particle transportation is a process as well, by which a particle interacts with geometrical volume boundaries and field of any kind. 
  + Because	of this, shower parameterization process can take over from the ordinary transportation without modifying the transportation process. 
+ Each particle has its own list of applicable processes. At each step, all processes listed are invoked to get proposed physical interaction lengths. 
+ The process which requires the shortest interaction length (in space-time) limits the step.	 
+ Each process has one or combination of the following natures.	
  + AtRest, e.g. muon ecay at rest 	
  + AlongStep (a.k.a. conAnuous process), e.g. Celenkov process	
  + PostStep (a.k.a. discrete process), e.g. decay on the fly

### Cuts
+ A Cut in Geant4 is a production threshold.
  + Not tracking cut, which does not exist in Geant4 as default.
    + All tracks are traced down to zero kinetic energy.
  + It is applied only for physics processes that have infrared divergence
+ Much detail will be given at later talks on physics. 

### Track status
+ At the end of each step, according to the processes involved, the state of a track
may be changed.
  + The user can also change the status in UserSteppingAction.
  + Statuses shown in bold are artificial, i.e. Geant4 kernel won’t set them, but the user can set.
+ `fAlive`
  + Continue the tracking.
+ `fStopButAlive`
  + The track has come to zero kinetic energy, but still AtRest process to occur.
+ `fStopAndKill`
  + The track has lost its identity because it has decayed, interacted or gone beyond the world boundary.
  + Secondaries will be pushed to the stack.
+ **`fKillTrackAndSecondaries`**
  + Kill the current track and also associated secondaries.
+ **`fSuspend`**
  + Suspend processing of the current track and push it and its secondaries to the stack.
• **`fPostponeToNextEvent`**
  + Postpone processing of the current track to the next event.
  + Secondaries are still being processed within the current event. 
