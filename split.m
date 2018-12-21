function [K]=split(A)
m=size(A);
K=cell(m(1)/4,m(2)/4);
for i=1:m(1)/4
    for j=1:m(2)/4
        K{i,j}=A(4*i-3:4*i,4*j-3:4*j);
    end
end
end

    