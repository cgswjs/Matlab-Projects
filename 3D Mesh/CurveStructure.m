clc 
clear
M=8;
N=8;
L=8;
LX=1; 
LY=1;
LZ=1;
dx=LX/M;
dy=LY/N; 
dz=LZ/L;   
for i=1:M;   
for j=1:N;     
for k=1:L;            
x(i,j,k)=i*dx;            
y0(i,j,k)=j*dy;           
y(i,j,k)=(x(i,j,k))^2+y0(i,j,k);      
z(i,j,k)=k*dz; 
end  
end
end 
for i=1:M;  
for j=1:N;    
for k=1:L; 
plot3(x(i,j,k),y(i,j,k),z(i,j,k),'*r') 
hold on 
grid on  
xlabel('x') 
ylabel('y')
zlabel('z')  
end  
end
end
for k=1:L;
for i=1:M; 
for j=1:N;   
if (i<M) 
xx=[ x(i+1,j,k) x(i,j,k) ];  
yy=[ y(i+1,j,k) y(i,j,k) ];      
zz=[ z(i,j,k) z(i,j,k) ];     
f=line(xx,yy,zz);    
elseif (i==M)  
xx=[ x(i,j,k) x(i,j,k) ];    
yy=[ y(i,j,k) y(i,j,k) ]; 
zz=[ z(i,j,k) z(i,j,k)];  
f=line(xx,yy,zz);    
end   
end
end 
end 
for k=1:L;
for i=1:M;    
for j=1:N;  
if (j<N)    
xxx=[ x(i,j+1,k) x(i,j,k) ];    
yyy=[ y(i,j+1,k) y(i,j,k) ]; 
zzz=[ z(i,j,k) z(i,j,k) ];  
f=line(xxx,yyy,zzz); 
elseif (j==N)  
xxx=[ x(i,j,k) x(i,j,k) ];   
yyy=[ y(i,j,k) y(i,j,k) ];  
zzz=[ z(i,j,k) z(i,j,k) ];   
f=line(xxx,yyy,zzz);   
end      
end 
end 
end  
for k=1:L; 
for i=1:M;     
for j=1:N;        
if (k<L)     
xxxx=[ x(i,j,k) x(i,j,k) ];
yyyy=[ y(i,j,k) y(i,j,k) ]; 
zzzz=[ z(i,j,k+1) z(i,j,k) ]; 
f=line(xxxx,yyyy,zzzz);
elseif (k==L)    
xxxx=[ x(i,j,k) x(i,j,k) ];
yyyy=[ y(i,j,k) y(i,j,k) ]; 
zzzz=[ z(i,j,k) z(i,j,k) ];
f=line(xxxx,yyyy,zzzz);        
end         
end
end
end
