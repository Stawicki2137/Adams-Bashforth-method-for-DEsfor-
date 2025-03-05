function [y] = AB3(b, a, x0, xN, Y0, Y1, Y2, N)
% Projekt 2, zadanie 30
% Mateusz Stawicki, 333274
%
% Wyznaczanie rozwiązania równania różniczkowego rzędu pierwszego lub
% drugiego metodą Adamsa-Bashfortha rzędu 3-go.
% WEJŚCIE
%   b   - uchwyt do funkcji opisujący prawą stronę liniowego
%         równania różniczkowego
%   a   - tablica komórkowa uchwytów do funkcji opisujących liniowe
%         równanie różniczkowe
%         a{3}(x) * y" + a{2}(x) * y' + a{1}(x) * y = b(x)
%   x0  - początek przedziału całkowania równania różniczkowego
%   xN  - koniec przedziału całkowania równania różniczkowego
%   Y0  - w zależności od rzędu równania różniczkowego: wartość początkowa
%         lub wektor wartości początkowych (pierwszy element to zadana
%         wartość rozwiązania, drugi to wartość jego pochodnej) w
%         punkcie x0
%   Y1  - patrz wyżej, z różnicą że Y1 jest obliczone w x0 + h
%   Y2  - patrz wyżej, z różnicą że Y2 jest obliczone w x0 + 2 * h
%   N   - liczba kroków (liczba podprzedziałów, na które dzielimy
%         przedział [x0, xN])
% WYJŚCIE
%   y   - wektor obliczonych przybliżeń wartości rozwiązania y w punktach
%         x_j = x0 + h * j, gdzie h = (xN - x0) / N, a j = 0,1,...,N

% Przypisania wykonane dla wygody operacji na uchwytach do funkcji
a1 = a{1}; a2 = a{2};
order = length(a) - 1; % Rząd równania różniczkowego

if order == 1 % Równanie 1-go rzędu a2(x) * y' + a1(x) * y = b(x)
    F = @(x, Y)(b(x) - a1(x) * Y) / a2(x); % Wyznaczenie funkcji F
else % Równanie 2-go rzędu a3(x) * y" + a2(x) * y' + a1(x) * y = b(x)
    a3 = a{3};
    F = @(x, Y) [
        Y(2);
        (b(x) - a1(x) .*  Y(1) - a2(x) .* Y(2)) ./ a3(x);
        ]; % Wyznaczenie funkcji F
end

Y = zeros(order, N + 1); % Inicjalizacja macierzy
Y(:,1) = Y0; Y(:,2) = Y1; Y(:,3) = Y2; % Przypisania wartości początkowych
h = (xN - x0) / N; % Wyznaczenie kroku całkowania

% Współczynniki kombinacji liniowej dla metody Adamsa-Bashfortha rzędu 3-go
alfa0 = 23/12; alfa1 = -16/12; alfa2 = 5/12;
for i = 3:N % Pętla wyznacza przybliżenia kolejnych wartości
    x_i = x0 + h * (i - 1);
    Y(:,i + 1) = Y(:,i) + h * (alfa0 * F(x_i, Y(:,i)) + ...
        alfa1 * F(x_i - h, Y(:,i - 1)) + alfa2 * F(x_i - 2 * h, ...
        Y(:,i - 2)));
end
y = Y(1, :); % Wektor obliczonych wartości y

end % function