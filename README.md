m# G-Acc-PrinceFentekes
Assignment 3, Derek Prince &amp; Nick Fentekes

## Overview
Video: [Processing]()

For this project we used a micro:bit to take accelerometer data and control direction and acceleration through impulse. This was done in processing with a small object en lieu of an actual car or vehicle for demonstration purposes.

## Tools and Hardware
We used [Processing](https://processing.org/), Wekinator, and a [Micro:bit](http://microbit.org/) to complete the project.

## Features
We tracked the 3 accelerometer values from the Micro:bit to give us pitch and roll in 3D space, and taking the time domain to be implicit with the stream of data.

As inputs, we used the first input to be the roll value and output the value normalized between -1 and 1 to change direction. The second input was just a yes/no detection to determine if the micro:bit was suitably stable in the center to avoid the feeling of constantly balancing the thing to go straight. The 3rd and final input was the pitch, handled the same way as roll but used to increase or decrease the speed.

## Training Algorithm
For the first and third inputs (direction change and speed increase/decrease respectively), we used a first-order linear regression for smooth control of the inputs and outputs. The values were mapped from -1 to 1 in the program in order to act as an increment/decrement to an angle variable and the input velocity.
I think it could have been valuable to use a NN training algorithm to take advantage of the sigmoid function shape being largely linear in the center and changing rapidly before flattening out on the ends. This would be because people rarely make extreme turning or acceleration (maybe less so on the latter...) movements while driving and it could be thought of as an "emergency" movement that requires large amounts of change quickly.

The last input (2) was a simple classifier to check if the changing values of the accelerometers should be interpreted as a movement or jitter/noise.

## Going Further
I think it would have been nice to include another micro:bit to split up direction and speed controls into something more fluid.
In addition to this, adding a sharp-movement-detector to safely half the vehicle could be a safer way to stop in emergencies than the method we have developed.
