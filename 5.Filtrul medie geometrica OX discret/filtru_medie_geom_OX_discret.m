function [ ] = filtru_medie_geom_OX_discret( nume,numei,gam,iT,eps,alpha )
%nume - imaginea observata
%numei - imaginea originala:doar pentru SNR si RMI
% iT- numarul de pixeli pentru simularea efectului de miscare
% eps - pentru filtrul invers


%exemplu apel:
% filtru_medie_geom_OX_discret('iT9sigma10LENNAA.BMP','LENNAA.BMP',0.4,10,0.001,1/2);
% filtru_medie_geom_OX_discret('iT13sigma5BADSCAN1.BMP','BADSCAN1.BMP',0.02,13,0.0001,1/2);

I=imread(nume);
J=I(:,:,1);
[l,c]=size(J);
g=double(J);

%calculul filtrului Laplace in frecvente
numefil='laplace.txt';
w=load(numefil);
TFDl=construieste_filtru_fr(l,c,w);

%calculul TFD a imaginii 
TFDg=fft2(g);

%calculul filtrului motion blur
TFDh=motion_blur_d(l,c,iT);

%filtrarea in domeniul frecventelor
TFDf=zeros(l,c);
for x=1:l
        for y=1:c
            %Verificam cond. pt filtrul Wieners
            if((abs(TFDh(x,y)))^2+gam*(abs(TFDl(x,y))^2)>eps)
                  Fw=(TFDh(x,y))'/((abs(TFDh(x,y)))^2+gam*(abs(TFDl(x,y)))^2);                  
            else
                Fw=1;
            end;
            %Verificam cond. pentru filtrul invers
            if(abs(TFDh(x,y))<eps)
                Fi=1;
            else
                Fi=(TFDh(x,y))'/(abs(TFDh(x,y)))^2;
            end;
            %Contopim cele 2 filtre pentru a crea filtrul geometric
            val=(Fi^alpha)*(Fw^(1-alpha));
            TFDf(x,y)=TFDg(x,y)*val;
        end;
end;

% calculul imaginii filtrate
g1=real(ifft2(TFDf));

%aducerea nivelelor de gri pe [0,255]
valmax=max(max(g1));
valmin=min(min(g1));
g=255*(g1-ones(l,c)*valmin)/(valmax-valmin);

%matricea rezultat
rez=uint8(g);

%afisarea si salvarea imaginii restaurate
figure
imshow(I);
title('Imaginea cu motion blur si zgomot');
figure
imshow(rez);
title('Filtrare geometrica');
nume1=['G' 'alpha' num2str(alpha) nume ];
imwrite(rez,nume1,'bmp');

er = SNR(numei,nume);
disp(['SNR imagine perturbata versus imagine originala  ' num2str(er)]);
er = RMI(numei,nume);
disp(['RMI imagine perturbata versus imagine originala  ' num2str(er)]);
er = SNR(numei,nume1);
disp(['SNR imagine filtrata medie geometrica versus imagine originala  ' num2str(er)]);
er = RMI(numei,nume1);
disp(['RMI imagine filtrata medie geometrica versus imagine originala  ' num2str(er)]);


end

function [TFDh]=motion_blur_d(l,c,iT)
TFDh=zeros(l,c);
for x=1:l
    for y=2:c
        TFDh(x,y)=(1/iT)*(sin(pi*((y-1)*iT/c))/sin(pi*((y-1)/c)))*exp(-1i*pi*(y-1)*(iT-1)/c);
    end;
    TFDh(x,c)=1;
end;
end
