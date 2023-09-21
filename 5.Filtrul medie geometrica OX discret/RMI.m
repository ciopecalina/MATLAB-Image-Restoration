function val = RMI(nume1,nume2)

I1=imread(nume1);
[N,M,~]=size(I1);
A=double(I1(:,:,1));
I2=imread(nume2);
B=double(I2(:,:,1));
L=256;
pab=zeros(L,L);
for x=1:N
     for y=1:M
         pab(A(x,y)+1,B(x,y)+1)=pab(A(x,y)+1,B(x,y)+1)+1;
     end
end
sumab=sum(sum(pab));
pab=pab/sumab;
pa=sum(pab,2);
pb=sum(pab,1);

L=256;
hA=0;
for i=1:L
    if pa(i)
        hA=hA-pa(i)*log(pa(i));
    end
end
hB=0;
for i=1:L
    if pb(i)
        hB=hB-pb(i)*log(pb(i));
    end
end
hAB=0;
for i=1:L
    for j=1:L
        if pab(i,j)
            hAB=hAB-pab(i,j)*log(pab(i,j));
        end
    end
end

val=(hA+hB-hAB)/hA;
end
