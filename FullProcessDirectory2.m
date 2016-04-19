function [ output_args ] = FullProcessDirectory2( folderpath,savelocation,names )
%Runs LM and GLM on specified folder, saving the files into the same
%folder
addpath(folderpath);

files=dir(fullfile(folderpath,'*.nev'));
[n,~]=size(files);

for j=1:n
   
       name=files(j,1).name;
       [k,~]=size(names);
       
    for f=1:k  
    if strcmp(name,names(f,:))
     
       try 
          Model = MultipleAnalysis(strcat(folderpath,'/',name),3);
          
          name=name(1:end-4);
       
          save (strcat(savelocation,'/MultipleProcessed',name,'.mat'),'Model');
          
       catch ER
          if(strcmp(ER.identifier,'MATLAB:badRectangle'))
             continue
          end
       end

       
    end
    end
end

end