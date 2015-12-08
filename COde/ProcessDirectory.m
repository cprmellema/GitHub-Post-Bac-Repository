function [ output_args ] = ProcessDirectory( folderpath,savelocation )
%Runs LM and GLM on specified folder, saving the files into the same
%folder
addpath(folderpath);

files=dir(fullfile(folderpath,'*.nev'));
[n,~]=size(files);

for j=1:n
   name=files(j,1).name;
   
   try 
       Linear_Model=GCprocess1(strcat(folderpath,'\',name),'normal','identity',6);
   catch ER
      if(strcmp(ER.identifier,'MATLAB:badRectangle'))
         continue
      end
   end
   
   General_Linear_Model=GCprocess1(strcat(folderpath,'\',name),'poisson','log',6);
   name=name(1:end-4);
   save (strcat(savelocation,'\','PL',name,'.mat'),'Linear_Model');
   save (strcat(savelocation,'\','PGL',name,'.mat'),'General_Linear_Model');
end

end