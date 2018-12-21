function [ new_residual ] = IDCT( DCT_residual_decode)
        DCT_residual0=(zeros(4,4));
        DCT_residual1=(zeros(4,4));

        % 1 hori
        DCT_residual0(1,:)=DCT_residual_decode(1,:)+DCT_residual_decode(3,:);
        DCT_residual0(2,:)=DCT_residual_decode(1,:)-DCT_residual_decode(3,:);
        DCT_residual0(3,:)=0.5*DCT_residual_decode(2,:)-DCT_residual_decode(4,:);
        DCT_residual0(4,:)=DCT_residual_decode(2,:)+0.5*DCT_residual_decode(4,:);

        DCT_residual1(1,:)=DCT_residual0(1,:)+DCT_residual0(4,:);
        DCT_residual1(2,:)=DCT_residual0(2,:)+DCT_residual0(3,:);
        DCT_residual1(3,:)=DCT_residual0(2,:)-DCT_residual0(3,:);
        DCT_residual1(4,:)=DCT_residual0(1,:)-DCT_residual0(4,:);
       
        % 2 vert
        DCT_residual0(:,1)=DCT_residual1(:,1)+DCT_residual1(:,3);
        DCT_residual0(:,2)=DCT_residual1(:,1)-DCT_residual1(:,3);
        DCT_residual0(:,3)=0.5*DCT_residual1(:,2)-DCT_residual1(:,4);
        DCT_residual0(:,4)=DCT_residual1(:,2)+0.5*DCT_residual1(:,4);
        
        DCT_residual1(:,1)=DCT_residual0(:,1)+DCT_residual0(:,4);
        DCT_residual1(:,2)=DCT_residual0(:,2)+DCT_residual0(:,3);
        DCT_residual1(:,3)=DCT_residual0(:,2)-DCT_residual0(:,3);
        DCT_residual1(:,4)=DCT_residual0(:,1)-DCT_residual0(:,4);
   
        new_residual...
        =[DCT_residual1(:,1)';DCT_residual1(:,2)';...
        DCT_residual1(:,3)';DCT_residual1(:,4)']';
end