function [residual, mv] = threeMV( reference, original, block_size, window_size,j,i )

        measure = inf;
        ori_block = original;

k=ceil(log2(window_size/2));
x=i+window_size/2;y=j+window_size/2;
pre_block=(zeros(4,4));
ref_int = padarray(double(reference), [window_size/2 window_size/2], 'replicate', 'both');

for s=k:-1:1
   stop1 = y+block_size-1;
   stop2 = x+block_size-1;
   d=2^(s-1);
   for n=-1:1
       for m=-1:1
       measure_temp = norm(ori_block-ref_int((y+d*n):(stop1+d*n), (x+d*m):(stop2+d*m)),'fro')^2;
                if measure_temp < measure
                    measure = measure_temp;
                    pre_block = ref_int((y+d*n):(stop1+d*n), (x+d*m):(stop2+d*m));
                    mv(1,1,1) = x-i+d*m-window_size/2;
                    mv(1,1,2) = y-j+d*n-window_size/2;
                end
       end
   end
   x=mv(1,1,1)+window_size/2+i;
   y=mv(1,1,2)+window_size/2+j;
end
        predict = pre_block;
residual = (ori_block-predict);
end
