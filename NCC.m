function ncc = NCC(I1, I2)
% ncc = NCC(I1, I2)
%
% Normalized Cross Correlation od images I1 and I2

mu1 = mean(I1, 'all');
mu2 = mean(I2, 'all');

ncc = sum((I1 - mu1).*(I2 - mu2),'all')./...
    (sqrt(sum((I1-mu1).^2,'all').*(sum((I2-mu2).^2,'all'))));

end