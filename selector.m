function result=selector(algo,fobj,PopSize,MaxIteration,lb,ub,dim)
%Optimizers={'PSO', 'MVO', 'GWO', 'MFO', 'CSA', 'BAT', 'WOA', 'FFA','CFA'};
%  algo,fobj,PopSize,MaxIteration,lb,ub,dim
  tic;
  if algo =='PSO'
    [BestSolution,BestFitness,Iteration]=PSO(PopSize,MaxIteration,lb,ub,dim,fobj)
  elseif algo == 'MVO'
    [BestSolution,BestFitness,Iteration]=MVO(PopSize,MaxIteration,lb,ub,dim,fobj)
  elseif algo == 'GWO'
    [BestSolution,BestFitness,Iteration]=GWO(PopSize,MaxIteration,lb,ub,dim,fobj)
  elseif algo == 'MFO'
    [BestSolution,BestFitness,Iteration]=MFO(PopSize,MaxIteration,lb,ub,dim,fobj)
  elseif algo == 'CSA'
    [BestSolution,BestFitness,Iteration]=CSA(PopSize,MaxIteration,lb,ub,dim,fobj)
  elseif algo == 'BAT'
    [BestSolution,BestFitness,Iteration]=BAT(PopSize,MaxIteration,lb,ub,dim,fobj)
  elseif algo == 'WOA'
    [BestSolution,BestFitness,Iteration]=WOA(PopSize,MaxIteration,lb,ub,dim,fobj)
  elseif algo == 'FFA'
    [BestSolution,BestFitness,Iteration]=FFA(PopSize,MaxIteration,lb,ub,dim,fobj)
  elseif algo == 'CFA'
    [BestSolution,BestFitness,Iteration]=CFA(PopSize,MaxIteration,lb,ub,dim,fobj)
  else
    result='Unknow Algorithm';
    return 
  end
  toc;
  result.BestSolution=BestSolution;
  result.BestFitness=BestFitness;
  result.Iteration=Iteration;
