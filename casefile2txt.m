function success=casefile2txt(casefile,solve)

success=0;

if nargin <2
    
    solve=0;
    
end

default_path='F:\projects\data\matpower-data-process\data\';

[pathstr,name,ext]=fileparts(casefile);

if isempty(pathstr)
    
    fprintf('    Warning: Path not set will use default path %s\n',default_path);
    
    outfile=strcat(default_path,name,'.txt');
    
else
    
    outfile=strcat(pathstr,name,'.txt');
    
end

if solve
    
    mpopt = mpoption('out.all',0,'verbose',0);
    
    mpc=runpf(casefile,mpopt);
    
    if ~mpc.success
        
        return;
        
    end
    
else
    
    mpc=loadcase(casefile);
    
end

data={mpc.version,mpc.baseMVA,mpc.bus,mpc.gen,mpc.branch};

comment_section={'# Imported from MATPOWER Case Format'
    '# System MVA base'
    '# Bus data: bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin'
    '# generator data: bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf'
    '# branch data: fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax PF* QF* PT* QT*'};

section_start={'mpc.version','mpc.baseMVA','mpc.bus','mpc.gen','mpc.branch'};

section_end={'mpc.version.end','mpc.baseMVA.end','mpc.bus.end','mpc.gen.end','mpc.branch.end'};

dataformat={'%s\r\n'
    '%d\r\n'
    '%10d%10d%15.6f%15.6f%15.6f%15.6f%10d%15.6f%15.6f%15.6f%10d%15.6f%15.6f\r\n'
    '%10d%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f\r\n'
    '%10d%10d%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%15.6f%10d%15.6f%15.6f\r\n'};

col_min=[1 1 13 21 13];

section_start_format='%s\r\n';

section_end_format='%s\r\n\r\n';

fileID = fopen(outfile,'w');

c=size(section_start,2);

for i=1:c
    
    fprintf(fileID,section_start_format,comment_section{i});
    
    fprintf(fileID,section_start_format,section_start{i});
    
    [rdata,cdata]=size(data{i});
    
    formatstr=dataformat{i};
    
    if cdata>col_min(i)
        
        formatstr=formatstr(1:length(formatstr)-4);
        
        for k=col_min(i):cdata-1
            
            formatstr=strcat(formatstr,'%15.6f');
            
        end
        
        formatstr=strcat(formatstr,'\r\n');
        
    end
    
    for j=1:rdata
        
        fprintf(fileID,formatstr,data{i}(j,:));
        
    end
    
    fprintf(fileID,section_end_format,section_end{i});
    
end

fclose(fileID);

success=1;

end