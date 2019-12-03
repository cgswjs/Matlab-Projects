clear variables; close all; clc;

Time = (linspace(0, 1750, 3000))';

c2 = 23; r = 0.002; c1 = 0;

Eps = log(c2*tan(r*Time/2 - c1));

plot(Time, Eps)