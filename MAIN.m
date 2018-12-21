
%% start

clc,clear,close all;
tic
%% load

file='foreman_420.yuv';
yuv_data = fread(fopen(file,'r'));   

width=352;
height=288;
QP_intra=22;    %qp for intra
QP_inter=24;    %qp for inter

half=0; %half pixel switch!!!!  0=FSB/3step     1=hal-pixel
%% Filter out the YUV data of the target frame  INTRA
    
frame_size = (1 + 0.25 * 2) * width * height;
Y_size=width * height;
UV_size=0.25 * width * height;

nthFrame=1;

intra_frame= yuv_data((nthFrame-1)*frame_size+1:nthFrame*frame_size);

intra_Y=intra_frame(1:Y_size);
intra_Y=reshape(intra_Y, width, height)';

transmission=zeros(4,4,height*width/4/4,3);
%% Intra and inter: Motion estimation
search_range=16; %+-8
block_size=4; %4*4
inter_Y=(zeros(height,width,10));
residual=(zeros(height,width,3));
new_frame=uint8(zeros(height,width,3));
old_frame=uint8(zeros(height,width,3));
old_frame(:,:,1)=intra_Y;
mv = zeros(width/block_size, height/block_size, 2,10);
predict=uint8(zeros(height,width,3));

% intra
for i = 1 : block_size : height
    for j = 1 : block_size : width
       DCT_r=DCT((double(old_frame(i:i+block_size-1,j:j+block_size-1,1))));  
 Qua=Quant( DCT_r,QP_intra,0);  
      DCT_residual_de=IQuant( Qua,QP_intra);
 new_re=(IDCT(DCT_residual_de)); 
[predict(i:i+block_size-1,j:j+block_size-1,1)] = uint8(new_re);
    end 
end

reference=predict(:,:,1);
yuv(:,:,1)=uint8(reference);

% inter
for nthFrame=2:10
inter_frame= yuv_data((nthFrame-1)*frame_size+1:nthFrame*frame_size);
inter_Y(:,:,nthFrame)=reshape(inter_frame(1:Y_size), width, height)';
old_frame(:,:,nthFrame)=inter_Y(:,:,nthFrame);
original=inter_Y(:,:,nthFrame);
for i = 1 : block_size : height
    for j = 1 : block_size : width
        move1 = ceil(i/block_size);
        move2 = ceil(j/block_size);
        
        % select motion estimation method:
        
    % full search block
[residual(i:i+block_size-1,j:j+block_size-1,nthFrame),mv(move2,move1,:,nthFrame)] = FMV(reference , original(i:i+block_size-1,j:j+block_size-1), block_size, search_range,i,j );
    % 3-step
%[residual(i:i+block_size-1,j:j+block_size-1,nthFrame),mv(move2,move1,:,nthFrame)] = threeMV(reference , original(i:i+block_size-1,j:j+block_size-1), block_size, search_range,i,j );
    % half-pixel
%[residual(i:i+block_size-1,j:j+block_size-1,nthFrame),mv(move2,move1,:,nthFrame)] = HMV(reference , original(i:i+block_size-1,j:j+block_size-1), block_size, search_range,i,j );

DCT_r=DCT(double(residual(i:i+block_size-1,j:j+block_size-1,nthFrame)));  
 Qua=Quant( DCT_r,QP_inter,1);  
      DCT_residual_de=IQuant( Qua,QP_inter);
 new_re=(IDCT(DCT_residual_de)); 
 
 % prediction with half-pixel switch
[predict(i:i+block_size-1,j:j+block_size-1,nthFrame)] = reconstruct( (reference),new_re,mv(move2,move1,:,nthFrame),search_range,i,j,half);
    end
end
reference=predict(:,:,nthFrame);
yuv=uint8(zeros(height,width,3));
end


%% DCT

residual(:,:, 1)=intra_Y;
DCT_block_size=block_size;
DCT_residual=(zeros(height,width,3));
DCT_residual_hf=(zeros(height,width,3));
residual=double(residual);
for nthFrame=1:10
for i = 1 : DCT_block_size : height
    for j = 1 : DCT_block_size : width
        DCT_residual(i:i+DCT_block_size-1,j:j+DCT_block_size-1,nthFrame)...
            =DCT( residual(i:i+DCT_block_size-1,j:j+DCT_block_size-1,nthFrame));  
    end
end
end

%% Quantization

% intra
for i = 1 : DCT_block_size : height
    for j = 1 : DCT_block_size : width
 Quantization(i:i+DCT_block_size-1,j:j+DCT_block_size-1,1)...
 =Quant( DCT_residual(i:i+DCT_block_size-1,j:j+DCT_block_size-1,1),QP_intra,0);  

    end
end

% inter
for nthFrame=2:10
    for i = 1 : DCT_block_size : height
        for j = 1 : DCT_block_size : width
         Quantization(i:i+DCT_block_size-1,j:j+DCT_block_size-1,nthFrame)...
        =Quant( DCT_residual(i:i+DCT_block_size-1,j:j+DCT_block_size-1,nthFrame),QP_inter,1);  
        end
    end
end

%% Zig Zag Scaning, encode, decode and rezigzag
Quant_zig_de=zeros(DCT_block_size*DCT_block_size);
f=Quantization;
for nthFrame=1:10
    QT=Quantization(:,:,nthFrame);
    ZigZag_before=split(QT);
    count=1;
    for i=1:min(size(ZigZag_before))
        for j=1:max(size(ZigZag_before))
            ZigZag_after{count}=rearrange(ZigZag_before{i,j});
            count=count+1;
        end
    end
    for j=1:max(size(ZigZag_after))
        Current_string=[];
        for i=1:16
            [a,b]=expgolomb(ZigZag_after{1,j}(i));
            Current_string=strcat(Current_string,b);
        end
            signal{nthFrame,j}=Current_string;
    end
    
end

save('signal.mat','signal')
frame_length=zeros(10,2);
for frame=1:10
    for i=1:max(size(signal))
        frame_length(frame,2)=frame_length(frame,2)+length(signal{frame,i});
    end
end
J=open('signal.mat');
for frame=1:10
    for i=1:max(size(J.signal))
        Mstream(i,1:16,frame)=decod(J.signal{frame,i}(1:end));
    end
end

A=ones(4);
for frame=1:10
    for i=1:max(size(J.signal))
        REblock{i}=rebuild(Mstream(i,:,frame));
    end
    Qnew=reshape(REblock,88,72)';
    Quantization(:,:,frame)=extract(Qnew);
end
m=Quantization;
error=sum(sum((f-m).^2));
delete('signal.mat')
clear J

%% Inverse Quantization
DCT_residual_decode=zeros(height,width,10);

% intra
for i = 1 : DCT_block_size : height
    for j = 1 : DCT_block_size : width
      DCT_residual_decode(i:i+DCT_block_size-1,j:j+DCT_block_size-1,1)...
 =IQuant( Quantization(i:i+DCT_block_size-1,j:j+DCT_block_size-1,1),QP_intra);
    end
end

% inter
for nthFrame=2:10
for i = 1 : DCT_block_size : height
    for j = 1 : DCT_block_size : width
      DCT_residual_decode(i:i+DCT_block_size-1,j:j+DCT_block_size-1,nthFrame)...
 =IQuant( Quantization(i:i+DCT_block_size-1,j:j+DCT_block_size-1,nthFrame),QP_inter);   
    end
end
end

%% Inverse DCT

frame=uint8(zeros(height,width,10));

new_residual=(zeros(height,width,nthFrame));
for nthFrame=1:10
for i = 1 : DCT_block_size : height
    for j = 1 : DCT_block_size : width
              new_residual(i:i+DCT_block_size-1,j:j+DCT_block_size-1,nthFrame)...
            =IDCT( DCT_residual_decode(i:i+DCT_block_size-1,j:j+DCT_block_size-1,nthFrame));  
    end
end
end

%% Prediction at decoder side

tmp_frame=uint8(zeros(height,width));
ref_int=uint8(new_residual(:,:,1));
new_frame(:,:, 1)=new_residual(:,:,1);
PSNR=zeros(1,10);
% intra
yuv(:,:,1)=new_frame(:,:,1);
figure (1)
subplot(3,3,1)
imshow(yuv(:,:,1)),title('1st' );
MSE=sum(sum(double(old_frame(:,:,1)-new_frame(:,:,1)).^2))/(width*height);
PSNR(1)=10*log10(255^2/MSE);
figure (2)

% inter
for nthFrame=2:10
    
for i = 1 : block_size : width
    for j = 1 : block_size : height
        
         % prediction with half-pixel switch
[tmp_frame(j:j+block_size-1,i:i+block_size-1)] = reconstruct( ref_int,new_residual(j:j+block_size-1,i:i+block_size-1,nthFrame),mv(ceil(i/block_size),ceil(j/block_size),:,nthFrame),search_range,j,i,half);
    end
end
ref_int=tmp_frame;
new_frame(:,:, nthFrame)=uint8(tmp_frame);
yuv(:,:,1)=new_frame(:,:,nthFrame);
subplot(3,3,nthFrame-1)
imshow(yuv(:,:,1)),title(num2str(nthFrame) );
sum(sum((predict(:,:,nthFrame)-new_frame(:,:,nthFrame)).^2))

MSE=sum(sum(double(old_frame(:,:,nthFrame)-new_frame(:,:,nthFrame)).^2))/(width*height);

% maximum Level is 255 for the original 8 bits image
PSNR(nthFrame)=10*log10(255^2/MSE);

end

PSNR

toc