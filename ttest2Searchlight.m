function ttest2Searchlight(filesPath,fileList1,fileList2,resultsFile,varargin)
directional = getArgumentValue('directional',true,varargin{:});
meanImg = getArgumentValue('meanImg',true,varargin{:});
fImg = getArgumentValue('filtered',true,varargin{:});
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
differenceImg = getArgumentValue('differenceImg',true,varargin{:});
cortex = getArgumentValue('cortex',false,varargin{:});
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:});
conditionsName = getArgumentValue('conditionsName',{'pair1','pair2'},varargin{:});
getDriveFolder;
folder2 = filesPath;

switch cxFile
    case 'MNI2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Harvard\b_Cortex.nii.gz'];
    case 'Barney2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\b_Cortex.nii.gz'];
    case 'Barney'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels\b_Cortex.nii.gz'];
    case 'Datta'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Datta\b_Cortex.nii.gz'];
    otherwise
        cortexFile = cxFile;
end

if cortex
    cortexImg = load_untouch_niiR(cortexFile);
    cortexImg.img = single(logical(cortexImg.img));
end
disp('Loading list1')
imgs1 = cell(1,length(fileList1));
for nFile = 1:length(fileList1)
    fileName = fileList1{nFile};
    file = [filesPath, '\',fileName];
    disp(['loading... ', file])
    dataF = load_untouch_niiR(file);
    if cortex %filters out whatever falls outside the mask
        dataF.img(:) = cortexImg.img(:).*dataF.img(:);
    end
    imgs1{nFile} = dataF.img;
end
disp('Loading list2')
imgs2 = cell(1,length(fileList2));
for nFile = 1:length(fileList2)
    fileName = fileList2{nFile};
    file = [folder2, '\',fileName];
    disp(['loading... ', file])
    dataF = load_untouch_niiR(file);
    if cortex %filters out whatever falls outside the mask
        dataF.img(:) = cortexImg.img(:).*dataF.img(:);
    end
    
    imgs2{nFile} = dataF.img;
end

nFiles=size(fileList1,1);
dimensions = size(imgs1{1});
difference = dataF;
tResults = dataF;
tResultsR = dataF;
tResultsL = dataF;
pValues = dataF;
pValuesR = dataF;
pValuesL = dataF;
pair1Img = dataF;
pair2Img = dataF;
for i = 1:dimensions(1)
    disp(['dimension: ',num2str(i), ' / ', num2str(dimensions(1)), ' number of files ', num2str(nFiles)]);    
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val1 = zeros(1,length(imgs1));
            val2 = zeros(1,length(imgs2));
            for subj = 1:length(imgs1)%subjs
                val1(subj) = imgs1{subj}(i,j,k);
                val2(subj) = imgs2{subj}(i,j,k);
            end
            media = mean(val1);
            if media > 0
                [~,p,~,stats] = ttest2(val1,val2,'Tail','both');
                [~,pR,~,statsR] = ttest2(val1,val2,'Tail','right');
                [~,pL,~,statsL] = ttest2(val2,val1,'Tail','right');
                t = stats.tstat;
                tR = statsR.tstat;
                tL = statsL.tstat;
            else
                p = 1; pR = 1; pL = 1;
                t = 0; tR = 0; tL = 0;
            end                      
            difference.img(i,j,k) = mean(val2) - mean(val1);
            pair1Img.img(i,j,k) = mean(val1);
            pair2Img.img(i,j,k) = mean(val2);
            tResults.img(i,j,k) = t;
            tResultsR.img(i,j,k) = tR;
            tResultsL.img(i,j,k) = tL;
            pValues.img(i,j,k) = p;
            pValuesR.img(i,j,k) = pR;
            pValuesL.img(i,j,k) = pL;
        end
    end
end

if meanImg
    save_untouch_nii(pair1Img,[resultsFile,'_',conditionsName{1},'.nii.gz']);
    save_untouch_nii(pair2Img,[resultsFile,'_',conditionsName{2},'.nii.gz']);
end

if pImg    
    save_untouch_nii(pValues,[resultsFile,'_p.nii.gz']);
end
if tImg
    save_untouch_nii(tResults,[resultsFile,'_t.nii.gz']);
    
    save_untouch_nii(tResultsR,[resultsFile,conditionsName{1},'_t.nii.gz']);
    save_untouch_nii(tResultsL,[resultsFile,conditionsName{2},'_t.nii.gz']);
end
if differenceImg
%     disp(['file]);
    save_untouch_nii(difference,[resultsFile,'_mp.nii.gz']);
end

sides = {conditionsName{1},conditionsName{2}};
% sides = {'R','L'};
tImgs = {tResultsR,tResultsL};
pImgs = {pValuesR,pValuesL};
if directional
    for nSide = 1:length(sides)
        tRes = tImgs{nSide};
        pRes = pImgs{nSide};
        side = sides{nSide};
        
        
        tRes.img(pRes.img(:) > 0.05) = 0;
        if sum(tRes.img(:)) > 0
            save_untouch_nii(tRes,[resultsFile,side,'_t_Thr05.nii.gz']);
        end
        tRes.img(pRes.img(:) > 0.01) = 0;
        if sum(tRes.img(:)) > 0
            save_untouch_nii(tRes,[resultsFile,side,'_t_Thr01.nii.gz']);
        end
        tRes.img(pRes.img(:) > 0.001) = 0;
        if sum(tRes.img(:)) > 0
            save_untouch_nii(tRes,[resultsFile,side,'_t_Thr001.nii.gz']);
        end

        tRes.img(pRes.img(:) > 0.0001) = 0;
        if sum(tRes.img(:)) > 0
            save_untouch_nii(tRes,[resultsFile,side,'_t_Thr0001.nii.gz']);
        end

        tRes.img(pRes.img(:) > 0.00001) = 0;
        if sum(tRes.img(:)) > 0
            save_untouch_nii(tRes,[resultsFile,side,'_t_Thr00001.nii.gz']);
        end

        tRes.img(pRes.img(:) > 0.000001) = 0;
        if sum(tRes.img(:)) > 0
            save_untouch_nii(tRes,[resultsFile,side,'_t_Thr000001.nii.gz']);
        end
    end
end

if fImg
    tResults.img(pValues.img(:) > 0.05) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr05.nii.gz']);
    end
    
    tResults.img(pValues.img(:) > 0.01) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr01.nii.gz']);
    end
    
    
     tResults.img(pValues.img(:) > 0.001) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr001.nii.gz']);
    end
    
    tResults.img(pValues.img(:) > 0.0001) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr0001.nii.gz']);
    end
    
    tResults.img(pValues.img(:) > 0.00001) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr00001.nii.gz']);
    end

    tResults.img(pValues.img(:) > 0.000001) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr000001.nii.gz']);
    end
    
    
end