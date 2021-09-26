# Image-Registration
Medical DICOM images registration using three different approaches:
- minimization of the Sum of Squared Differences (SSD);
- maximization of the Normalized Cross Correlation (NCC);
- maximization of the Mutual Information (MI).

This repo contains:
- "_CT-0001-0103.dcm_", "_MRI-0001-0022.dcm_", "_PET-0001-0030.dcm_" and "_MRIrot_", the images to be registered.
- "_main_Registration.m_" is the main script which calls the following functions:
   - "_NStepSearch.m_" (a modification of existing algorithms made by myself), useful to optimize the registration, which calls one of the following functions:
     - "_SSD.m_", which computes the Sum of Squared Differences;
     - "_NCC.m_", which computes the Normalized Cross Correlation;
     - "_MI.m_", which computes the Mutual Information, calling the function "_JointHistogram.m_";
   - "_zeroPadding.m_", useful to uniform images after scaling (note: this function was not writted by myself);
   - "_checkerboard_view.m_", useful to visualize the registration and visually analyze the result (note: this function was not writted by myself). 
