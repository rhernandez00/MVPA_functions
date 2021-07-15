function [ctx,cortexNii] = getCortex(cxFile)
%Loads cortex file, options are MNI2mm, Barney2MM, Barney, Datta
getDriveFolder;

cortexFile = getCortexFile(cxFile);
cortexNii = load_untouch_niiR(cortexFile);
cortexNii.img = single(logical(cortexNii.img));
ctx = cortexNii.img;