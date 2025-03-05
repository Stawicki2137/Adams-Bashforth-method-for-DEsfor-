function [y, Y] = RK3(b, a, x0, xN, Y0, N, MAX_ITER)
% Projekt 2, zadanie 30
% Mateusz Stawicki, 333274
%
% Wyznaczanie MAX_ITER początkowych wartości rozwiązania równania
% różniczkowego rzędu pierwszego lub drugiego metodą Rungego - Kutty
% rzędu 3-go dla współczynników alfa = 1/3 oraz beta = 2/3. W przypadku
% braku argumentu MAX_ITER funkcja domyślnie przyjmuje N co pozwala
% wyznaczyć pełne rozwiązanie równania przy użyciu funkcji RK3.
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
%   Y   - dla równań 1 rzędu Y = y, dla równań 2 rzędu macierz, której
%         pierwszy wiersz jest równy wektorowi y (Y(1,:) = y), drugi wiersz
%         zawiera wartości y' w punktach x_j = x0 + h * j, gdzie
%         h = (xN - x0) / N, a j = 0,1,...,N

if nargin < 7, MAX_ITER = N; end % Domyślny argument
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

Y = zeros(order, MAX_ITER + 1); % Inicjalizacja macierzy
Y(:,1) = Y0; % Przypisanie warunku początkowego
h = (xN - x0) / N; % Wyznaczenie kroku całkowania

for i = 1:MAX_ITER % Pętla wyznacza przybliżenia kolejnych wartości
    x_i = x0 + h * (i - 1); % Punkt w którym przybliżana jest wartość
    K1 = h * F(x_i, Y(:,i));
    K2 = h * F(x_i + h * 1/3, Y(:,i) + 1/3 * K1);
    K3 = h * F(x_i + h * 2/3, Y(:,i) + 2/3 * K2);
    Y(:,i + 1) = Y(:,i) + 1/4 * K1  + 3/4 * K3; % Przybliżenie wartości
end
y = Y(1, :); % Wektor obliczonych wartości y

end % function