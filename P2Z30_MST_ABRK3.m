function [y] = P2Z30_MST_ABRK3(b, a, x0, xN, Y0, N)
% Projekt 2, zadanie 30
% Mateusz Stawicki, 333274
%
% Funkcja wyznacza wektor rozwiązań równania różniczkowego pierwszego lub
% drugiego rzędu korzystając z metody Adamsa-Bashfortha rzędu 3-go.
% Wartości początkowe Y1, Y2 wykorzystane w metodzie Adamsa-Bashfortha
% wyznaczane są za pomocą meotody Rungego-Kutty rzędu 3-go.
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
%         wartość rozwiązania, drugi to wartość jego pochodnej)
%   N   - liczba kroków (liczba podprzedziałów, na które dzielimy
%         przedział [x0, xN])
% WYJŚCIE
%   y   - wektor obliczonych przybliżeń wartości rozwiązania y w punktach
%         x_j = x0 + h * j, gdzie h = (xN - x0) / N, a j = 0,1,...,N

% Wyznaczenie wartości początkowych metodą Rungego-Kutty rzędu 3-go
[~, Yp] = RK3(b, a, x0, xN, Y0, N, 2);
Y1 = Yp(:,2); Y2 = Yp(:,3); % Przypisanie warunków początkowych

% Wyznaczenie wektora obliczonych przybliżeń metodą Adamsa-Bashfortha
% rzędu 3-go
y = AB3(b, a, x0, xN, Y0, Y1, Y2, N);

end % function


