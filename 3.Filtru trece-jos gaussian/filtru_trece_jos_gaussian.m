function [ ] = filtru_trece_jos_gaussian( nume,D0 )
%nume - numele imaginii
%D0 - raza

%exemple de apel: 
%filtru_trece_jos_gaussian('LENNAA.BMP',20)
%filtru_trece_jos_gaussian('LENNAA.BMP',50)

I=imread(nume);
[m,n,p]=size(I);
I=I(:,:,1);

%calculul valorilor cu care expandam imaginea prin adaugarea de linii si
%coloane nule
l=2*m;
c=2*n;

%linia si coloana de unde incepem copierea imaginii initiale in imaginea
%expandata
m1=fix(m/2)+1;
n1=fix(n/2)+1;

%expandarea imaginii
f=zeros(l,c);
f(m1:m+m1-1,n1:n+n1-1)=double(I);
fc=f;

%centrarea imaginii expandate
for i=1:l
    for j=1:c
       fc(i,j)=f(i,j)*(-1)^(i+j);
    end;
end;

%calculul TFD a imaginii centrate
TFDfc=fft2(fc);

%calculul lui alpha
alpha=calcul_alpha(TFDfc,D0);

TFDg=zeros(l,c);

%calculul functiei filtru lowpass ideale
h=zeros(l,c);
disp(['valoarea procentului din totalul puterii spectrale incluse in cercul de raza:' num2str(D0) ' este:' num2str(alpha) ]);
for i=1:l
    for j=1:c
        h(i,j)=exp((-Dist(i,j,l,c)^2)/(2*D0^2));
        TFDg(i,j)=h(i,j)*TFDfc(i,j);
    end;
end;

% calculul variantei extinse a imaginii filtrate
gc=real(ifft2(TFDg));
g=gc;
for i=1:l
    for j=1:c
       g(i,j)=gc(i,j)*(-1)^(i+j);
    end;
end;

%matricea rezultat
rez=uint8( g(m1:m+m1-1,n1:n+n1-1));

%afisarea imaginii initiale
figure
imshow(I);
title('Imaginea initiala');

%afisarea si salvarea rezultatelor
figure
imshow(rez);
title(['Imaginea filtrata Gaussian LP cu raza ' num2str(D0)]);
nume1=['GLP_' num2str(D0) '.jpg'];
imwrite(rez,nume1,'jpg');

end

function [val]=Dist(i,j,l,c)
l1=l/2;c1=c/2;
val=sqrt((i-l1)^2+(j-c1)^2); % functie pt gauss
end

function [alpha]=calcul_alpha(F,D0)
[l,c]=size(F);

%calculul puterii spectrale in fiecare punct
P=zeros(l,c);
for i=1:l
    for j=1:c
        P(i,j)=abs(F(i,j))^2;
    end;
end;

%calculul puterii spectrale totale
PT=sum(sum(P));

%calculul puterii spectrale considerate in total, pentru raza D0
Pincl=0;
for i=1:l
    for j=1:c
        if(Dist(i,j,l,c)<=D0)
            Pincl=Pincl+P(i,j);
        end;
    end;
end;

%calculul procentului alpha
alpha=100*Pincl/PT;

end
