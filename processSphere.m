function processSphere(fileList,categories,thr,fileOut)
%fileList is a struct that contains the names of the files to be mean,
%%fileOut is the name of the file created
%fileList =newList;
FDRThr = 1/categories;
FDRp = 0.1;
fileList;
for i = 1:length(fileList)
    
    data = load_untouch_nii(fileList{i});
    imgs{i} = data.img;
end
%data.img(:) = single(0);
data2 = data;
data3 = data;
dimensions = size(imgs{1}); %calculates the dimensions
for i = 1:dimensions(1)
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(fileList));
            for m = 1:length(fileList)
                val(m) = imgs{m}(92-i,j,k);
            end
            if mean(val) > 1
                error('something is wrong')
            end
            if mean(val) < 0
                error('something is wrong')
            end
            %if all(val > thr)
            [h,p,ci,stats] = ttest(val,1/categories);
            t = stats.tstat;
            if mean(val) < thr
                t = 0;
                p = 1;
            end
            data2.img(i,j,k) = t;
            data3.img(i,j,k) = p;
            data.img(i,j,k) = mean(val);
        end
    end
end

% [a,b] = FDR(data3.img(data3.img < FDRp),FDRp);
% 
% if a
%     data.img(data3.img < a) = 0;
%     save_untouch_nii(data,[fileOut,'meanA','.nii.gz']);
% end
% if b
%     data.img(data3.img < b) = 0;
%     save_untouch_nii(data,[fileOut,'meanB','.nii.gz']);
% end
save_untouch_nii(data,[fileOut,'mean','.nii.gz']);
save_untouch_nii(data2,[fileOut,'TTest','.nii.gz']);
%save_untouch_nii(data3,[fileOut,'p','.nii.gz']);