function [] = perturba_motion_noise_MDiscret(nume,iT,sigma)

%% FUNCTIA PERTURBA O IMAGINE NORMAL SI ADAUGA UN EFECT DE MISCARE PE A DOUA AXA

%% EXEMPLE DE APEL
%perturba_motion_noise_MDiscret('LENNAA.bmp',5,20);  - efect de miscare slab si zgomot mare
% perturba_motion_noise_MDiscret('LENNAA.bmp',9,10); 
%perturba_motion_noise_MDiscret('LENNAA.bmp',11,5);  - efect de miscare puternic si zgomot slab
%perturba_motion_noise_MDiscret('BADSCAN1.bmp',9,15); 
%perturba_motion_noise_MDiscret('BADSCAN1.bmp',13,5);  - efect de miscare puternic si zgomot slab

%% CORPUL FUNCTIEI
I=imread(nume);
J=I(:,:,1);
[l,c]=size(J);
%l=m+m1-1;c=n+n1-1;
f=double(J);

%calculul TFD a imaginii 

TFDfc=fft2(f);

%calculul filtrului
TFDh=motion_blur_d(l,c,iT);

%filtrarea in domeniul frecventelor
TFDg=zeros(l,c);
for x=1:l
        for y=1:c
            TFDg(x,y)=TFDh(x,y)*TFDfc(x,y);
        end;
end;

% calculul imaginii filtrate
g1=abs(ifft2(TFDg)); % sau real

zg=normrnd(0,sigma,l,c);

%matricea rezultat
rez1=double(uint8(g1));

rez=uint8(rez1+zg);

%afisarea si salvarea perturbarii
figure
imshow(I);
title('Imaginea initiala');
figure
imshow(rez);
title(['Imaginea peturbata motion blur+zgomot']);
numep=['iT' num2str(iT) 'sigma' num2str(sigma) nume]; 
imwrite(rez,numep);
end


function [TFDh]=motion_blur_d(l,c,iT)
% iT - nr. de pixeli deplasare
TFDh=zeros(l,c);
for x=1:l
    for y=2:c
        TFDh(x,y)=(1/iT)*(sin(pi*((y-1)*iT/c))/sin(pi*((y-1)/c)))*exp(-1i*pi*(y-1)*(iT-1)/c);
    end;
    TFDh(x,1)=1;
end;
end