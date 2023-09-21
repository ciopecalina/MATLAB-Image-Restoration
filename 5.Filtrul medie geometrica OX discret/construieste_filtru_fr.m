function [TFDh] = construieste_filtru_fr(l,c,w)
[m1,n1]=size(w);
%calculul functiei filtru in domeniul de frecvente pe baza filtrului
%spatial in cazul Laplace  

%% ATENTIE! NU SE FACE FILTRARE CU LAPLACE (NU SE FACE CENTRARE)! TREBUIE DOAR CALCULATA FORMA
% FOURIER A FILTRULUI LAPLACE PENTRU CONSTRUCTIA FILTRULUI WIENER 

h=zeros(l,c);
l1=uint16(l/2);c1=uint16(c/2);
for i=-(m1-1)/2:(m1-1)/2
    for j=-(n1-1)/2:(n1-1)/2
            h(l1+i,c1+j)=w(i+(m1-1)/2+1,j+(n1-1)/2+1);
    end;
end;

TFDh=fft2(h);

end