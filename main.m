% in matpower phase shifter is not modelled, all phase shifter angle are
% set to 0.

clc;clear;

matpath='F:\projects\matpower5.1';

lists=dir(matpath);

exclude_files={'case3375wp','info','format'};

n=0;

for i=1:length(lists)
    
    casefile=lists(i).name;
    
    if check_file(casefile,exclude_files)
        
        [pathstr,name,ext]=fileparts(casefile);
        
        if casefile2txt(name,1);
            
            fprintf('Case %s processed.\n',casefile);
            
            n=n+1;
        
        else
        
            fprintf('Warning: Case %s not converge, will ignore!\n',casefile);
            
        end
        
    end
    
end

fprintf('Processed %d files.\n',n);


