function [BestSolution,BestFitness,Iteration]=CFA_P1(PopSize,MaxIteration,lb,ub,FuncDimension,fobj)

% used to simulate the parallel version 

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
    tmp_cell=zeros(FuncDimension,size(G(:,:,1),1));
    for cell=1:size(G(:,:,1),1)
        boundary_len=length(ub);
        for point=1:size(G(:,:,1),2)

            R=rand*(r1-r2)+r2;
            V=rand*(v1-v2)+v2;
            %V=1;
            reflection=R*G(cell,point,1);
            visibility=V*(Best(point)-G(cell,point,1));
            tmp_cell(point,cell)=reflection+visibility;
            if boundary_len==1
               if tmp_cell(point,cell)>ub
                  tmp_cell(point,cell)=ub;
               end 
               if tmp_cell(point,cell)<lb
                  tmp_cell(point,cell)=ub;
               end 
            else
               % assume the lenth of ub equals to FuncDimension
               if tmp_cell(point,cell)>ub(point)
                  tmp_cell(point,cell)=ub(point);
               end 
               if tmp_cell(point,cell)<lb(point)
                  tmp_cell(point,cell)=lb(point);
               end
            end
        end
    end
    for cell=1:size(G(:,:,1),1)
        Fitness_new=fobj(tmp_cell(:,cell)');
        if Fitness_new< FBest
            Best=tmp_cell(:,cell)';
            FBest=Fitness_new;
        end
        if Fitness_new < fobj(G(cell,:,1))
            G(cell,:,1)=tmp_cell(:,cell)';
        end
    end

% for case 3 and 4
    tmp_cell=zeros(FuncDimension,size(G(:,:,2),1));
    boundary_len=length(ub);
    for cell=1:size(G(:,:,2),1)
        for point=1:size(G(:,:,2),2)
            %R=rand*(v1-v2)+v2;
            R=1;
            V=rand*(r1-r2)+r2;
            reflection=R*Best(point);
            visibility=V*(Best(point)-G(cell,point,2));
            tmp_cell(point,cell)=reflection+visibility;
            if boundary_len==1
               if tmp_cell(point,cell)>ub
                  tmp_cell(point,cell)=ub;
               end
               if tmp_cell(point,cell)<lb
                  tmp_cell(point,cell)=ub;
               end
            else
               % assume the lenth of ub equals to FuncDimension
               if tmp_cell(point,cell)>ub(point)
                  tmp_cell(point,cell)=ub(point);
               end
               if tmp_cell(point,cell)<lb(point)
                  tmp_cell(point,cell)=lb(point);
               end
            end
        end
   end
   for cell=1:size(G(:,:,2),1)
        Fitness_new=fobj(tmp_cell(:,cell)');
        if Fitness_new< FBest
             Best=tmp_cell(:,cell)';
             FBest=Fitness_new;
        end
        if Fitness_new < fobj(G(cell,:,2))
             G(cell,:,2)=tmp_cell(:,cell)';
        end
    end 
% for case 5
    
    AVBest=mean(Best);
    tmp_cell=zeros(FuncDimension,size(G(:,:,3),1));
    boundary_len=length(ub);
    for cell=1:size(G(:,:,3),1)
        for point=1:size(G(:,:,3),2)
            %R=rand*(v1-v2)+v2;
            R=1;
            V=rand*(r1-r2)+r2;
            reflection=R*Best(point);
            visibility=V*(Best(point)-AVBest);
            tmp_cell(point,cell)=reflection+visibility;
            if boundary_len==1
               if tmp_cell(point,cell)>ub
                  tmp_cell(point,cell)=ub;
               end
               if tmp_cell(point,cell)<lb
                  tmp_cell(point,cell)=ub;
               end
            else
               % assume the lenth of ub equals to FuncDimension
               if tmp_cell(point,cell)>ub(point)
                  tmp_cell(point,cell)=ub(point);
               end
               if tmp_cell(point,cell)<lb(point)
                  tmp_cell(point,cell)=lb(point);
               end
           end
        end
    end
    for cell=1:size(G(:,:,3),1)
        Fitness_new=fobj(tmp_cell(:,cell)');
        if Fitness_new< FBest
             Best=tmp_cell(:,cell)';
             FBest=Fitness_new;
        end
        if Fitness_new < fobj(G(cell,:,3))
             G(cell,:,3)=tmp_cell(:,cell)';
        end
    end
% for case 6
    tmp_cell=zeros(FuncDimension,size(G(:,:,4),1));
    for cell=1:size(G(:,:,4),1)
        tmp_cell(:,cell)=random_pop(1,FuncDimension,ub,lb);
    end 
    for cell=1:size(G(:,:,4),1)
        Fitness_new=fobj(tmp_cell(:,cell)');
        if Fitness_new< FBest
          Best=tmp_cell(:,cell)';
          FBest=Fitness_new;
        end
        if Fitness_new < fobj(G(cell,:,3))
            G(cell,:,3)=tmp_cell(:,cell)';
        end
    end
    Iter=Iter+1;
    %Print the best universe details after every 100 iterations
    if mod(Iter,20)==0
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
