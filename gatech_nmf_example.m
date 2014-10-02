%Non-negative matrix factorization
%No dependencies
%Uses GaTech method for factorization
%Author: Vijay Gadepally, vijayg@mit.edu

close all;
maxiter=20;

%Load Twitter dataset
A1 = load('/home/gridsan/groups/D4Muser/Twitter/pipeline/Step1_Parse/geo_tweets/2013_07_08/tsv.0244.mat');
E1=A1.A;

A2 = load('/home/gridsan/groups/D4Muser/Twitter/pipeline/Step1_Parse/geo_tweets/2013_07_08/tsv.0245.mat');
E2 = A2.A;

E=E1+E2;

%E=E(1:1000,:);
%%Remove Stop Words
%Find common words:
comm_word_str='the,of,and,at,a,to,in,is,you,that,it,he,was,for,on,are,as,with,his,they,I,I''m,at,be,this,have,from,or,one,had,by,word,but,not,what,all,were,we,when,your,can,said,me,i,ha,haha,hahahaha,lol,RT,';
%comm_word_str=['twas, a, able, about, across, after, aint, all, almost, also, am, among, an, and, any, are, arent, as, at, be, because, been, but, by, can, cant, cannot, could, couldve, couldnt, dear, did, didnt, do, does, doesnt, dont, either, ever, every, from, get, got, had, has, hasnt, have, he, hed, her, hers, him, his, how, howd, howll, hows, however, i, id, ill, im, ive, in, into, is, isnt, it, its, its, just, least, let, like, likely, may, me, might, mightve, mightnt, most, must, mustve, mustnt, my, neither, no, nor, not, of, off, often, on, only, or, other, our, own, rather, said, say, says, shant, she, shed, shell, shes, should, shouldve, shouldnt, since, so, some, than, that, thatll, thats, the, their, them, then, there, theres, these, they, theyd, theyll, theyre, theyve, this, tis, to, too, twas, us, wants, was, wasnt, we, wed, well, were, were, werent, what, whatd, whats, when, when, whend, where, whered, which, who, whom, why, will,with'];
rowWord=CatStr('word,', '|', comm_word_str);

E = E-E(:,rowWord); % Get rid of most commond
E = E(:,StartsWith('word|,')); %E(:,StartsWith('language|,'));

%Only pick a subset to fit in memory
%E = E(1:5000,:);
figure; spy(transpose(E));
xlabel('Document ID');  ylabel('Entity');

%Pick number of topics based on number of languages
%k = numel(sum(E(:,StartsWith('language|')),1)>100);
k=6;
%k=100;
kStr = sprintf('%0.2d,',1:k);          % Set number of topics for NMF.

AA= Adj(Abs0(E));
[n,m]=size(AA);

W=abs(randn(n,k));
H=abs(zeros(k,m));

curriter=1;
err=100000;

[W,H,iter,HIS]=nmf(Adj(Abs0(E)),k);   % MATLAB function call

%Put labels on W and H
WW = putCol(noVal(putAdj(E,sparse(W))),kStr);  % Put labels on WW.
figure; spy(WW > 0.5);                        % Show documents that are strongly tied to topics.
xlabel('Topic ID');  ylabel('Document ID');

HH = putRow(noVal(putAdj(E,sparse(H))),kStr);  % Put labels on H.

figure; spy(HH.' > 0.5);                       % Show entities that are strongly tied to topics.
xlabel('Topic ID');  ylabel('Entity');

%Print out popular words
for i=1:k
    disp(['Popular words in Topic: ' num2str(i)]);
    colnum=sprintf('%0.2d,',i);
    disp( Col(HH(colnum,:) > 0.5) );
end


