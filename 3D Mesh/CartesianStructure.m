clc 
clear 
M=7; 
N=7; 
L=7;
LX=1; 
LY=1; 
LZ=1; 
dx=LX/M; 
dy=LY/N; 
dz=LZ/L; 
for k=1:L; 
if (k==1 |k==L) 
c=0;
else 
c=1;
end
for i=1:M;
for j=1:N;
if (j==1 | i==1) 
u(i,j,k)=0*c;
elseif (j==N | i==M) 
u(i,j,k)=0; 
else u(i,j,k)=c*randn(1,1);
end 
end 
end 
end 
for i=1:M; 
for j=1:N; 
for k=1:L; 
x(i,j,k)=i*dx;
y(i,j,k)=j*dy;
z(i,j,k)=k*dz; 
end 
end
end
figure
for i=1:M; 
for j=1:N; 
for k=1:L; 
plot3(x(i,j,k),y(i,j,k),z(i,j,k),'*r') 
end 
hold on 
end 
end 
title('Domain Points')
xlabel('x') 
ylabel('y') 
zlabel('z') 
tic
for i=1:M; 
for j=1:N; 
for k=1:L; 
xc=x(i,j,k); 
yc=y(i,j,k); 
zc=z(i,j,k); 
hold on 
plot3(xc,yc,zc,'*b')
axis equal
%-------------------------------------------------------- 
%Bottom Plane 
xc1=xc+dx/2;
yc1=yc+dy/2;
zc1=zc-dz/2; xc2=xc-dx/2; yc2=yc+dy/2; zc2=zc-dz/2; xc3=xc-dx/2; yc3=yc-dy/2; zc3=zc-dz/2; 
xc4=xc+dx/2; yc4=yc-dy/2; zc4=zc-dz/2; v1=[xc1,xc2]; v2=[yc1,yc2]; v3=[zc1,zc2]; f=line(v1,v2,v3); v1=[xc2,xc3]; 
v2=[yc2,yc3]; v3=[zc2,zc3]; f=line(v1,v2,v3); v1=[xc3,xc4]; v2=[yc3,yc4]; v3=[zc3,zc4]; f=line(v1,v2,v3); v1=[xc4,xc1]; 
v2=[yc4,yc1]; v3=[zc4,zc1]; f=line(v1,v2,v3); %-------------------------------------------------------- 
%Top Plane xc5=xc+dx/2; 
yc5=yc+dy/2; 
zc5=zc+dz/2; xc6=xc-dx/2; yc6=yc+dy/2; zc6=zc+dz/2; xc7=xc-dx/2; yc7=yc-dy/2; 
zc7=zc+dz/2;
xc8=xc+dx/2;
yc8=yc-dy/2; 
zc8=zc+dz/2; 
v1=[xc5,xc6]; 
v2=[yc5,yc6]; 
v3=[zc5,zc6];
f=line(v1,v2,v3);
v1=[xc6,xc7]; 
v2=[yc6,yc7]; 
v3=[zc6,zc7]; 
f=line(v1,v2,v3); 
v1=[xc7,xc8]; 
v2=[yc7,yc8]; 
v3=[zc7,zc8]; 
f=line(v1,v2,v3); 
v1=[xc8,xc5]; 
v2=[yc8,yc5];
v3=[zc8,zc5]; 
f=line(v1,v2,v3); 
%--------------------------------------------------------
% Side Planes
v1=[xc1,xc5]; 
v2=[yc1,yc5]; 
v3=[zc1,zc5]; 
f=line(v1,v2,v3); 
v1=[xc2,xc6]; 
v2=[yc2,yc6]; 
v3=[zc2,zc6];
f=line(v1,v2,v3); 
v1=[xc3,xc7]; 
v2=[yc3,yc7]; 
v3=[zc3,zc7]; 
f=line(v1,v2,v3); 
v1=[xc4,xc8]; 
v2=[yc4,yc8]; 
v3=[zc4,zc8];
f=line(v1,v2,v3); 
%-------------------------------------------------------- 
end 
end 
end 
toc
