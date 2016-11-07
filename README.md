# Active Noise Cancellation Functions in Matlab and C
A bunch of functions implementing active noise cancellation using various LMS algorithms (FxLMS, FuLMS, NLMS) in Matlab and C.
Initially I wrote these for an [Audio Signal Processing](http://www.ece.rochester.edu/~zduan/teaching/ece472/index.html) class during my masters.

Functions include:
+ **LMS (Least Mean Squares):** most basic canonical ANC algo
  + [in C](https://github.com/markostam/active-noise-cancellation/blob/master/Code/adaptive_mss.c)
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/FxLMS_mss.m)
+ **FxLMS (Filtered eXtended Least Mean Squares):** adds an additional learned filter for the secondary path signal - signal from cancellation speakers to users ears - to account for phase problems and audio coloration added during practical noise cancellation applications
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/FxLMS_mss.m)
+ **NLMS (Normalized Least Mean Squares):** adds simple adaptively updated learning rate on top of LMS to speed convergence.
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/NLMS_mss.m)
+ FxNLMS (Normalized Filtered eXtended Least Mean Squares) - combines FxLMS and NLMS
+ **FuNLMS (Filtered-u Last Mean Squares):** adds an additional active LMS filter to FxNLMS to cancel out noise bleeding from the cancellation speaker to the error mic. Fairly robust but convergence not gaurunteed!
  + [in Matlab](https://github.com/markostam/active-noise-cancellation/blob/master/Code/FuNLMS_mss.m)

![cool viz](https://github.com/markostam/active-noise-cancellation/blob/master/images/Screenshot%202016-11-07%2015.30.06.png?raw=true)
