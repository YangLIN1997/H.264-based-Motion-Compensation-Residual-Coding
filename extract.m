function B=extract(D)
m=size(D);
for i=1:m(1)
    for j=1:m(2)
        B(4*i-3:4*i,4*j-3:4*j)=D{i,j};
    end
end