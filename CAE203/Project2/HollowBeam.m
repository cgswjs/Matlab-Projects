function [Deflection, Stress, Cost] = HollowBeam(P, L, E, Gamma, h, C, g)

b = 0.10; t = b/10;

Area = b*h - (b - 2*t)*(h - 2*t);

I = b*h.^3/12 - (b - 2*t)*(h - 2*t).^3/12;

q = Area*Gamma;

Deflection = P*L^3./(3*E*I) + q*L^4./(8*E*I);

MBend = P*L + 1/2*q*L^2;

Stress = MBend.*h./(2*I);

Cost = C*Area*Gamma*L/g;


