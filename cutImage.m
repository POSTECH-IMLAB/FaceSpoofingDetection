function cutI = cutImage( I, cutTop, cutBottom )
%CUTIMAGE 이 함수의 요약 설명 위치
%   자세한 설명 위치
% cutTopBottom = 25;
% I = imread('fake','jpg');
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

% figure;
% imshow(I)

R = R(1:size(R, 1)-cutBottom, :);
R = R((cutTop+1):size(R, 1), :);
G = G(1:size(G, 1)-cutBottom, :);
G = G((cutTop+1):size(G, 1), :);
B = B(1:size(B, 1)-cutBottom, :);
B = B((cutTop+1):size(B, 1), :);

cutI(:, :, 1) = R;
cutI(:, :, 2) = G;
cutI(:, :, 3) = B;

% figure;
% imshow(cutI)

end

