function FrameSegment(InputFile, OutputFile, StartTimes, WindowWidth)

Vname = load(InputFile);
fy                     = orderfields(Vname);
names                  = fieldnames(fy);
if numel(names)==1
   fz                  = getfield(fy,cell2mat(names(1,:)));
else
   fz                  = getfield(fy,cell2mat(names(2,:)));
end
orig_fs                = 1./(fz.interval);
T = [0:fz.interval:double(fz.points)/orig_fs - fz.interval];

TrueStartTimes = StartTimes.*orig_fs/1000;
TrueEndTimes = (StartTimes + WindowWidth).*orig_fs/1000;

if(sum(TrueEndTimes>fz.points)>0)
    disp('Error! Start times + Window widths exceed total signal length!');
    return
end

if(nargin==4)
    
    for i = 1:numel(StartTimes)
        Data.values = fz.values(TrueStartTimes(i):TrueEndTimes(i),:,:);
        %Data.values = cat(3,values{:});
        Data.points = length(Data.values(:,1,1));
        Data.interval = fz.interval;
        Data.frames = fz.frames;
        
        [~,fn,ext] = fileparts(OutputFile)
        save([fn '_' num2str(i) ext],'Data');
    end
    
end



