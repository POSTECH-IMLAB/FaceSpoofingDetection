function glcmFeatures = GLCMFeatures(glcm, numLevels)

% clear all;
% I = imread('real.jpg');
% I = rgb2gray(imread('fake.jpg'));
% numLevels = 16;
% glcm = graycomatrix(I, 'NumLevels', numLevels, 'offset', [0 1]);
% glcm45 = graycomatrix(I, 'NumLevels', numLevels, 'offset', [-1 1]);
% glcm90 = graycomatrix(I, 'NumLevels', 16, 'offset', [-1 0]);
% glcm135 = graycomatrix(I, 'NumLevels', 16, 'offset', [-1 -1]);

normal = sum(sum(glcm, 1), 2);
glcm = glcm ./ normal;

fEnergy = 0; % same with Angular Second Moment Feature
fContrast = 0;
fHomogeneity = 0;
fEntropy = 0;
ux = 0; % mean of p_x;
uy = 0; % mean of p_y;
pxy = zeros(numLevels*numLevels, 1);
pdxy = zeros(numLevels, 1);
px = zeros(numLevels, 1);
for i = 1 : numLevels,
    for j = 1 : numLevels,
        % energy
        fEnergy = fEnergy + ( glcm(i, j) * glcm(i, j) );
        % contrast
        fContrast = fContrast + ( (i-j)*(i-j) * glcm(i, j) );
        % homogeneity
        fHomogeneity = fHomogeneity + glcm(i, j)/( 1+ (i-j)*(i-j) );
        % entropy
        if glcm(i,j) ~= 0,
            fEntropy = fEntropy + glcm(i,j)*log( glcm(i,j) );
        end
        % mean of p_x
        ux = ux + (i-1)*glcm(i,j);
        % mean of p_y
        uy = uy + (j-1)*glcm(i,j);
        % p_{x+y}(k)
        pxy(i+j-1) = pxy(i+j-1) + glcm(i,j);
        % p_{x-y}(k)
        if i >= j, 
            pdxy(i-j+1) = pdxy(i-j+1) + glcm(i,j);
        else 
            pdxy(j-i+1) = pdxy(j-i+1) + glcm(i,j);
        end
        % p_x
        px(i) = px(i) + glcm(i,j);        
    end
end

stdDevix = 0;
stdDeviy = 0;
fVariance = 0;
hx = 0;
DiffAver = 0;
fSumAver = 0;
fSumEntr = 0;
fDiffEntr = 0;
for i = 1 : numLevels,
    % Variance
    for j = 1 : numLevels,
        stdDevix = stdDevix + ( ((i-1)-ux)*((i-1)-ux) * glcm(i,j) );
        stdDeviy = stdDeviy + ( ((i-1)-uy)*((i-1)-uy) * glcm(i,j) );
        fVariance = fVariance + ((i-1)-ux)*((i-1)-ux) * glcm(i,j);
    end
    
    if px(i) ~= 0,
        hx = hx + px(i) * log(px(i));
    end
    
    % sum average
    DiffAver = DiffAver + (i-1)*pdxy(i);
    fSumAver = fSumAver + (2*(i-1))*pxy(2*i-1);
    fSumAver = fSumAver + (2*(i+1-1))*pxy(2*i+1-1);
    
    % sum entropy
    if pxy(2*i - 1) ~= 0,
        fSumEntr = fSumEntr + pxy(2*i-1) * log(pxy(2*i-1));
    end
    if pxy(2*i + 1 - 1) ~= 0,
        fSumEntr = fSumEntr + pxy(2*i+1-1)*log(pxy(2*i+1-1));
    end
    
    % different entropy
    if pdxy(i) ~= 0,
        fDiffEntr = fDiffEntr + pdxy(i)*log(pdxy(i));
    end
end

fCorrelation = 0;
hxy1 = 0;
hxy2 = 0;
fSumVari = 0;
fDiffVari = 0;
for i = 1 : numLevels,
    for j = 1 : numLevels,
        fCorrelation = fCorrelation + ( ((i-1)-ux)*((j-1)-ux)*glcm(i,j) ) / (stdDevix * stdDevix);
        if px(i) ~= 0 && px(j) ~= 0,
            hxy1 = hxy1 + glcm(i,j) * log(px(i)*px(j));
            hxy2 = hxy2 + px(i) * px(j) * log(px(i)*px(j));
        end
        fSumVari = fSumVari + ( (2*(i-1)-1) - fSumAver ) * ( (2*(i-1)-1) - fSumAver ) * pxy(2*i-1);
        fSumVari = fSumVari + ( (2*(i-1)+1-1) - fSumAver ) * ( (2*(i-1)+1-1) - fSumAver ) * pxy(2*i+1-1);
        % different variance
        fDiffVari = fDiffVari + ( (i-1) - DiffAver ) * ( (i-1) - DiffAver) * pdxy(i);
    end
end

hxy1 = -hxy1;
hxy2 = -hxy2;
% InfMeaCor1
fInMeaCor1 = ( fEntropy - hxy1 ) / hx;
% InfMeaCor2
fInMeaCor2 = sqrt( 1 - exp( -2*(hxy2 - fEntropy) ) );

% glcmFeatures.fContrast = fContrast;
% glcmFeatures.fCorrelation = fCorrelation;
% glcmFeatures.fDiffEntr = fDiffEntr;
% glcmFeatures.fDiffVari = fDiffVari;
% glcmFeatures.fEnergy = fEnergy;
% glcmFeatures.fEntropy = fEntropy;
% glcmFeatures.fHomogeneity = fHomogeneity;
% glcmFeatures.fInMeaCor1 = fInMeaCor1;
% glcmFeatures.fInMeaCor2 = fInMeaCor2;
% glcmFeatures.fSumAver = fSumAver;
% glcmFeatures.fSumEntr = fSumEntr;
% glcmFeatures.fSumVari = fSumVari;
% glcmFeatures.fVariance = fVariance;

glcmFeatures = zeros(11,1);
glcmFeatures(1,1) = fContrast;
glcmFeatures(2,1) = fCorrelation;
glcmFeatures(3,1) = fDiffEntr;
glcmFeatures(4,1) = fDiffVari;
glcmFeatures(5,1) = fEnergy;
glcmFeatures(6,1) = fEntropy;
glcmFeatures(7,1) = fHomogeneity;
glcmFeatures(8,1) = fSumAver;
glcmFeatures(9,1) = fSumEntr;
glcmFeatures(10,1) = fSumVari;
glcmFeatures(11,1) = fVariance;


end