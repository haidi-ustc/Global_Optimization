function [BestSolution,BestFitness,Iteration]=PSO(PopSize,MaxIteration,lb,ub,FuncDimension,fobj)

c1 = 2;
c2 = 2;
w = 0.7;
w_ini = 0.9; 
w_end = 0.4;

x=random_pop(PopSize,FuncDimension,ub,lb);
v=random_pop(PopSize,FuncDimension,ub,lb);

y=zeros(PopSize,FuncDimension);
p=zeros(1,PopSize);
for i=1:PopSize
    p(i)=fobj(x(i,:));
    y(i,:)=x(i,:);
end

gbest=x(1,:); 
for i=2:PopSize
    if (fobj(x(i,:)) < fobj(gbest))
        gbest=x(i,:);
    end
end

for t=1:MaxIteration
    %w=(w_ini-w_end)*(MaxIteration-10)/MaxIteration+w_end;
    for i=1:PopSize
        v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(gbest-x(i,:));
        x(i,:)=x(i,:)+v(i,:);
        if fobj(x(i,:))<p(i)
            p(i)=fobj(x(i,:));
            y(i,:)=x(i,:);
        end
        if p(i)<fobj(gbest)
            gbest=y(i,:);
        end
    end
    %Print the best universe details after every 100 iterations
    if mod(t,100)==0
        display(['At iteration ', num2str(t), ' the best fitness is ', num2str(fobj(gbest))]);
    end

end

BestSolution=gbest';
BestFitness=fobj(gbest);
Iteration=MaxIteration;



