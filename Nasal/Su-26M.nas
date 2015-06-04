aircraft.livery.init("Aircraft/Su-26M/Models/Liveries");
#Canopy routines

toggle_canopy = func {
  if(getprop("/controls/canopy/canopy-pos-norm") > 0) {
    interpolate("/controls/canopy/canopy-pos-norm", 0, 2);
  } else {
    interpolate("/controls/canopy/canopy-pos-norm", 1, 2);
  }
}


toggle_vent = func {
  if(getprop("/controls/canopy/vent-flap-norm") > 0) {
    interpolate("/controls/canopy/vent-flap-norm", 0, 1);
  } else {
    interpolate("/controls/canopy/vent-flap-norm", 1, 1);
  }
}



#g-meter min/max needles

registerTimer = func {

    settimer(gmeterUpdate, 0.2);

}

flag = 0;
done = 0;
initialized = 0;

gmeterUpdate = func {

    GCurrent = props.globals.getNode("/fdm/jsbsim/accelerations/n-pilot-z-norm[0]").getValue();

    if(!initialized) { 
     props.globals.getNode("/fdm/jsbsim/accelerations/pilot-gmin[0]", -1).setDoubleValue(1);
     props.globals.getNode("/fdm/jsbsim/accelerations/pilot-gmax[0]", -1).setDoubleValue(1);
     props.globals.getNode("/fdm/jsbsim/accelerations/pilot-gmin[1]", -1).setDoubleValue(1);
     props.globals.getNode("/fdm/jsbsim/accelerations/pilot-gmax[1]", -1).setDoubleValue(1);
     initialized = 1;
     }

    GMin1 = props.globals.getNode("/fdm/jsbsim/accelerations/pilot-gmin[0]").getValue();
    GMax1 = props.globals.getNode("/fdm/jsbsim/accelerations/pilot-gmax[0]").getValue();
    GMin2 = props.globals.getNode("/fdm/jsbsim/accelerations/pilot-gmin[1]").getValue();
    GMax2 = props.globals.getNode("/fdm/jsbsim/accelerations/pilot-gmax[1]").getValue();


    if(GCurrent < 1 and GCurrent < GMin1){setprop("/fdm/jsbsim/accelerations/pilot-gmin[0]", GCurrent);}
    else {if(GCurrent > GMax1){setprop("/fdm/jsbsim/accelerations/pilot-gmax[0]", GCurrent);}}
    if(GCurrent < 1 and GCurrent < GMin2){setprop("/fdm/jsbsim/accelerations/pilot-gmin[1]", GCurrent);}
    else {if(GCurrent > GMax2){setprop("/fdm/jsbsim/accelerations/pilot-gmax[1]", GCurrent);}}
    
    registerTimer();

}


#fire up timers
registerTimer ();



#set controls
    setprop("/controls/browse-y", 0);
    setprop("/controls/browse-z", 0.5);
    
setprop("/engines/engine/fuel-flow-gph-ind", 0);
    
FP_set = func {
if(getprop("/controls/engines/engine/pump")==0)
{setprop("/engines/engine/fuel-flow-gph-ind",getprop("/engines/engine/fuel-flow-gph-ind")+ 20);}
else{ }
};
  
    
#magneto switch
    setprop("/controls/engines/engine/magneto1", 0);
    setprop("/controls/engines/engine/magneto2", 0);
    setprop("/controls/engines/engine/magnetos", 0);
    setprop("/controls/engines/engine/magneto-lock", 0);
    
magneto_switch = func {
if(getprop("/controls/engines/engine/magneto-lock")==0)
{setprop("/controls/engines/engine/magnetos", 0);}
else{setprop("/controls/engines/engine/magnetos", 
getprop("/controls/engines/engine/magneto1")+
2*getprop("/controls/engines/engine/magneto2"));}
};

#starter lock
   setprop("/controls/engines/engine/starter-lock", 0);
   
starter_lock = func
  {if(getprop("/controls/engines/engine/starter-lock")==0 )
  {setprop("/controls/engines/engine/starter", 0)}
  };
  
#radio com1 / chatter
   setprop("/instrumentation/comm/frequencies/select100", 9);  
   setprop("/instrumentation/comm/frequencies/select1", 20);
   setprop("/instrumentation/comm/frequencies/select2", 0);
   setprop("/instrumentation/comm/frequencies/selected-mhz", 127.500);
   setprop("/instrumentation/comm/volume-set", 0.6);    
   setprop("/instrumentation/comm/volume-lock", 0);    
   setprop("/instrumentation/comm/volume", 0);    
   setprop("/sim/sound/chatter/volume", 0);    

      
freq_set = func {setprop("/instrumentation/comm/frequencies/selected-mhz", 
                 getprop("/instrumentation/comm/frequencies/select100")+118+
                 0.025*getprop("/instrumentation/comm/frequencies/select1"))}; 
                 
vol_set = func {setprop("/instrumentation/comm/volume", 
                 getprop("/instrumentation/comm/volume-set")*getprop("/instrumentation/comm/volume-lock"))}; 

chvol_set = func {setprop("/sim/sound/chatter/volume", 
                 getprop("/instrumentation/comm/volume-set")*getprop("/instrumentation/comm/volume-lock"))}; 
                
                 
#chronometr start
    setprop("/sim/time/chronom-sec0", 0);

chron_start0 = func {setprop("/sim/time/chronom-sec0", getprop("/sim/time/elapsed-sec"))}; 

                 