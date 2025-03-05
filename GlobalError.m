function [err] = GlobalError(Y_num, Y_exa)
% Projekt 2, zadanie 30
% Mateusz Stawicki, 333274
%
% Funkcja pomocnicza do testów implementacji oraz testów numerycznych.
% Wyznacza błąd globalny uzyskanego rozwiązania równania różniczkowego.
% WEJŚCIE
% Y_num - wektor rozwiązań numeryczną metodą
% Y_exa - wektor rozwiązań analityczną metodą
% WYJŚCIE
%   err - błąd globalny wyznaczonego rozwiązania

err = max(abs(Y_exa - Y_num));

end % function
