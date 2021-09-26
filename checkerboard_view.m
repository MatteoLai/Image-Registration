function checkerboard_view(Image1, Image2, NumberOfSquare)

[m,n] = size (Image1);

[p,q] = size (Image2);
if m<p
Image4=Image2;
Imaget = padarray(Image1, [round((max(m,p)-min(m,p))/2) round((max(n,q)-min(n,q))/2)], 'replicate');
Image3=imcrop(Imaget,[1 1 size(Image4,1)-1  size(Image4,2)-1 ]);
elseif m>p
Image4=Image1;
Imaget = padarray(Image2, [round((max(m,p)-min(m,p))/2) round((max(n,q)-min(n,q))/2)], 'replicate');
Image3=imcrop(Imaget,[1 1 size(Image4,1)-1  size(Image4,2)-1 ]); 
else
    Image3=Image1;
    Image4=Image2;    
end


C =checkerboard(floor(max(m,n)/NumberOfSquare),NumberOfSquare,NumberOfSquare);

C2 = C(1:max(m,p),1:max(n,q));

%ImageF = Image4.*uint16(C2) + Image3.*uint16((1-C2));

ImageF = Image4.*(C2) + Image3.*((1-C2));

imagesc(ImageF)
colormap gray; axis image; axis off;