function [BestSolution,BestFitness,Iteration]=CFA(PopSize,MaxIteration,lb,ub,FuncDimension,fobj)

if mod(PopSize,4)~=0
   PopSize=20
end 

% Default parameters
r1=1;r2=-1;
v1=-2;v2=2;
% initialize population
P=random_pop(PopSize,FuncDimension,ub,lb);

% calculate the Fitness
Fitness=zeros(PopSize,1);
for pop_i=1:PopSize
    Fitness(pop_i)=fobj(P(pop_i,:));
end

% Find the initial best solution
[FBest,Best_index]=min(Fitness);
Best=P(Best_index,:);

% divide into four group 
N_Goup_cell=PopSize/4;
G=zeros(N_Goup_cell,FuncDimension,4);
for ig=0:3
    G(:,:,ig+1)=P((N_Goup_cell*ig+1):(N_Goup_cell*ig+N_Goup_cell),:);
end

%main loop
Iter=0;
AllFitness=zeros(MaxIteration+1,PopSize);
AllFitness(1,:)=Fitness;
GlobalFitnessBest=zeros(MaxIteration,2);
while Iter <= MaxIteration 
  
% for case 1 and 2
    for cell=1:size(G(:,:,1),1)
        tmp_cell=zeros(1,FuncDimension);
        boundary_len=length(ub);
        for point=1:size(G(:,:,1),2)

            R=rand*(r1-r2)+r2;
            %V=rand*(v1-v2)+v2;
            V=1;
            reflection=R*G(cell,point,1);
            visibility=V*(Best(point)-G(cell,point,1));
            tmp_cell(point)=reflection+visibility;
            if boundary_len==1
               if tmp_cell(point)>ub
                  tmp_cell(point)=ub;
               end 
               if tmp_cell(point)<lb
                  tmp_cell(point)=ub;
               end 
            else
               % assume the lenth of ub equals to FuncDimension
               if tmp_cell(point)>ub(point)
                  tmp_cell(point)=ub(point);
               end 
               if tmp_cell(point)<lb(point)
                  tmp_cell(point)=lb(point);
               end
            end
        end
        Fitness_new=fobj(tmp_cell);
        if Fitness_new< FBest
            Best=tmp_cell;
            FBest=Fitness_new;
        end
        if Fitness_new < fobj(G(cell,:,1))
            G(cell,:,1)=tmp_cell;
        end
    end

% for case 3 and 4
    boundary_len=length(ub);
    for cell=1:size(G(:,:,2),1)
        tmp_cell=zeros(1,FuncDimension);
        for point=1:size(G(:,:,2),2)
            %R=rand*(v1-v2)+v2;
            R=1;
            V=rand*(r1-r2)+r2;
            reflection=R*Best(point);
            visibility=V*(Best(point)-G(cell,point,2));
            tmp_cell(point)=reflection+visibility;
            if boundary_len==1
               if tmp_cell(point)>ub
                  tmp_cell(point)=ub;
               end
               if tmp_cell(point)<lb
                  tmp_cell(point)=ub;
               end
            else
               % assume the lenth of ub equals to FuncDimension
               if tmp_cell(point)>ub(point)
                  tmp_cell(point)=ub(point);
               end
               if tmp_cell(point)<lb(point)
                  tmp_cell(point)=lb(point);
               end
            end
        end
        Fitness_new=fobj(tmp_cell);
        if Fitness_new< FBest
             Best=tmp_cell;
             FBest=Fitness_new;
        end
        if Fitness_new < fobj(G(cell,:,2))
             G(cell,:,2)=tmp_cell;
        end
    end 
% for case 5
    AVBest=mean(Best);
    boundary_len=length(ub);
    for cell=1:size(G(:,:,3),1)
        tmp_cell=zeros(1,FuncDimension);
        for point=1:size(G(:,:,3),2)
            %R=rand*(v1-v2)+v2;
            R=1;
            V=rand*(r1-r2)+r2;
            reflection=R*Best(point);
            visibility=V*(Best(point)-AVBest);
            tmp_cell(point)=reflection+visibility;
            if boundary_len==1
               if tmp_cell(point)>ub
                  tmp_cell(point)=ub;
               end
               if tmp_cell(point)<lb
                  tmp_cell(point)=ub;
               end
            else
               % assume the lenth of ub equals to FuncDimension
               if tmp_cell(point)>ub(point)
                  tmp_cell(point)=ub(point);
               end
               if tmp_cell(point)<lb(point)
                  tmp_cell(point)=lb(point);
               end
           end
        end
        Fitness_new=fobj(tmp_cell);
        if Fitness_new< FBest
             Best=tmp_cell;
             FBest=Fitness_new;
        end
        if Fitness_new < fobj(G(cell,:,3))
             G(cell,:,3)=tmp_cell;
        end
    end
% for case 6
    for cell=1:size(G(:,:,4),1)
        tmp_cell=random_pop(1,FuncDimension,ub,lb);
        Fitness_new=fobj(tmp_cell);
        if Fitness_new< FBest
          Best=tmp_cell;
          FBest=Fitness_new;
        end
        if Fitness_new < fobj(G(cell,:,3))
            G(cell,:,3)=tmp_cell;
        end
    end
    Iter=Iter+1;
    %Print the best universe details after every 100 iterations
    if mod(Iter,100)==0
        display(['At iteration ', num2str(Iter), ' the best fitness is ', num2str(FBest)]);
    end

    GlobalFitnessBest(Iter,1)=Iter;
    GlobalFitnessBest(Iter,2)=FBest;
    %if abs(FBest)<1e-5
    %  fprintf('Fbest=%d\n',FBest);
    %  fprintf('Iter=%d\n',Iter);
    %  fprintf('Best vector: \n');
      %GlobalFitnessBest=GlobalFitnessBest(1:Iter,1:2);
      %plot(GlobalFitnessBest(:,1),GlobalFitnessBest(:,2),'r-o','LineWidth',2);
    % break
    %end
    
end
BestRecord=GlobalFitnessBest;
BestSolution=Best;
BestFitness=FBest;
Iteration=Iter;
end
