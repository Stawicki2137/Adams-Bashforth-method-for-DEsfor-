function [] = numtest1()
% Projekt 2, zadanie 30
% Mateusz Stawicki, 333274
%
% Funkcja testująca własności numeryczne zaimplementowanej metody.

% Wypisanie informacji o teście
fprintf("---------------------------------numtest1----------------" + ...
    "------------------\n");
fprintf("Test porównuje błędy globalne rozwiązań uzyskanych za " + ...
    "pomocą metody\n" + ...
    "Rungego-Kutty 3-go rzędu z błędami globalnymi rozwiązań " + ...
    "uzyskanych za\n" + ...
    "pomocą metody Adamsa-Bashfortha 3-go rzędu. Test ma na celu " + ...
    "sprawdzić czy\n" + ...
    "dopisanie kilku linijek kodu prowadzi do uzyskania lepszej " + ...
    "dokładności.\n");
fprintf("-------------------------------Opis Testów-------" + ...
    "--------------------------\n");
fprintf("Kolumny zawierają kolejno:\n" + ...
    "  h   - krok całkowania\n" + ...
    "BG_AB - błąd globalny dla rozwiązania metodą " + ...
    "Adamsa-Bashfortha rzędu 3-go\n" + ...
    "SB_AB - stosunek błędów globalnych dla rozwiązania " + ...
    "metodą AB\n" + ...
    "SH_   - stosunek kroków całkowania do sześcianu " + ...
    "(h2/h1)^3\n" + ...
    "BG_RK - błąd globalny dla rozwiązania metodą " + ...
    "Rungego-Kutty rzędu 3-go\n" + ...
    "SB_RK - stosunek błędów globalnych dla rozwiązań" + ...
    " metodą RK\n");
fprintf("---------------------------------------------------" + ...
    "------------------------\n");
% Odpowiednie wyświetlanie
fprintf("[Press any key] "); pause(); fprintf("\n");

% Parametry wykorzystane w testach (można je w kodzie zmieniać dzięki czemu
% łatwo rozszerzyć testy, obserwować co się dzieje na innych przedziałach,
% innej liczbie kroków itd.)
x0 = 0; xN = 1; % Przedział całkowania
Y0p = {1,[1,1],[1,1]}; % Tablica komórkowa warunków początkowych
% Tablice komórkowe zawierające w komórkach parametry a,b oraz N
% opisane dokładnie w specyfikacji funkcji AB3
A = {{@(x) 0, @(x) 5}; {@(x) 1, @(x) -2, @(x) 1}; {@(x) 6, ...
    @(x) -5, @(x) 1}};
B = {@(x) exp(x), @(x) x^3, @(x) 0};
N1 = {[5,10,100,200,400,700,1000,2000];[5,10,100,200,400, ...
    700,10000,20000];[5,10,100,200,400,700,10000,20000]};
n = length(N1{1});
V = zeros(n,2); % Inicjalizacja wektora pomocniczego przechowującego N oraz
% błąd globalny (potrzebne do wypisania wyników testów) dla metody AB3
V1 = zeros(n,2); % analogicznie dla metody RK3
% Dokładne funkcje wyznaczone analitycznie będące rozwiązaniem równania
EXAC = {@(x) 1/5 .* exp(x) + 4/5, @(x) (-23 .* exp(x)) + ...
    (6 .* x .* exp(x)) + (x.^3) + (6 .* x.^2) + (18 .* x) + 24, ...
    @(x) 2 .* exp(2.*x) - 1 .* exp(x.*3)};
% Sposób wyświetlania równania
name = {"5 * y' = e^x","y'' - 2 * y' + y = x^3", ...
    "y'' - 5 * y' + 6 * y = 0" };
k = length(A);
for j = 1:k % Testowanie kolejnych równań
    a = A{j};
    b = B{j};
    N = N1{j};
    Y0 = Y0p{j};
    exa = EXAC{j};
    for i = 1:n % Testowanie różnych wartości kroków dla danego równania
        V(i,1) = N(i);
        V1(i,1) = N(i);
         % Metoda Adamsa-Bashfortha 3-go rzędu
        y_numericalAB3 = P2Z30_MST_ABRK3(b, a, x0, xN, Y0, N(i));
        % Metoda Rungego - Kutty 3-go rzędu
        y_numericalRK3 = RK3(b, a, x0, xN, Y0, N(i)); 
        % Punkty, w których obliczane są wartości
        x_values = linspace(x0, xN, N(i) + 1); 
        y_exact = exa(x_values); % Dokładne rozwiązanie
        % Błąd globalny dla rozwiązania metodą Adamsa-Bashfortha 3-go rzędu
        err1 = GlobalError(y_numericalAB3, y_exact); 
        % Błąd globalny dla rozwiązania metodą Rungego-Kutty 3-go rzędu
        err2 = GlobalError(y_numericalRK3, y_exact);
        V(i,2) = err1;
        V1(i,2) = err2;
    end
    if j == 2 % Zadbanie o poprawne wyświetlanie
        fprintf("[Press any key] "); pause(); fprintf("\n");
    end
    if j == 3 % Zadbanie o poprawne wyświetlanie
        fprintf("[Press any key] "); pause(); fprintf("\n");
    end

    % Wypisanie informacji o tym jakie równanie jest rozpatrywane
    fprintf("---------------------------------------------------" + ...
        "------------------------\n");
    fprintf("Równanie różniczkowe: %s\n",name{j});
    fprintf("---------------------------------------------------" + ...
        "------------------------\n");

    % Wypisanie tabeli
    fprintf("|     h     |   BG_AB   |   SB_AB   |     SH_   |  " + ...
        " BG_RK   |   SB_RK   |\n")
    for i = 1:n
        if i == 1
            fprintf("| %5.3e | %5.3e |     -     |      -    | %5.3e" + ...
                " |     -     |\n",  (xN - x0) / V(1,1), V(1,2), V1(1,2));
        else
            fprintf("| %5.3e | %5.3e | %5.3e | %5.3e | %5.3e | %5.3e" + ...
                " |\n",  (xN - x0) / V(i,1), V(i,2), V(i,2) / V(i-1,2), ...
                (V(i - 1,1) / V(i))^3,V1(i,2), V1(i,2) / V1(i-1,2));
        end
    end
    fprintf("------------------------------------------------------" + ...
        "---------------------\n");
end
fprintf("[Press any key] "); pause(); fprintf("\n");

end % function


