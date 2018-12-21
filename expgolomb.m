function [ len, string ] = expgolomb( num )
%EXPGOLOMB is the function to calculate the
%Exp-Golomb code for a integer
%NUM   The number to be calculated
%LEN   The length of the resulting binary code sequence
%STRING   The resulting binary code sequence for integer NUM

if num == 0
    len = 1;
    string = '1';
elseif num >0
    string = dec2bin(2*num);
    len_tmp = length(string);
    temp = num2str(10^(len_tmp-1));
    string = strcat(temp(2:len_tmp),string);
    len = 2*len_tmp-1;
else
    string = dec2bin(-2*num+1);
    len_tmp = length(string);
    temp = num2str(10^(len_tmp-1));
    string = strcat(temp(2:len_tmp),string);
    len = 2*len_tmp-1;
end

