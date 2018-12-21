function [residual, mv] = FMV( reference, original, block_size, window_size,j,i )


ref_int = padarray(double(reference), [window_size/2 window_size/2], 'replicate', 'both');

        stop1 = j+block_size-1;
        stop2 = i+block_size-1;
        ori_block = original;
        measure = inf;
        for k = 0 : window_size
            for l = 0 : window_size-1
                measure_temp = norm(ori_block-ref_int((j+l):(stop1+l), (i+k):(stop2+k)),'fro')^2;
                if measure_temp < measure
                    measure = measure_temp;
                    pre_block = ref_int((j+l):(stop1+l), (i+k):(stop2+k));
                    mv(1,1,1) = (k-window_size/2);
                    mv(1,1,2) = (l-window_size/2);
                end
            end
        end
        predict = pre_block;

residual = (ori_block-predict);

end