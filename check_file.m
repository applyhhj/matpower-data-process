function valid=check_file(filename,exclude)

valid=0;

idx=strfind(filename,'case');
    
if idx==1
   
c=size(exclude,2);

    for k=1:c
       
        if ~isempty(strfind(filename,exclude{k}))
           
            return;
            
        end
        
    end
    
else
    
    return;
    
end
    
valid=1;

end