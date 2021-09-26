function ssd = SSD(I1, I2)
% ssd = SSD(I1, I2)
%
% Sum of Squared Differences between images I1 and I2.

ssd = sum((I1-I2).^2,'all');

end