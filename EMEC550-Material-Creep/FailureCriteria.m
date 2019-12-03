%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables; close all; clc
% Stress Matrix (MPa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SYield = input('Enter Yield Stress of Material in MPa: \n');

Sxx = 100; Sxy = 50; Sxz = 0; 
Syy = -14; Syz = 0;
Szz = 0;
MStress = [Sxx Sxy Sxz; Sxy Syy Syz; Sxz Syz Szz];

SPrinYo = eigs(MStress); SPrin = sort(SPrinYo);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum Principle Stress BRITTLE MATERIALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SMax = max(abs(SPrin));

if SMax < SYield
    fprintf('Maximum Principle Stress Okay \n')
    FofS = SYield/SMax;
    fprintf('Factor of Safety: %9.8f \n', FofS)
else
    fprintf('Maximum Principle Stress Exceeds Yield Stress \n')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum Principle Strain BRITTLE MATERIALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E = input('Enter Elastic Modulus in Units Consistent with Yield Stress \n');
nu = input('Enter Poisson''s Ratio \n');

Eps = 1/E*(SPrin(3) - nu*SPrin(2) - nu*SPrin(1)); % Strain

% Yield strain of the material
EpsY = SYield/E;

if abs(Eps) < EpsY
    fprintf('Maximum Principle Strain Okay \n')
    FofSEps = EpsY/abs(Eps);
    fprintf('Factor of Safety: %9.8f \n', FofSEps)
else
    fprintf('Maximum Principle Strain Exceeds Yield Strain \n')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot yield surface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
enYa = 250;

StressX = linspace(-SYield, SYield, enYa); 
StressY = linspace(-SYield, SYield, enYa); 
StressZ = linspace(-SYield, SYield, enYa); 

OneFish = zeros(1, enYa);
ShiftX1 = zeros(1, enYa) - SYield; ShiftX2 = zeros(1, enYa) + SYield;
ShiftX3 = ShiftX1; ShiftX4 = ShiftX2;

plot3(StressX, ShiftX1, ShiftX1); hold on
plot3(StressX, ShiftX1, ShiftX2);
plot3(StressX, ShiftX2, ShiftX1);
plot3(StressX, ShiftX2, ShiftX2);

plot3(ShiftX1, StressY, ShiftX1);
plot3(ShiftX1, StressY, ShiftX2);
plot3(ShiftX2, StressY, ShiftX1);
plot3(ShiftX2, StressY, ShiftX2);

plot3(ShiftX1, ShiftX1, StressZ);
plot3(ShiftX1, ShiftX2, StressZ);
plot3(ShiftX2, ShiftX1, StressZ);
plot3(ShiftX2, ShiftX2, StressZ); 

if abs(Eps) < EpsY
    plot3(SPrin(1), SPrin(2), SPrin(3), 'g.', 'MarkerSize', 25);
else
    plot3(SPrin(1), SPrin(2), SPrin(3), 'rx', 'MarkerSize', 25);
end

hold off

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Strain Energy Density
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Uo = 1/(2*E)*(SPrin(3)^2 + SPrin(2)^2 + SPrin(1)^2 -2*nu*...
    (SPrin(3)*SPrin(2) + SPrin(3)*SPrin(1) + SPrin(1)*SPrin(2)));

Uyield = SYield^2/(2*E);

if Uo < Uyield
    fprintf('Strain Energy Density Okay \n')
    FofSEnergy = Uyield/Uo;
    fprintf('Factor of Safety: %9.8f \n', FofSEnergy)
else
    fprintf('Maximum Energy Density Exceeds Yield Energy \n')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum shear stress
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ShearMax = (SPrin(3) - SPrin(1))/2;
ShearYield = SYield/2;

if ShearMax < ShearYield
    fprintf('Shear Stress Okay \n')
    FofSShear = ShearYield/ShearMax;
    fprintf('Factor of Safety: %9.8f \n', FofSShear)
else
    fprintf('Material fails maximum shear criterion \n')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Distortional Energy Density: Von Mises Criterion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G = E/(2 + 2*nu);

Uod = ((SPrin(3) - SPrin(2))^2 + (SPrin(1) - SPrin(2))^2 + ...
    (SPrin(3) - SPrin(1))^2)/(12*G);

UoY = SYield^2/(6*G);

if Uod < UoY
    fprintf('Von Mises Okay \n')
    FofSVM = UoY/Uod;
    fprintf('Factor of Safety: %9.8f \n', FofSVM)
else
    fprintf('Material fails Von Mises criterion \n')
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deviatoric Stress
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SDev1 = SPrin(1) - mean(SPrin); SDev2 = SPrin(2) - mean(SPrin);
SDev3 = SPrin(3) - mean(SPrin);

SDev = sqrt(SDev1^2 + SDev2^2 + SDev3^2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Brittle Fracture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Is there concern with Brittle Fracture \n')
BritFrac = input('Yes: Enter 1 \nNo: Enter 2 \n');

if BritFrac == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     Sxx = 100; Sxy = 50; Sxz = 0;
%     Syy = -14; Syz = 0;
%     Szz = 0;
%     MStress = [Sxx Sxy Sxz; Sxy Syy Syz; Sxz Syz Szz];
% 
%     SPrinYo = eigs(MStress); SPrin = sort(SPrinYo);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    fprintf('What do you seek, Barbarian? \n')
    Seeking = input('KIc: 1 \nCritical Stress: 2 \nCrack Length: 3 \n');
    if Seeking == 1
        
        % Determine K one C value
        Beta = input('Enter shape factor from a table: \n');
        StressCrit = max([SPrin(1) SPrin(2) SPrin(3)]);
        a = input('Enter crack size in meters: \n');
        
        KIc = Beta*StressCrit*sqrt(pi*a);
        
        fprintf('Fracture Toughness: %5.2f: Check Units\n', KIc)
    elseif Seeking == 2
        % Determine critical stress based on a flaw size
        Beta = input('Enter shape factor from a table: \n');
        a = input('Enter crack size in meters: \n');
        KIc = input('Enter expected critical KIc value from a reference \n');
        
        StressCrit = KIc/(Beta*sqrt(pi*a));
        
        fprintf('Critical Stress: %5.2f: Check Units\n', StressCrit)
    elseif Seeking == 3
        % Determine critical crack length
        KIc = input('Enter expected critical KIc value from a reference \n');
        Beta = input('Enter shape factor from a table: \n');
        StressCrit = max([SPrin(1) SPrin(2) SPrin(3)]);
        
        a = (KIc/(Beta*StressCrit*sqrt(pi)))^2;
        
        fprintf('Critical Crack Length: %5.2f: Check Units\n', a)
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fatigue Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






















