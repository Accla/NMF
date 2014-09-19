%Uses Newton's iterative method to solve AX = I

function X = matrixInverse(A)

invA = inv(A);
maxiter = 100;

for i=1:maxiter

 if(i==1)
    X=transpose(A)/(norm(A,1)*norm(A,Inf));
 end

 X=X*(2*eye(size(A,1))-A*X);
 disp(['Norm: ' num2str(norm((inv(A)-X),'fro'))]);
end

