function JI = JointHistogram(Image1, Image2)
% JI = JointHistogram(Image1, Image2)
% 
% Compute the joint histogram between Image1 and Image2

Image1 = uint8(Image1); % In order to reduce computational time
Image2 = uint8(Image2);

[m1,n1] = size(Image1);
[m,n] = size(Image2);

M1 = round(max(Image1(:)));
M2 = round(max(Image2(:)));
JI = zeros(M1+1, M2+1);

if m1 == m && n1 == n
    
    for i = 1:m
        for j = 1:n
            I1 = round(Image1(i,j)) +1;
            I2 = round(Image2(i,j)) +1;
            JI(I1,I2) = JI(I1,I2) + 1;
        end
    end
    
else
   error('Images must have the same dimention!') 
end

% figure
% image(JI), colormap gray, axis image
% title 'Joint histogram'

end