//------------------------------------------------------------------------
// name: drones.ck
// author: Doga Buse Cavdir
// desc: Drone sound engine, controlled by finger tip and accelerometer modules.
// date: 01.24.2020
//------------------------------------------------------------------------

//////////////////////////////////////////////////////////

Gain master;
0.8 => master.gain;
0.01 => float g_target;

// start the drones
spork ~startDrone();
//////////////////////////////////////////////////////////


0 => int device;
if( me.args() ) me.arg(0) => Std.atoi => device;
MidiIn min;
MidiMsg msg;
if( !min.open( device ) ) me.exit();
<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

/////////////////////////////////////////////////////////
// time
1000::ms => dur T;
T - (now % T) => now;
60 => float baseFreq;
0 => float lfo_freqDif;
0.05 => float gainDif;
//spork ~gainControl();


while (true){
    min => now;
    if( min.recv(msg) ){
        if(msg.data2 == 5) { // FSR - A6 - pin 12
           //Math.min((baseFreq - (msg.data3*30/210)),30) => baseFreq;
           ((baseFreq - (msg.data3*10/210))) => baseFreq;
           //<<<"data",msg.data3>>>;
           //<<<"base freq", baseFreq>>>;
        }
        if(msg.data2 == 3) { // FSR - A5 - pin 15
            //Math.max((baseFreq + (msg.data3*30/210)),120) => baseFreq;
            ((baseFreq + (msg.data3*10/210))) => baseFreq;
        }
        
        if (msg.data2 == 4) { // FSR - A4 - pin 8
            if (lfo_freqDif <= 10){
                msg.data3*10/100 => lfo_freqDif; // for max 10 Hz beating, dying off to 0
                <<<"lfo frequency difference", lfo_freqDif>>>;
            }
        }
        if (msg.data2 == 0){ // Acc Axis X
            //spork ~fadeOut(master);
            //<<< "Acc X",  msg.data3 >>>;
            
            if (msg.data3 >= 70 && msg.data3 < 126){
                <<< "spork fade out">>>;
                spork ~fadeOut(master);
            }
            
        }

    }
}


fun void LowFreq1 () {
    SinOsc osc => Gain g1 => master => dac;    
    
    SinOsc lfo=> blackhole;
    
    float Value;
    now => time d1t0;
    d1t0 + 60::second => time d1t1;
    while (now<d1t1)
    {
        baseFreq => osc.freq;
        0.45 - gainDif =>g1.gain;
        lfo.last() => Value;
        0.2 => lfo.freq;
        
        (Value + 1) / 2 => Value;
        
        Value => osc.gain;
        
        1::ms => now;
    }
}

//Shred Low1;

fun void LowFreq2 () {
    SinOsc osc => Gain g1 => master => dac;
    
    SinOsc lfo=> blackhole;
    
    float Value;
    now => time d2t0;
    d2t0 + 60::second => time d2t1;
    while (now<d2t1)
    {
        baseFreq => osc.freq;
        0.45 + gainDif=>g1.gain;
        0.2 + lfo_freqDif => lfo.freq;
        
        lfo.last() => Value;
        
        (Value + 1) / 2 => Value;
        
        Value => osc.gain;
        
        1::ms => now;
        //<<< freq", osc.freq()>>>;
    }
}

//Shred Low2;

fun void startDrone()
{
    now => time t0;
    t0 + 90::second => time t1;
    while(now<= t1)
    {
        spork ~LowFreq1();
        10::second=>now;
        spork ~LowFreq2();
        30::second=>now;
    }
}

/*
fun void fadeOut(Gain gain)
{
    // gain parameters;
    float g_target, g_inc;
    
    // spork gain stuff
    0.1 => g_target;
    .01 => float slew;
    now + 20::second => time then;
    while (now<then)
    {
        (g_target - g_inc) * slew + g_inc => g_inc => gain.gain;
        0.2 :: second => now;
    }
}
*/
fun void fadeOut( Gain gain)
{
    .009 => float slew;
    float g_inc;
    now + 25::second => time then;
    while (now<then)
    {
        //<<< "decreasing to", g_target>>>;
        gain.gain() - (g_inc) * slew => g_inc => gain.gain;
        0.02 :: second => now;
    }
}

fun void gainControl(){
    while (true){
        min => now;
        if( min.recv(msg) ){
            if (msg.data2 == 1){ // Acc Axis X
                //spork ~fadeOut(master);
                <<< msg.data3 >>>;
                
                if (msg.data3 >= 80){
                    <<< "spork fade out">>>;
                    spork ~fadeOut(master);
                }
                
            }
        }
    }
}
