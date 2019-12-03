clc
clear
LX=1
LY=1
N=12
M=12
DX=LX/N
DY=LY/M
for I=1:N
for J=1:M
x(I,J)=I*DX;
y(I,J)=J*DY;
A(I,J)=sin(x(I,J)*y(I,J))/(x(I,J)*y(I,J))+0.01*randn(1,1);
end 
end

for I=1:N
for J=1:M
plot (I,J,'.')
hold on
grid on
end 
end
title('Relationship Between M and N')
xlabel('N Number of Nodes')
ylabel('M Number of Nodes')

figure(2)
for I=1:N
for J=1:M
plot (x(I,J),y(I,J),'.')
hold on
grid on
end 
end
title('Relationship Between M and N')
xlabel('Node Coordinate in x direction')
ylabel('Node Coordinate in y direction')

figure(3)
mesh(x,y,A)
