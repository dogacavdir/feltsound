//------------------------------------------------------------------------
// name: wobble_main.ck
// author: Doga Buse Cavdir
// desc: Wobble effect sound engine. Data processing for the wobble effects. 
// edit: 01.02.2024
// date: 01.24.2020
//------------------------------------------------------------------------
// beating A4, drop A5 and acc, change pitch A6

.9999 => float filter_pole;
25 => float volume;
1 => float level;
OnePole pole;
LPF lpf;
Impulse imp;
Gain gain;

0 => float move;
0 => float offset;
8 => float maxGain;
3 => float increaseRate;

50 => float lastAccVal;

false => int button1IsPressed;
false => int button2IsPressed;
false => int button3IsPressed;

80 => float freq;

SinOsc s => gain => Faust distortion => dac;
//pipe to all 8 channels, set gain

distortion.eval(` 
process = dm.cubicnl_demo;
`);

//<<< distortion.dump() >>>;

imp => lpf => pole => gain;
3 => gain.op;
volume => gain.gain;
filter_pole => pole.pole;
10 => lpf.freq;

freq => s.freq;


0 => int device;
if( me.args() ) me.arg(0) => Std.atoi => device;
MidiIn min;
MidiMsg msg;
if( !min.open( device ) ) me.exit();
<<< "MIDI device:", min.num(), " -> ", min.name() >>>;


while (true) {
    min => now;
    if( min.recv(msg) ){
        if(msg.data2 == 1){ //x
            //<<< Math.fabs(msg.data3 - lastAccVal) >>>;
            if(Math.fabs(msg.data3 - lastAccVal) > 20) {
                -6 => move;
            }
            else if(Math.fabs(msg.data3 - lastAccVal) > 3) {
                move - Math.fabs(msg.data3 - lastAccVal) => move;
            }
            else {
                Math.min(move + increaseRate, maxGain) => move;
            }
            
            //Math.max(0, 8-(Math.fabs(msg.data3 - lastAccVal))) => float dx;
            //5 => float dx;
            if(button2IsPressed) {
                0 => move;
            }
            //if(dx != 0){
            Math.max(0, move) => imp.next;
            //}
            //<<< msg.data3  >>>;
            if (button3IsPressed) {
                s.freq() + (msg.data3 - lastAccVal)/2.0 => freq;
                Math.max(45, Math.min(95, freq)) => freq;
                freq => s.freq;
                <<< freq >>>;
            }
            msg.data3 => lastAccVal;
            //<<< move >>>;
        }
        if(msg.data2 == 5){ //button1
            (msg.data3 > 20) => button1IsPressed;
            if (button1IsPressed) {
                ((lastAccVal - 54.0) / (75.0 - 54.0))*(95 - 45) + 45 => freq;
                Math.max(45, Math.min(95, freq)) => freq;
                freq => s.freq;
                <<< freq >>>;
            }
        }
        if(msg.data2 == 4){ //button2
            (msg.data3 > 20) => button2IsPressed;
        }
        if(msg.data2 == 3){ //button3
            if (msg.data3 > 20) {
                true => button3IsPressed;
                256 => maxGain;
            } else {
                64 => maxGain;
            }
            
        }
        <<< gain >>>;
    }
}