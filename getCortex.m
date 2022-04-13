function [ctx,cortexNii,original] = getCortex(cxFile)
%Loads cortex file, options are MNI2mm, Barney2MM, Barney, Datta

cortexFile = getCortexFile(cxFile);
cortexNii = load_untouch_niiR(cortexFile);
original = cortexNii.img;
cortexNii.img = single(logical(cortexNii.img));
ctx = cortexNii.img;