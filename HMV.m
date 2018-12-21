function [residual, mv] = HMV( reference, original, block_size, window_size,j,i )

        measure = inf;
        ori_block = original;

k=ceil(log2(window_size/2));
        x=i+window_size/2;y=j+window_size/2;
pre_block=(zeros(4,4));
ref_int = padarray(double(reference), [window_size/2+1 window_size/2+1], 'replicate', 'both');
 
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
                    mv(1,1,1) = x-i+d*m-window_size/2-1;
                    mv(1,1,2) = y-j+d*n-window_size/2-1;
                end
       end
   end
   x=mv(1,1,1)+window_size/2+1+i;
   y=mv(1,1,2)+window_size/2+1+j;
end

% half
   stop1 = y+block_size-1;
   stop2 = x+block_size-1;
   d=1;
   for n=-0.5:0.5:0.5
       for m=-0.5:0.5:0.5
           if abs(n)==0.5 && abs(m)==0.5
           ref=round((ref_int((y+2*d*n):(stop1+2*d*n), (x+2*d*m):(stop2+2*d*m))...
               +ref_int((y+2*d*n):(stop1+2*d*n), (x):(stop2))...
               +ref_int((y):(stop1), (x+2*d*m):(stop2+2*d*m))...
               +ref_int((y):(stop1), (x):(stop2)))/4);
           elseif n==0 && abs(m)==0.5
           ref=round((ref_int((y):(stop1), (x+2*d*m):(stop2+2*d*m))...
               +ref_int((y):(stop1), (x):(stop2)))/2); 
           elseif abs(n)==0.5 && m==0
           ref=round((ref_int((y+2*d*n):(stop1+2*d*n), (x):(stop2))...
               +ref_int((y):(stop1), (x):(stop2)))/2);  
           else
               ref=ref_int((y):(stop1), (x):(stop2));
           end
           
           measure_temp = norm(ori_block-ref,'fro')^2;
       
                if measure_temp < measure
                    measure = measure_temp;
                    pre_block = ref;
                    mv(1,1,1) = x-i+d*m-window_size/2-1;
                    mv(1,1,2) = y-j+d*n-window_size/2-1;
                end
       end
   end

predict = pre_block;
residual = (ori_block-predict);

end


