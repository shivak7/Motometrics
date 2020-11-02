function c = split(delims, t, flag)
% SPLIT(DELIM, TEXT)
% Returns a cell array of the text segments of TEXT, where segments
% are delimited by the string DELIM.
% 
% SPLIT({DELIM1, DELIM2, ...}, TEXT)
% Returns a cell array of the text segments of TEXT, where segments
% are delimited by any of the strings DELIM1, DELIM2, etc.
% 
% SPLIT(..., 'i')
% Detects delimiters in a case-insensitive manner (default is case-
% sensitive).
% 
% See also JOIN.

if nargin < 3, flag = ''; end
match = min(strmatch(lower(flag), {'sensitive', 'case sensitive', 'insensitive', 'case insensitive'}));
if isempty(match), error('unknown command option'),end
caseSensitive = (match==1 | match==2);

if nargin < 1, delims = {}; end
if isempty(delims), delims = num2cell(char([9:13 32])); end

if size(t,1)>1
	c = {};
	for i=1:size(t,1)
		c1 = split(delims, t(i,:), flag);
		c1 = [c1 cell(1, size(c,2) - size(c1,2))];
		c = [c cell(size(c,1), size(c1,2) - size(c,2)); c1];
	end
	return
end

if isnumeric(delims), delims = char(delims); end
if ischar(delims), delims = {delims}; end
for i = 1:length(delims)
	delims{i} = char(delims{i}(:)');
	len(i) = length(delims{i});
end
[len i] = sort(-len);
len = -len; delims = delims(i);
t = t(:)';

c = {};
while ~isempty(t)
	[s e] = findfirst(t, delims, caseSensitive);
	if s == 0, c{end+1} = t; break, end
	if s > 1, c{end+1} = t(1:s-1); end
	t(1:e) = [];
end

%%%%%%%%%%%%%%%%%%%%%
function [startToken, endToken] = findfirst(s, tok, caseSensitive)

if ~caseSensitive, s = lower(s); tok = lower(tok); end
for i = 1:prod(size(tok))
	len(i) = length(tok{i});
	s(end+1:len(i)) = char(0);
	startToken(i) = min([inf findstr(s, tok{i})]);
end
[startToken i] = min(startToken);
if isinf(startToken)
	startToken = 0;
	endToken = -1;
else
	endToken = startToken + len(i) - 1;
end
