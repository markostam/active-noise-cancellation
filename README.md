# Active Noise Cancellation Functions in Matlab and C
A bunch of functions implementing active noise cancellation using various LMS algorithms (FxLMS, FuLMS, NLMS) in Matlab and C.
I wrote these as part of my final project for an [Audio Signal Processing](http://www.ece.rochester.edu/~zduan/teaching/ece472/index.html) class during my masters.

I've also included [a short & not very serious powerpoint](https://github.com/markostam/active-noise-cancellation/blob/master/noise_cancellation_recurse2.pptx) of a 5 minute lightning talk I gave on the project later at the [Recurse Center](https://recurse.com). 

Here's a [slightly more serious paper](http://www.ece.rochester.edu/~zduan/teaching/ece472/projects/2016/Stamenovic_paper.pdf) I wrote about some of my experiments with ANC and this code.

# Functions:
+ **LMS (Least Mean Squares):** most basic canonical ANC algo
  + [in C](https://github.com/markostam/active-noise-cancellation/blob/master/Code/adaptive_mss.c)
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/FxLMS_mss.m)
+ **FxLMS (Filtered eXtended Least Mean Squares):** adds an additional learned filter for the secondary path signal - signal from cancellation speakers to users ears - to account for phase problems and audio coloration added during practical noise cancellation applications
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/FxLMS_mss.m)
+ **NLMS (Normalized Least Mean Squares):** adds simple adaptively updated learning rate on top of LMS to speed convergence.
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/NLMS_mss.m)
+ **FxNLMS (Normalized Filtered eXtended Least Mean Squares):** combines FxLMS and NLMS
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/FxNLMS_mss.m)
+ **FuNLMS (Filtered-u Last Mean Squares):** adds an additional active LMS filter to FxNLMS to cancel out noise bleeding from the cancellation speaker to the error mic. Fairly robust but convergence not gaurunteed!
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/FuNLMS_mss.m)

![cool viz](https://github.com/markostam/active-noise-cancellation/blob/master/images/Screenshot%202016-11-07%2015.30.06.png?raw=true)
