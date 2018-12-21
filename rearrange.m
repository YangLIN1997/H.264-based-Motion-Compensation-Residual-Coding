function a=rearrange(A)
m=size(A);
length=m(1)*m(2);
lengthy=m(1)+m(2);
a(1)=A(1,1);
c=2;
index=1;
while index<=length
    if c<=m(1)+1
        if round(c/2)==c/2
       a(index:index+c-2)=diag(A(c-1:-1:1,1:c-1));
        else
       a(index:index+c-2)=diag(A(1:c-1,c-1:-1:1));
        end
        index=index+c-1;
    c=c+1;
    else
        try
       if round(c/2)==c/2
       a(index:index+lengthy-c)=diag(A(m(1):-1:lengthy-c,lengthy-c:m(2)));
       else
       a(index:index+lengthy-c)=diag(A(lengthy-c+2:m(2),m(1):-1:lengthy-c+2));
       end
    index=index+9-c;
    c=c+1;
        catch
            a(16)=A(m(1),m(2));
            index=index+1;
        end
    end
end