//------------------------------------------------------------------------
// name: main.ck
// author: Doga Buse Cavdir
// desc: Main control algorithm for sound engines. 
// date: 01.24.2020
// edit: 01.02.2024
//------------------------------------------------------------------------

///
false => int mode01; // only wobble
false => int mode02; // only drones
false => int mode03; // both mode
false => int mode04; // clear everything mode

false => int hes1IsPressed;
false => int hes2IsPressed;
false => int hes3IsPressed;

0 => int wobblemainID;
0 => int wobbleID;
0 => int droneID;

// Midi device decleration
0 => int device;
if( me.args() ) me.arg(0) => Std.atoi => device;
MidiIn min;
MidiMsg msg;
if( !min.open( device ) ) me.exit();
<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

while(true){
    min => now;
    if( min.recv(msg) ){
        if(msg.data2 == 7){ // A13 hes activated 
            if (msg.data3 == 127){
                !hes1IsPressed => hes1IsPressed;
                <<< "hes1", hes1IsPressed, "hes2", hes2IsPressed, "hes3", hes3IsPressed >>>;
            }
        }
        if(msg.data2 == 8){ // A14 hes activated 
            if (msg.data3 == 127){
                !hes2IsPressed => hes2IsPressed;
                <<< "hes1", hes1IsPressed, "hes2", hes2IsPressed, "hes3", hes3IsPressed >>>;
            }
        }
        if(msg.data2 == 9){ // A9 hes activated 
            if (msg.data3 == 127){
                !hes3IsPressed => hes3IsPressed;
                //<<< hes3IsPressed >>>;
                <<< "hes1", hes1IsPressed, "hes2", hes2IsPressed, "hes3", hes3IsPressed >>>;
                
            }        
        }
        
        if (!hes3IsPressed){ // cancel mode -mode04- is off
            false => mode04;
            
            if (!hes2IsPressed){
                if (hes1IsPressed && !mode01){
                    true => mode01;
                    false => mode04;
                    <<< "wobble is on", mode01, "drone is off", mode02 >>>;
                    //if (!wobbleID) 
                    Machine.add(me.sourceDir()+"wobble.ck") => wobbleID;
                    //if (!wobblemainID) 
                    Machine.add(me.sourceDir()+"wobble_main.ck") => wobblemainID;
                    Machine.remove(droneID);
                    0 => droneID;
                }
                if (!hes1IsPressed && mode01){
                    false => mode01;
                    <<< "wobble is off", mode01, "drone is off", mode02 >>>;
                    Machine.remove(wobblemainID);
                    Machine.remove(wobbleID);
                    0 => wobblemainID;
                    0 => wobbleID;
                }
            }
            if (!hes1IsPressed) {
                if (hes2IsPressed && !mode02){
                    true => mode02;
                    false => mode04;
                    <<< "wobble is off", mode01, "drone is on", mode02 >>>;
                    if (!droneID) Machine.add(me.sourceDir()+"drones.ck") => droneID;
                    Machine.remove(wobblemainID);
                    Machine.remove(wobbleID);
                    0 => wobblemainID;
                    0 => wobbleID;
                }
                if (!hes2IsPressed && mode02){
                    false => mode02;
                    <<< "wobble is off", mode01, "drone is off", mode02 >>>;
                    Machine.remove(droneID);
                    0 => droneID;
                }
            }
            
            if (hes1IsPressed && hes2IsPressed && !mode03){ // both mode is on
                true => mode03;
                false => mode01;
                false => mode02; 
                false => mode04;
                //false => mode02;
                <<< "wobble is on", mode01, "drone is on", mode02, "both", mode03 >>>;
                Machine.remove(wobblemainID);
                Machine.remove(wobbleID);
                Machine.remove(droneID);
                Machine.add(me.sourceDir()+"drones.ck") => droneID;
                Machine.add(me.sourceDir()+"wobble.ck") => wobbleID;
                Machine.add(me.sourceDir()+"wobble_main.ck") => wobblemainID;
            }
        }
        else if (hes3IsPressed && !mode04){
            true => mode04;
            false => mode01;
            false => mode02;
            false => mode03;
            false => hes1IsPressed;
            false => hes2IsPressed;
            false => hes3IsPressed;
            <<< "kill all", mode04, "hes3", hes3IsPressed >>>;
            // need to create a fade off
            Machine.remove(wobblemainID);
            Machine.remove(wobbleID);
            Machine.remove(droneID);
            0 => wobblemainID;
            0 => wobbleID;
            0 => droneID;
        }
        
    }
}
