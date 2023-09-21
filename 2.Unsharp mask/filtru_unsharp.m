function [R]=filtru_unsharp(J, alpha)
dim=3;

% extinderea imaginii cu cate m1-1 linii deasupra/sub imagine si cate n1-1 coloane la stanga/dreapta imaginii
[m,n]=size(J);
l=m + 2*dim-2; 
c=n + 2*dim-2;

%imaginea extinsa pentru aplicarea mastii
f=zeros(l,c);
f(dim : m + dim - 1, dim : n + dim - 1)=J;

%matricea tipului de filtru unsharp
w = (1/(1+alpha))*[-alpha , alpha-1 , -alpha ; alpha-1, alpha+5,alpha-1; -alpha, alpha-1, -alpha];

% calculul matricei rezultat al corelatiei/convolutie
g=zeros(l,c);% Contur
a=(dim-1)/2;
b=(dim-1)/2;

%filtrare cu masca w
for x=dim:m + dim-1
    for y=dim:n + dim-1
        for s=1:dim
            for t=1:dim
                %pentru corelatie
                %g(x,y)=g(x,y)+w(s,t)*f(x+s-a-1,y+t-b-1);
                %pentru convolutie
                g(x,y)=g(x,y)+w(s,t)*f(x-s+a+1,y-t+b+1);
            end
        end
    end
end
%R - rezultatul filtrarii
R=g(dim:m+dim-1,dim:n+dim-1);

end

