function BlurMeasure = noRefferencePerceptualBlurMetric(I)

% I = gpuArray(imread('circuit.tif'));
% I = imread('circuit.tif');
% fake : 2.3618, genuine : 2.6168
%I = rgb2gray(imread('real.jpg'));
%I = imread('real.jpg');
%I = I(:,:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I = rgb2gray(I);
BW = edge(I,'Sobel', [], 'vertical');

[sizeY, sizeX] = size(BW);

% rowArr = zeros(1, sizeX);

TotBM = 0;
edgeIdx = 0;
NbEdges = 0;
leftLocalMaxima = 0;
leftLocalMaximaIdx = 0;
leftLocalMinima = 0;
leftLocalMinimaIdx = 0;
rightLocalMaxima = 0;
rightLocalMaximaIdx = 0;
rightLocalMinima = 0;
rightLocalMinimaIdx = 0;

for k = 1:sizeY,
    oriRowArr = I(k, 1:sizeX);
    edgeRowArr = BW(k, 1:sizeX);
    for i = 1 : sizeX,
        % find edge index of one row
        if edgeRowArr(i) == 1,
            edgeIdx = i;
            NbEdges = NbEdges + 1;
            % fine left local maxima & minima
            if i > 2,
                leftLocalMaxima = oriRowArr(i-1);
                leftLocalMinima = oriRowArr(i-1);
                leftLocalMaximaIdx = i-1;
                leftLocalMinimaIdx = i-1;
                % find left local maxima
                for j = i-1 : -1 : 2,
                    if leftLocalMaxima <= oriRowArr(j-1),
                        leftLocalMaxima = oriRowArr(j-1);
                        leftLocalMaximaIdx = j-1;
                    else
                        break;
                    end
                end
                % find left local minima
                for j = i-1 : -1 : 2,
                    if leftLocalMinima >= oriRowArr(j-1),
                        leftLocalMinima = oriRowArr(j-1);
                        leftLocalMinimaIdx = j-1;
                    else
                        break;
                    end
                end
            else
                leftLocalMaxima = oriRowArr(i);
                leftLocalMinima = oriRowArr(i);
                leftLocalMaximaIdx = i;
                leftLocalMinimaIdx = i;
            end
            
            % fine right local maxima & minima
            if i < sizeX - 1,
                rightLocalMaxima = oriRowArr(i+1);
                rightLocalMinima = oriRowArr(i+1);
                rightLocalMaximaIdx = i+1;
                rightLocalMinimaIdx = i+1;
                % find right local maxima
                for j = i+1 : 1 : sizeX-1,
                    if rightLocalMaxima <= oriRowArr(j+1),
                        rightLocalMaxima = oriRowArr(j+1);
                        rightLocalMaximaIdx = j+1;
                    else
                        break;
                    end
                end
                % find right local minima
                for j = i+1 : 1 : sizeX-1,
                    if rightLocalMinima >= oriRowArr(j+1),
                        rightLocalMinima = oriRowArr(j+1);
                        rightLocalMinimaIdx = j+1;
                    else
                        break;
                    end
                end
                
            else
                rightLocalMaxima = oriRowArr(i);
                rightLocalMinima = oriRowArr(i);
                rightLocalMaximaIdx = i;
                rightLocalMinimaIdx = i;
            end
            
            leftMinRightMaxGap = rightLocalMaximaIdx - leftLocalMinimaIdx;
            leftMaxRightMinGap = rightLocalMinimaIdx - leftLocalMaximaIdx;
            if leftMinRightMaxGap < leftMaxRightMinGap,
                TotBM = TotBM + leftMinRightMaxGap;
            else
                TotBM = TotBM + leftMaxRightMinGap;
            end
        end
    end
end

% BlurMeasure = TotBM/NbEdges;
BlurMeasure = TotBM/(NbEdges * sizeX);

end


