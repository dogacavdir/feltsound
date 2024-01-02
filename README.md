# Felt Sound: Movement-based, ASL-inspired Digital Musical Instrument

This repository contains the audio (ChucK and FaucK), Arduino (for Teensy 3.5 or 3.6), and CAD code to recreate the Felt Sound digital musical instrument. While the sound design and its related audio code remain the same, the 3D design includes two versions of the interface. The first prototype captures the data using a set of Hall effect sensors and magnets embedded in the wearable modules; the second prototype captures the digital data from tactile buttons. The main controller code (see folder Arduino) is structured for version 2. The interface is designed modularly and modules can be worn in different combinations. 

## Supported Systems

### Software

- ChucK
- Faust in ChucK (FaucK)
- Teensyduino, add-on for Arduino IDE
- Solidworks 3D CAD
- Ultimaker CURA

### Electronics

- ADXl335 3-axis accelerometer
- Teensy 3.5
- Hall Effect sensor (non-latching)
- Force-sensitive resistors (FSR)

## Cited in:

Doga Cavdir. 2022. Touch, Listen, (Re)Act: Co-designing Vibrotactile Wearable Instruments for Deaf and Hard of Hearing. Proceedings of the International Conference on New Interfaces for Musical Expression. DOI: [10.21428/92fbeb44.b24043e8](10.21428/92fbeb44.b24043e8).

Doga Cavdir, and Ge Wang. 2020. Felt Sound: A Shared Musical Experience for the Deaf and Hard of Hearing. Proceedings of the International Conference on New Interfaces for Musical Expression. DOI: [10.5281/zenodo.4813305](10.5281/zenodo.4813305).

Doga Cavdir. 2020. Embedding electronics in additive manufacturing for digital musical instrument design. In Proceedings of the Sound and Music Computing Conferences. Zenodo. DOI: [10.5281/zenodo.3898705](https://doi.org/10.5281/zenodo.3898705).
