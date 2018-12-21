function BZ=decod(C)
lengthy=length(C);
index=1;
index1=1;
BZ=zeros(1,16);
while index<lengthy
    count=0;
if C(index)=='1'
    BZ(index1)=0;
    index1=index1+1;
    index=index+1;
else
    while C(index)=='0'
        count=count+1;
        index=index+1;
    end
    while count>0
    BZ(index1)=BZ(index1)+2^(count-1)*str2num(C(index));
    count=count-1;
    index=index+1;
    end
    if C(index)=='1'
       BZ(index1)=-BZ(index1);
    end
        index1=index1+1;
        index=index+1;    
end
end
    

