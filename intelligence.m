% 
% Created by Dany Vohl and Kim Poirier-Champagne
% Copyright 2012
%
% Creates a Bayesian network to find probabilities of heart disease 
% Program based on the bnt library.
%
% This was a reasearch project in Advanced Concepts for Intelligent Systems
%
% We have not implement the inference part yet.

clear vars;

%Construction du graphe
N=11;
max=1; age=2; class=3; pain=4; chol=5; angina=6; slopePeak=7; noVessels=8; thal=9; oldPeak=10; sex=11; 

rand('state',sum(100*clock));
randn('state',sum(100*clock));

dag=zeros(N,N);
dag(max,[age class])=1;
dag(class,[pain chol angina slopePeak noVessels thal])=1;
dag(slopePeak,oldPeak)=1;
dag(thal,sex) = 1;

discrete_nodes=1:N;
node_sizes=[3 3 2 4 3 2 3 4 3 3 2];  
bnet=mk_bnet(dag,node_sizes,discrete_nodes);

%Affichage du graphe
names={'max','age','class','pain', 'chol','agina','slopePeak','noVessels', 'thal','oldPeak','sex'};

draw_graph(bnet.dag,names)
title('D�tection des risques de maladie du coeur');

bnet.CPD{max}=tabular_CPD(bnet,max,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{age}=tabular_CPD(bnet,age,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{class}=tabular_CPD(bnet,class,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{pain}=tabular_CPD(bnet,pain,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{chol}=tabular_CPD(bnet,chol,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{angina}=tabular_CPD(bnet,angina,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{slopePeak}=tabular_CPD(bnet,slopePeak,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{noVessels}=tabular_CPD(bnet,noVessels,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{thal}=tabular_CPD(bnet,thal,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{oldPeak}=tabular_CPD(bnet,oldPeak,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');
bnet.CPD{sex}=tabular_CPD(bnet,sex,'prior_type', 'dirichlet', 'dirichlet_type', 'unif');

%Load le fichier
[Age, Sex, Pain, Pressure, Cholestoral, Sugar,...
 Rest, Max, Angina, OldPeak, SlopePeak, NoVessels,...
Thal, Class] = textread('h.csv',...
'%d %d %d %d %d %d %d %d %d %d %d %d %d %d', 'delimiter', '\t',...
'headerlines', 1);

% Cree le fichier .math
save('donnees.mat', 'Max', 'Age', 'Class', 'Pain', 'Cholestoral', 'Angina', 'SlopePeak', 'NoVessels', 'Thal', 'OldPeak', 'Sex','-mat');

Donnees = [ Max' Age' Class' Pain' Cholestoral' Angina' SlopePeak' NoVessels' Thal' OldPeak' Sex']; 

%Apprentissage
bnet = learn_params(bnet, Donnees); 

%Affichage des tables
CPT = cell(1,N);
for i=1:N
  s=struct(bnet.CPD{i});  % contre l'aspect priv� de l'objet
  CPT{i}=s.CPT;
end
celldisp(CPT)

%Inf�rence


