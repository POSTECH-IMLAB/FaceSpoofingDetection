function [ H_Con ] = overlapLBP( I, mapping, mapping2 )

    [I1, I2, I3, I4, I5, I6, I7, I8, I9] = overlapImageForLBP(I);
    H1 = lbp(I1,1,8,mapping,'nh');
    H2 = lbp(I2,1,8,mapping,'nh');
    H3 = lbp(I3,1,8,mapping,'nh');
    H4 = lbp(I4,1,8,mapping,'nh');
    H5 = lbp(I5,1,8,mapping,'nh');
    H6 = lbp(I6,1,8,mapping,'nh');
    H7 = lbp(I7,1,8,mapping,'nh');
    H8 = lbp(I8,1,8,mapping,'nh');
    H9 = lbp(I9,1,8,mapping,'nh');
    H10 = lbp(I,2,8,mapping,'nh');
    H11 = lbp(I, 2, 16, mapping2, 'nh');
    H_Con = [H1 H2 H3 H4 H5 H6 H7 H8 H9 H10 H11];

    

end

