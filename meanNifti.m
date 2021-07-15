function meanNifti(fileList,categories,thr,fileOut)
error('outdated, use meanNiftiFiles')
%fileList is a struct that contains the names of the files to be mean,
%%fileOut is the name of the file created
for i = 1:length(fileList)
    data = load_untouch_nii(fileList{i});
    imgs{i} = data.img;
end
data.img(:) = 0;
data2 = data;
dimensions = size(imgs{1}); %calculates the dimensions
for i = 1:dimensions(1)
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(fileList));
            for m = 1:length(fileList)
                val(m) = imgs{m}(i,j,k);
            end
            if mean(val) > 1
                error('something is wrong')
            end
            if mean(val) < 0
                error('something is wrong')
            end
            %if all(val > thr)
            if mean(val) > thr
                [h,p,ci,stats] = ttest(val,1/categories);
                t = stats.tstat;
            else
                t = 0;
            end
            data2.img(i,j,k) = t;
            data.img(i,j,k) = mean(val);
        end
    end
end

save_nii(data,[fileOut,'mean','.nii.gz']);
save_nii(data,[fileOut,'TTest','.nii.gz']);