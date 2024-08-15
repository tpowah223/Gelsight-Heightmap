Gelsight Heightmap is a program based off of a repository that houses old Gelsight Matlab code used to create 3D reconstructions or plots 
from a series of 2D images that were taken from impressions of an object on an elastomer or a Gelsight sensor.

This is the repository that this is based on:
https://github.com/siyuandong16/gelsight_heightmap_reconstruction

There are two main scripts in this program: Calibration and Reconstruction. Everything else is just functions that were built to make it run.
Calibration deals with building the lookup table that is able to match the pixel intensity change to a gradient/normal that will then correspond to a height later on.
To run calibration, you should have a data set of atleast 10 pictures, not including the first picture in the set which should be frame0 or just a background image of the gel with nothing touching it.
The first/background picture should be named 'frame0' and everything else should be 'Im*'.

You will specify the folder name and parameters vital to the calibration. Stick with the default if you do not know how they will affect your output. Pixmm you will have to calculate everytime.
Once the calibration script is running you will have to encircle manually the calibration spheres that you pressed into the gel elastomer. 
Make sure to cover the entire visible area of image change around the circle.  
Use WASD to control the calibration circle and +- to control the size. 'R' will turn the picture to grayscale. 'C' will change the color of the calibration circle so you can see better.
Press 'esc' when you have encircled the entire area.

Once this is done for the entire sat you should get the output that calibration is 'in process' and then 'done'.

Now for Reconstruction, all you have to do is speciy the folder you want to take from and select the image in that folder that you would like to reconstruct. 
The only other step you have to apply is masking to the reconstruction image in question. 
