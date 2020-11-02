classdef dishfit
% Example:
% 
%     x = [ 1.0    4.0    6.0    1.6    3.5    1.8    3.0    2.5];
%     y = [11.8   18.0   18.0   12.8   16.4   13.0   15.8   13.8];
% 
%  f = dishfit(x, y, tol);
% 
%  plot(f)  % dotted line is the initial guess p0; solid line is the least-squares local
%           % optimum p closest to the initial guess
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	properties(GetAccess = 'public', SetAccess = 'public')
		p0 = [0 0 0 1];
		p  = [0 0 0 1];
		x;
		y;
        tol = 0.1; 
        err = 0;
	end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	methods(Static = true)  % only static methods can be called from the command line with classname.methodname()
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function hello
			disp('Hello!')
		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	end
	methods
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function obj = dishfit(x, y, tol)
          
			if nargin
               
				obj.x   = x;
				obj.y   = y;
                obj.tol = tol;
				obj = obj.go();
                obj.err = objective(obj.p, x, y);
            end
            
		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function obj = set.y(obj, y)
			obj.y = y;
			obj   = go(obj);
		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function obj = set.x(obj, x)
			obj.x = x;
			obj   = go(obj);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function obj = set.tol(obj, tol)
			obj.tol  = tol;
			obj      = go(obj);
		end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
        function obj = go(obj)
			obj.p0 = guess(obj.x, obj.y);
			obj.p = optimize(obj.p0, obj.x, obj.y, obj.tol);
		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function hOut = plot(obj, varargin)
            washeld = ishold; 
			if ~isempty(varargin)
                h.optimized = plotfunction(obj.p, obj.x, varargin{2});
            else
                h.optimized = plotfunction(obj.p, obj.x, [1 1 1]);
            end
            tem = {'color', get(h.optimized.handle, 'color')};
            
            hold all
			h.data = plotdata(obj.x, obj.y, tem);
            if ~isempty(varargin)
                axes_str = varargin{1};
                ylabel(axes_str{1});
                xlabel(axes_str{2});
                set(gca,'FontSize',20,'Fontweight','bold');
            end
			if ~washeld, hold off, end
			if nargout, hOut.handle = h;hOut.x = h.optimized.x;hOut.y = h.optimized.y; else figure(gcf), drawnow, end
		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p0 = guess(x, y)
% find a starting point for the optimization, as robustly as possible
% 
	if isempty(x) | isempty(y) , p0 = []; return, end
	x1 = x;
    y1 = y;
    
    x = x(:);
	y = y(:);
 	[y reorder] = sort(y);
 	x = x(reorder);
	n = numel(x);

    % min of curve
	ind = round(n * 0.05);
	ind = ind + [-2:+2];
	ind(ind < 1 | ind > n) = [];
 	c = median(y(ind));
    
    
    % max of curve
	ind = round(n * 0.95);
	ind = ind + [-2:+2];
	ind(ind < 1 | ind > n) = [];
	d = median(y(ind));
    
    % mid of curve
	[ans ind] = min(abs(y - (c+d)/2));
	ind = ind + [-2:+2];
	ind(ind < 1 | ind > n) = [];
	a = median(x(ind));

    % get the probable slope
	b = 0;

	y = y - c;
	y = y ./ (d - c);
	bad = y >= 1 | y <= 0 | isnan(y) | isinf(y) | imag(y) ~= 0;
	y(bad) = [];
	x(bad) = [];
    y2 = y; x2 = x;
	if numel(x) >= 2
		y = inverselogistic(y);
		tmp = [x ones(size(x))]\y;
		b = log(tmp(1));
		a = -tmp(2)/tmp(1);
	end

	p0 = [a b c d];
    
%     if(imag(sum(p0))~=0)
%       keyboard
%     end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = optimize(p0, x, y,tol)
% starting with an initial guess p0, find the parameter set that minimizes the
% objective() for given x and y
	if isempty(x) | isempty(y) | isempty(tol) |isempty(p0), p = []; return, end
        
	optimizer = @fminsearch;  % uses options:  Display, TolX, TolFun, MaxFunEvals, MaxIter, FunValCheck, PlotFcns, and OutputFcn.
	options = optimset(optimizer);
	options = optimset(options, 'Display', 'off','TolX',tol,'TolFun',0.01);
	% change further options here as desired:
	funchandle = @(p) objective(p, x, y);
	[p f flag out] = optimizer(funchandle, p0, options);
    %keyboard
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function err = objective(p, x, y)
% function be minimized during optimization
	prediction = forward(x, p(1), p(2), p(3), p(4));
	residuals = y - prediction; % here's where we decide
	err = (sum(residuals.^2));  %   that we are using least-squares, can use least-abs
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = forward(x, a, b, c, d)
% forward sigmoid function shift a, slope exp(b), minimum c, maximum d
    c = 0; % the minimum is forced to be 0. % added to check constraints: Disha 
	x = x - a;
	x = x .* exp(b);
	y = logistic(x);
	y = y .* (d - c );
	y = y + c;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = inverse(y, a, b, c, d)
% inverse of y = forward(x, a, b, c, d) with respect to x
    c = 0; % the minimum is forced to be 0. % added to check constraints: Disha 
	y = y - c;
	y = y ./ (d - c);
	x = inverselogistic(y);
	x = x ./ exp(b);
	x = x + a;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = logistic(x)
	y = 1 ./ (1 + exp(-x));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = inverselogistic(y)
	x = -log(1./y - 1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hOut = plotfunction(p,x2, color)
% plot a curve with parameters p
	alpha      = 0.001;
	resolution = 500;
% 	lo = inverse(    alpha, p(1), p(2), 0, 1);
	lo = 0;
%   up = 6;    
%     up = inverse(1 - alpha, p(1), p(2), 0, 1);
% 	x  = linspace(lo, up, resolution);
% 	y  = forward(x, p(1), p(2), p(3), p(4));
    x2  = linspace(lo, max(x2), resolution);
    y2 = forward(x2, p(1), p(2), p(3), p(4));
   
 
    h  = plot(x2, y2,'linewidth',4, 'color', color);% Asht changed linewidth from 1.5 to 4.
	
    grid on
	if nargout, hOut.handle = h;hOut.x= x2;hOut.y=y2; else figure(gcf), drawnow, end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hOut = plotdata(x, y, tem)
% plot scatterplot of data x, y
	h = plot(x, y, 'linewidth',100,'marker', '.', 'markersize', 50, 'linestyle', 'none',tem{:});
	%set(h, 'markerfacecolor', get(h, 'color'), varargin{:})
	grid on
	if nargout, hOut.handle = h;hOut.x= x;hOut.y=y; else figure(gcf), drawnow, end
end