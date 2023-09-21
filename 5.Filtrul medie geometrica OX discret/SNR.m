function [val] = SNR(nume1,nume2)
I=imread(nume1);
f=double(I(:,:,1));
[m,n]=size(f);
J=imread(nume2);
g=double(J(:,:,1));
s1=0;s2=0;
for i=1:m
    for j=1:n
        s1=s1+f(i,j)^2;
        s2=s2+(f(i,j)-g(i,j))^2;
    end;
end;
val=10*log10(s1/s2);
end

