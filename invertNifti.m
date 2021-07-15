function data2 = invertNifti(data)

data2 = data;
dimensions = size(data.img);
    for i = 1:dimensions(1)
        for j = 1:dimensions(2)
            for k = 1:dimensions(3)
                %i,j,k
                data2.img(i,j,k) = data.img(92-i,j,k);
            end
        end
    end