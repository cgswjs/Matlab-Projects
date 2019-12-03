clear; close all; clc

BeamSelect = input(' 1: Hollow Aluminum \n 2: Solid Aluminum \n 3: Hollow Steel \n 4: Solid Steel \n ');

L = 3; % Length in meters
P = 1000; % Load in Newtons
EAl = 69*10^9; % Pa
ESt = 210*10^9; % Pa
GammaAl = 26487; % N/m^3
GammatSt = 75537; % N/m^3
g=9.81;

MaxAl = 551.5*10^6;
MaxSt = 75537*10^6;

CAl=1.43;%Aluminum price
CSt=1.21;%Steel price

Def = 10; Stress = 10^7; h = 0.005; dh = 0.001;%set up initial values

if BeamSelect == 1
    while Def > 0.10 || Stress > MaxAl/3
        [Def, Stress, Ctot] = HollowBeam(P, L, EAl, GammaAl, h, CAl, g);
        h = h + dh;
         
    end
elseif BeamSelect == 2
    while Def > 0.10 || Stress > MaxAl/3
        [Def, Stress, Ctot] = SolidBeam(P, L, EAl, GammaAl, h, CAl, g);
        h = h + dh;
    end
elseif BeamSelect == 3
    while Def > 0.10 || Stress > MaxSt/3
        [Def, Stress, Ctot] = HollowBeam(P, L, ESt, GammaSt, h, CSt, g);
        h = h + dh;
    end
elseif BeamSelect == 4
    while Def > 0.10 || Stress > MaxSt/3
        [Def, Stress, Ctot] = SolidBeam(P, L, ESt, GammaSt, h, CSt, g);
        h = h + dh;
    end
end
fprintf('Beam Height: %4.3f m \n Beam Stress: %6.3f Pa \n Beam Deflection: %4.3f m \n Beam Cost: %4.3f Dollars \n', h, Stress, Def,Ctot)