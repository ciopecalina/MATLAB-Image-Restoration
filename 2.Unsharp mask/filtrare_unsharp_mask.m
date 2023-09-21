function [R] = filtrare_unsharp_mask(nume,alpha)

% nume - numele fisierului ce contine imaginea
% alpha - constanta real pozitiva folosita in definirea matricei de
% filtrare, procentul alpha pentru intensitate
% R - imaginea reconstruita in urma contrastului adaugat

%Exemplu de apel: R=filtrare_unsharp_mask ('LENNA.BMP',0.7);
%                 R=filtrare_unsharp_mask ('LENNA.BMP',0.3);
%                 R=filtrare_unsharp_mask ('LENNA.BMP',1.5);

%citirea imaginii
I=imread(nume);
[m, n,p]=size(I);
figure
imshow(I);
title('Imaginea initiala nefiltrata');

%R - rezultatul filtrarii, imaginea filtrata
R=zeros(m,n,p);

%alpha trebuie sa fie intre 0 si 1 
if(alpha<0)
alpha=0;
elseif(alpha>1)
alpha=1;
end

%pentru fiecare plan al imaginii
for i=1:p
  J=double(I(:,:,i));
  R(:,:,i)=filtru_unsharp(J,alpha);
end

R=uint8(R);
figure
imshow(R);
title('Imaginea filtrata cu unsharp mask');
end


