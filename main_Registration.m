close all
clear
clc

%% visualizzazioni delle 3 immagini MRI / CT / PET
figure(1);
subplot(1,3,1)
info_ImageCT = dicominfo('CT-0001-0103.dcm');
ImageCT = dicomread('CT-0001-0103.dcm');
ImageCT = double(ImageCT);
imagesc(ImageCT,[1000 1125])
axis image; colormap gray; axis off;
title('CT')

subplot(1,3,2)
info_ImageMRI = dicominfo('MRI-0001-0022.dcm');
ImageMRI = dicomread('MRI-0001-0022.dcm');
ImageMRI = double(ImageMRI);
imagesc(ImageMRI)
axis image; colormap gray; axis off;
title('MRI')

subplot(1,3,3)
info_ImagePET = dicominfo('PET-0001-0030.dcm');
ImagePET = dicomread('PET-0001-0030.dcm');
ImagePET = double(ImagePET);
imagesc(ImagePET)
axis image; colormap gray; axis off;
title('PET')

%% Scaling
resCT = info_ImageCT.PixelSpacing; % CT is the image with best resolution
resMRI = info_ImageMRI.PixelSpacing;
resPET = info_ImagePET.PixelSpacing;

scaleMRI = resMRI(1)/resCT(1);
scalePET = resPET(1)/resCT(1);
ImageMRIs = imresize(ImageMRI, scaleMRI); % s: scaling
ImagePETs = imresize(ImagePET, scalePET); % s: scaling

% Padding of imeges to uniform dimensions:
ImageCTp = zeroPadding(ImagePETs, ImageCT); % p: padding
ImageMRIp = zeroPadding(ImagePETs, ImageMRIs); % p: padding
ImagePETp = ImagePETs; 

% Visualization of results:
figure
subplot(1,3,1)
imagesc(ImageCTp,[1000 1125])
axis image; colormap gray; axis off;
title('CT (padding)')

subplot(1,3,2)
imagesc(ImageMRIp)
axis image; colormap gray; axis off;
title('MRI (scaling + padding)')

subplot(1,3,3)
imagesc(ImagePETp)
axis image; colormap gray; axis off;
title('PET (scaling)')

%% Translation
tic

% CT-MRI translation
[txMRI_ssd, tyMRI_ssd] = NStepSearch(ImageCTp, ImageMRIp, 'ssd');
ImageMRIt_ssd = imtranslate(ImageMRIp, [txMRI_ssd, tyMRI_ssd]);

[txMRI_ncc, tyMRI_ncc] = NStepSearch(ImageCTp, ImageMRIp, 'ncc');
ImageMRIt_ncc = imtranslate(ImageMRIp, [txMRI_ncc, tyMRI_ncc]);

[txMRI_MI, tyMRI_MI] = NStepSearch(ImageCTp, ImageMRIp, 'mi');
ImageMRIt_MI = imtranslate(ImageMRIp, [txMRI_MI, tyMRI_MI]);

% CT-PET translation
[txPET_ssd, tyPET_ssd] = NStepSearch(ImageCTp, ImagePETp, 'ssd');
ImagePETt_ssd = imtranslate(ImagePETp, [txPET_ssd, tyPET_ssd]);

[txPET_ncc,tyPET_ncc] = NStepSearch(ImageCTp, ImagePETp, 'ncc');
ImagePETt_ncc = imtranslate(ImagePETp, [txPET_ncc, tyPET_ncc]);

[txPET_MI, tyPET_MI] = NStepSearch(ImageCTp, ImagePETp, 'mi');
ImagePETt_MI = imtranslate(ImagePETp, [txPET_MI, tyPET_MI]);

% Visualization of the results:
NumberOfSquare = 4;

figure('Name','CT-MRI translation')
subplot(221)
checkerboard_view(ImageCTp, ImageMRIp, NumberOfSquare)
title('CT-MRI (pre-registration)')
subplot(222)
checkerboard_view(ImageCTp, ImageMRIt_ssd, NumberOfSquare)
title('CT-MRI: minimization of SSD')
subplot(223)
checkerboard_view(ImageCTp, ImageMRIt_ncc, NumberOfSquare)
title('CT-MRI: maximization of NCC')
subplot(224)
checkerboard_view(ImageCTp, ImageMRIt_MI, NumberOfSquare)
title('CT-MRI: maximization of MI')

figure('Name','CT-PET translation')
subplot(221)
checkerboard_view(ImageCTp, ImagePETp, NumberOfSquare)
title('CT-PET (pre-registration)')
subplot(222)
checkerboard_view(ImageCTp, ImagePETt_ssd, NumberOfSquare)
title('CT-PET: minimization of SSD')
subplot(223)
checkerboard_view(ImageCTp, ImagePETt_ncc, NumberOfSquare)
title('CT-PET: maximization of NCC')
subplot(224)
checkerboard_view(ImageCTp, ImagePETt_MI, NumberOfSquare)
title('CT-PET: maximization of MI')
toc

%% Rotation
MRIrot = dicomread('MRIrot');
MRIrot = double(MRIrot);
[m,n] = size(ImageMRI);

figure
subplot(121)
imagesc(MRIrot), colormap gray, axis image
title 'MRIrot'
subplot(122)
imagesc(ImageMRI), colormap gray, axis image
title 'ImageMRI'

rotation = 30;
ssd_vec = zeros(1, rotation-1);
ncc_vec = zeros(1, rotation-1);
mi_vec = zeros(1, rotation-1);
count = 1;
for theta = 1:rotation
    ImageMRIr = imrotate(MRIrot, theta, 'nearest', 'crop');
    ssd_vec(count) = SSD(ImageMRIr, ImageMRI);
    ncc_vec(count) = NCC(ImageMRIr, ImageMRI);
    mi_vec(count) = MI(ImageMRIr, ImageMRI);
    count = count+1;
end

theta_ssd = find(ssd_vec == min(ssd_vec(:)));
ImageMRIr_ssd = imrotate(MRIrot, theta_ssd, 'nearest', 'crop');

theta_ncc = find(ncc_vec == max(ncc_vec(:)));
ImageMRIr_ncc = imrotate(MRIrot, theta_ncc, 'nearest', 'crop');

theta_mi = find(mi_vec == max(mi_vec(:)));
ImageMRIr_mi = imrotate(MRIrot, theta_mi, 'nearest', 'crop');

% Visualization of results:
figure('Name','MRI-MRIrot')
subplot(221)
checkerboard_view(ImageMRI, MRIrot, NumberOfSquare)
title('MRI-MRIrot (pre-registration)')
subplot(222)
checkerboard_view(ImageMRI, ImageMRIr_ssd, NumberOfSquare)
title('MRI-MRIrot: minimization of SSD')
subplot(223)
checkerboard_view(ImageMRI, ImageMRIr_ncc, NumberOfSquare)
title('MRI-MRIrot: maximization of NCC')
subplot(224)
checkerboard_view(ImageMRI, ImageMRIr_mi, NumberOfSquare)
title('MRI-MRIrot: maximization of MI')