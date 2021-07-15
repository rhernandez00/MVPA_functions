clc
clear all
addpath('C:\Users\Hallgato\Dropbox\MVPA\funciones')

fileName = 'C:\Users\Hallgato\Google Drive\Faces_Hu\RSAHumSTD\task1model1r3subj001';
resFile = 'C:\Users\Hallgato\Google Drive\Faces_Hu\RSAResults\task1model1r3subj001';

pThr = 0.05;
thrImg = false;
corImg = false;
pImg = true;
corrType = 'Pearson';


goalMatrix = [0 0 0 1 1 1];
categories = 4;
testCorrelation(fileName,resFile,categories,goalMatrix,'pThr',pThr,'thrImg',thrImg,'corImg',corImg,'corrType',corrType);


%%
categories = 4;

task1model1r3Group_000_001.nii
baseFile = 'C:\Users\Hallgato\Google Drive\Faces_Hu\RSAHumSTD\task1model1r3subj001';
coords = [25,41,27];
value = correlateCoordinate(baseFile,coords,categories)

