function [ ] = filtru_medie_armonica( nume, d )
%nume - numele imaginii 
%d - dimensiunea mastii

%exemple de apel:
% filtru_medie_armonica('LENNA_zg_G.jpg', 5)
% filtru_medie_armonica('LENNA_zg_G.jpg', 3)

I=imread(nume);
[m,n,p]=size(I);
if p>1
    I=rgb2gray(I);
end;
f=double(I);
t=(d+1)/2;
fe=zeros(m+d-1,n+d-1);
fe(t:m+t-1,t:n+t-1)=f;
nfe = zeros(m+d-1,n+d-1);

for l=t:m+t-1
    for c=t:n+t-1
        wlc = fe(l-t+1:l+t-1,c-t+1:c+t-1);
        %sir = reshape(wlc,[d*d,1]);
        suma=0;
        %[m2,n2]=size(wlc);
        for i=1:d
            for j=1:d
                suma=suma+(1/wlc(i,j));
            end;
        end;
        nfe(l,c)=(d*d)/(suma);
    end;
end;
rez=uint8(nfe(t:m+t-1,t:n+t-1));

figure
subplot(1,2,1);
imshow(I);
title('Imaginea initiala');
subplot(1,2,2);
imshow(rez);
nume1 = ['f_armon_' nume];
imwrite(rez,nume1);
title('Imaginea filtrata cu medie armonica');
end

