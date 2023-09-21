function  f_descompunere(numei, procent)
  %numei - numele imaginii
  %procent - procentul de descompunere
  %Exemplu de apel : f_descompunere('LENNA.BMP',5)

    I = imread(numei);
    [n, ~, p] = size(I);
    I = double(I);
    
    % functia de descompunere svd pe componente de culoare
    if p == 1
        R = uint8(desc_svd(I, n, procent));
    else
        for k = 1:p
            R(:, :, k) = uint8(desc_svd(I(:, :, k), n, procent));
        end
    end
    
    % afisare imagine initiala si imagine comprimata
    figure
    imshow(uint8(I));
    title('Imaginea initiala');
    figure
    imshow(R);
    title(['Descompunere SVD cu compresie de ' num2str(100-procent) '%']);
    
    % numele fisierului de iesire
    [nume ext] = strsplit(numei, '.'){1, :};
    numeo = [nume num2str(procent) '.' ext];
    
    % salvare fisier de iesire
    imwrite(R, numeo);

end

function R = desc_svd(I, n, procent)
    % descompunerea imaginii folosind SVD
    [U, S, V] = svd(I);
    
    % nr de valori singulare folosite
    N = fix((n * procent) / 100.0);
    
    % eliminarea valorile singulare nefolosite
    S(N+1:end, :) = 0;
    S(:, N+1:end) = 0;
    
    % imagine noua din valorile ramase
    R = U * S * V';
end

