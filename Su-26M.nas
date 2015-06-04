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

