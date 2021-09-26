function [tx, ty] = NStepSearch(I_fixed, I_moving, varargin)
% [tx, ty] = NStepSearch(I_fixed, I_moving, 'bmd')
%
% N-Step Search is a modification of 3-Step Search (3SS) algorithm, with
% the only difference that it halves d (size of translation) till it reaches
% the size of a pixel.
%
% Input:
% - I_fixed:  Image fixed during translation
% - I_moving: Image moving during translation
% - bmd (Block Matching Distance), could be:
%       'ssd' -> the algorithm minimize the Sum of Squared Differences (default)
%       'ncc' -> the algorithm maximize the Normalized Cross Correlation
%       'mi'  -> the algorithm maximize the Mutual Information
% Output:
% tx, ty : coordinates of best translation

if nargin < 3
    mode = 'ssd';
else
    mode = varargin{1};
end

[s1,s2] = size(I_moving);
d = round(s1/4); % First size of translation
tx = 0; ty = 0;
ssd = zeros(1,9);
ncc = ssd;
mi = ssd;

while d > 0.5
    % Translate I_moving in the 8 pixel around (tx,ty):
    %
    %      (tx-d, ty+d)      (tx, ty+d)        (tx+d, ty+d)
    %
    %       (tx-d, ty)        (tx, ty)          (tx+d, ty)
    %
    %      (tx-d, ty-d)      (tx, ty-d)        (tx+d, ty-d)
    
    dx = [0, 0, 0, d, d, d, -d, -d, -d];
    dy = [0, d, -d, 0, d, -d, 0, d, -d];
    for i = 1:length(ssd)
        ImageT = imtranslate(I_moving, [tx+dx(i), ty+dy(i)]);
        if strcmp(mode,'ssd')
            ssd(i) = SSD(I_fixed, ImageT);
        elseif strcmp(mode,'ncc')
            ncc(i) = NCC(I_fixed, ImageT);
        elseif strcmp(mode,'mi')
            mi(i) = MI(I_fixed, ImageT);
        end
    end
        % Find the translation that maximize the measure of similarity:
        if strcmp(mode,'ssd')
            idx = find(ssd == min(ssd));
        elseif strcmp(mode,'ncc')
            idx = find(ncc == max(ncc));
        elseif strcmp(mode,'mi')
            idx = find(mi == max(mi));
        end
    
    tx = tx + dx(idx); 
    ty = ty + dy(idx);
    d = floor(d/2);
end
end