m = floor(n/8); k = floor(m/5);
fprintf('\nSize [n,m,k] = [%i,%i,%i]\n',n,m,k);

% generate xs
db = 40;

% set opts parameters
sigma = 0.01;
digit = 5; if sigma > 0; digit = 3; end
opts.tol = 5*10^(-digit);

% Used by all three kinds
p = randperm(n);
picks = sort(p(1:m)); picks(1) = 1;
noise = sigma*randn(m,1);
perm = randperm(n);
Mtype = {' pdct','pdwht',' pdft'};

% call solver

for j = 1:2

    opts.rho = (j-1)*5e-4;
    t0 = cputime;
    for k = 1:3
        op_A = eval(['@' Mtype{k} '_operator']);
        A = feval(op_A,picks,perm);
        b = A.times(xs) + noise;
        [x,Out] = yall1(A, b, opts);
        x = real(x); rerr = norm(x-xs)/norm(xs);
        Mat = upper(Mtype{k});
        fprintf([Mat ': iter %4i  Rel_err = %6.2e\n'],...
            Out.iter,rerr);
    end
    fprintf('  rho = %4.1e,  CPU %6.2f sec.\n\n',...
        opts.rho,cputime-t0);
    
end

