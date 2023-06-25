function par=Decode_Decimal_Unsigned(pop,sig,dec)



if (nargin < 3),
   error(['Too few input arguments. Use: PAR=decode(POP,SIG,DEC)']);
end;

if size(sig)~=size(dec),
   error(['Mismatch between SIG and DEC']);
end;


[pop_size,chrom_len]=size(pop);
npar=length(sig);

if chrom_len~=sum(sig),
    error(['Mismatch between chromosome length and SIG']);
end    

par=zeros(pop_size,npar);

for pop_index = 1:pop_size,
    start_gene = 0;
    for par_index = 1:npar,

       for count=1:sig(par_index),
           gene_index=start_gene+count; 
           weight=dec(par_index)-count;
 	       par(pop_index,par_index)=par(pop_index,par_index)+(pop(pop_index,gene_index))*10^weight;
       end
       start_gene=start_gene+sig(par_index);
     
	end % Ends "for par_index=..." loop      
end    % Ends "for pop_index=..." loop

