
%% STA/LTA REF station and save helicorder image for every day

ref_edp = [1 7 2 1.6 3 1.5 0 0];
f = fullfile('C:','Documents and Settings','dketner','Desktop',...
             'RED_Events','STA_LTA_Daily','REF');

t_start = datenum([2009 03 25 00 00 00]);
t_end = datenum([2009 03 25 00 00 00]);
% 734138 --> Dec 31, 2009
for day = t_start:t_end % Range to detect
   w = get_red_w('ref:ehz',day,day+1,1);
   w = zero2nan(w,10);
   sub_n_sst = extract_sst(n_sst,day,day+1);
   w = set2val(w,sub_n_sst,NaN);
   sst = sta_lta(w,'edp',ref_edp,'lta_mode','freeze');
   [rms fi pf] = sst2eventop(sst);
   save(fullfile(f,'SST_002',[datestr(day,29),'.mat']),'sst','rms','fi','pf')
   clear rms fi pf sub_n_sst
   
   w = resample(w,'median',4);
   fh = build(helicorder(w,'mpl',30,'e_sst',sst));
   set(fh,'PaperType','A','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,1])
   print(fh, '-dpng', fullfile(f,'HEL_002',datestr(day,29))) 
   close(fh)
   clear fh sst w
   clc
end
