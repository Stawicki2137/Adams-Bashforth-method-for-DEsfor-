function [] = numtest2()
% Projekt 2, zadanie 30
% Mateusz Stawicki, 333274
%
% Funkcja testująca własności numeryczne zaimplementowanej metody.

fprintf("---------------------------------numtest2-----" + ...
    "-----------------------------\n");
fprintf("Test sprawdza czy metoda Adamsa-Bashfortha 3-go rzędu" + ...
    " jest istotnie\n" + ...
    "ograniczana przez fakt, że kwadratura zastosowana w metodzie " + ...
    "jest\n" + ...
    "rzędu 3.\n");
x0 = 0; xN = 1; % Końce przedziału całkowania równania różniczkowego
N = [5,10,100,200,400,800,1000,2000]; % Wektor liczby kroków
n = length(N);
Y0 = 1; % Warunek początkowy
% Rozwiązania analityczne testowanych równań
EXAC = {@(x) 1/3 .* x.^3 + 1, @(x) 1/4 .* x.^4 + 1, @(x) 1/5 .* x.^5 + 1};
name = {"y' = x^2","y' = x^3","y' = x^4"}; % Sposób wyświetlania równannia
a = {@(x) 0, @(x) 1}; % Równanie postaci y' = B{i}
B = {@(x) x^2, @(x) x^3, @(x) x^4};
V = zeros(n,2);
for j = 1:3 % Testowanie kolejnych równań
    if j == 2 % Zadbanie o poprawne wyświetlanie
        fprintf("[Press any key] "); pause(); fprintf("\n");
    end
    exa = EXAC{j};
    b = B{j};
    fprintf("------------------------------------------------------" + ...
        "---------------------\n");
    fprintf("Równanie różniczkowe: %s\n",name{j});
    fprintf("----------------------------------------------------" + ...
        "-----------------------\n");
    fprintf("|        h       |  błąd globalny |\n");
    for i = 1:n % Obliczanie błędów globlanych dla kolejnych kroków
        y_numerical = P2Z30_MST_ABRK3(b, a, x0, xN, Y0, N(i));
        x_values = linspace(x0, xN, N(i) + 1);
        y_exact = exa(x_values);
        err1 = GlobalError(y_numerical, y_exact);
        V(i,1) = N(i);
        V(i,2) = err1;
        fprintf("|    %5.3e   |    %5.3e   |\n", ...
            (xN - x0) / V(i,1), V(i,2) );
    end

end
fprintf("[Press any key] "); pause(); fprintf("\n");

end % function