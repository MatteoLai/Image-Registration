 function  mi = MI(Image1, Image2)
% MI = MutualInformation(Image1, Image2)
%
% Compute the mutual information between Image1 and Image2

eps = 1e-6;

h1 = imhist(uint8(Image1));
p1 = h1/(sum(h1(:)));
H1 = -sum(p1.*log2(p1 + eps)); % Entropy of Image1

h2 = imhist(uint8(Image2));
p2 = h2/(sum(h2(:)));
H2 = -sum(p2.*log2(p2 + eps)); % Entropy of Image2

JI = JointHistogram(Image1, Image2);
JI = JI/sum(JI(:));

H = JI.*log2(JI + eps);
H12 = -sum(H(:));

mi = H1 + H2 - H12;
end