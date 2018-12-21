function [ Quantization ] = Quant( DCT_residual,QP,inter)
% In: 4*4 matrix
% Out: 4*4 matrix

qbits=15+floor(QP/6);
a=[13107 11916 10082 9362 8192 7282];
b=[5243 4660 4194 3647 3355 2893];
c=[8066 7490 6554 5825 5243 4559];
i=QP-floor(QP/6)*6+1;
MF=[a(i) c(i) a(i) c(i);c(i) b(i) c(i) b(i)
    a(i) c(i) a(i) c(i);c(i) b(i) c(i) b(i)];
f_intra=2^qbits /3;
f_inter=2^qbits /6;

if inter==0
 Quantization...
=bitshift(floor(abs(DCT_residual).*double(MF)...
+f_intra),-qbits).*(((DCT_residual>0))+((DCT_residual>=0)-1));
else
     Quantization...
=bitshift(floor(abs(DCT_residual).*double(MF)...
+f_inter),-qbits).*(((DCT_residual>0))+((DCT_residual>=0)-1));
end