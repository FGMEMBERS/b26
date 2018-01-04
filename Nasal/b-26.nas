var sin = func(a) { math.sin(a * math.pi / 180.0) }
var cos = func(a) { math.cos(a * math.pi / 180.0) }
var blower0 = props.globals.getNode("controls/engines/engine[0]/boost");
var blower1 = props.globals.getNode("controls/engines/engine[1]/boost");

init = func {
  setprop ("/autopilot/locks/heading" , "none" );
  setprop ("/autopilot/locks/altitude" , "none" );

  if (getprop("/controls/engines/engine[0]/on-startup-running") == 1) {
    setprop("/consumables/fuel/tank[1]/selected",1);
    setprop("/controls/engines/engine[0]/magnetos",3);
    setprop("/controls/engines/engine[0]/coolflap-auto",1);
#    setprop("/controls/engines/engine[0]/radlever",1);
    setprop("/engines/engine[0]/oil-visc",1);
    setprop("/engines/engine[0]/rpm",800);
    setprop("/engines/engine[0]/engine-running",1);
	}
  if (getprop("/controls/engines/engine[1]/on-startup-running") == 1) {
    setprop("/consumables/fuel/tank[3]/selected",1);
    setprop("/controls/engines/engine[1]/magnetos",3);
    setprop("/controls/engines/engine[1]/coolflap-auto",1);
#    setprop("/controls/engines/engine[1]/radlever",1);
    setprop("/engines/engine[1]/oil-visc",1);
    setprop("/engines/engine[1]/rpm",800);
    setprop("/engines/engine[1]/engine-running",1);
	}
 main_loop();
}
setlistener("/controls/fuel/switch-position-port", func (n) {
	position=n.getValue();
    setprop("/consumables/fuel/tank[0]/selected",0);
    setprop("/consumables/fuel/tank[1]/selected",0);
    if(position >= 0.0){
		setprop("/consumables/fuel/tank[" ~ position ~ "]/selected",1);
		setprop("/engines/engine[0]/out-of-fuel",0);
        };    
    },1);
setlistener("/controls/fuel/switch-position-starb", func (n) {
	position=n.getValue();
    setprop("/consumables/fuel/tank[2]/selected",0);
    setprop("/consumables/fuel/tank[3]/selected",0);
    if(position >= 2.0){
		setprop("/consumables/fuel/tank[" ~ position ~ "]/selected",1);
		setprop("/engines/engine[0]/out-of-fuel",0);
        };    
    },1);


var reardoorL = aircraft.door.new ("/controls/doors/reardoor.L/",4);




var fuel_jettison = func(side) {
  remaining_inner = getprop("consumables/fuel/tank["~side~"]/level-gal_us");
  remaining_outer = getprop("consumables/fuel/tank["~(side+1)~"]/level-gal_us");
  interpolate("consumables/fuel/tank["~side~"]/level-gal_us", (remaining_inner-20),5);
  interpolate("consumables/fuel/tank["~(side+1)~"]/level-gal_us", (remaining_outer-15),5);
}

var shift_blower0_up = func {
	if (blower0.getValue() <= 0.46){
		interpolate("controls/engines/engine[0]/boost", 1, 30);
	}
}
var shift_blower0_dn = func {
	if (blower0.getValue() >= 1.0){
		interpolate("controls/engines/engine[0]/boost", 0.46, 30);
	}
}
var shift_blower1_up = func {
	if (blower0.getValue() <= 0.46){
		interpolate("controls/engines/engine[1]/boost", 1, 30);
	}
}
var shift_blower1_dn = func {
	if (blower0.getValue() >= 1.0){
		interpolate("controls/engines/engine[1]/boost", 0.46, 30);
	}
}

var flash_trigger = props.globals.getNode("controls/armament/trigger", 0);
aircraft.light.new("sim/model/beaufighter/lighting/flash-lu", [0.05, 0.052], flash_trigger);
aircraft.light.new("sim/model/beaufighter/lighting/flash-ld", [0.052, 0.05], flash_trigger);
aircraft.light.new("sim/model/beaufighter/lighting/flash-ru", [0.051, 0.051], flash_trigger);
aircraft.light.new("sim/model/beaufighter/lighting/flash-rd", [0.0505, 0.0505], flash_trigger);

var bombbay = aircraft.door.new ("/controls/armament/bombbay/",5);

# setlistener("/sim/signals/fdm-initialized",init);

aircraft.livery.init("Aircraft/b26/Models/Liveries", "sim/model/livery/name");
