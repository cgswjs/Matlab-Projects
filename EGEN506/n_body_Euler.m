clear;clc
disp('Gravitational n-Body Simulation using the Euler-Cromer and RK4 Methods')
disp('-------------------------------------------------------------')
% Asking for user input
numberofbodies = input('Please enter a number of bodies to be included in the simulation: ');
time = input('Please enter a duration of observation (in years):' );
disp(['The simulation will simulate ' num2str(numberofbodies) ' bodies over a period of ' num2str(time) ' years.'])
disp('-------------------------------------------------------------')

% Initializing the time and time step
to = 0;		    % [years]
tf = time;		% [years]
dt=0.0005;		% [years]

t=to:dt:tf;	% Time values

% Constants and basics
%---------------------------------------------------------------------------------
G = (6.67408e-11)*(1.989e30)*(3.154e+7)^2/(1.496e+11)^3; % Gau=G*Msol*(Second/yr)^2/(Meters/AU)^3
n = numberofbodies;				% Number of bodies in the simulation

% Preallocating arrays for position vectors and velocity vectors
x  = zeros(n,length(t));		% x-position
y  = zeros(n,length(t));		% y-position
z  = zeros(n,length(t));		% z-position
vx = zeros(n,length(t));		% x velocity
vy = zeros(n,length(t));		% y velocity
vz = zeros(n,length(t));		% z velocity

% Mass matrix
masses = zeros(1,n);	% Preallocating an array for masses
for i=1:n
    disp(['Type in the mass of body ' num2str(i) ' in units of solar mass:']);
    masses(i)=input('');
end

% Create mass products matrix (M(i)*m(i))
massproducts = [n*n,n*n]; % all the combination of m(i)m(j)

for i=1:n
    for j=1:n
        massproducts(i,j)=masses(i) * masses(j);
        if i==j
            massproducts(i,j)=0;
        end
        
    end
end


%Initial Conditions
for i=1:n
    disp(['Please enter the initial x coordinate of body ' num2str(i) ':']);
    x(i,1)=input(''); %Initial x coordinate for ith body
    disp(['Please enter the initial y coordinate of body ' num2str(i) ':']);
    y(i,1)=input(''); %Initial y coordinate for ith body
    disp(['Please enter the initial z coordinate of body ' num2str(i) ':']);
    z(i,1)=input(''); %Initial z coordinate for ith body
    
    disp(['Please enter the x-component of the initial velocity of body ' num2str(i) ':']);
    vx(i,1)=input(''); %Initial vx for ith body
    disp(['Please enter the y-component of the initial velocity of body ' num2str(i) ':']);
    vy(i,1)=input(''); %Initial vy for ith body
    disp(['Please enter the z-component of the initial velocity of body ' num2str(i) ':']);
    vz(i,1)=input(''); %Initial vz for ith body
end

choice=input('Do you want to use Euler Cromer(1) or RK4(2)');
disp(['You have chosen method (' num2str(choice) ')'])
if choice==1
    %Loop over time with Euler Cromer
    for k = 1:length(t)
        
        clear r;
        
        for i = 1:n
            for j = 1:n
                %get the distance
                r(i,j) = sqrt( (x(i,k)-x(j,k)).^2 + (y(i,k)-y(j,k)).^2 ...
                    + (z(i,k)-z(j,k)).^2 );
                if i==j
                    r(i,j)=0;
                end
            end
        end
        
        
        
        for i=1:n
            clear mmr3	% Clearing this out mass product over r^3
            clear summm	% Clearing this out
            mmr3 = (1/masses(i))*massproducts(i,:)./(r(i,:).^3);
            mmr3(isnan(mmr3)) = 0;
            summm=sum(mmr3); %Sum mass product
            
            %Gmx/r^3=accelaration
            vx(:,k+1) = vx(:,k) + ((G*(x(:,k+1)-x(:,k))*dt)*summm);%update vx
            vy(:,k+1) = vy(:,k) + ((G*(y(:,k+1)-y(:,k))*dt)*summm);
            vz(:,k+1) = vz(:,k) + ((G*(z(:,k+1)-z(:,k))*dt)*summm);
        end
        
        % Standard Euler-Cromer procedure
        x(:,k+1) = x(:,k) + vx(:,k+1) * dt;
        y(:,k+1) = y(:,k) + vy(:,k+1) * dt;
        z(:,k+1) = z(:,k) + vz(:,k+1) * dt;
        
        for i=1:n
            %Plotting Euler-Comer
            plot3(x(i,1),y(i,1),z(i,1),'o')
            hold on
            plot3(x(i,1:k),y(i,1:k),z(i,1:k))
        end
        hold off
        
        grid on
        title(['$n$-Body Simulation: $n=' num2str(numberofbodies) '$, $t=[0,' num2str(time) ']$ [years]'],'interpreter','latex')
        xlabel('$x$ [AU]','interpreter','latex')
        ylabel('$y$ [AU]','interpreter','latex')
        zlabel('$z$ [AU]','interpreter','latex')
        drawnow
        
        
    end
elseif choice==2
    % RK4
    for k=1:length(t)
        clear r;
        
        for i = 1:n
            for j = 1:n
                %get the distance
                r(i,j) = sqrt( (x(i,k)-x(j,k)).^2 + (y(i,k)-y(j,k)).^2 ...
                    + (z(i,k)-z(j,k)).^2 );
                if i==j
                    r(i,j)=0;
                end
            end
        end
        
        for i=1:n
            clear mmr3	% Clearing this out mass product over r^3
            clear summm	% Clearing this out
            mmr3 = (1/masses(i))*massproducts(i,:)./(r(i,:).^3);
            mmr3(isnan(mmr3)) = 0;
            summm=sum(mmr3); %Sum mass product
        end
        
        for i=1:n
            %RK4
            %Create K1 K2 K3 K4 matrices for x
            p1x=zeros(n,k);
            p2x=zeros(n,k);
            p3x=zeros(n,k);
            p4x=zeros(n,k);
            %update Ks
            p1x(:,k)=dt*(G* x(i,k)*summm);%K1 for x
            p2x(:,k)=dt*(G*(x(i,k)+p1x(i,k)/2)*summm);%K2 for x
            p3x(:,k)=dt*(G*(x(i,k)+p2x(i,k)/2)*summm);%K3 for x
            p4x(:,k)=dt*(G*(x(i,k)+p3x(i,k))*summm);%K4 for x
            %Update x with RK4
            x(:,k+1)=x(:,k)+dt/6*(p1x(:,k)+p2x(:,k)+p3x(:,k)+p4x(:,k));
            %-------------------------------------------------------------%
            %Create K1 K2 K3 K4 matrices for y
            p1y=zeros(n,k);
            p2y=zeros(n,k);
            p3y=zeros(n,k);
            p4y=zeros(n,k);
            %update Ks
            p1y(:,k)=dt*(G* y(i,k)*summm);%K1 for x
            p2y(:,k)=dt*(G*(y(i,k)+p1y(i,k)/2)*summm);%K2 for x
            p3y(:,k)=dt*(G*(y(i,k)+p2y(i,k)/2)*summm);%K3 for x
            p4y(:,k)=dt*(G*(y(i,k)+p3y(i,k))*summm);%K4 for x
            %Update y with RK4
            y(:,k+1)=y(:,k)+dt/6*(p1y(i,k)+p2y(i,k)+p3y(i,k)+p4y(i,k));
            %-------------------------------------------------------------%
            %Create K1 K2 K3 K4 matrices for z
            p1z=zeros(n,k);
            p2z=zeros(n,k);
            p3z=zeros(n,k);
            p4z=zeros(n,k);
            %update Ks
            p1z(:,k)=dt*(G* z(i,k)*summm);%K1 for x
            p2z(:,k)=dt*(G*(z(i,k)+p1z(i,k)/2)*summm);%K2 for x
            p3z(:,k)=dt*(G*(z(i,k)+p2z(i,k)/2)*summm);%K3 for x
            p4z(:,k)=dt*(G*(z(i,k)+p3z(i,k))*summm);%K4 for x
            %Update z with RK4
            z(:,k+1)=z(:,k)+dt/6*(p1z(i,k)+p2z(i,k)+p3z(i,k)+p4z(i,k));
        end
        %Plorrinf Euler-Cromer
        for i=1:n
            plot3(x(i,1),y(i,1),z(i,1),'o')
            hold on
            plot3(x(i,1:k),y(i,1:k),z(i,1:k))
        end
        hold off
        
        %Graph Labels
        grid on
        title(['$n$-Body Simulation: $n=' num2str(numberofbodies) '$, $t=[0,' num2str(time) ']$ [years]'],'interpreter','latex')
        xlabel('$x$ [AU]','interpreter','latex')
        ylabel('$y$ [AU]','interpreter','latex')
        zlabel('$z$ [AU]','interpreter','latex')
        drawnow
        
    end
end


