function ie_get_corr_statsplot_multirows = ie_get_corr_statsplot_multirows(IE_Y, SE_Y, NE_Y, IE_X, SE_X, NE_X, Plot_Title, Y_Label, X_Label)
% This function gets correlation stats for imagined extinction study
% Have the data for IE, SE, and NE in workspace so that col 1 is X and col
% 2 is Y

% quick check
if size(IE_Y,1) ~= 20;warning('IE wrong size, check N');end;
if size(NE_Y,1) ~= 24;warning('NE wrong size, check N');end;
if size(SE_Y,1) ~= 22;warning('SE wrong size, check N');end;

% colors ... 
% IE 50A2CE / [80/255 162/255 206/255]
% SE B3B3B3 / [179/255 179/255 179/255]
% NE 4C4C4C / [76/255 76/255 76/255]
fs=16;
sz=70;
lnsz=1.5;
ie_cf=[80/255 162/255 206/255];
se_cf=[179/255 179/255 179/255];
ne_cf=[76/255 76/255 76/255];

num_rows=size(IE_X,2);
% all_cf=[repmat(ie_cf,20,1);repmat(se_cf,22,1);repmat(ne_cf,24,1)];
%%
counter=0;
for roi=1:num_rows
    for g=1:3
        counter=counter+1;
        if g==1;
            name='IE';cf=ie_cf;%pos=0;
            X=IE_X(:,roi);Y=IE_Y;
        elseif g==2
            name='SE';cf=se_cf;%pos=3;
            X=SE_X(:,roi);Y=SE_Y;
        elseif g==3
            name='NE';cf=ne_cf;%pos=6;
            X=NE_X(:,roi);Y=NE_Y;
        end
            set(gcf,'units','normalized','position',[.1 .5 .9 .5],'DefaultAxesFontSize',fs); %pos=pos+1;
            ax(counter)=subplot(num_rows,3,counter);
            s=scatter(Y,X,sz,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',cf,'LineWidth',lnsz);
            [r,p]=corr(Y,X);
            % do OLS        
            s=lsline;
            if p > 0.05
                set(s,'LineStyle','--','color','k');
            else
                set(s,'LineStyle','-','color','k');
            end
            disp(sprintf('%s Pearsons Correlation, %s, R=%f, p=%f', name, Plot_Title, r, p));
    %         % do robust
    %         [brob STATS] = robustfit(X,Y);
    %         hold on;
    %         if p > 0.05
    %             plot(X,brob(1)+brob(2)*X,'--k','LineWidth',lnsz);
    %         else
    %             plot(X,brob(1)+brob(2)*X,'-k','LineWidth',lnsz)
    %         end
    
    % labels off
%             xlabel(sprintf('%s',X_Label{roi}),'FontSize',fs);
%             ylabel(Y_Label,'FontSize',fs);
            title(sprintf('R=%g,p=%g', r,p),'FontSize',fs-3);
            linkaxes;
            xt = get(gca, 'XTick');
    end
end
linkaxes([ax(1:end)],'xy');
pause; %to manually resize
%%
saveas(gcf,sprintf('%s_Corr_rnorm_%s_vmPFC_swap',Plot_Title),'fig');
saveas(gcf,sprintf('%s_Corr_rnorm_%s_vmPFC_swap',Plot_Title),'png');