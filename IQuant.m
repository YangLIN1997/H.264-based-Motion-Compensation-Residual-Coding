function [ DCT_residual_decode ] = IQuant( Quantization,QP)
% In: 4*4 matrix
% Out: 4*4 matrix
a=[10 11 13 14 16 18];
b=[16 18 20 23 25 29];
c=[13 14 16 18 20 23];
i=QP-floor(QP/6)*6+1;
V=[a(i) c(i) a(i) c(i);c(i) b(i) c(i) b(i)
    a(i) c(i) a(i) c(i);c(i) b(i) c(i) b(i)];

      DCT_residual_decode...
          =Quantization.*(V)*2^(floor(QP/6))/64;
end