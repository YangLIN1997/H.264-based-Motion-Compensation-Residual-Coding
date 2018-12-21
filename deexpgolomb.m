function [num] = deexpgolomb( string  )
%EXPGOLOMB is the function to calculate the
%Exp-Golomb code for a integer
%NUM   The number to be calculated
%LEN   The length of the resulting binary code sequence
%STRING   The resulting binary code sequence for integer NUM

if string(1) == '1'
    num = 0;
else
    i=1;
        while string(i)=='0'
            i=i+1;
        end
    num_tmp=bin2dec(string(i:length(string)));
    if string(length(string))=='0'
        num=num_tmp/2;
    else
        num=(num_tmp-1)/-2;   
    end
end
    