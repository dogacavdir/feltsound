//------------------------------------------------------------------------
// name: wobble.ck
// author: Doga Buse Cavdir
// desc: Wobble sound engine, activates "wobble" effect with x axis accelerometer data change.  
// edit: 01.02.2024
// date: 01.24.2020
//------------------------------------------------------------------------

false => int button2IsPressed;
false => int button3IsPressed;
70 => int thresholdHigh;
65 => int thresholdLow;
false => int wobbleActive;

0 => float currMessage;

0 => int device;
if( me.args() ) me.arg(0) => Std.atoi => device;
MidiIn min;
MidiMsg msg;
if( !min.open( device ) ) me.exit();
<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

fun void wobble(){
    Gain gain;
    SinOsc s => gain => Faust distortion => dac;
    distortion.eval(`
    process = dm.cubicnl_demo;
    `);
    50 => s.freq;
    1 => float x;
    1 => gain.gain;
    false => int decay;
    while (x < 300) {
        //1 => gain.gain;
        //Math.sin(x) => gain.gain;
        //Math.fabs(Math.sin(x)/(x+10))*20 => gain.gain;
        //Math.max(0, Math.min(1, gain.gain()))*2 => gain.gain;
        if(x > 240) {
            true => decay;
            Math.fabs(Math.sin(x)/(x*1.2))*20 => gain.gain;
        }
        else { 
            Math.fabs(Math.sin(x)/(x+10))*20 => gain.gain;
            Math.max(0, Math.min(1, gain.gain()))*2 => gain.gain;
        }
        //<<< gain.gain() >>>;
        x+0.8 => x;
        //v = set value
        //you can use the complete path or a parameter
        10::ms => now;
    }
}


while (true) {
    min => now;
    //fck.v("/chuck/freq",100);
    if( min.recv(msg) ){
        if(msg.data2 == 0){ //x
            msg.data3 => currMessage;
        }
        //<<< wobbleActive >>>;
        if(msg.data2 == 4){ //button1
            (msg.data3 > 20) => button2IsPressed;
        }
        if(msg.data2 == 5){ //button1
            (msg.data3 > 20) => button3IsPressed;
            //<<<button3IsPressed>>>;
        }
        if(button2IsPressed && !button3IsPressed){
            <<<button3IsPressed>>>;
            <<<button2IsPressed>>>;
            if(currMessage >= thresholdHigh && wobbleActive) {
                //<<< wobbleActive >>>;
                spork ~ wobble();
                false => wobbleActive;   
            }
            else if(currMessage <= thresholdLow  && !wobbleActive) {
                true => wobbleActive;
            }
        }
    }
    //v = set value
    //you can use the complete path or a parameter
}