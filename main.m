PopSize=40;
MaxIteration=5000;
% Select optimizers
PSO= false ;
MVO= false ;
MVO= false ;
GWO= false ;
MFO= false ;
CSA= false ;
BAT= false ;
WOA= false ;
FFA= false ;
CFA= true  ;

% Select benchmark function
logLabel=ones(24,1);
for k=1:length(logLabel)   
  eval(['F',num2str(k),'=','1']);
end


Optimizers={'PSO', 'MVO', 'GWO', 'MFO', 'CSA', 'BAT', 'WOA', 'FFA', 'CFA'};
BenchmarkFunctions=24;
disp('')
for algo=1:length(Optimizers)
    AlgoName=Optimizers{algo};
    IsAlgo=eval(AlgoName);
    if IsAlgo
        disp('-------------------Selected Algorithm-----------------');
        disp(AlgoName);
        for j_fun=1:BenchmarkFunctions
            sfunction=['F',num2str(j_fun)];
            IsFunc=eval(sfunction);
            if IsFunc
               disp('---------Selected Function--------');
               disp(sfunction);
               [lb,ub,dim,fobj] = benchmarks(sfunction);
               fout=selector(AlgoName,fobj,PopSize,MaxIteration,lb,ub,dim);
               algo,fobj,PopSize,MaxIteration,lb,ub,dim
               fout
            end 
        end 
    end

end

