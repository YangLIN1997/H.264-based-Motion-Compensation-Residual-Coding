function [ DCT_residual ] = DCT( residual)
% In: 4*4 matrix
% Out: 4*4 matrix

DCT_residual0=(zeros(4,4));
DCT_residual1=(zeros(4,4));

        % 1 hori
        DCT_residual0(1,:)=residual(1,:)+residual(4,:);
        DCT_residual0(2,:)=residual(2,:)+residual(3,:);
        DCT_residual0(3,:)=residual(2,:)-residual(3,:);
        DCT_residual0(4,:)=residual(1,:)-residual(4,:);

        DCT_residual1(1,:)=DCT_residual0(1,:)+DCT_residual0(2,:);
        DCT_residual1(2,:)=2*DCT_residual0(4,:)+DCT_residual0(3,:);
        DCT_residual1(3,:)=DCT_residual0(1,:)-DCT_residual0(2,:);
        DCT_residual1(4,:)=DCT_residual0(4,:)-2*DCT_residual0(3,:);
        
        % 2 vert
        DCT_residual0(:,1)=DCT_residual1(:,1)+DCT_residual1(:,4);
        DCT_residual0(:,2)=DCT_residual1(:,2)+DCT_residual1(:,3);
        DCT_residual0(:,3)=DCT_residual1(:,2)-DCT_residual1(:,3);
        DCT_residual0(:,4)=DCT_residual1(:,1)-DCT_residual1(:,4);

        DCT_residual1(:,1)=DCT_residual0(:,1)+DCT_residual0(:,2);
        DCT_residual1(:,2)=2*DCT_residual0(:,4)+DCT_residual0(:,3);
        DCT_residual1(:,3)=DCT_residual0(:,1)-DCT_residual0(:,2);
        DCT_residual1(:,4)=DCT_residual0(:,4)-2*DCT_residual0(:,3);
   
        
        DCT_residual...
        =([DCT_residual1(:,1),DCT_residual1(:,2),...
        DCT_residual1(:,3),DCT_residual1(:,4)]);
end